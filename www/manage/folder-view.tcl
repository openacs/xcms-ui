ad_page_contract {
    lists the items under a folder.  we need to use different queries on template and content manage_type
} {
    item
    {orderby:optional}
    {page:optional}
    {return_url "[ad_conn url]"}
}
if {![regexp {/$} [ad_conn url]]} {
	ad_returnredirect "[ad_conn url]/"
	ad_script_abort
}

set root_id [parameter::get -parameter root_folder_id -default "-100"]
array set current_item $item
set folder_id $current_item(item_id)
array set folder [bcms::folder::get_folder -folder_id $folder_id]
set package_url [ad_conn package_url]

#set type_options [bcms::folder::content_types_select -folder_id $folder_id]

set type_options { {Page page-add} {Folder folder-add} {Image image-add} }

ad_form -name add-item  -export {return_url} -form {
	{submit:text(submit) {label "Add New"} {value "Add New"}}
	{item_type:text(select) {label ""} {options $type_options } }
	{parent_id:text(hidden) {value $folder_id}}
} -on_submit {
	ad_returnredirect "[ad_conn package_url]manage/${item_type}?[export_vars {{parent_id $folder_id} return_url}]"
}

set url_base "${package_url}/manage/"

    template::list::create \
        -name item_list \
        -multirow item_list \
        -pass_properties { package_url } \
        -key item_id \
    -actions [list "Set Folder Category" "/categories/cadmin/one-object?[export_vars {{object_id $folder_id} return_url}]" "Set the root category for the currently displayed folder" "Change Template" "${url_base}apply-template?[export_vars { {item_id $folder_id} return_url}]" "Change the template used to display this item."] \
    -bulk_actions [list \
            "Delete" "${package_url}manage/delete-item" "Delete checked items" \
            "Move" "${package_url}manage/move-item" "Move checked items" \
                          ]\
        -bulk_action_export_vars {
            return_url
        } \
        -elements {
            name {
                label "Name"
                link_url_col name
            }
            title {
                label "Title"
            }
            content_type {
                label "Type"
                display_template { 
                    <if @item_list.content_type@ eq content_folder>
                    <a href=@item_list.name@><img src="@package_url@resources/folder.png" border="0"></a>
                    </if>
                    <if @item_list.content_type@ eq content_revision>
                       <if @item_list.storage_type@ eq text>
                          <a href=@item_list.name@><img src="@package_url@resources/page.png" border="0"></a>
                       </if>
                       <else>
                          <a href=@item_list.name@><img src="@package_url@resources/file.png" border="0"></a>
                       </else>
                    </if> 
                    <if @item_list.content_type@ eq image>
                    <a href=@item_list.name@><img src="@package_url@resources/image.png" border="0"></a>
                    </if>
                    <if @item_list.content_type@ eq contract_revision>
                    <a href=@item_list.name@><img src="@package_url@resources/contract_revision.png" border="0"></a>
                    </if>
                    <if @item_list.content_type@ eq sb_writing>
                    <a href=@item_list.name@><img src="@package_url@resources/sb_writing.png" border="0"></a>
                    </if>
                    <if @item_list.content_type@ eq sb_event>
                    <a href=@item_list.name@><img src="@package_url@resources/sb_event.png" border="0"></a>
                    </if>                    
                    <if @item_list.content_type@ eq sb_download>
                    <a href=@item_list.name@><img src="@package_url@resources/sb_download.png" border="0"></a>
                    </if>                    
                }
                html { style "width:70px" }
            }
            last_modified_pretty {
                label "Last Modified"
                html { style "width:180px" }
            }
            publish_status {
                label "Status"
            }
        } \
        -orderby {
            default_value name,asc
            name {
                orderby name
            }
            title {
                orderby title
            }
            content_type {
                orderby content_type
            }
            last_modified {
                orderby last_modified
            }
        } \
        -page_size 10 \
        -page_groupsize 10 \
        -page_query {
                        select  i.item_id,
                                i.name,  
                                i.live_revision, 
                                i.latest_revision, 
                                i.publish_status, 
                                i.content_type, 
                                i.storage_type,
                                i.tree_sortkey,
                                last_modified,
                                r.title, 
                                r.description
                        from cr_items i, cr_revisionsx r
                        where
                                i.parent_id = $current_item(item_id)
                                and i.latest_revision = r.revision_id
                        union

                        select i.item_id, 
                                i.name,  
                                i.live_revision, 
                                i.latest_revision, 
                                i.publish_status, 
                                i.content_type, 
                                i.storage_type,
                                i.tree_sortkey,
                                null as last_modified,
                                f.label as title,
                                f.description
                        from cr_items i, cr_folders f
                        where
                                i.parent_id = $current_item(item_id)
                                and i.item_id = f.folder_id
                        [template::list::orderby_clause -orderby -name item_list]
        } \
        -page_flush_p 1
    

    bcms::item::list_items -parent_id $folder_id -multirow_name item_list -orderby [template::list::orderby_clause -name item_list] -show_only [template::list::page_get_ids -name item_list]

set context_action ""
# this can be used to show help text on the page
set context_help ""

set title "View Folder"

set context [bcms::widget::item_context -item_id $folder_id -root_id $root_id -root_url [ad_conn package_url]manage/ ]

set context [lrange $context 0 [expr [llength $context] - 2]]

lappend context $folder(label)
