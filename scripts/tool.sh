#!/system/bin/sh
. "/data/adb/agh/settings.conf"; . "/data/adb/agh/scripts/base.sh"

start_adguardhome() {
    [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null 2>&1 && exit 0
    export SSL_CERT_DIR="/system/etc/security/cacerts/"
    "$BIN_DIR/AdGuardHome" > /dev/null 2>&1 &
    echo "$!" > "$PID_FILE"
    if [ "$enable_iptables" = true ]; then
        "$SCRIPT_DIR/iptables.sh" enable
        log "AdGuardHome已启用"
    fi
    update_description "AdGuardHome已启用"
}

stop_adguardhome() {
    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null || kill -9 "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE"
    else
        pkill -9 -f "AdGuardHome" 2>/dev/null
    fi
    "$SCRIPT_DIR/iptables.sh" disable
    log "AdGuardHome已禁用"
    update_description "AdGuardHome已禁用"
}

toggle_adguardhome() {
    [ -f "$PID_FILE" ] && ps | grep -w "$(cat "$PID_FILE")" | grep -q "AdGuardHome" && stop_adguardhome || start_adguardhome
}

case "$1" in
start)start_adguardhome;;
stop)stop_adguardhome;;
toggle)toggle_adguardhome;;
*)exit 1;;
esac