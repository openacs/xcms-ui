ad_page_contract {
    view a template revision, if no revision_id is passed then latest revision is used
} {
    item
    {revision_id ""}
    {return_url:optional "[ad_conn url]"}
}


set package_url [ad_conn package_url]

#if {![exists_and_not_null revision_id]} {
#set revision_id [item::get_best_revision $item_id]
#}
set root_id [parameter::get -parameter template_folder_id]
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


array set template_revision [bcms::revision::get_revision -revision_id $revision_id]

set context_help ""

set url_stub "[ad_conn package_url]/manage/"
template::multirow create actions url label title

	template::multirow append actions "./template-write?[export_vars {revision_id return_url}]" "Publish Template" "Publish this template."
template::multirow append actions "${url_stub}delete-item?[export_vars {item_id return_url}]" "Delete" "Delete this item."



set title "View Template"
set context [bcms::widget::item_context -item_id $item_id -root_id $root_id]
set context [lrange $context 0 [expr [llength $context] - 2]]
lappend context "$template_revision(title)"
