<master src="master">
<property name="title">@title@</property>
<property name="context_url">@return_url@</property>

<listtemplate name="related_items" style="../../../bcms-ui-base/lib/item-list"></listtemplate>

<include src="../../lib/search" name_search="@name_search@" title_search="@title_search@" content_search="@content_search@" 
display_search_results="@display_search_results@" content_type_search="@content_type_search@" bulk_actions="@bulk_actions@" 
bulk_action_export_vars="@bulk_action_export_vars@" orderby="@orderby@" page="@page@">

