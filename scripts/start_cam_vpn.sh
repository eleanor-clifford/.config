ip netns add camvpn
ip netns exec camvpn ip addr add 127.0.0.1/8 dev lo
ip netns exec camvpn ip link set lo up
ip link add vpn0 type veth peer name vpn1
ip link set vpn0 up
ip link set vpn1 netns camvpn up
ip addr add 10.200.200.1/24 dev vpn0
ip netns exec camvpn ip addr add 10.200.200.2/24 dev vpn1
ip netns exec camvpn ip route add default via 10.200.200.1 dev vpn1
iptables -A INPUT \! -i vpn0 -s 10.200.200.0/24 -j DROP
iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o en+ -j MASQUERADE
sysctl -q net.ipv4.ip_forward=1
mkdir -p /etc/netns/camvpn
sh -c "echo 'nameserver 1.1.1.1' > /etc/netns/camvpn/resolv.conf"
ip netns exec camvpn ipsec restart
sleep 2
ip netns exec camvpn ipsec up CAM
