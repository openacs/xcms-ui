<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<strong>Current Template: </strong>
<if @current_template.title@ not nil>@current_template.title@ 
    <a class="button" href="@package_url@manage/unregister-template?item_id=@item_id@&template_id=@current_template.item_id@&context=public&return_url=@current_url@" title="Revert to default template">Unregister Template</a> <a class="button" href="@return_url@" title="Return to page view">Cancel</a>
</if>
<else>
    none
</else>

<listtemplate name="template_list"></listtemplate>
