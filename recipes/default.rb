include_recipe "graphite::common"
include_recipe "graphite::whisper"
include_recipe "graphite::carbon"
include_recipe "graphite::web"
include_recipe "graphite::uwsgi"
include_recipe "graphite::statsd"

execute "correct permissions for graphite folder" do
  command %{
    chown -fR graphite. #{node.graphite.home}
  }
end
