<master src="master">
<property name="title">@title@</property>
<property name="context_url">@return_url@</property>
<property name="context">context</property>
<if @category.category_id@ not nil>
    <fieldset class="formtemplate">
        <legend>Assigned Root Category</legend>
        <div class="formtemplate">
            <div class="oneelement">
                <label>Category Heading</label>
                <div class="formfield">@category.heading@</div>
            </div>
            <div class="oneelement">
                <label>Description</label>
                <div class="formfield">@category.description@</div>
            </div>
        </div>
    </fieldset>
</if>
<else>
    <listtemplate name="category_list"></listtemplate>
</else>
