# Register Zeppelin as HopsWorks service
bash 'set_zeppelin_as_enabled' do
  user "root"
  group "root"
  code <<-EOH
    #{node['ndb']['scripts_dir']}/mysql-client.sh -e \"INSERT INTO hopsworks.variables values('zeppelin_enabled', '#{node['zeppelin']['enabled']}')\"
  EOH
  not_if "#{node['ndb']['scripts_dir']}/mysql-client.sh -e \"SELECT * FROM hopsworks.variables WHERE id='zeppelin_enabled'\" | grep zeppelin_enabled"
end

hopsworks_user= node['install']['user'].empty? ? "glassfish" : node['install']['user']
if node.attribute?('hopsworks') == true
  if node['hopsworks'].attribute?('user') == true
    hopsworks_user = node['hopsworks']['user']
  end
end

directory node['zeppelin']['base_dir'] + "/Projects" do
  owner hopsworks_user
  group node['hops']['group']
  mode "0710"
  action :create
end
