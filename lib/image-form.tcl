# this file is meant to be included with the following parameters

# parent_id - if you are creating a new image
# revision_id - if you are editing a image revision
# return_url - requires a return_url, so after creating or editing a folder it redirect to this url

xcms_ui::check_include_vars

ad_form -name simpleform  -mode $form_mode -html {enctype multipart/form-data} -form {
    revision_id:key

    {name:text(text) {help_text {no spaces, no special characters}} {label "Image Name"}}
    {title:text(text) {label "Title"}}
    {description:text(textarea),optional {html {rows 5 cols 80}} {label "Description"}}
    {width:integer(text),optional {label "Width"}}
    {height:integer(text),optional {label "Height"}}
    {upload_file:file(file),optional {label "Image"}}
    {parent_id:integer(hidden),optional {value $parent_id}}
    {item_id:integer(hidden),optional {value $item_id}}
    {return_url:text(hidden) {value $return_url}}

} -validate {
    {upload_file
        {!$__new_p || [exists_and_not_null upload_file]}
        # require file only we are uploading a new file, otherwise it ok to just edit the other fields
        "Image is required"
    }
    {name
        {![bcms::item::is_item_duplicate_p -url $name -root_id $parent_id -item_id $item_id]}
        "Image Name already exists, <br /> please use another Image Name"
    }
} -edit_request {

    array set one_revision [bcms::revision::get_revision -revision_id $revision_id -additional_properties {width height}]
    set item_id $one_revision(item_id)
    set name $one_revision(name)
    set title $one_revision(title)
    set content $one_revision(content)
    set description $one_revision(description)
    set width $one_revision(width)
    set height $one_revision(height)
    set parent_id $one_revision(parent_id)

} -edit_data {

    if {[exists_and_not_null upload_file]} {
        bcms::revision::set_revision -revision_id $revision_id \
            -title $title -description $description -upload_file $upload_file
    } else {
        bcms::revision::set_revision -revision_id $revision_id \
            -title $title -description $description
    }

    set additional_properties {}
    if {[info exists width]} {
        lappend additional_properties [list width $width]
    }
    if {[info exists height]} {
        lappend additional_properties [list height $height]
    }

    db_dml update_event "update images set [bcms::parse_properties -properties $additional_properties -return_format update] where image_id = :revision_id"

    if {[info exists name]} {
        bcms::item::set_item -item_id $item_id -name $name
        # we have renamed the image, we need to redirect on the new name
        bcms_ui_base::redirect_after_rename -item_id $item_id
    }

} -new_data {

    db_transaction {
        set item_id [bcms::item::create_item -item_name $name -parent_id $parent_id -content_type image \
                         -storage_type file]

        set additional_properties {}
        if {[exists_and_not_null width]} { lappend additional_properties [list width $width] }
        if {[exists_and_not_null height]} { lappend additional_properties [list height $height] }
        set revision_id [bcms::revision::upload_file_revision -item_id $item_id \
                             -title $title -description $description \
                             -upload_file $upload_file \
                             -additional_properties $additional_properties]

    }

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort

}

set context "Add/Edit Image"
ad_return_template "/packages/xcms-ui/lib/simple-form"


