# Default base recipe for EdgeLink

# Remove any IP addresses from node['sshd']['sshd_config']['ListenAddress'] that aren't
# defined on this host, then set node attributes accordingly from
# node['edgelink']['sshd_config']['ListenAddress'].

node_ip_addresses = []
valid_listen_addresses = []

node['network']['interfaces'].each do |iface, attrs|
	if !attrs.key?('addresses')
		next
	end

	attrs['addresses'].each do |ip, params|
		# Only add IPv4 and v6 addresses, not MAC addresses
		if params.key?('family') and ['inet', 'inet6'].include?(params['family'])
			node_ip_addresses << ip
		end
	end
end

node_ip_addresses.uniq!

sshd_listen_addresses = node['edgelink']['sshd_config']['ListenAddress']
Chef::Log.info("Possible listen addresses: #{sshd_listen_addresses}")
sshd_listen_addresses.each do |address|
	if address.include?(':')
		stripped_address = address[0, address.index(':')]
	else
		stripped_address = address
	end

	if node_ip_addresses.include?(stripped_address)
		valid_listen_addresses << address
	end
end

Chef::Log.info("The following addresses will be used for the sshd ListenAddress option: #{valid_listen_addresses}")
node.set['sshd']['sshd_config']['ListenAddress'] = valid_listen_addresses
