Warbler::Config.new do |config|
  config.jar_name = 'redmine'
  config.features = %w(executable)
  config.dirs = %w(app config db lib log script vendor tmp files plugins extra public/plugin_assets)
  config.bundler = true
  config.bundle_without = ["development", "test"]
  config.gems += ["rmagick4j"]
  config.gem_path = "WEB-INF/vendor/bundle"
  config.move_jars_to_webinf_lib = true
  config.compile_gems = false
#  config.webserver = 'jetty'
  config.bytecode_version = '1.8'
  config.webxml.rails.env = ENV['RAILS_ENV'] || 'production'
  config.webxml.jruby.compat.version = '2.0'
  config.webxml.jruby.runtime.arguments = '--2.0'
end
