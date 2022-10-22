#!/bin/bash

#   需要开路由转发 重要重要
#   cat >  /etc/sysctl.conf <<EOF
#   net.ipv4.ip_forward = 1
#   EOF
#
#   sysctl -p

# 生成公钥 私钥 cmd参考
# wg genkey | tee wg0-prikey  | wg pubkey > wg0-pubkey
# SWG_PRIKEY=`cat wg0-prikey`
# SWG_PUBKEY=`cat wg0-pubkey`
# wg genkey  | tee wg1-prikey | wg pubkey > wg1-pubkey
# CWG1_PRIKEY=`cat wg1-prikey`
# CWG1_PUBKEY=`cat wg1-pubkey`

# wg genkey  | tee wg2-prikey | wg pubkey > wg2-pubkey
# CWG2_PRIKEY=`cat wg2-prikey`
# CWG2_PUBKEY=`cat wg2-pubkey`

##### 公网云服务信息    -- 密钥自行替换 以下只是示例
SWG_PRIKEY='XXXXX1'
SWG_PUBKEY='XXXXX1'
### 云服务IP
SWG_IP=111.111.111.111
### 云服务端口
SWG_PORT=19999

###### 客户端信息
CWG1_PRIKEY='XXXXX1'
CWG1_PUBKEY='XXXXX1'

###### 客户端信息
CWG2_PRIKEY='XXXXX1'
CWG2_PUBKEY='XXXXX1'


###### wiki服务 客户端信息
WIKI_PRIKEY='XXXXX1'
WIKI_PUBKEY='XXXXX1'


#####  顶层 子网 信息 默认掩码是 24
top_net='100.100.100.0/24'

# top子网IP
ser_top_ip=$(echo ${top_net} | awk '{split($1,attr_0,".") ; print attr_0[1]"."attr_0[2]"."attr_0[3]".1/24" }')
ser_Netcard="eth0"

cli_1_ip=$(echo ${top_net} | awk '{split($1,attr_0,".") ; print attr_0[1]"."attr_0[2]"."attr_0[3]".101/32" }')
cli_2_ip=$(echo ${top_net} | awk '{split($1,attr_0,".") ; print attr_0[1]"."attr_0[2]"."attr_0[3]".102/32" }')

wiki_ip=$(echo ${top_net} | awk '{split($1,attr_0,".") ; print attr_0[1]"."attr_0[2]"."attr_0[3]".250/32" }')

# 子网网段
cli_1_net="172.18.0.0/24"
cli_1_Netcard="eth0"
cli_2_net="192.168.0.0/24"
cli_2_Netcard="eth0"
# 各节点允许访问的网段
cli_1_AllowedIPs_s=${cli_1_ip},${cli_1_net}
cli_1_AllowedIPs_c=${top_net},${cli_2_net}

cli_2_AllowedIPs_s=${cli_2_ip},${cli_2_net}
cli_2_AllowedIPs_c=${top_net},${cli_1_net}

WIKI_AllowedIPs_s=${wiki_ip}
WIKI_AllowedIPs_c=${top_net}

# 网关节点
cat >serwg.conf <<EOF
[Interface]
Address = ${ser_top_ip}
ListenPort = ${SWG_PORT}
PrivateKey = ${SWG_PRIKEY}
PostUp   = iptables -A FORWARD -i %i -j ACCEPT
PostUp   = iptables -A FORWARD -o %i -j ACCEPT
PostUp   = iptables -t nat -A POSTROUTING -o ${ser_Netcard} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT
PostDown = iptables -D FORWARD -o %i -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o ${ser_Netcard} -j MASQUERADE

[Peer]
PublicKey = ${CWG1_PUBKEY}
AllowedIPs = ${cli_1_AllowedIPs_s}


[Peer]
PublicKey = ${CWG2_PUBKEY}
AllowedIPs = ${cli_2_AllowedIPs_s}

[Peer]
PublicKey = ${WIKI_PUBKEY}
AllowedIPs = ${WIKI_AllowedIPs_s}


EOF

# 子网1
cat >cli_workspace_wg.conf <<EOF
[Interface]
Address = ${cli_1_ip}
PrivateKey = ${CWG1_PRIKEY}
PostUp   = iptables -A FORWARD -i %i -j ACCEPT
PostUp   = iptables -A FORWARD -o %i -j ACCEPT
PostUp   = iptables -t nat -A POSTROUTING -o ${cli_1_Netcard} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT
PostDown = iptables -D FORWARD -o %i -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o ${cli_1_Netcard} -j MASQUERADE

[Peer]
PublicKey = ${SWG_PUBKEY}
AllowedIPs = ${cli_1_AllowedIPs_c}
Endpoint = ${SWG_IP}:${SWG_PORT}
PersistentKeepalive = 15

EOF

# 子网2
cat >cli_home_wg.conf <<EOF
[Interface]
Address = ${cli_2_ip}
PrivateKey = ${CWG2_PRIKEY}
PostUp   = iptables -A FORWARD -i %i -j ACCEPT
PostUp   = iptables -A FORWARD -o %i -j ACCEPT
PostUp   = iptables -t nat -A POSTROUTING -o ${cli_2_Netcard} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT
PostDown = iptables -D FORWARD -o %i -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o ${cli_2_Netcard} -j MASQUERADE

[Peer]
PublicKey = ${SWG_PUBKEY}
AllowedIPs = ${cli_2_AllowedIPs_c}
Endpoint = ${SWG_IP}:${SWG_PORT}
PersistentKeepalive = 15

EOF

# 子网 wiki
cat >cli_wiki_wg.conf <<EOF
[Interface]
Address = ${wiki_ip}
PrivateKey = ${WIKI_PRIKEY}

[Peer]
PublicKey = ${SWG_PUBKEY}
AllowedIPs = ${WIKI_AllowedIPs_c}
Endpoint = ${SWG_IP}:${SWG_PORT}
PersistentKeepalive = 15

EOF
