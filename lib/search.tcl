#    display search results

#    supply the following vars:
#    name_search:optional
#    title_search:optional
#    content_search:optional
#    content_type_search:optional
#    {display_search_results:optional 0}
#    {bulk_actions:optional ""}
#    {bulk_action_export_vars:optional ""}
#    {orderby:optional}
#    {page:optional}


if {[info exists name_search] && [empty_string_p $name_search]} {
    unset name_search
}
if {[info exists title_search] && [empty_string_p $title_search]} {
    unset title_search
}
if {[info exists content_search] && [empty_string_p $content_search]} {
    unset content_search
}
if {[info exists content_type_search] && [empty_string_p $content_type_search]} {
    unset content_type_search
}
if {![info exists display_search_results]} {
    set display_search_results 0
}
if {![info exists bulk_actions]} {
    set bulk_actions ""
}
if {![info exists bulk_action_export_vars]} {
    set bulk_action_export_vars ""
}

if {$display_search_results} {

    set root_folder_id [parameter::get -parameter root_folder_id]

    set addtnl_where_list {}
    if {[exists_and_not_null content_search]} {
        set openfts_where "and txt.fts_index @@ '\\\'$content_search\\\'' and txt.tid = i.live_revision"
        set openfts_from ", txt"
    } else {
        set openfts_where ""
        set openfts_from ""
    }

    set package_url [ad_conn package_url]

    if {![info exists folder_id]} {
        set folder_id [parameter::get -parameter root_folder_id]
    }

    # we need to construct the pass on bulk action export vars
    # on the local tcl name space and also add them to the filters
    set bulk_action_export_vars_filter ""
    foreach export_var $bulk_action_export_vars {
        if {![info exists $export_var]} {
            # lets just make sure that it does not exist on the local namespace
            upvar 1 $export_var $export_var
        }
        append bulk_action_export_vars_filter "
           $export_var {
               add_url_eval {[export_vars $export_var]}
           }
        "
    }
    set filters "
            $bulk_action_export_vars_filter
            display_search_results {}
            title_search {
                where_clause {title ilike '%' || :title_search || '%'}
            }
            name_search {
                where_clause {name ilike '%' || :name_search || '%'}
            }
            content_search {}
            content_type_search {
                where_clause {content_type = :content_type_search}
            }
    "

    template::list::create \
        -name search_results \
        -multirow search_results \
        -key item_id \
        -pass_properties { package_url } \
        -bulk_actions $bulk_actions \
        -bulk_action_export_vars $bulk_action_export_vars \
        -elements {
            name {
                label "Name"
                link_url_eval {${package_url}manage/switch-type?manage_type=content&return_url=[ad_urlencode "${package_url}$path"]}
            }
            title {
                label "Title"
            }
            content_type {
                label "Type"
                display_template { 
                    <if @search_results.content_type@ eq content_folder>
                    <a href=@search_results.name@><img src="@package_url@xcms-ui-images/folder.png" border="0"></a>
                    </if>
                    <if @search_results.content_type@ eq content_revision>
                       <if @search_results.storage_type@ eq text>
                          <a href=@search_results.name@><img src="@package_url@xcms-ui-images/page.png" border="0"></a>
                       </if>
                       <else>
                          <a href=@search_results.name@><img src="@package_url@xcms-ui-images/file.png" border="0"></a>
                       </else>
                    </if> 
                    <if @search_results.content_type@ eq image>
                    <a href=@search_results.name@><img src="@package_url@xcms-ui-images/image.png" border="0"></a>
                    </if>
                    <if @search_results.content_type@ eq sb_writing>
                    <a href=@search_results.name@><img src="@package_url@xcms-ui-images/sb_writing.png" border="0"></a>
                    </if>
                    <if @search_results.content_type@ eq sb_event>
                    <a href=@search_results.name@><img src="@package_url@xcms-ui-images/sb_event.png" border="0"></a>
                    </if>                    
                    <if @search_results.content_type@ eq sb_download>
                    <a href=@search_results.name@><img src="@package_url@xcms-ui-images/sb_download.png" border="0"></a>
                    </if>    
                }
                html { style "width:70px" }
            }
            last_modified {
                label "Last Modified"
                html { style "width:180px" }
            }
        } \
        -filters $filters \
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
        -page_flush_p 1 \
        -page_query_name get_results_page_query


    db_multirow search_results get_results "SQL"


    set title "Search Results"

} else {
    template::form::create simpleform
    template::element::create simpleform name_search -widget text -label "Name" -datatype string -optional
    template::element::create simpleform title_search -widget text -label "Title" -datatype string -optional
    template::element::create simpleform content_search -widget text -label "Published Content" -datatype string -optional
    if {[exists_and_not_null content_type_search]} {
        template::element::create simpleform content_type_search -widget hidden -value $content_type_search
    }
    template::element::create simpleform display_search_results -widget hidden -value 1
    foreach export_var $bulk_action_export_vars {
        upvar 1 $export_var export_var_local
        if {![template::element::exists simpleform $export_var]} {
            template::element::create simpleform $export_var -widget hidden -value $export_var_local -datatype string
        }
    }

    # we need to put this dummy one even we dont use it
    template::list::create \
        -name search_results \
        -multirow search_results \
        -key item_id \
        -elements {}

    set title "Search"

}
