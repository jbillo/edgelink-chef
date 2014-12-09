# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "jbillo"
client_key               "#{current_dir}/jbillo.pem"
validation_client_name   "edgelink-validator"
validation_key           "#{current_dir}/edgelink-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/edgelink"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
