# this file is meant to be included with the following parameters
#
# parent_id - if you are creating a new page
# revision_id - if you are editing a page revision
# return_url - requires a return_url, so after creating or editing a folder it redirect to this url
# form_mode - either "edit" or "display"
set storage_type text
xcms_ui::check_include_vars
set package_id [ad_conn package_id]
ad_form -name simpleform -mode $form_mode -html {enctype multipart/form-data} -form {
    revision_id:key

    {name:text(text) {help_text {no spaces, no special characters}} {label "Page Name"}}
    {title:text(text) {label "Title"}}
    {description:text(textarea),optional {html {rows 5 cols 80}} {label "Description"}}
    {parent_id:integer(hidden),optional {value $parent_id}}
    {item_id:integer(hidden),optional {value $item_id}}
    {return_url:text(hidden) {value $return_url}}
    {storage_type:text(hidden) {value $storage_type}}    
    {content:richtext_or_file(richtext_or_file),optional {html {rows 20 cols 80}} {label "Page Content"}}

} -edit_request {
	array set one_revision [bcms::revision::get_revision -revision_id $revision_id]
    set item_id $one_revision(item_id)

    array set one_item [bcms::item::get_item -item_id $item_id]
    
    set name $one_revision(name)
    set title $one_revision(title)
    set description $one_revision(description)

    set storage_type $one_item(storage_type)
    
    set mime_type $one_revision(mime_type)

    if {[string equal "text" $storage_type]} {
    
    	set content [template::util::richtext_or_file create $storage_type $mime_type $one_revision(content)]

    } else {
	set content [template::util::richtext_or_file create $storage_type $mime_type "" $one_revision(content) "" ""] 
    }
    
    set parent_id $one_revision(parent_id)

} -validate {
    {name
        {![bcms::item::is_item_duplicate_p -url $name -root_id $parent_id -item_id $item_id]}
        "Page Name already exists, <br /> please use another Page Name"
    }
} -edit_data {
	set mime_type [template::util::richtext_or_file::get_property mime_type $content]
	set content [template::util::richtext_or_file::get_property text $content]
# DAVEB always create a new revision on edit
# have a RENAME function. name shouldn't be edited ususally. it breaks
# links
ns_log notice "DAVEB page-form edit_data"
# TODO: DAVEB Fix this to work with file upload!!

    if {[string equal "text" $storage_type]} {
	
	set revision_id [bcms::revision::add_revision -item_id $item_id \
	    -title $title \
	    -content $content \
	    -description $description \
	    -mime_type $mime_type \
	    -creation_user [ad_conn user_id] \
			     -creation_ip [ad_conn peeraddr]]
	set return_url "${return_url}?[export_vars revision_id]"
    } else {

	bcms::revision::upload_revision 

    }

    ad_returnredirect $return_url
    ad_script_abort
    
} -new_data {
    set mime_type [template::util::richtext_or_file::get_property mime_type $content]
    set storage_type [template::util::richtext_or_file::get_property storage_type $content]
    ns_log notice "DAVEB page-form storage_type = $storage_type"
    if {[string equal "file" $storage_type]} {
	set tmp_filename [template::util::richtext_or_file::get_property tmp_filename $content]

	if {![string equal "text/html" $mime_type]} {
	    ns_log notice "DAVEB upload page mime_type=$mime_type"
	    
	    set html_filename [mime_type_convert::convert_file $tmp_filename $mime_type "text/html"] 
	    set upload_filename [template::util::richtext_or_file::get_property filename $content]
	    set upload_file [list $upload_filename $html_filename $mime_type]
	    set mime_type "text/html"
	} else {
	    set html_filename $tmp_filename
	}
	    set fd [open $html_filename]
	    set content [read $fd]
	    close $fd
	#get just the content

	#might want to be clever and get title?
	
	regexp -nocase {(.*?)<body.*?>(.*)</body.*?>} $content match headers body
	 set content $body
	
    } elseif {[string equal "text" $storage_type]} {
	ns_log notice "DAVEB! page-form content is $content"
	set content [template::util::richtext_or_file::get_property text $content]
    }
    # create the page and revision
    set item_id [bcms::create_page -page_name $name -folder_id $parent_id -mime_type $mime_type \
                     -title $title -description $description -page_body $content]


} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort

}

ad_return_template "/packages/xcms-ui/lib/simple-form"


