ad_page_contract {
    sets the package parameter based from the name and value
} {
    parameter_name:notnull
    value:notnull
    return_url:notnull
}

parameter::set_value -parameter $parameter_name -value $value

ad_returnredirect $return_url
ad_script_abort
