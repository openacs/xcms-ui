ad_page_contract {
	Set live_revision, publish_status, publish_date
	for a cr_item
} -query {
	item_id:integer,notnull
	return_url:notnull
	{revision_id:integer,optional}
} -properties {


}

set user_id [ad_conn user_id]

permission::require_permission \
	-object_id $item_id \
	-party_id $user_id \
	-privilege "admin"

if {![exists_and_not_null revision_id]} {
	set revision_id [item::get_best_revision $item_id]
}

item::publish -item_id $item_id -revision_id $revision_id

ad_returnredirect $return_url
ad_script_abort
