ad_page_contract {
    this page is set the root_folder_id and template_folder_id of this package instance
    TODO revisit this page to make sure its able to handle multi level folders
} {
}

bcms::folder::tree_folders -parent_id [bcms::template::get_cr_root_template_folder] -multirow_name folders -include_parent

set current_template_folder_id [parameter::get -parameter template_folder_id]

set current_url [ad_return_url -urlencode]

set title "Set Folder"
set context [list $title]
