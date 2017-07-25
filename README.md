## Sensu-Plugins-flowdock

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-flowdock.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-flowdock)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-flowdock.svg)](http://badge.fury.io/rb/sensu-plugins-flowdock)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-flowdock.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-flowdock)

## Functionality

## Files
 * bin/handler-flowdock.rb

## Usage

```
{
  "flowdock": {
    "auth_token": "FLOWDOCK_API_TOKEN",
    "tags" : "sensu alerting",
    "push_type": "inbox|chat",
    "mail_from": "alerting@sensu.com",
    "name_from": "Sensu",
    "subscriptions": {
        "default": {
            "tags": "default"
        }
    }
  }
}

Params are optionals, only auth_token is required.

  * auth_token : Flowdock token API
  * tag : Fowdock tags separate by " "
  * push_type : Push into inbox or chat (default chat)
  * mail_from : email from for inbox
  * name_from : Name of flowdock/email user
  * subscriptions : Allow to add more tags according to subscriber

```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes
