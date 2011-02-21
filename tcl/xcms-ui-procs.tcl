ad_library {

	Procs specific for for this XCMS UI (xcms-ui)

	@author Jun Yamog
	@creation-date Aug 2003
	@cvs-id $Id$

}


namespace eval xcms_ui {}

ad_proc -public xcms_ui::move_url {
    {-items_to_move:required}
    {-destination_folder:required}
    {-return_url:required}
    {-redirect_to_folder "0"}
} {
    returns the link to move an item to another folder

    @param items_to_move         a list of item_id you wish to move
    @param destination_folder    folder_id of where the item will be be moved
    @param return_url            after moving, redirects to this url
    @param redirect_to_folder    if set to 1 then it will rebuild the return_url pointing to the new
                                 folder being moved to

    @return a link, normally used for the list builder
} {
    set item_id $items_to_move
    set folder_id $destination_folder

    # redirect the destination folder, normally you will need to do this if one of the item_id
    # is the current return_url.  So you will not redirect to a item that has moved
    if {$redirect_to_folder} {
        set path_list [bcms::item::get_item_path -item_id $destination_folder -prepend_path [ad_conn package_url] -return_list -no_parent]
        set path "[ns_set get [lindex $path_list 0] path]"
        set return_url $path
    }

    set url [export_vars -url -base "[ad_conn package_url]manage/move-item" {item_id:multiple folder_id redirect_to_folder return_url}]
    return $url
}


ad_proc -public xcms_ui::delete_url {
    {-items_to_delete:required}
    {-return_url:required}
    {-confirm:boolean}
} {
    returns the link to delete the items

    @param items_to_delete     a list of item_id you wish to delet
    @param return_url          after deleting, move to this url
    @param confirm             if passed it will generate a link that will delete the items 
                               without confirmation

    @return a link to delete the items, but if a folder that will be deleted is not empty
    it will return a null string
} {
    set item_id $items_to_delete

    set item_ids [join $item_id ", "]
    set can_delete_p [db_string can_delete "SQL"]
    if {[string equal $can_delete_p "t"]} {
        return [export_vars -url -base "[ad_conn package_url]manage/delete-item" {item_id:multiple confirm_p return_url}]
    } else {
        return {}
    }
}

ad_proc -public xcms_ui::apply_template_url {
    {-item_id:required}
    {-template_id:required}
    {-return_url:required}
} {
    returns a link to apply the template

    @param item_id             id of the item to apply the template to
    @param template_id         id of which template to use
    @param return_url          after applying the template, redirect to this url

    @return a link to apply the template
} {

    set url [export_vars -url -base "[ad_conn package_url]manage/apply-template" {item_id template_id return_url}]
    return $url

}
    
ad_proc -public xcms_ui::delete_template_url {
    {-templates_to_delete:required}
    {-return_url:required}
} {
    returns the link to delete the templates, use this when the user has confirmed

    @param templates_to_delete a list of template_id you wish to delet
    @param return_url          after deleting, move to this url

    @return a link to delete the templates
} {
    set confirm_p 1
    set template_id $templates_to_delete

    return [export_vars -url -base "[ad_conn package_url]manage/template-delete" {template_id:multiple confirm_p return_url}]

}

ad_proc -public xcms_ui::switch_cms_context_url {
    {-cms_context:required}
    {-return_url}
} {
    create a link to switch to a cms_context

    @param cms_context  switch to which cms_context
    @param return_url   set where to redirect after switching cms_context

    @return a url to on how to switch to a cms_context
} {

    set package_url [ad_conn package_url]
    if {![info exists return_url]} {
        set return_url [ad_return_url]
    }

    return [export_vars -base ${package_url}manage/switch-context {{cms_context $cms_context} {return_url $return_url}}]

}

ad_proc -public xcms_ui::context_action_link {
    {-context_action:required}
    {-export_vars:required}
    {-context_action_label}
} {
    create a html a href for a particular context action

    @param context_action       context action you would like to generate a link
    @parem export_vars          vars to put on the get query
} {

    set package_url [ad_conn package_url]

    set context_action_link " <a class=\"contextaction\""

    switch -exact $context_action {
        apply-template {
            append context_action_link " id=\"apply-template\" href=\"${package_url}manage/apply-template?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Apply Template"
            }
            append context_action_link "</a>"
        }
        folder-set-category {
            append context_action_link " id=\"folder-set-category\" href=\"${package_url}manage/folder-set-category?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Use Categories"
            }
            append context_action_link "</a>"
        }
        folder-add {
            append context_action_link " id=\"folder-add\" href=\"${package_url}manage/folder-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add SubFolder"
            }
            append context_action_link "</a>"
        }
        page-add {
            append context_action_link " id=\"page-add\" href=\"${package_url}manage/page-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add Page"
            }
            append context_action_link "</a>"
        }
        image-add {
            append context_action_link " id=\"image-add\" href=\"${package_url}manage/image-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add Image"
            }
            append context_action_link "</a>"
        }
        file-add {
            append context_action_link " id=\"file-add\" href=\"${package_url}manage/file-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add File"
            }
            append context_action_link "</a>"
        }
        sb-event-add {
            append context_action_link " id=\"sb-event-add\" href=\"${package_url}manage/sb-event-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add Event & Gigs"
            }
            append context_action_link "</a>"
        }
        sb-bio-add {
            append context_action_link " id=\"sb-bio-add\" href=\"${package_url}manage/sb-bio-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add Biography"
            }
            append context_action_link "</a>"
        }
        template-add {
            append context_action_link " id=\"template-add\" href=\"${package_url}manage/template-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add Template"
            }
            append context_action_link "</a>"
        }
        revision-publish {
            append context_action_link " id=\"revision-publish\" href=\"${package_url}manage/revision-publish?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Publish"
            }
            append context_action_link "</a>"
        }
        revision-unpublish {
            append context_action_link " id=\"revision-unpublish\" href=\"${package_url}manage/revision-unpublish?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Unpublish"
            }
            append context_action_link "</a>"
        }
        categorize-item {
            append context_action_link " id=\"categorize-item\" href=\"${package_url}manage/categorize-item?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Categorize"
            }
            append context_action_link "</a>"
        }
        revision-list {
            append context_action_link " id=\"revision-list\" href=\"${package_url}manage/revision-list?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "View Version(s)"
            }
            append context_action_link "</a>"
        }
        relate-page {
            append context_action_link " id=\"relate-page\" href=\"${package_url}manage/relate-item?${export_vars}&[export_vars {{content_type_search content_revision} {relation_type pages}}]\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Relate Page"
            }
            append context_action_link "</a>"
        }
        relate-image {
            append context_action_link " id=\"relate-image\" href=\"${package_url}manage/relate-item?${export_vars}&[export_vars {{content_type_search image} {relation_type images}}]\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Relate Image"
            }
            append context_action_link "</a>"
        }
        template-write {
            append context_action_link " id=\"template-write\" href=\"${package_url}manage/template-write?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Write Template"
            }
            append context_action_link "</a>"
        }
        sb-writing-add {
            append context_action_link " id=\"sb-writing-add\" href=\"${package_url}manage/sb-writing-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add Writing"
            }
            append context_action_link "</a>"
        }
        sb-download-add {
            append context_action_link " id=\"sb-download-add\" href=\"${package_url}manage/sb-download-add?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Add Download"
            }
            append context_action_link "</a>"
        }
        sb-band-set {
            append context_action_link " id=\"sb-band-set\" href=\"${package_url}manage/sb-band-set?$export_vars\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Select Band"
            }
            append context_action_link "</a>"
        }
        sb-featured-set {
            append context_action_link " id=\"sb-featured-set\" href=\"${package_url}manage/sb-featured-set?$export_vars&[export_vars {{action set}}]\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Set Featured"
            }
            append context_action_link "</a>"
        }
        sb-featured-unset {
            append context_action_link " id=\"sb-featured-set\" href=\"${package_url}manage/sb-featured-set?$export_vars&[export_vars {{action unset}}]\">"
            if {[info exists context_action_label]} {
                append context_action_link $context_action_label
            } else {
                append context_action_link "Unset Featured"
            }
            append context_action_link "</a>"
        }
        default { error "context_action = $context_action is not a valid value" }
        
    }

    return $context_action_link

}


ad_proc -public xcms_ui::redirect_after_rename {
    {-item_id:required}
    {-url_base "[ad_conn package_url]"}
} {
    after renaming the url/name of an item.  you will need to redirect to the new url/name

    @param item_id redirect to the url of this item
} {
    set first_row [lindex [bcms::item::get_item_path -item_id $item_id -prepend_path [ad_conn package_url] -return_list -no_parent] 1]
    if {[llength $first_row] > 0} {
        set path [ns_set get $first_row path]
    } else {
        set path $url_base
    }
    
    ns_log notice " DAVEB!! url_base '$url_base' path '$path'"
    ad_returnredirect "${path}"
    ad_script_abort
}

ad_proc -public xcms_ui::check_include_vars {
} {
    check item_id, folder_id, revision_id, form_mode and return_url vars.  This is used for the forms that is included in /xcms-ui/lib
} {
    upvar 1 item_id item_id parent_id parent_id  revision_id revision_id form_mode form_mode return_url return_url

    # check if the parameters exists and set them to their defaults
    if {![info exists parent_id]} {
        if {![info exists revision_id]} {
            error "parent_id does not exists, please pass in the parent_id if you are creating a new item"
        }
        set parent_id ""
        set item_id ""
    } else {
        set item_id ""
    }
    if {![info exists form_mode]} {
        set form_mode edit
    }
    if {![info exists return_url]} {
        error "return_url does not exists, please pass in return_url"
    }
}

ad_proc xcms_ui::content_root {
    {-node_id ""}
} {
    @param node_id If node_id is specified content root is returned
     for that site_node. Otherwise the node_id of the current request
    is used.
    @return content folder_id for node_id. empty string if no folder
	is mapped to node_id
    
} {

    return [db_string get_content_root "" -default ""]

    
}

ad_proc xcms_ui::template_root {
    {-node_id ""}
} {
    @param node_id If node_id is specified content root is returned
     for that site_node. Otherwise the node_id of the current request
    is used.
    @return content folder_id for node_id. empty string if no folder
	is mapped to node_id
} {

    return [db_string get_content_root "" -default ""]
    
}
