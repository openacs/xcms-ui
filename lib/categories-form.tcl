# item_id Object ID to assign categories to
# parent_id Object ID to use to find out which category trees are available
# return_url
ns_log notice "DAVEB categories-form.tcl item_id = $item_id"

ad_form -name categories -mode $form_mode -export {parent_id return_url} -has_edit 1 -form {
	item_id:key
	    {edit:text(submit) {label "Edit Categories ->"}}

}

set category_trees [category_tree::get_mapped_trees $parent_id]
ns_log notice "DAVEB: parent_id $parent_id category trees $category_trees"

foreach elm $category_trees {
    foreach { tree_id name subtree_id } $elm {}
    ad_form -extend -name categories -form \
        [list [list category_id_${tree_id}:integer(category) \
                   {label $name} \
                   {html {single single}} \
                   {category_tree_id $tree_id} \
                   {category_subtree_id $subtree_id} \
                   {category_object_id {[value_if_exists item_id]}} ]]
}

ad_form -extend -name categories -edit_request {


} -on_submit {

    set category_ids [list]
    foreach elm $category_trees {
        foreach { tree_id name dummy } $elm {}
            set category_ids [concat $category_ids [set category_id_${tree_id}]]
    }
			    
# set categories

    category::map_object -remove_old -object_id $item_id $category_ids

	ad_returnredirect $return_url
}



