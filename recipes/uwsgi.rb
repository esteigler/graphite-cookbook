
python_pip "uwsgi" do
  action :install
end

directory "/etc/nginx" do
  action :create
end

directory "/etc/uwsgi" do
  action :create
  mode "0755"
end

# template the ini file for uwsgi
template "/etc/uwsgi/graphite.ini" do
  source "web/uwsgi.ini.erb"
  mode "0644"
  backup false
end

# upstart config
template "/etc/init/uwsgi.conf" do
  source "web/uwsgi.upstart.erb"
  mode "0644"
  backup false
end

# install the django wsgi handler init script
template "#{node[:graphite][:home]}/webapp/wsgi.py" do
  source "web/wsgi.py.erb"
  owner node.graphite.user
  group node.graphite.group
  mode "0644"
end

template "#{node[:graphite][:home]}/conf/dashboard.conf" do
  source "dashboard.conf.erb"
  owner node.graphite.user
  group node.graphite.group
  mode "0644"
  backup false
end

template "#{node[:graphite][:home]}/webapp/graphite/local_settings.py" do
  source "local_settings.py.erb"
  owner node.graphite.user
  group node.graphite.group
  mode "0644"
  backup false
end

service "uwsgi" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/nginx/sites-available/graphite.conf" do
  source "web/nginx.conf.erb"
  mode "0644"
  backup false
end

nginx_site "graphite.conf" do
  action :enable
end
