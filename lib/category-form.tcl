ad_page_contract {
    a form to create or edit a category

    this file is meant to be included with the following parameters

    category_id - if you are editing a category
    parent_id - if you are adding a subcategory
    return_url - requires a return_url, so after creating or editing a category it redirect to this url
} {
}

if {![info exists parent_id]} {
    set parent_id ""
}


ad_form -name simpleform -has_edit 1 -form {

    category_id:key

    {heading:text(text) {html {style "width: 20em"}} {label "Category Heading"}}
    {description:text(textarea) {html {style "width: 40em; height: 20em"}} {label "Description"}}
    {parent_id:integer(hidden),optional {value $parent_id}}
    {return_url:text(hidden) {value $return_url}}
    {formbutton:text(submit) {label "Edit Categories"}}
} -edit_request {

    array set category [bcms::category::get_category -category_id $category_id]
    set heading $category(heading)
    set description $category(description)
    
} -edit_data {

    bcms::category::set_category -category_id $category_id -heading $heading -description $description 

} -new_data {

    set creation_user [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]

    bcms::category::create_category -heading $heading -description $description -parent_id $parent_id \
        -creation_user $creation_user -creation_ip $creation_ip

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort

}


ad_return_template "/packages/bcms-ui-base/lib/simple-form"



    
    
