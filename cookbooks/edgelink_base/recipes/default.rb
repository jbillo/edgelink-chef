# Default base recipe for EdgeLink


#
# [sshd] Set valid SSH ListenAddress properties
#

# Remove any IP addresses from node['sshd']['sshd_config']['ListenAddress'] that aren't
# defined on this host, then set node attributes accordingly from
# node['edgelink']['sshd_config']['ListenAddress']. We also convert these addresses to a hash
# so that the sshd recipe places this section after the Port definition.

node_ip_addresses = []
valid_listen_addresses = {}

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
		valid_listen_addresses[address] = ''
	end
end

Chef::Log.info("The following addresses will be used for the sshd ListenAddress option: #{valid_listen_addresses.keys}")
node.set['sshd']['sshd_config']['ListenAddress'] = valid_listen_addresses

#
# [simple_iptables] Firewall ALL THE THINGS
#

include_recipe "simple_iptables"

simple_iptables_rule "system" do
	rule [
		# Allow all traffic on the loopback device
        "--in-interface lo",
        # Allow any established connections to continue, even if they would be in violation of other rules.
        "-m conntrack --ctstate ESTABLISHED,RELATED",
        # Allow ping, generally
        "-p icmp"
	]
	jump "ACCEPT"
end

# Log all denied access attempts
simple_iptables_rule "syslog" do
	rule "--match limit --limit 5/min --log-prefix \"iptables denied: \" --log-level 7"
	jump "LOG"
	weight 99
end

# What's this? We have an explicit list of ports to allow for SSH.
allowed_ssh_ports = node['sshd']['sshd_config']['Port'] rescue []
allowed_ssh_rules = []
allowed_ssh_ports.each do |port|
	allowed_ssh_rules << "-p tcp --dport #{port}"
end

simple_iptables_rule "inbound_ssh" do
	rule allowed_ssh_rules
	jump "ACCEPT"
end

# We also have a set of EdgeLink-defined ports that we want to allow in
allowed_edgelink_tcp_rules = []
allowed_edgelink_udp_rules = []
node['edgelink']['firewall']['allowed_tcp_ports'].each do |port|
	allowed_edgelink_tcp_rules << "-p tcp --dport #{port}"
end
node['edgelink']['firewall']['allowed_udp_ports'].each do |port|
	allowed_edgelink_udp_rules << "-p udp --dport #{port}"
end

simple_iptables_rule "edgelink_tcp" do
	rule allowed_edgelink_tcp_rules
	jump "ACCEPT"
end
simple_iptables_rule "edgelink_udp" do
	rule allowed_edgelink_udp_rules
	jump "ACCEPT"
end

# Reject packets other than those explicitly allowed
simple_iptables_policy "INPUT" do
	policy "DROP"
end
