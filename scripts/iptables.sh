. /data/adb/agh/settings.conf
. /data/adb/agh/scripts/base.sh

iptables_w="iptables -w 64"
ip6tables_w="ip6tables -w 64"

enable_iptables() {
  $iptables_w -t nat -L ADGUARD_REDIRECT_DNS >/dev/null 2>&1 && return
  $iptables_w -t nat -N ADGUARD_REDIRECT_DNS
  $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -m owner --uid-owner $adg_user --gid-owner $adg_group -j RETURN
  for subnet in $ignore_dest_list; do $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -d $subnet -j RETURN; done
  for subnet in $ignore_src_list; do $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -s $subnet -j RETURN; done
  $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -p udp --dport 53 -j REDIRECT --to-ports $redir_port
  $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -p tcp --dport 53 -j REDIRECT --to-ports $redir_port
  $iptables_w -t nat -I OUTPUT -j ADGUARD_REDIRECT_DNS
}

disable_iptables() {
  ! $iptables_w -t nat -L ADGUARD_REDIRECT_DNS >/dev/null 2>&1 && return
  $iptables_w -t nat -D OUTPUT -j ADGUARD_REDIRECT_DNS
  $iptables_w -t nat -F ADGUARD_REDIRECT_DNS
  $iptables_w -t nat -X ADGUARD_REDIRECT_DNS
}

add_block_ipv6_dns() {
  $ip6tables_w -t filter -L ADGUARD_BLOCK_DNS >/dev/null 2>&1 && return
  $ip6tables_w -t filter -N ADGUARD_BLOCK_DNS
  $ip6tables_w -t filter -A ADGUARD_BLOCK_DNS -p udp --dport 53 -j DROP
  $ip6tables_w -t filter -A ADGUARD_BLOCK_DNS -p tcp --dport 53 -j DROP
  $ip6tables_w -t filter -I OUTPUT -j ADGUARD_BLOCK_DNS
}

del_block_ipv6_dns() {
  ! $ip6tables_w -t filter -L ADGUARD_BLOCK_DNS >/dev/null 2>&1 && return
  $ip6tables_w -t filter -F ADGUARD_BLOCK_DNS
  $ip6tables_w -t filter -D OUTPUT -j ADGUARD_BLOCK_DNS
  $ip6tables_w -t filter -X ADGUARD_BLOCK_DNS
}

case "$1" in
enable) enable_iptables; [ "$block_ipv6_dns" = true ] && add_block_ipv6_dns ;;
disable) disable_iptables; del_block_ipv6_dns ;;
*) exit 1 ;;
esac