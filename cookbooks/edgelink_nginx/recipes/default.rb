include_recipe 'nginx'

#temporarily commented out until we find something worth modifying in the stock config
#chef_gem 'chef-rewind'
#require 'chef/rewind'
#rewind :template => "nginx.conf" do
#	source "nginx.conf.erb"
#	cookbook_name "edgelink_nginx"
#end

template "#{node['nginx']['dir']}/conf.d/buffer_timeout.conf" do
	source "conf.d/buffer_timeout.conf.erb"
    notifies :reload, 'service[nginx]'
end

Chef::Log.info(node['nginx'])

template "#{node['nginx']['dir']}/conf.d/upstream.conf" do
	source "conf.d/upstream.conf.erb"
	variables ({
		:client_header_buffer_size => node['nginx']['client_header_buffer_size'],
		:large_client_header_buffers => node['nginx']['large_client_header_buffers'],
		:client_body_timeout => node['nginx']['client_body_timeout'],
		:client_header_timeout => node['nginx']['client_header_timeout'],
		:send_timeout => node['nginx']['send_timeout']
	})
    notifies :reload, 'service[nginx]'
end

template "#{node['nginx']['dir']}/conf.d/ssl.conf" do
	source "conf.d/ssl.conf.erb"
	variables ({
		:ssl_protocols => node['nginx']['ssl_protocols']
	})
    notifies :reload, 'service[nginx]'
end