#

set bcms_package_id [site_node::get_children -package_key "bcms-ui-base" -element "package_id" -node_id [ad_conn node_id]]
set subnavbar_link "<a href=\"[apm_package_url_from_id $bcms_package_id]manage/[ad_conn path_info]\">Manage Content</a>"

set context [bcms::widget::item_context -item_id $::content::item_id -root_id $::content::root_folder_id]
if {[llength $context] > 1} {
    set last_page [lindex $context end]
    set last_page [lindex $last_page end]

    set context [lrange $context 1 [expr [llength $context] -2]]
    lappend context $last_page
} else {
    set context ""
}
