ad_page_contract {
    view a page revision, if no revision_id is passed then latest revision is used
} {
    item
    {object_id ""}
    {revision_id ""}
    {return_url:optional [ad_return_url]}
}

array set content $item
set item_id $content(item_id)
if {[empty_string_p $revision_id]} {
	if {![empty_string_p $content(live_revision)]} {
		set revision_id $content(live_revision)
	} elseif {![empty_string_p $content(latest_revision)]} {
		set revision_id $content(latest_revision)
	} else {
		ns_returnnotfound
	}
}

set return_url [ad_conn url]
set package_url [ad_conn package_url]

    set context_help "You can edit this page, etc."

    set title "View Page"
    if {![string equal $revision_id $content(live_revision)]} {
	append title " -- Revision $revision_id"
    }

    set context [bcms::widget::item_context -item_id $item_id -root_id $::content::root_folder_id -root_url [ad_conn package_url]manage/]
set page_title [lindex [lindex $context end] end ]
    set context [lrange $context 0 [expr [llength $context] - 2]]
    lappend context "View Page: $page_title"


set url_base "[ad_conn package_url]/manage/"

template::multirow create actions url label title

template::multirow append actions "${url_base}apply-template?[export_vars {item_id return_url}]" "Change Template" "Change the template used to display this item."
#template::multirow append actions "${url_base}categorize-item?[export_vars {item_id return_url}]" "Categorize Item" "Set the categories assigned to this item"

if {![string equal "live" $content(publish_status)]} {
	template::multirow append actions "${url_base}item-publish?[export_vars {item_id return_url}]" "Publish Item" "Publish this item."
} else {
	template::multirow append actions "${url_base}item-unpublish?[export_vars {item_id return_url}]" "Unpublish Item" "Unpublish this item."
}
template::multirow append actions "${url_base}delete-item?[export_vars {item_id {return_url $package_url}}]" "Delete" "Delete this item."




