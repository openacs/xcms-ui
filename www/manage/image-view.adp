<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>
<property name="context_help">@context_help@</property>


<div>
<p>
<multiple name="actions">
<a class="button" href="@actions.url@" title="@title@">@actions.label@</a>
</multiple>
</p>
</div>


<fieldset class="formtemplate">
<legend>@title@</legend>
<include src="/packages/bcms-ui-base/lib/image-form" revision_id="@revision_id@" return_url="@return_url@" form_mode="display">
</fieldset>

<p>
<include src="revision-list" item_id="@item_id@" return_url="@return_url@">
</p>
<div style="clear:both;"></div>
<img src="@current_item.name@?preview_p=t">


