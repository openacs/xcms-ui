ad_page_contract {
    apply a template to an item
} {
    item_id:notnull,naturalnum
    template_id:optional,naturalnum
    return_url:notnull
}

set package_url [ad_conn package_url]
set current_url [ad_return_url -urlencode]

if {[info exists template_id]} {

    bcms::template::apply_template -item_id $item_id -template_id $template_id -context public
    ad_returnredirect $return_url
    ad_script_abort

} else {

    template::list::create \
        -name template_list \
        -pass_properties { item_id return_url } \
        -multirow template_list \
        -key item_id \
        -elements {
            title {
                label "Title"
                link_url_eval {[xcms_ui::apply_template_url -item_id $item_id -template_id $template_id -return_url $return_url]}
            }
	    description {
		label "Description"
	    }
        }
    bcms::template::list_templates -parent_id [parameter::get -parameter template_folder_id] -multirow_name template_list -revision live
    
    
    set title "Apply Template"
    set context_help ""

    array set current_template [bcms::template::get_template -item_id $item_id -context public]
    if {[array size current_template] > 0 && ![string equal $current_template(name) default_template]} {
        array set current_template [bcms::item::get_item -item_id $current_template(item_id) -revision live]
    }

    set context "Change Template"
}
