<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<table>
        <tr><th>Path</th><th></th><th></th></tr>
<multiple name="folders">
	<tr>
	<td>
	@folders.path@ 
	</td>
	<if @folders.folder_id@ ne @current_template_folder_id@>
                <td>
		<a href="set-parameter?parameter_name=template_folder_id&value=@folders.folder_id@&return_url=@current_url@"> make this folder your template folder</a> 
                </td>
                <td>
                <a href="create-folder?parent_id=@folders.folder_id@&return_url=@current_url@"> create a subfolder </a> 
                </td>
	</if>
	<else>
                <td>
		current template folder
                </td>
                <td>
                <a href="create-folder?parent_id=@folders.folder_id@&return_url=@current_url@"> create a subfolder </a> 
                </td>
	</else>
	</tr>
</multiple>
</table>
