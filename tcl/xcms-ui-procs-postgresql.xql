<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.2</version></rdbms>

        <fullquery name="bcms_ui_base::delete_url.can_delete">
                <querytext>
                        select case when count(*) = 0 then true else false end 
                        from cr_items 
                        where content_type = 'content_folder' 
                        and item_id in ($item_ids)
                        and not content_folder__is_empty(item_id)
                </querytext>
        </fullquery>

</queryset>
