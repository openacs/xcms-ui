ad_page_contract {
    unpublish this revision
} {
    revision_id:notnull,naturalnum
    return_url:notnull
}

bcms::revision::set_revision_status -revision_id $revision_id -status production

ad_returnredirect $return_url
ad_script_abort
