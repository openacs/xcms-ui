ad_page_contract {
    view a image revision, if no revision_id is passed then latest revision is used
} {
    item
    {revision_id:optional,naturalnum}
    {preview_p:optional ""}
    {return_url "[ad_conn url]"}
}


set package_url [ad_conn package_url]
array set current_item $item
set item_id $current_item(item_id)
if {![exists_and_not_null revision_id]} {
	set revision_id [item::get_best_revision $item_id]
}
# if we are previewing lets serve the file
if {[string equal $preview_p "t"]} {
        cr_write_content -revision_id $revision_id
        ad_script_abort
}
set root_id [parameter::get -parameter root_folder_id]
array set image_revision [bcms::revision::get_revision -revision_id $revision_id]

# we will only allow edits on the latest version, else you can only view them
if {$revision_id == $image_revision(latest_revision)} {

set url_base "[ad_conn package_url]manage/"
template::multirow create actions url label title
if {![string equal "live" $current_item(publish_status)]} {
	template::multirow append actions "${url_base}item-publish?[export_vars {item_id return_url}]" "Publish Item" "Publish the latest revision of this item"
} {
	template::multirow append actions "${url_base}item-unpublish?[export_vars {item_id return_url}]" "Unpublish Item" "Publish the latest revision of this item"


}

template::multirow append actions "${url_base}categorize-item?[export_vars {item_id return_url}]" "Categorize Item" "Set the categories assigned to this item"


template::multirow append actions "${url_base}delete-item?[export_vars {item_id return_url}]" "Delete" "Delete this item."




set context_help "You can edit this image, etc."

    set title "View image"
    set context [bcms::widget::item_context -item_id $current_item(item_id) -root_id $root_id]
    set context [lrange $context 0 [expr [llength $context] - 2]]
    lappend context "$image_revision(title)"

} else {
    set context_action [bcms_ui_base::context_action_link -context_action revision-list \
                                   -export_vars [export_vars {{item_id $current_item(item_id)} return_url}]]

    set context_help "This is a version of a image.  You can only view this image"

    set title "View Image Version"
    set context [bcms::widget::item_context -item_id $current_item(item_id) -root_id $root_id]
    lappend context "version $revision_id"

}

