set package_url [ad_conn package_url]
set current_url [ad_return_url]

if {[info exists context]} {
    set context_bar [ad_context_bar_html $context]
} else {
    set context_bar [ad_context_bar]
}
set manage_type [ad_get_client_property -default content [ad_conn package_id] manage_type]
