ad_page_contract {
    set the root category to be used by this folder's content
} {
    folder_id:integer,notnull
    category_id:naturalnum,optional
    return_url:notnull
}

if {[info exists category_id]} {
    # we need to assign the root category_id to this folder_id
    bcms::item::assign_category -item_id $folder_id -category_id $category_id
}

set categories [bcms::item::get_categories -item_id $folder_id]
if {[llength $categories] > 0} {
    # if its already assigned a category, display it only
    set category_id [lindex $categories 0]
    array set category [bcms::category::get_category -category_id $category_id]

    # there is a bug listtemplate seems not to obey if, we will create 
    # a blank list template
    # TODO fix this bug
    template::list::create \
        -name category_list \
        -multirow category_list \
        -elements {}

} else {
    # we need to display the root categories

    set package_url [ad_conn package_url]
    set return_url_encoded [ad_urlencode $return_url]

    bcms::category::list_categories -multirow_name category_list

    template::list::create \
        -pass_properties { folder_id return_url_encoded package_url } \
        -name category_list \
        -multirow category_list \
        -key category_id \
        -elements {
            category_id {
                label "Root Category"
                display_col heading
                link_url_eval "${package_url}manage/folder-set-category?folder_id=$folder_id&category_id=$category_id&return_url=$return_url_encoded"
            }
            description {
                label "Description"
            }
        }

}



set title "Assign Root Category"
