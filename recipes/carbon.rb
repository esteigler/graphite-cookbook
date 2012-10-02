package "libsqlite3-dev"

packages = {
  'pysqlite' => '2.6.3',
  'Twisted' => '11.1.0',
  'txAMQP' => '0.5',
  'carbon' => node['graphite']['version'],
}

packages.each do |package, version|
  python_pip package do
    version version
    action :install
  end
end

service "carbon-cache" do
  supports :status => true, :restart => true, :reload => true
  provider Chef::Provider::Service::Upstart
end

template "#{node['graphite']['home']}/conf/carbon.conf" do
  source "carbon.conf.erb"
  owner "graphite"
  mode "0644"
  notifies :restart, resources(:service => "carbon-cache"), :delayed
  backup false
end

template "#{node['graphite']['home']}/conf/storage-schemas.conf" do
  source "storage-schemas.conf.erb"
  owner "graphite"
  mode "0644"
  notifies :restart, resources(:service => "carbon-cache"), :delayed
  backup false
end

template "/etc/init/carbon-cache.conf" do
  source "carbon-cache.upstart.erb"
  mode "0644"
  notifies :restart, resources(:service => "carbon-cache"), :delayed
  backup false
end

bash "update_perms" do
  user "root"
  cwd "#{node['graphite']['home']}/storage"
  code "chown -R graphite ."
end

service "carbon-cache" do
  pattern "carbon-cache"
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end

