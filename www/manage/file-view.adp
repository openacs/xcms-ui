<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>
<property name="context_action">@context_action@</property>
<property name="context_help">@context_help@</property>
<property name="display_switch_context_p">1</property>

<fieldset class="formtemplate">
<legend>@title@</legend>
<include src="/packages/bcms-ui-base/lib/file-form" revision_id="@revision_id@" return_url="@return_url@" form_mode="display">
</fieldset>

<a href="@current_item.name@?preview_p=1">Download</a>



