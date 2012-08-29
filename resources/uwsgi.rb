actions :create, :delete, :restart, :stop, :start

attribute :app_name, :default => "uwsgi_app", :name_attribute => true
attribute :working_directory, :required => true
attribute :handler, :required => true
attribute :pidfile, :default => "/var/run/uwsgi.pid"
attribute :socket, :default => "/tmp/uwsgi.sock"
attribute :logfile, :default => "/var/log/uwsgi.log"
attribute :workers, :default => 2
attribute :uid, :default => "www-data"
attribute :gid, :default => "www-data"
