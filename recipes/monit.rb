namespace :monit do
  desc "Stop monit"
  task :stop do
    sudo "stop monit"
  end

  desc "Start monit"
  task :start do
    sudo "start monit"
  end

  desc "Restart monit"
  task :restart do
    sudo "stop monit || true"
    sudo "start monit"
  end

  desc "Reload monit config"
  task :reload do
    sudo 'monit reload'
  end
end

after 'deploy', 'monit:reload'