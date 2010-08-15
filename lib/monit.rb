module Monit
  PROWL_PATH = "/usr/bin/prowl.sh"

  def monit(options = {})
    package 'monit', :ensure => :installed

    file '/etc/monit', :ensure => :directory

    file '/etc/monit/monitrc',
      :mode => '700',
      :require => file('/etc/monit'),
      :backup => false,
      :content => template("#{File.dirname(__FILE__)}/../templates/monitrc.erb", binding)

    file '/etc/init/monit.conf',
      :require => file('/etc/monit'),
      :backup => false,
      :content => template("#{File.dirname(__FILE__)}/../templates/monit.conf.erb", binding)

    file '/etc/monit/conf.d', :ensure => :directory

    # get all files in config/monit that match the current host name
    # drop them in /etc/monit/conf.d/ which is included by /etc/monit/monitrc
    filenames = []
    Dir.entries(File.join(rails_root, 'config', 'monit')).map{|f| f.gsub('.erb', '')}.reject{|f| ['.', '..'].include?(f)}.select{|f| Facter.hostname.match(f)}.each do |filename|
      filenames << "#{filename}.conf"
      file "/etc/monit/conf.d/#{filename}.conf",
        :mode => '700',
        :require => file('/etc/monit/conf.d'),
        :backup => false,
        :content => template(File.join(rails_root, 'config', 'monit', "#{filename}.erb"), binding)
    end

    Dir.entries('/etc/monit/conf.d').reject{|f| (filenames + ['.', '..']).include?(f)}.each do |filename|
      file "/etc/monit/conf.d/#{filename}", :ensure => :absent
    end

    if options[:prowl]
      package 'curl', :ensure => :installed

      file PROWL_PATH,
        :mode => '744',
        :backup => false,
        :content => template("#{File.dirname(__FILE__)}/../templates/prowl.sh.erb", binding)
    end
  end

private

  def prowl(message = "ZOMG, something's wrong!", priority = 0)
    "exec \"#{PROWL_PATH} #{priority} '#{Facter.hostname}' '#{message}'\""
  end
end
