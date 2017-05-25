#!/usr/bin/env ruby
#
# Sensu Flowdock (https://www.flowdock.com/api/chat) notifier
# This handler sends event information to the Flowdock Push API: Chat.
# The handler pushes event output to chat:
# This setting is required in flowdock.json
#   auth_token  :  The flowdock api token (flow_api_token)
#
# Dependencies
# -----------
# - flowdock - proxy functionality may required newest release
#
#
# Author Ramez Hanna <rhanna@informatiq.org>
# Author Peter Daugavietis <pdaugavietis@gmail.com>

# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details

require 'sensu-handler'
require 'flowdock'

class FlowdockNotifier < Sensu::Handler
  option :json_config,
         description: 'Config Name',
         short: '-j JsonConfig',
         long: '--json_config JsonConfig',
         required: false,
         default: 'flowdock'

  def build_tags_list
    default_tags = @settings[config[:json_config]]['tags'] || 'sensu'
    tags = default_tags.split(' ')
    if @settings[config[:json_config]].key?('subscriptions')
      @event['client']['subscriptions'].each do |sub|
        if @settings[config[:json_config]]['subscriptions'].key?(sub)
          tags.concat @settings[config[:json_config]]['subscriptions'][sub]['tags'].split(' ')
        end
      end
    end
    if @event['client'].key?('flowdock_tags')
      tags.concat @event['client']['flowdock_tags']
    end
    tags
  end

  def action_to_string
    @event['action'].eql?('resolve') ? 'RESOLVED' : 'ALERT'
  end

  def short_name
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def status_to_string
    case @event['check']['status']
    when 0
      'OK'
    when 1
      'WARNING'
    when 2
      'CRITICAL'
    else
      'UNKNOWN'
    end
  end

  def status_to_color
    case @event['check']['status']
    when 0
      'green'
    when 1
      'yellow'
    when 2
      'red'
    else
      'grey'
    end
  end

  def build_event_url
    @settings[config[:json_config]]['dashboard_url'] + '/#/client/' +
      @settings[config[:json_config]]['datacenter_name'] + '/' +
      @event['client']['name'] + '?check=' + @event['check']['name'] if @settings[config[:json_config]]['datacenter_name']
  end

  def build_message
    message = {}
    message['event'] = 'activity'
    message['flow_token'] = @settings[config[:json_config]]['flow_token']
    message['author'] = {}
    message['author']['name'] = @settings[config[:json_config]]['datacenter_name'] + '/' + @event['client']['name']
    message['author']['avatar'] = "https://sensuapp.org/img/logo-flat-white.png"
    message['tags'] = build_tags_list
    message['title'] = action_to_string.upcase
    message['external_thread_id'] = @event['id'].to_s
    message['thread'] = {}
    message['thread']['title'] = @event['client']['name'] + '/' + @event['check']['name']
    message['thread']['fields'] = []
    message['thread']['fields'].push('label' => 'source', 'value' => @event['check']['source'])
    message['thread']['fields'].push('label' => 'command', 'value' => @event['check']['command'].to_s)
    message['thread']['fields'].push('label' => 'output', 'value' => @event['check']['output'].to_s)
    message['thread']['fields'].push('label' => 'subscribers', 'value' => @event['check']['subscribers'].to_s)
    message['thread']['fields'].push('label' => 'occurred_first', 'value' => DateTime.strptime(@event['check']['executed'].to_s, '%s'))
    message['thread']['fields'].push('label' => 'occurrences', 'value' => @event['occurrences'].to_s)
    message['thread']['fields'].push('label' => 'occurrences_watermark', 'value' => @event['occurrences_watermark'].to_s)
    message['thread']['fields'].push('label' => 'sent_from', 'value' => @event['check']['origin'])
    message['thread']['body'] = @event['check']['description'] | ''
    message['thread']['external_url'] = build_event_url || 'http://localhost:3000'
    message['thread']['status'] = {}
    message['thread']['status']['color'] = status_to_color
    message['thread']['status']['value'] = status_to_string
    message
  end

  def handle
    @settings = JSON.parse(File.read('flowdock.json'))

    flow_token = @settings[config[:json_config]]['flow_token']

    proxy_host = @settings[config[:json_config]]['proxy_host']
    proxy_port = @settings[config[:json_config]]['proxy_port']
    proxy_username = @settings[config[:json_config]]['proxy_username']
    proxy_password = @settings[config[:json_config]]['proxy_password']

    if proxy_host
      client = Flowdock::Client.new(flow_token: flow_token,
                                    proxy_host: proxy_host,
                                    proxy_port: proxy_port,
                                    proxy_username: proxy_username,
                                    proxy_password: proxy_password)
    else
      client = Flowdock::Client.new(flow_token: flow_token)
    end
    client.post_to_thread build_message
  end
end
