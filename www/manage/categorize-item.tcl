ad_page_contract {
    set the categeries of a particular item
} {
    item_id:naturalnum,notnull
    return_url:notnull
    category_id:naturalnum,multiple,optional
}

set context "Categorize Item"
if {[info exists category_id]} {
    # process the category assignments
    
    bcms::item::clear_categories -item_id $item_id
    foreach category $category_id {
        bcms::item::assign_category -item_id $item_id -category_id $category
    }
    ad_returnredirect $return_url
    ad_script_abort

} else {
    # display the form to select the categories
    array set item [bcms::item::get_item -item_id $item_id]
    set folder_id $item(parent_id)
    set parent_id [lindex [bcms::item::get_categories -item_id $folder_id] 0]
ns_log notice "DAVEB categorize-item folder_id $folder_id parent_id $parent_id"
    set option_list [bcms::widget::extract_values -list_of_ns_sets \
                         [bcms::category::tree_categories -parent_id $parent_id -return_list] \
                         -keys_to_extract {path category_id}]

    set category_list [bcms::item::get_categories -item_id $item_id]

    template::form::create simpleform
    template::element::create simpleform category_id -widget multiselect \
        -datatype integer -label "Categories" -options $option_list -values $category_list
    template::element::create simpleform return_url -widget hidden -datatype text -value $return_url
    template::element::create simpleform item_id -widget hidden -datatype integer -value $item_id
    template::element::create simpleform folder_id -widget hidden -datatype integer -value $folder_id


    set title "Set Category"

}
