<master src="master">
<property name="title">@title@</property>
<property name="context">@context@</property>
<property name="context_help">@context_help@</property>

<multiple name="actions">
<div class="button">
<a href="@actions.url@" title="@actions.title@">@actions.label@</a>
</div>
</multiple>


<include src="/packages/bcms-ui-base/lib/template-form" revision_id="@revision_id@" return_url="@return_url@" form_mode="display">

