ad_page_contract {
    delete templates
} {
    item_id:notnull,naturalnum,multiple
    {confirm_p:optional,boolean 0}
    return_url:notnull
}



    template::list::create \
        -name delete_list \
        -multirow delete_list \
        -key item_id \
        -elements [subst {
            title {
                label "Item"
            }
        }]

    set template_ids [join $item_id ", "]
    db_multirow delete_list get_to_be_deleted "
                        select  i.item_id, 
                                i.name, 
                                i.live_revision, 
                                i.latest_revision, 
                                i.publish_status, 
                                i.content_type, 
                                i.storage_type,
                                i.tree_sortkey,
                                r.title
                        from cr_items i, cr_revisions r
                        where
                                i.item_id in ($template_ids)
                                and r.revision_id = i.latest_revision"



    set title "Delete"

	ad_form -name delete_confirm -cancel_url $return_url -form {
	    {notice:text(inform) {label ""} {value "The listed items will be deleted."}}
	    {item_id:text(hidden) {value $item_id}}
	    {return_url:text(hidden) {value $return_url}}
	} -on_submit {


    db_transaction {
        foreach one_item $item_id {
            bcms::template::delete_template -template_id $one_item
        }
    }
    ad_returnredirect $return_url
    ad_script_abort

}
