# this file is meant to be included with the following parameters
#
# folder_id - if you are creating a new file
# revision_id - if you are editing a file revision
# return_url - requires a return_url, so after creating or editing a folder it redirect to this url
# form_mode - either "edit" or "display"

bcms_ui_base::check_include_vars

ad_form -name simpleform  -mode $form_mode -html {enctype multipart/form-data} -form {
    revision_id:key

    {name:text(text) {help_text {no spaces, no special characters}} {label "File Name"}}
    {title:text(text) {label "Title"}}
    {description:text(textarea),optional {html {rows 5 cols 80}} {label "Description"}}
    {upload_file:file(file),optional {label "File"}}
    {parent_id:integer(hidden),optional {value $parent_id}}
    {item_id:integer(hidden),optional {value $item_id}}
    {return_url:text(hidden) {value $return_url}}

} -validate {
    {upload_file
        {!$__new_p || [exists_and_not_null upload_file]}
        # require file only we are uploading a new file, otherwise it ok to just edit the other fields
        "File is required"
    }
    {name
        {![bcms::item::is_item_duplicate_p -url $name -root_id $parent_id -item_id $item_id]}
        "File Name already exists, <br /> please use another File Name"
    }
} -edit_request {

    array set one_revision [bcms::revision::get_revision -revision_id $revision_id]
    set item_id $one_revision(item_id)
    set name $one_revision(name)
    set title $one_revision(title)
    set content $one_revision(content)
    set description $one_revision(description)
    set parent_id $one_revision(parent_id)

} -edit_data {

    if {[exists_and_not_null upload_file]} {
        bcms::revision::set_revision -revision_id $revision_id \
            -title $title -description $description -upload_file $upload_file
    } else {
        bcms::revision::set_revision -revision_id $revision_id \
            -title $title -description $description
    }
    if {[info exists name]} {
        bcms::item::set_item -item_id $item_id -name $name
        # we have renamed the file, we need to redirect on the new name
        bcms_ui_base::redirect_after_rename -item_id $item_id
    }

} -new_data {

    # create the file and revision
    set item_id [bcms::upload_file -file_name $name -folder_id $parent_id \
                     -title $title -description $description -upload_file $upload_file]

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort

}

ad_return_template "/packages/xcms-ui/lib/simple-form"


