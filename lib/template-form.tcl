# this file is meant to be included with the following parameters

# parent_id - if you are creating a new template
# revision_id - if you are editing a template revision
# return_url - requires a return_url, so after creating or editing a folder it redirect to this url
# form_mode - either "edit" or "display"

xcms_ui::check_include_vars

set cms_context [parameter::get -parameter cms_context -default ""]
if {[string equal $cms_context ""]} {
    error "no cms context defined"
}

ad_form -name simpleform -mode $form_mode -form {
    revision_id:key

    {name:text(text) {label "Template Name"}}
    {title:text(text) {label "Title"}}
    {description:text(textarea),optional {html {rows 5 cols 80}} {label "Description"}}
    {content:text(textarea),optional {html {rows 20 cols 80}} {label "Template Content"}}
    {parent_id:integer(hidden),optional {value $parent_id}}
    {item_id:integer(hidden),optional {value $item_id}}
    {return_url:text(hidden) {value $return_url}}

} -validate {
    {name
        {![bcms::item::is_item_duplicate_p -url $name -root_id $parent_id -item_id $item_id]}
        "Template Name already exists, <br /> please use another Template Name"
    }
} -edit_request {

    array set one_revision [bcms::revision::get_revision -revision_id $revision_id]
    set item_id $one_revision(item_id)
    set name $one_revision(name)
    set title $one_revision(title)
    set description $one_revision(description)
    set folder_id $one_revision(parent_id)

# For now, just show the template thats in the database
# DAVEB

#    set template_dir [parameter::get -parameter TemplateRoot]
#    set template_root_id [parameter::get -parameter template_folder_id]
#    set template_path [db_string get_url "select content_item__get_path(:item_id,:template_root_id)"]
#    set template_root "[acs_root_dir]/${template_dir}"
#set template_filename "${template_root}/${template_path}.adp"
#ns_log notice "DAVEB: template-form template_filename $template_filename"
#    # read the file contents from the file system
#    if {[file exists $template_filename]} {
#        set content [template::util::read_file $template_filename]
#    } else {
        set content $one_revision(content)
#    }

} -edit_data {

    bcms::revision::set_revision -revision_id $revision_id \
       -title $title -content $content -description $description

    array set template [bcms::item::get_item -item_id $item_id]

# skip this, content::init will publish the template. Later we can
# add a feature to publish a revision of a template
# DAVEB

    if {![empty_string_p $template(live_revision)]} {

    set template_dir [parameter::get -parameter TemplateRoot]
    set template_root_id [parameter::get -parameter template_folder_id]
    set template_path [db_string get_url "select content_item__get_path(:item_id,:template_root_id)"]
    set template_root "[acs_root_dir]/${template_dir}"
set template_filename "${template_root}/${template_path}.adp"
#
    ns_log notice "DAVEB template-form writing template to $template_filename"
        template::util::write_file $template_filename $content
    }

} -new_data {

    # create the template and revision
    db_transaction {
        set item_id [bcms::template::create_template -template_name $name -parent_id $parent_id]
        set revision_id [bcms::template::add_template -template_id $item_id \
                             -title $title -content $content -description $description]
    }

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort

}

ad_return_template "/packages/xcms-ui/lib/simple-form"


