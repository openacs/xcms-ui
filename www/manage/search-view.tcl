ad_page_contract {
    display search results
} {
    {display_search_results:optional 0}
    {name_search:optional ""}
    {title_search:optional ""}
    {content_search:optional ""}
    {orderby:optional name,asc}
    {page:optional 1}
}

if {$display_search_results} {
    set title "Search Results"
} else {
    set title "Search Form"
}

set package_url [ad_conn package_url]
set context [list [list $package_url "Search"] $title]

# check the permission if user has permission for the package
if {![permission::permission_p -object_id [ad_conn package_id] -privilege admin]} {
    ad_return_forbidden "Serurity Violation" "You don't have permission to administer. This incident has been logged."
    ad_script_abort
}


