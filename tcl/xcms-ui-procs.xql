<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">

<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2004-05-03 -->
<!-- @cvs-id $Id$ -->

<queryset>

  <fullquery name="xcms_ui::register_folders.node_id_exists_p">
    <querytext>
      select 1 from xcms_site_node_fodler_map
      where node_id=:node_id
    </querytext>
  </fullquery>
  
  <fullquery name="xcms_ui::register_folders.add_node">
    <querytext>
      insert into xcms_site_node_folder_map
      values
      (:node_id,:folder_id,:template_folder_id,:default_use_context)
    </querytext>
  </fullquery>

  <fullquery name="xcms_ui::register_folders.update_node">
    <querytext>
      udate xcms_site_node_folder_map
      set 
          folder_id=:folder_id,
          template_folder_id=:template_folder_id,
          default_use_context=:default_use_context
      where node_id=:node_id
    </querytext>
  </fullquery>

</queryset>