#a form to create or edit a folder
#
# this file is meant to be included with the following parameters
#
# folder_id - if you are editing a folder
# parent_id - if you are creating a folder
# create_index_p - if true will create a blank page named "index" on the new folder, defaults to true
# return_url - requires a return_url, so after creating or editing a folder it redirect to this url
# form_mode - either "edit" or "display"

# initialize the vars that don't exist
if {![info exists parent_id]} {
    if {![info exists folder_id]} {
        error "you are likely going to use this form to create a new folder, please include a parent_id parameter"
    }
    set parent_id ""
}
if {![info exists create_index_p]} {
    set create_index_p true
}
if {![info exists form_mode]} {
    set form_mode edit
}

ad_form -name simpleform -mode $form_mode -has_edit 1 -form {

    folder_id:key

    {folder_name:text(text) {help_text {Name to be use in URL. No spaces, no special characters}} {label "Folder Name"}}
    {folder_label:text(text) {label "Folder Label"}}
    {description:text(textarea),optional {label "Folder Description"}}
    {create_index_p:boolean(hidden),optional {value $create_index_p}}
    {parent_id:integer(hidden),optional {value $parent_id}}
    {return_url:text(hidden) {value $return_url}}
    {edit:text(submit) {label "Edit Folder ^"}}

} -edit_request {

    array set folder [bcms::folder::get_folder -folder_id $folder_id]
    set folder_name $folder(name)
    set folder_label $folder(label)
    set description $folder(description)
} -edit_data {

    bcms::folder::set_folder -folder_id $folder_id -name $folder_name -label $folder_label -description $description

    if {[info exists folder_name]} {
        # we have renamed the folder, we need to redirect on the new name
        bcms_ui_base::redirect_after_rename -item_id $folder_id -url_base "[ad_conn package_url]manage"
    }

} -new_data {

    set creation_user [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]

    db_transaction {
        # now that we have all the data create the folder
	# TODO add create_index parameter??
	# TODO add additional content types somehow?

	set folder_id [bcms::folder::create_folder \
			   -name $folder_name \
			   -folder_label $folder_label \
			   -parent_id $parent_id \
			   -description $description \
			   -content_types "content_revision image content_folder content_extlink content_symlink"]

        if {$create_index_p} {
            # create the index page for the folder
            set item_id [bcms::item::create_item -item_name index -parent_id $folder_id -content_type content_revision \
                             -storage_type text -creation_user $creation_user -creation_ip $creation_ip]

            # create an initial revision, a blank page
            set revision_id [bcms::revision::add_revision -item_id $item_id \
				 -title $folder_label \
				 -content "" \
				 -description "" \
				 -mime_type "text/html" \
				 -creation_user $creation_user \
				 -creation_ip $creation_ip]
        }

    }
    
} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort

} 


ad_return_template "/packages/bcms-ui-base/lib/simple-form"

