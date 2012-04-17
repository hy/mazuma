configure :test do
  set :raise_errors, true
  set :show_exceptions, true
  set :logging, true
  set :dump_errors, true

  set :bind, 'localhost' # 0.0.0.0 to listen on all available interfaces.
  # set :port, 9292

  set :reload_templates, true
  set :protection, true

  # Log configuration
  FileUtils.mkdir_p 'log' unless File.exists?('log')
  log = File.new("log/sinatra.log", "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end
