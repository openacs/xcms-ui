<master src="master">
<property name="title">@title@</property>
<property name="context">@context;noquote@</property>
<property name="context_action">@context_action;noquote@</property>
<property name="context_help">@context_help;noquote@</property>
<property name="display_switch_context_p">1</property>
<fieldset class="formtemplate">
<legend>Folder Properties</legend>
<include src="/packages/bcms-ui-base/lib/folder-form" folder_id="@current_item.item_id@" return_url="@return_url@" form_mode="display">
</fieldset>

<fieldset class="formtemplate">
<legend>Folder Contents</legend>
<formtemplate style="inline" id="add-item"></formtemplate>
<listtemplate name="item_list"></listtemplate>
</fieldset>
