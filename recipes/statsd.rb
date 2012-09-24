python_pip "pystatsd" do
  action :install
end

cookbook_file "/etc/init/pystatsd.conf" do
  source "pystatsd.conf.upstart"
  mode "0644"
  backup false
end

cookbook_file "/etc/default/pystatsd" do
  source "pystatsd.default"
  mode "0644"
  backup false
end

service "pystatsd" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
