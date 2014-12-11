chef_gem 'chef-rewind'
require 'chef/rewind'

include_recipe 'nginx'
include_recipe 'nginx::naxsi_module'

rewind :template => "nginx.conf" do
	source "nginx.conf.erb"
	cookbook_name "edgelink_nginx"
end
