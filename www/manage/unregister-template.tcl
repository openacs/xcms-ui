ad_page_contract {
    unregister a template from a content item
} {
    item_id:notnull,naturalnum
    template_id:notnull,naturalnum
    context:notnull
    return_url:notnull
}

bcms::template::unregister_template -item_id $item_id -template_id $template_id -context $context

ad_returnredirect $return_url
ad_script_abort
