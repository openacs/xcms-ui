ad_library {
	Install callback procedures for xcms-ui-base
}

namespace eval xcms_ui::install {}

ad_proc xcms_ui::install::package_install {} {

}


ad_proc xcms_ui::install::after_mount {
	-package_id
	-node_id
} {
	After mount callback
} {

    array set sn [site_node::get_from_object_id -object_id $package_id]
    ns_log notice "
--------------------------------------------------------------------------------
DAVE debugging procedure xcms_ui::install::after_mount
--------------------------------------------------------------------------------
sn = '[array get sn]'
--------------------------------------------------------------------------------"
    # create a new folder for this package_id
	set folder_id [bcms::folder::create_folder \
		-name "pages-${package_id}" \
		-folder_label "Pages" \
		-parent_id "0" \
		-description "Content Managed Pages" \
		-package_id $package_id \
		-context_id $package_id \
		-content_types "content_revision content_folder content_extlink content_symlink image" 
		]

	# setup a template folder also
	set template_folder_id [bcms::folder::create_folder \
		-name "templates-${package_id}" \
		-folder_label "Templates" \
		-parent_id "0" \
		-description "Content Templates" \
		-package_id $package_id \
		-context_id $package_id \
		-content_types "content_template"
		]

# load in default templates

set template_root "templates$sn(url)"
set template_dir "[acs_root_dir]/${template_root}"
set www_dir "[acs_root_dir]/www$sn(url)"

if {![file exists $template_dir]} {
	file mkdir $template_dir
}

if {![file exists $www_dir]} {
	file mkdir $www_dir
}

set templates [list xcms-default content_revision "Default Content Template" xcms-folder-default content_folder "Default Folder Template"]
set template_base "[acs_root_dir]/packages/xcms-ui/lib/"

# setup use_context
set use_context "xcms-${package_id}-public"
db_dml set_use_context "insert into cr_template_use_contexts values (:use_context)"

foreach {filename content_type title } $templates {

       set template_id [bcms::template::create_template \
			-template_name $filename \
			-parent_id $template_folder_id]

       set fd [open "${template_base}${filename}.adp"]
	set content [read $fd]
	close $fd

       
	bcms::template::register_template \
		-template_id $template_id \
		-content_type $content_type \
		-context $use_context \
		-is_default_p "t"
		
	bcms::template::add_template \
		-template_id $template_id \
		-title $title \
		-content $content
		
	file copy -force "${template_base}${filename}.adp" "${template_base}${filename}.tcl" $template_dir

}


# import the sample index page
set fd [open ${template_base}sample-index.adp]
set sample_index_content [read $fd]
close $fd

set sample_index_id [bcms::create_page \
			 -page_name "index" \
			 -folder_id $folder_id \
			 -mime_type "text/html" \
			 -title "XCMS Sample Index" \
			 -page_body $sample_index_content]

# set live revision
item::publish -item_id $sample_index_id
# TODO remove these
# set parameters

parameter::set_value -package_id $package_id -parameter "root_folder_id" -value $folder_id
parameter::set_value -package_id $package_id -parameter "template_folder_id" -value $template_folder_id
parameter::set_value -package_id $package_id -parameter "TemplateRoot" -value $template_root
parameter::set_value -package_id $package_id -parameter cms_context -value $use_context
# FIXME this requires a call from pl/sql to register the relationship

# TODO add cr_item_rels for content and template folders, conext is
# always xcms-${package_id}-public
#bcms::item::relate_item \
    -item_id $folder_id \
    -relation_tag "xcms-root-content-folder" \
    -related_object_id $sn(node_id)
#bcms::item::relate_item \
    -item_id $template_folder_id \
    -relation_tag "xcms-root-template-folder" \
    -related_object_id $sn(node_id)


# get default index.vuh file
# substitute default folder ids

#set fd [open "${template_base}index.vuh"]
#set index_content [read $fd]
#close $fd

#regsub -- {-100} $index_content $folder_id index_content]
#regsub -- {-200} $index_content $template_folder_id index_content]
#regsub -- {REPLACE-USE-CONTEXT} $index_content $use_context index_content]
#regsub -- {REPLACE-PACKAGE-ID} $index_content $package_id index_content]

#set fd [open "${www_dir}index.vuh" w]
#puts $fd $index_content
#close $fd

}

ad_proc xcms_ui::install::package_uninstall {} {

} {
	unregister_templates
}

ad_proc xcms_ui::install::unregister_templates {} {

	unregister templates for package removal

} {


}
