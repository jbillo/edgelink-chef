default['edgelink']['sshd_config']['ListenAddress'] = []
default['edgelink']['firewall']['allowed_tcp_ports'] = [80, 443, 6667, 8000]
default['edgelink']['firewall']['allowed_udp_ports'] = ["60000:61000"]

default['nginx']['keepalive_timeout'] = '15s'
default['nginx']['client_body_buffer_size'] = '10K'
default['nginx']['client_max_body_size'] = '16m'

default['nginx']['client_header_buffer_size'] = '1K'
default['nginx']['large_client_header_buffers'] = '2 1K'
default['nginx']['client_body_timeout'] = 12
default['nginx']['client_header_timeout'] = 12
default['nginx']['send_timeout'] = 10

# don't use SSLv3 ref: POODLE
default['nginx']['ssl_protocols'] = ['TLSv1', 'TLSv1.1', 'TLSv1.2']

default['sshd']['sshd_config'] = {
	"PermitEmptyPasswords" => "no",
	"Port" => [55022, 8080],
	"TCPKeepAlive" => "yes",
	"Match" => {
		"group sftponly" => {
			"ChrootDirectory" => "/home/%u",
			"X11Forwarding" => "no",
			"AllowTcpForwarding" => "no",
			"ForceCommand" => "internal-sftp"
		},
		"group sudo" => {
			"PasswordAuthentication" => "no"
		},
		"group admin" => {
			"PasswordAuthentication" => "no"
		}
	}
}
