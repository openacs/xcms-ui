ad_page_contract {
    remove a relation of an item
} {
    rel_id:naturalnum,notnull
    return_url:notnull
}

bcms::item::unrelate_item -rel_id $rel_id

ad_returnredirect $return_url
ad_script_abort
