Moonshine_Monit
===============

A plugin for [Moonshine](http://github.com/railsmachine/moonshine)

Moonshine_Monit provides simple installation and configuration management for [monit](http://mmonit.com/monit/).

Instructions
------------

    script/plugin install git://github.com/crankharder/moonshine_monit.git

Monit configuration files go in config/monit/*.erb

The name of the configuration files are important.  They must match the host name of the server where you want them deployed.

For example, if you have servers prod-db1.foo.com, prod-app1.foo.com, then you can name your config files "prod.erb", "app1.erb", "db1.erb"

This would install "prod.erb" and "db1.erb" to prod-db1.foo.com  and "prod.erb" and "app1.erb" to "prod-app1.foo.com"

moonshine.yml
-------------

Your moonshine config has a few options:

    :monit:
      :interval: 15  # the interval that monit checks things in seconds

This plugin has two ways to send notifications

A mailserver:

    :monit:
      :mailserver:
        :host: prod-app1.foo.com
       :port: 25
       :emails:
         - your_email@foo.com
         - your_other_email@foo.com

Or Prowl:

    :monit:
      :prowl:
        :api_key: 1123hj12j4hg12jh4gj12h4gj1h2g4
    

If you use prowl there's a helper method that you can use in your config.erb files:

    <%= prowl("your message here", priority) %> -- where priority is one of -2,-1,0,1,2    


Example config file
-------------------

Please note that this plugin helps you get monit running.  You're on your own writing monit config files, but here's an example with the prowl helper mentioned above.

Check out their documentation here: [Monit](http://mmonit.com/monit/documentation/)

    set httpd port 2812 and
      use address 192.168.1.192
      allow 123.456.789.123
      allow 192.168.1.100
      allow 127.0.0.1

    check host stg-app1 with address 192.168.1.191
      if failed port 80 with timeout 15 seconds then <%= prowl("http down on stg-app1") %>
      if failed port 443 with timeout 15 seconds then <%= prowl("https down on stg-app1") %>