<master>
<property name="context">@context;noquote@</property>
<property name="title">@title@</property>
<div id="main">
<include src="/packages/bcms-ui-base/lib/navbar">
    <div id="contextpane">
        <if @context_action@ not nil>
        <div id="contextaction">
            @context_action;noquote@
        </div>
        </if>
        <div id="contexthelp">
        <if @context_help@ not nil>
            <p>@context_help;noquote@</p>
        </if>
        <else>
            <p>no help available</p>
        </else>
        </div>
    </div>

    <div id="contentpane">
        <slave>
    </div>

</div>

</body>
</html>
