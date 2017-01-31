#!/opt/sensu/embedded/bin/ruby
#
#Sensu Solr slave check, develop by Claranet UK Ltd
#Author Dario Ferrer
#Modified by:
#Last modification: 30-01-2017

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

  option :port,
         short: '-p PORT',
         long: '--port PORT',
         description: 'Solr Port to connect to',
         proc: proc(&:to_i),
         required: true

  option :core,
         description: 'Solr Core to check',
         short: '-c CORE',
         long: '--core CORE',
         default: nil

  option :baseurl,
         description: 'Base url (primary core of the multicore system)',
         short: '-b BASEURL',
         long: '--baseurl BASEURL',
         default: "solr"

  def run
    cores = []
    if config[:core]
      cores = [config[:core]]
    else
      # If no core is specified, get all cores
      status_url = "http://#{config[:host]}:#{config[:port]}/#{config[:baseurl]}/admin/cores?action=STATUS&wt=json"
      status_resp = Net::HTTP.get_response(URI.parse(status_url))
      status = JSON.parse(status_resp.body)
      cores = status['status'].keys
    end

    cores.each do |core|
      ping_url = "http://#{config[:host]}:#{config[:port]}/#{config[:baseurl]}/#{core}/admin/ping?wt=json"
      resp = Net::HTTP.get_response(URI.parse(ping_url))
      ping = JSON.parse(resp.body)

      if ping['status'] != "OK"
        critical "something not good in #{core}"
      end
    end
    ok "all cores ok"
  end
end
