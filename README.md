## Sensu-Plugins-flowdock

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-flowdock.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-flowdock)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-flowdock.svg)](http://badge.fury.io/rb/sensu-plugins-flowdock)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-flowdock.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-flowdock)

## Functionality

## Files
 * bin/handler-flowdock.rb

## Usage
@event['client']['flowdock_tags']

```
{
  "flowdock": {
    "dashboard_url": "sensu-url",
    "host_id_command": "hostname",
    "flow_token": "",
    "proxy_host": "",
    "proxy_port": "",
    "proxy_username": "",
    "proxy_password": "",
    "tags": [
      "sensu",
      "alert"
    ],
    "subscriptions": {
      "subscription_name": {
        "tags": [ "sensu", "subscription_tag"]
      }
    }
  }
}

{
  "client": {
    ...
    "flowdock_tags": [ "client_tag" ]
    ...
    "u1b0": {
      "datacenter_name":"MRK"
    }
  }
}
```

Params are optionals, only auth_token is required.

  * auth_token : Flowdock token API
  * tag : Flowdock tags separated by spaces (" ")
  * push_type : Push into inbox or chat (default chat)
  * mail_from : email from for inbox
  * name_from : Name of flowdock/email user
  * subscriptions : Allow to add more tags according to subscriber

```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes
