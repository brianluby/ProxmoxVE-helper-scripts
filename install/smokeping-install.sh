#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
msg_ok "Installed Dependencies"

msg_info "Installing SmokePing"
$STD apt-get install -y smokeping
cat <<EOF >/etc/smokeping/config.d/Targets
*** Targets ***
probe = FPing
menu = Top
title = Network Latency Grapher
remark = Welcome to SmokePing.
+ Homelab
menu = Homelab
title = Local Network (ICMP)
++ LocalMachine
title = This host
host = localhost
++ fw1
title = fw1
host = fw1.luby.us
++ vm1
title = vm1
host = vm1.luby.us
++ vm2
title = vm2
host = vm2.luby.us
+ DNS
menu = DNS latency
title = DNS latency (ICMP)
++ Google
title = Google
host = 8.8.8.8
++ Cloudflare
title = Cloudflare
host = 1.1.1.1
++ Quad9  
title = Quad9 
host = 9.9.9.9
++ OpenDNS
title = OpenDNS
host = 208.67.222.222
+ HTTP
menu = HTTP latency
title = HTTP latency (ICMP)
++ Github
host = github.com
++ Discord
host = discord.com
++ Google
host = google.com
++ Cloudflare
host = cloudflare.com
++ Amazon
host = amazon.com
++ Netflix
host = netflix.com
EOF
systemctl restart smokeping
msg_ok "Installed SmokePing"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
