<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="get_results">      
    <querytext>

        select * from (
            select i.item_id, 
                i.name, 
                content_item__get_path(i.item_id, r.item_id) as path,
                i.parent_id,
                case when i.content_type = 'content_folder' then content_folder__get_label(i.item_id) else bcms__get_title(i.item_id, 'latest') end as title,
                i.live_revision,
                i.latest_revision,
                i.content_type,
                to_char(ao.last_modified,'YYYY-MM-DD HH:MM AM') as last_modified,
                i.storage_type
            from cr_items i, acs_objects ao,
                (select tree_sortkey, item_id from cr_items where item_id = :root_folder_id) r $openfts_from
            where tree_ancestor_p(r.tree_sortkey, i.tree_sortkey) 
                and ao.object_id = i.item_id
                and i.item_id <> r.item_id
                $openfts_where
                [template::list::page_where_clause -key i.item_id -and -name search_results]
        ) results
            where 1 = 1
            [template::list::filter_where_clauses -and -name search_results]
            [template::list::orderby_clause -orderby -name search_results]
    </querytext>
</fullquery>

<fullquery name="get_results_page_query">      
    <querytext>

        select * from (
            select i.item_id, 
                i.name, 
                i.parent_id,
                case when i.content_type = 'content_folder' then content_folder__get_label(i.item_id) else bcms__get_title(i.item_id, 'latest') end as title,
                i.live_revision,
                i.content_type,
                to_char(ao.last_modified,'YYYY-MM-DD HH:MM AM') as last_modified
            from cr_items i, acs_objects ao,
                (select tree_sortkey, item_id from cr_items where item_id = :root_folder_id) r $openfts_from
            where tree_ancestor_p(r.tree_sortkey, i.tree_sortkey) 
                and ao.object_id = i.item_id
                and i.item_id <> r.item_id
                $openfts_where
        ) results
            where 1 = 1
            [template::list::filter_where_clauses -and -name search_results]
            [template::list::orderby_clause -orderby -name search_results]
    </querytext>
</fullquery>


</queryset>
