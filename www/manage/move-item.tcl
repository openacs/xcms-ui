ad_page_contract {
    moves item_id to folder_id
} {
    item_id:notnull,naturalnum,multiple
    folder_id:optional,integer
    return_url:notnull
    {redirect_to_folder:optional,boolean 0}
}

# we already have a destination folder, that means move the items
# otherwise list the folders
if {[info exists folder_id]} {

    foreach one_item $item_id {
        bcms::item::set_item -item_id $one_item -parent_id $folder_id
    }

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
                link_url_eval {[bcms_ui_base::move_url -items_to_move "$item_id" -destination_folder $folder_id -redirect_to_folder $redirect_to_folder -return_url $return_url]}
		display_template {<div style="text-indent: @folder_tree.level@em;">@folder_tree.label@</div>} 
            }
        }

    bcms::folder::tree_folders -parent_id [bcms::folder::get_bcms_root_folder] -prepend_path [ad_conn package_url] -multirow_name folder_tree 

    set title "Move"

}
