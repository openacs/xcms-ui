ad_library {
	Install callback procedures for xcms-ui-base
}

namespace eval xcms_ui_base::install {}

ad_proc xcms_ui_base::install::package_install {} {


}


ad_proc xcms_ui_base::install::after_mount {
	-package_id
	-node_id
} {
	After mount callback
} {

	register_default_templates -package_id $package_id -node_id $node_id

}

ad_proc xcms_ui_base::install::register_default_templates {
	-package_id
	-node_id
} {
	Register default templates for content_folder
	and content_revision. Import templates from
	packages/xcms-ui-base/templates/ and create template folders

} {

# register public display templates

    set parent_subsite_package_id [site_node::closest_ancestor_package \
				       -node_id $node_id \
				       -package_key "acs-subsite"
				   ]

    set parent_subsite_url [apm_package_url_from_id $parent_subsite_package_id]
    
    set template_folder_id [parameter::get \
				   -parameter "TemplateRoot" \
				   -package_id $parent_subsite_package_id
			   ]
    
    if {![empty_string_p $template_folder_id]} {
	
	set template_folder_id [xcms::folder::create_folder \
	        -name "xcms-${package_id}-templates" \
		-folder_label "XCMS ${package_id} Templates" \
		-parent_id "-200" \
		-content_types [list content_folder content_template]]
	
	parameter::set_value \
		-package_id $package_id \
		-parameter "template_folder_id" \
		-value $template_folder_id

    }
    
    set template_root  "[acs_root_dir]/templates/${parent_subsite_url}"

    parameter::set_value \
	-package_id $package_id \
	-parameter TemplateRoot \
	-value $template_root
	
# ideally we create a folder mapped to the site_node here set
# to the content_root_id parameter, problem is, if we
# want to manage the main site content, so default to subsite root
# which for now is just -100
 
	set default_template_id [xcms::template::create_template \
				-template_name "xcms-default" \
				-parent_id $template_folder_id]
 	set default_template_dir [acs_r	set template_root  "[acs_root_dir]/templates/${parent_subsite_url}"

	set default_template_file  [acs_root_dir]/packages/xcms-ui-base/lib/xcms-default
	set fd [open ${default_template_file}.adp]
	set default_template_content [read $fd]
	close $fd
	
	xcms::template::add_template \
		-template_id $default_template_id \
		-title "Default Content Template" \
		-content $default_template_content
		
 	set folder_template_id [xcms::template::create_template \
				-template_name "xcms-folder-default" \
				-parent_id $template_folder_id]

	set default_folder_template_file  [acs_root_dir]/packages/xcms-ui-base/lib/xcms-folder-default
	set fd [open ${default_folder_template_file}.adp]
	set default_folder_template_content [read $fd]
	close $fd
	

	xcms::template::add_template \
		-template_id $folder_template_id \
		-title "Default Folder Template" \
		-content $default_folder_template_content
        file mkdir $template_root
	file copy ${default_template_dir}/public $template_root
        file copy ${default_template_dir} ${template_root}

       xcms::template::register_template \
		-content_type "content_revision" \
		-template_id $default_template_id \
		-context "xcms-public"

	xcms::template::register_template \
		-content_type "content_folder" \
		-template_id $folder_template_id \
		-context "xcms-public"

}

ad_proc xcms_ui_base::install::package_uninstall {} {

} {
	unregister_templates
}

ad_proc xcms_ui_base::install::unregister_templates {} {

	unregister templates for package removal

} {


}
