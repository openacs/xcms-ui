<if @display_search_results@ false>

<fieldset class="formtemplate">
<legend>@title@</legend>
<formtemplate id="simpleform" style="../../../bcms-ui-base/lib/form-template"></formtemplate>
</fieldset>

</if>
<else>
    <listtemplate name="search_results" style="../../../bcms-ui-base/lib/item-list"></listtemplate>
</else>
