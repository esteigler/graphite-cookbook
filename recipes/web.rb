packages = {
  'Django' => '1.3.1',
  'python-memcached' => '1.47',
  'django-tagging' => '0.3.1',
  'simplejson' => '2.2.1',
}

packages.each do |package, version|
  python_pip package do
    version version
    action :install
  end
end

python_pip "graphite_web" do
  version node['graphite']['version']
  action :install
  not_if {File.exists?("#{node['graphite']['home']}/webapp/graphite/__init__.py")}
end

package "python-cairo" do
  action :install
end

# execute "correct permissions for graphite web" do
#   command "chown -fR graphite.uwsgi #{node.graphite.home}/webapp"
#   command "chmod -fR 755 #{node.graphite.home}/webapp"
#   command "chmod -fR 755 #{node.graphite.home}/storage/log/webapp"
# end

file "#{node['graphite']['home']}/webapp/favicon.ico" do
  owner "graphite"
  group "graphite"
end

execute "syncdb" do
  command "yes no | python #{node['graphite']['home']}/webapp/graphite/manage.py syncdb"
  not_if "[ -f #{node['graphite']['home']}/storage/graphite.db ]"
end
