#!/opt/sensu/embedded/bin/ruby
#
#Sensu Solr slave check, develop by Claranet UK Ltd
#Author Dario Ferrer
#Modified by:
#Last modification: 31-01-2017

require 'sensu-plugin/check/cli'
require 'net/http'
require 'json'
require 'uri'

class CheckSolr < Sensu::Plugin::Check::CLI
  option :host,
         short: '-h HOST',
         long: '--host HOST',
         description: 'Solr Host to connect to',
         required: true

  option :masterhost,
         short: '-m MASTERHOST',
         long: '--masterhost MASTERHOST',
         description: 'Solr Master Host to compare cores',
         required: true

  option :port,
         short: '-p PORT',
         long: '--port PORT',
         description: 'Solr Port to connect to',
         proc: proc(&:to_i),
         required: true


  option :baseurl,
         description: 'Base url (primary core of the multicore system)',
         short: '-b BASEURL',
         long: '--baseurl BASEURL',
         default: "solr"

  def run
    def get_status(host)
      status_url = "http://#{host}:#{config[:port]}/#{config[:baseurl]}/admin/cores?action=STATUS&wt=json"
      status_resp = Net::HTTP.get_response(URI.parse(status_url))
      status = JSON.parse(status_resp.body)
    end
    slave_status = get_status(config[:host])
    master_status = get_status(config[:masterhost])
    cores = slave_status['status'].keys

    cores.each do |core|
      slave_core_version = slave_status['status'][core]['index']['version'] 
      master_core_version = master_status['status'][core]['index']['version'] 
      print "Core: #{core} slave_version: #{slave_core_version} master_version: #{master_core_version}\n"
      if slave_core_version != master_core_version
        critical "Master and slave versions not matching for core #{core}"
      end
    end
    ok "all cores ok"
  end
end
