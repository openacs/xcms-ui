<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>

<div>
<multiple name="actions">
<a class="button" href="@actions.url@" title="@actions.title@">@actions.label@</a>
</multiple>
</div>



<fieldset class="formtemplate">
<legend>@title@</legend>

<include src="/packages/bcms-ui-base/resources/page-form" revision_id="@revision_id@" return_url="@return_url@" form_mode="display">
</fieldset>
<fieldset class="formtemplate">
<legend>Additional Properties</legend>
<include src="/packages/xcms-ui/lib/categories-form" item_id="@item_id@" parent_id="@content.parent_id@" return_url="@return_url@" form_mode="display">
</fieldset>
<include src="revision-list" item_id="@item_id@" return_url="@return_url@">
