ad_page_contract {
	Set live_revision, publish_status, publish_date
	for a cr_item
} -query {
	item_id:integer,notnull
	return_url:notnull
} -properties {


}

set user_id [ad_conn user_id]

permission::require_permission \
	-object_id $item_id \
	-party_id $user_id \
	-privilege "admin"
set revision_id [item::get_best_revision $item_id]

item::unpublish -item_id $item_id

ad_returnredirect $return_url
ad_script_abort
