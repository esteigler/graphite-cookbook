
graphite_uwsgi "graphite-web" do
  handler "wsgi.py"
  working_directory "#{node[:graphite][:home]}/webapp/"
  uid node.graphite.user
  gid node.graphite.group
end

# install the django wsgi handler init script
template "#{node[:graphite][:home]}/webapp/wsgi.py" do
  source "web/wsgi.py.erb"
  owner node.graphite.user
  group node.graphite.group
  mode "0644"
  notifies :restart, resources(:graphite_uwsgi => "graphite-web"), :delayed
end

template "#{node[:graphite][:home]}/conf/dashboard.conf" do
  cookbook "graphite"
  owner node.graphite.user
  group node.graphite.group
  mode "0644"
  notifies :restart, resources(:graphite_uwsgi => "graphite-web"), :delayed
  backup false
end

template "#{node[:graphite][:home]}/webapp/graphite/local_settings.py" do
  cookbook "graphite"
  source "local_settings.py.erb"
  owner node.graphite.user
  group node.graphite.group
  mode "0644"
  notifies :restart, resources(:graphite_uwsgi => "graphite-web"), :delayed
  backup false
end
