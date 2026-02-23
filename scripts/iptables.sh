. /data/adb/agh/settings.conf
. /data/adb/agh/scripts/base.sh

iptables_w="iptables -w 64"
ip6tables_w="ip6tables -w 64"

check_ipv6_nat_support() {
  $ip6tables_w -t nat -L >/dev/null 2>&1
}

enable_iptables() {
  $iptables_w -t nat -L ADGUARD_REDIRECT_DNS >/dev/null 2>&1 && return

  $iptables_w -t nat -N ADGUARD_REDIRECT_DNS || return 1
  $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -m owner --uid-owner $adg_user --gid-owner $adg_group -j RETURN || return 1

  for subnet in $ignore_dest_list; do
    $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -d $subnet -j RETURN || return 1
  done
  for subnet in $ignore_src_list; do
    $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -s $subnet -j RETURN || return 1
  done

  $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -p udp --dport 53 -j REDIRECT --to-ports $redir_port || return 1
  $iptables_w -t nat -A ADGUARD_REDIRECT_DNS -p tcp --dport 53 -j REDIRECT --to-ports $redir_port || return 1
  $iptables_w -t nat -I OUTPUT -j ADGUARD_REDIRECT_DNS || return 1
}

disable_iptables() {
  $iptables_w -t nat -L ADGUARD_REDIRECT_DNS >/dev/null 2>&1 || return

  $iptables_w -t nat -D OUTPUT -j ADGUARD_REDIRECT_DNS || return 1
  $iptables_w -t nat -F ADGUARD_REDIRECT_DNS || return 1
  $iptables_w -t nat -X ADGUARD_REDIRECT_DNS || return 1
}

add_block_ipv6_dns() {
  $ip6tables_w -t filter -L ADGUARD_BLOCK_DNS >/dev/null 2>&1 && return

  $ip6tables_w -t filter -N ADGUARD_BLOCK_DNS || return 1
  $ip6tables_w -t filter -A ADGUARD_BLOCK_DNS -p udp --dport 53 -j DROP || return 1
  $ip6tables_w -t filter -A ADGUARD_BLOCK_DNS -p tcp --dport 53 -j DROP || return 1
  $ip6tables_w -t filter -I OUTPUT -j ADGUARD_BLOCK_DNS || return 1
}

del_block_ipv6_dns() {
  $ip6tables_w -t filter -L ADGUARD_BLOCK_DNS >/dev/null 2>&1 || return

  $ip6tables_w -t filter -F ADGUARD_BLOCK_DNS || return 1
  $ip6tables_w -t filter -D OUTPUT -j ADGUARD_BLOCK_DNS || return 1
  $ip6tables_w -t filter -X ADGUARD_BLOCK_DNS || return 1
}

enable_ipv6_iptables() {
  check_ipv6_nat_support || return
  $ip6tables_w -t nat -L ADGUARD_REDIRECT_DNS6 >/dev/null 2>&1 && return

  $ip6tables_w -t nat -N ADGUARD_REDIRECT_DNS6 || return 1
  $ip6tables_w -t nat -A ADGUARD_REDIRECT_DNS6 -m owner --uid-owner $adg_user --gid-owner $adg_group -j RETURN || return 1

  for subnet in $ignore_dest_list; do
    $ip6tables_w -t nat -A ADGUARD_REDIRECT_DNS6 -d $subnet -j RETURN || return 1
  done
  for subnet in $ignore_src_list; do
    $ip6tables_w -t nat -A ADGUARD_REDIRECT_DNS6 -s $subnet -j RETURN || return 1
  done

  $ip6tables_w -t nat -A ADGUARD_REDIRECT_DNS6 -p udp --dport 53 -j REDIRECT --to-ports $redir_port || return 1
  $ip6tables_w -t nat -A ADGUARD_REDIRECT_DNS6 -p tcp --dport 53 -j REDIRECT --to-ports $redir_port || return 1
  $ip6tables_w -t nat -I OUTPUT -j ADGUARD_REDIRECT_DNS6 || return 1
}

disable_ipv6_iptables() {
  check_ipv6_nat_support || return
  $ip6tables_w -t nat -L ADGUARD_REDIRECT_DNS6 >/dev/null 2>&1 || return

  $ip6tables_w -t nat -D OUTPUT -j ADGUARD_REDIRECT_DNS6 || return 1
  $ip6tables_w -t nat -F ADGUARD_REDIRECT_DNS6 || return 1
  $ip6tables_w -t nat -X ADGUARD_REDIRECT_DNS6 || return 1
}

case "$1" in
enable)
  enable_iptables || exit 1
  if [ "$block_ipv6_dns" = true ]; then
    add_block_ipv6_dns || exit 1
  else
    enable_ipv6_iptables || exit 1
  fi
  ;;
disable)
  disable_iptables || exit 1
  del_block_ipv6_dns || exit 1
  disable_ipv6_iptables || exit 1
  ;;
*)
  echo "Usage: $0 {enable|disable}"
  exit 1
  ;;
esac