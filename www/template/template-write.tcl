ad_page_contract {
    write the template to the file system and set the revision to live
} {
    revision_id:notnull,naturalnum
    return_url:notnull
}

set cms_context [parameter::get -parameter cms_context -default ""]

set template_root [parameter::get -parameter TemplateRoot -default "templates"]

if {[string equal $cms_context ""]} {
    error "no cms context defined"
}

array set template [bcms::revision::get_revision -revision_id $revision_id]

if {[array size template] > 0} {
    bcms::revision::set_revision_status -revision_id $revision_id -status live
    set template_file "[acs_root_dir]/${template_root}/${template(name)}.adp"
    template::util::write_file $template_file $template(content)
} else {
    error "revision does not exist"
}

ad_returnredirect $return_url
ad_script_abort
