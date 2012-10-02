name              "graphite"
maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures Graphite"
version           "1.0.7"

recipe "graphite::default", "Installs all 3 Graphite components: whisper, carbon & web"
recipe "graphite::carbon", "Installs carbon and the configuration files"
recipe "graphite::common", "Installs common components for carbon/graphite"
recipe "graphite::statsd", "Installs py-statsd"
recipe "graphite::whisper", "Installs the whisper storage engine"
recipe "graphite::web", "Installs the graphite web ui"
recipe "graphite::uwsgi", "Installs and configures uWSGI for the web ui"

supports "ubuntu"

depends "python"
