ad_page_contract {
    create a subfolder
} {
    parent_id:notnull,integer
    return_url:notnull
}

set title "Create Sub-Folder"
set context [list [list $return_url "Set Folder"] $title]
