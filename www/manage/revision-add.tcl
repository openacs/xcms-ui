ad_page_contract {
    add a revision, copy from the latest one
} {
    item_id:notnull,naturalnum
    return_url:notnull
}

array set item [bcms::item::get_item -item_id $item_id]

if {[array size item] > 0} {
    bcms::revision::copy_revision -revision_id $item(latest_revision)
} else {
    error "item does not exist"
}

ad_returnredirect $return_url
ad_script_abort


