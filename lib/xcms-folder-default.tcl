# get a listing of all items in this folder and its direct children

# get a sort_order for the folders and contents from cr_child_rels
if {![string equal "/" [string index [ad_conn url] end ]]} {
	ad_returnredirect "[ad_conn url]/"
}
set folder_id [content::get_item_id]

array set folder [bcms::folder::get_folder -folder_id $folder_id]
template::util::array_to_vars folder
set context "${label}"
bcms::folder::list_folders -parent_id $folder_id \
		          -multirow_name folders

db_multirow contents get_folder_contents {
	select ci.name,
	       ci.item_id,
	       content_item__get_title(ci.item_id) as title,
	       ci.parent_id,
	       case when ci.content_type = 'content_folder' then 1 else 0 end as folder_p
	from cr_items ci 				
        where parent_id=:folder_id
	order by tree_sortkey
        limit 10
	}

set admin_p [permission::permission_p -object_id [ad_conn package_id] -party_id [ad_conn user_id] -privilege "admin"]
set manage_url "[ad_conn package_url]manage/[ad_conn path_info]"
ad_return_template

