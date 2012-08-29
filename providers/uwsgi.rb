
def initialize(*args)
  super
  @action = :create
end

action :create do
  python_pip "uWSGI" do
    binary "uwsgi --version"
  end

  service "#{new_resource.app_name}" do
    supports :status => true, :restart => true, :reload => true
    provider Chef::Provider::Service::Upstart
  end

  file new_resource.logfile do
    action :create_if_missing
    owner new_resource.uid
    group new_resource.gid
    mode "0644"
  end

  # app config
  template "/etc/uwsgi/#{new_resource.app_name}.ini" do
    source "web/uwsgi.ini.erb"
    mode "0644"
    backup false

    notifies :restart, resources(:service => new_resource.app_name), :delayed

    options = {}
    %w[
      handler
      working_directory
      pidfile
      socket
      workers
      uid
      gid
      logfile
    ].each do |k|
      options[k] = new_resource.send(k)
    end
    variables options
  end

  # upstart config
  template "/etc/init/#{new_resource.app_name}.conf" do
    cookbook "python"
    source "web/uwsgi.upstart.erb"
    mode "0644"
    backup false

    notifies :restart, resources(:service => "uwsgi"), :delayed

    options = {}
    %w[
      uwsgi_bin
      envs
      pidfile
      socket
    ].each do |k|
      options[k] = new_resource.send(k)
    end
    options['ini'] = "/etc/init/#{new_resource.app_name}.conf"
    variables options
  end
end

action :start do
  service "#{new_resource.app_name}" do
    action :start
  end
end

action :stop do
  service "#{new_resource.app_name}" do
    action :stop
  end
end

action :restart do
  service "#{new_resource.app_name}" do
    action :restart
  end
end
