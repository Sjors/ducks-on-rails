# Be sure to restart your server when you modify this file
# Because I'm on a shared host and I can't get rake gems:unpack to work properly,
# I installed the gems in my home folder and pointed a symlink "gempath" to it.
# This symlink is ignored by git.
ENV['GEM_PATH'] ||= "gempath"

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Add GMT to the path:
ENV["PATH"]+=":/usr/lib/gmt/bin/"

require 'config/settings'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'rails_generator/secret_key_generator'  

Rails::Initializer.run do |config|

  config.time_zone = 'UTC'

  secret_file = File.join(RAILS_ROOT, "secret")  
  if File.exist?(secret_file)  
    secret = File.read(secret_file)  
  else  
    secret = Rails::SecretKeyGenerator.new("_ducks_on_rails_session").generate_secret  
    File.open(secret_file, 'w') { |f| f.write(secret) }  
  end  

  config.action_controller.session = {  
    :session_key => '_instant_social_session',  
    :secret      => secret  
  }  

  config.gem "composite_primary_keys", :lib => "composite_primary_keys"
  config.gem "gchartrb", :lib => "google_chart"
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below
require 'composite_primary_keys'
require 'gmt'

Inflector.inflections do |inflect|
inflect.irregular 'nao', 'nao'
end
