python_pip "Django" do
  version "1.3.1"
end

python_pip "python-memcached" do
  version "1.47"
end

python_pip "graphite_web" do
  version node[:graphite][:version]
  directory "#{node[:graphite][:home]}/webapp"
end

python_pip "django-tagging" do
  version "0.3.1"
end

python_pip "simplejson" do
  version "2.2.1"
end

package "python-cairo"

# execute "correct permissions for graphite web" do
#   command "chown -fR graphite.uwsgi #{node.graphite.home}/webapp"
#   command "chmod -fR 755 #{node.graphite.home}/webapp"
#   command "chmod -fR 755 #{node.graphite.home}/storage/log/webapp"
# end

file "#{node[:graphite][:home]}/webapp/favicon.ico" do
  owner "graphite"
  group "graphite"
end

execute "syncdb" do
  command "yes no | python #{node[:graphite][:home]}/webapp/graphite/manage.py syncdb"
  not_if "[ -f #{node[:graphite][:home]}/storage/graphite.db ]"
end
