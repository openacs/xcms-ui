ad_page_contract {

	setup folders and templates

} -query {

	{type "package"}

} 

set user_id [ad_conn user_id]
set this_package_id [ad_conn package_id]
set subsite_id [ad_conn subsite_id]

# if type of subsite is requested make sure we have pemission to 
# admin the subsite

if {[string equal "subsite" $type]} {
	permission::require_permission \
		-object_id $subsite_id \
		-party_id $user_id \
		-privilege "admin"

	# if we are setting up the subsite, use that package_id

    set package_id $subsite_id

} else {

    set package_id $this_package_id
}

array set sn [site_node::get_from_object_id -object_id $package_id]

# see if there is a folder for this subsite

if {[string equal $sn(node_id) [site_node::get_node_id  -url "/"]]} {
	set folder_id "-100"
	set template_folder_id "-200"
} else {
	set folder_id [bcms::folder::get_id_by_package_id -package_id $package_id]

	# create a new folder for this package_id
	set folder_id [bcms::folder::create_folder \
		-name "pages-${package_id}" \
		-folder_label "Pages" \
		-parent_id "0" \
		-description "Content Managed Pages" \
		-package_id $package_id \
		-context_id $this_package_id \
		-content_types "content_revision content_folder content_extlink content_symlink image" \
		-subtypes
		]
		
	# Main Subsite folder -100 already has a corresponding template
	# folder. If we are not setting up for folder_id -100 create
	# a template folder also
	set template_folder_id [bcms::folder::create_folder \
		-name "templates-${package_id}" \
		-folder_label "Templates" \
		-parent_id "0" \
		-description "Content Templates" \
		-package_id $package_id \
		-context_id $this_package_id \
		-content_types "content_template" \
		-subtypes
		]
}

# load in default templates

set template_root "/templates${sn(url)}"
set template_dir "[acs_root_dir]${template_root}"
set www_dir "[acs_root_dir]/www${sn(url)}"

if {![file exists $template_dir]} {
	file mkdir $template_dir
}

if {![file exists $www_dir]} {
	file mkdir $www_dir
}

set templates [list xcms-default content_revision "Default Content Template" xcms-folder-default content_folder "Default Folder Template"]
set template_base "[acs_root_dir]/packages/xcms-ui/lib/"
foreach {filename content_type title } $templates {

       set template_id [bcms::template::create_template \
			-template_name $filename \
			-parent_id $template_folder_id]

	set fd [open "${template_base}$filename.adp"]
	set content [read $fd]
	close $fd

	bcms::template::register_template \
		-template_id $template_id \
		-content_type $content_type \
		-context "public" \
		-is_default_p "t"
		
	bcms::template::add_template \
		-template_id $template_id \
		-title $title \
		-content $content
		
	file copy -force "${template_base}${filename}.adp" "${template_base}${filename}.tcl" $template_dir

}

# set parameters

parameter::set_value -parameter "root_folder_id" -value $folder_id
parameter::set_value -parameter "template_folder_id" -value $template_folder_id
parameter::set_value -parameter "TemplateRoot" -value $template_root

# get default index.vuh file
# substitute default folder ids

set fd [open "${template_base}index.vuh"]
set index_content [read $fd]
close $fd

set index_content [regsub -- {-100} $index_content $folder_id]
set index_content [regsub -- {-200} $index_content $template_folder_id]

set fd [open "${www_dir}index.vuh" w]
puts $fd $index_content
close $fd

