ad_page_contract {
    moves item_id to folder_id
} {
    item_id:notnull,naturalnum
    folder_id:optional,integer
    {return_url:optional "[ad_return_url]"}
}

# we already have a destination folder, that means move the items
# otherwise list the folders
if {[info exists folder_id]} {
    array set item [bcms::item::get_item -item_id $item_id]
        set link_item_id [bcms::item::create_link \
		-target_id $item_id \
		-parent_id $folder_id \
		-name $item(name) \
		-label $item(name)]

    set return_url "./[bcms::item::get_url -item_id $link_item_id] -root_id [parameter::get -parameter root_folder_id]]"

    ad_returnredirect $return_url
    ad_script_abort

} else {

    template::list::create \
        -name folder_tree \
        -pass_properties { item_id redirect_to_folder return_url } \
        -multirow folder_tree \
        -key folder_id \
        -elements {
            label {
                label "Folder"
                link_url_eval {[set link_url "./symlink-item?[export_vars {folder_id item_id}]"]}
		display_template {<div style="text-indent: @folder_tree.level@em;">@folder_tree.label@</div>} 
            }
        }

    bcms::folder::tree_folders -parent_id [bcms::folder::get_bcms_root_folder] -prepend_path [ad_conn package_url] -multirow_name folder_tree 

    set title "Create Link to Exising Page	"

}
