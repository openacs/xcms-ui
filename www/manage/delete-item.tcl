ad_page_contract {
    delete items
} {
    item_id:notnull
    {confirm_p:optional,boolean 0}
    return_url:notnull
}


    template::list::create \
        -name delete_list \
        -multirow delete_list \
        -key item_id \
        -elements {
            title {
                label "Item"
            }
            can_delete {
                label "Can be deleted"
            }
        }

    set item_ids [join $item_id ", "]
    db_multirow delete_list get_to_be_deleted "
                        select  i.item_id, 
                                i.name, 
                                i.live_revision, 
                                i.latest_revision, 
                                i.publish_status, 
                                i.content_type, 
                                i.storage_type,
                                i.tree_sortkey,
                                case when i.content_type = 'content_folder' then content_folder__get_label(i.item_id) else bcms__get_title(i.item_id, 'latest') end as title,
                                case when i.content_type = 'content_folder' then content_folder__is_empty(i.item_id) else true end as can_delete
                        from cr_items i
                        where
                                i.item_id in ($item_ids)"

	ad_form -name delete_confirm -cancel_url $return_url -form {
	    {notice:text(inform) {label ""} {value "The listed items will be deleted."}}
	    {item_id:text(hidden) {value $item_id}}
	    {return_url:text(hidden) {value $return_url}}
	} -on_submit {
	    set item_id [split $item_id]
    db_transaction {
        foreach one_item $item_id {
            array set item [bcms::item::get_item -item_id $one_item]
            if {[string equal $item(content_type) "content_folder"]} {
                bcms::folder::delete_folder -folder_id $one_item
            } else {
                bcms::item::delete_item -item_id $one_item
            }
        }
    }
    ad_returnredirect $return_url
    ad_script_abort
}


set confirm_link [bcms_ui_base::delete_url -items_to_delete $item_id -return_url $return_url -confirm]

    set title "Delete"

