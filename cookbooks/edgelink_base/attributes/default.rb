default['edgelink']['sshd_config']['ListenAddress'] = []
default['edgelink']['firewall']['allowed_tcp_ports'] = [80, 443, 6667, 8000]
default['edgelink']['firewall']['allowed_udp_ports'] = ["60000:61000"]

default['nginx']['keepalive_timeout'] = '15s'
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
