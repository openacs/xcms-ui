ad_page_contract {
    relate item_id_one with one or more content item
} {
    item_id_one:notnull
    item_id:optional,multiple
    return_url:notnull
    {name_search:optional ""}
    {title_search:optional ""}
    {content_search:optional ""}
    {display_search_results:optional 0}
    {orderby:optional name,asc}
    {page:optional 1}
    {content_type_search:notnull}
    {relation_type:notnull}
}

if {[info exists item_id]} {
    foreach related_object_id $item_id {
        bcms::item::relate_item -relation_type $relation_type -item_id $item_id_one -related_object_id $related_object_id
    }

    ad_returnredirect $return_url
    ad_script_abort
}

set package_url [ad_conn package_url]
set bulk_actions [list "Relate" "${package_url}manage/relate-item" "Relate checked items"]
set bulk_action_export_vars {item_id_one return_url content_type_search relation_type}

template::list::create \
    -name related_items \
    -multirow related_items \
    -key rel_id \
    -pass_properties { package_url } \
    -bulk_actions [list "Unrelate" "${package_url}manage/unrelate-item" "Unrelate checked items"] \
    -bulk_action_export_vars {
        return_url
    } \
    -elements {
        name {
            label "Name"
        }
        title {
            label "Title"
        }
    }


bcms::item::list_related_items -item_id $item_id_one -relation_tag $relation_type -multirow_name related_items -revision latest


set title "Relate Content"
