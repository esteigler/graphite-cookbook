
include_recipe 'graphite::uwsgi'

# Create proxy with HTTP authentication via Nginx
#
template "#{node.nginx.dir}/conf.d/graphite_web.conf" do
  source "web/nginx.conf.erb"
  owner node.graphite.user
  group node.graphite.group
  mode 0755
  notifies :restart, resources(:service => "nginx")
end
