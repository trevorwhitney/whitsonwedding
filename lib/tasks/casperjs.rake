namespace :casperjs do
  test_server_pid_file = "tmp/pids/test_server.pid"
  app_port             = 3030

  desc "Start Testing Server"
  task :start_test_server do
    counter = 0

    Thread.new {
      command_line = "bundle exec rails server -p #{app_port} -e test -P #{test_server_pid_file}"
      puts "Starting: #{command_line}"
      system command_line
    }

    while (not File.exist?(test_server_pid_file)) && counter < 30 do
      counter += 1
      print '.' if counter > 15
      sleep 2
    end

    if counter >= 30
      STDERR.puts "Start took too long!"
    else
      puts "Test server running ..."
    end
  end

  desc "Stop Testing Server"
  task :stop_test_server do
    puts "Stopping test server ..."
    pid = IO.read(test_server_pid_file).to_i rescue nil

    if pid.present?
      system("kill -9 #{pid}")
      FileUtils.rm(test_server_pid_file)
      puts "... Test server stopped"
    else
      STDERR.puts "Cannot stop server - no pid file found!"
    end
  end


  desc "run Casper JS Tests, starts rails server,run the tests and then stop the server "
  task :spec => [:start_test_server ] do
    begin
      spec_path = Rails.root.join("spec/integrations/")
      spec_support_path = Rails.root.join("spec/support/")
      log_path  = Rails.root.join("log")
      puts "Running CasperJS Specs in #{spec_path}"
      # 1. first runs pre.js
      # 2. then runs all JS and CoffeeScript Specs in directory spec_path
            #--pre=#{File.join(spec_support_path, 'pre.js.coffee')} \
      # 3. then runs post.js
            #--post=#{File.join(spec_support_path, 'post.js.coffee')} \
      # 4. finally stores result to log/casper_spec_output.xml
      system("casperjs test \
            --testhost=http://localhost:#{app_port} \
            --save_to_xml=#{File.join(log_path, 'casper_spec_output.xml')} \
            --log-level=info \
             #{File.join(spec_path)}")
    ensure
      Rake::Task["casperjs:stop_test_server"].invoke
    end
  end
end
