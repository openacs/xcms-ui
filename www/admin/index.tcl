array set subsite_sn [site_node::get_from_object_id -object_id [ad_conn subsite_id]]
set subsite_id [ad_conn subsite_id]
set subsite_url $subsite_sn(url)

set subsite_name $subsite_sn(instance_name)

set subsite_admin_p [permission::permission_p \
			-party_id [ad_conn user_id] \
			-object_id [ad_conn subsite_id] \
			-privilege "admin"]

set package_url [ad_conn package_url]
set package_name [ad_conn instance_name]

set template_root "[acs_root_dir]templates${subsite_sn(url)}"
