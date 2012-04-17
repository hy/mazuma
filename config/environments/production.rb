configure :production do
  set :raise_errors, false
  set :show_exceptions, false
  set :reload_templates, false
  set :protection, true
  set :logging, true
  set :dump_errors, true
end
