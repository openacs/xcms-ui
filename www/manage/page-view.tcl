ad_page_contract {
    view a page revision, if no revision_id is passed then latest revision is used
} {
    {revision_id:optional,naturalnum $content(latest_revision)}
    {return_url:optional [ad_return_url]}
}

set package_url [ad_conn package_url]

array set page_revision [bcms::revision::get_revision -revision_id $revision_id]

# we will only allow edits on the latest version, else you can only view them
if {$revision_id == $page_revision(latest_revision)} {



    set context_help "You can edit this page, etc."

    set title "View Page"
    set context [bcms::widget::item_context -item_id $current_item(item_id) -root_id $root_id]
    set context [lrange $context 0 [expr [llength $context] - 2]]
    lappend context "$page_revision(title)"

} else {


    set context_help "This is a version of a page.  You can only view this page"

    set title "View Page Version"
    set context [bcms::widget::item_context -item_id $current_item(item_id) -root_id $root_id]
    lappend context "version $revision_id"

}

