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
	<if @folders.folder_id@ ne @current_root_folder_id@>
                <td>
		<a href="set-parameter?parameter_name=root_folder_id&value=@folders.folder_id@&return_url=@current_url@">make this folder your root folder</a> 
                </td>
                <td>
                <a href="create-folder?parent_id=@folders.folder_id@&create_index_p=true&return_url=@current_url@"> create a subfolder </a> 
                </td>
	</if>
	<else>
                <td>
		current root folder
                </td>
                <td>
                <a href="create-folder?parent_id=@folders.folder_id@&create_index_p=true&return_url=@current_url@"> create a subfolder </a> 
                </td>
	</else>
	</tr>
</multiple>
</table>

<if @current_root_folder_id@ not nil>
    <form>
        Register New Content Type: <input type="text" name="new_content_type">
    </form>
</if>
