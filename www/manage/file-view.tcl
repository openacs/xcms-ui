ad_page_contract {
    view a file revision, if no revision_id is passed then latest revision is used
} {
    {revision_id:optional,naturalnum $current_item(latest_revision)}
    {preview_p:optional 0}
    {return_url:optional [ad_return_url]}
}

set package_url [ad_conn package_url]

# if we are previewing lets serve the file
if {$preview_p} {
        cr_write_content -revision_id $revision_id
        ad_script_abort
}

array set file_revision [bcms::revision::get_revision -revision_id $revision_id]

# we will only allow edits on the latest version, else you can only view them
if {$revision_id == $file_revision(latest_revision)} {

    set context_action ""
    if {[empty_string_p $current_item(live_revision)]} {
        append context_action [bcms::ui::base::context_action_link -context_action revision-publish \
                                   -export_vars [export_vars {revision_id return_url}]]
    } else {
        append context_action [bcms::ui::base::context_action_link -context_action revision-unpublish \
                                   -export_vars [export_vars {{revision_id $current_item(live_revision)} return_url}]]
    }
    append context_action [bcms::ui::base::context_action_link -context_action categorize-item \
                                   -export_vars [export_vars {{item_id $current_item(item_id)} {folder_id $current_item(parent_id)} return_url}]]
    append context_action [bcms::ui::base::context_action_link -context_action revision-list \
                                   -export_vars [export_vars {{item_id $current_item(item_id)} return_url}]]

    set context_help "You can edit this file, etc."

    set title "View file"
    set context [bcms::widget::item_context -item_id $current_item(item_id) -root_id $root_id]
    set context [lrange $context 0 [expr [llength $context] - 2]]
    lappend context "$file_revision(title)"

} else {
    set context_action [bcms::ui::base::context_action_link -context_action revision-list \
                                   -export_vars [export_vars {{item_id $current_item(item_id)} return_url}]]

    set context_help "This is a version of a file.  You can only view this file"

    set title "View File Version"
    set context [bcms::widget::item_context -item_id $current_item(item_id) -root_id $root_id]
    lappend context "version $revision_id"

}

