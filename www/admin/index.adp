<master>

<h3>Configure this BCMS UI instance</h3>


<ul>
  <if @subsite_admin_p@ eq 1>
  <li><a href="./setup?type=subsite">Setup to manage content under subsite: @subsite_name@ mounted at @subsite_url@ subsite_id = @subsite_id@ pakcage_id=@subsite_sn.package_id@ node_id=@subsite_sn.node_id@ template_root=@template_root@</a></li>
  </if>

  <li><a href="./setup?type=package">Setup to manage content under : @package_name@ mounted at @package_url@</a></li>

</ul>

  



