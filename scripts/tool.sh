#!/system/bin/sh
. "/data/adb/agh/settings.conf"
. "/data/adb/agh/scripts/base.sh"

start_adguardhome() {
    if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" >/dev/null 2>&1; then
        log "AdGuardHome 已在运行"
        update_description "AdGuardHome 已启用"
        return 0
    fi
    export SSL_CERT_DIR="/system/etc/security/cacerts/"
    "$BIN_DIR/AdGuardHome" >/dev/null 2>&1 &
    echo "$!" > "$PID_FILE"
    if [ "$enable_iptables" = true ]; then
        "$SCRIPT_DIR/iptables.sh" enable
        log "AdGuardHome 已启用"
    fi
    update_description "AdGuardHome 已启用"
}

stop_adguardhome() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if ps -p "$pid" >/dev/null 2>&1; then
            kill "$pid" >/dev/null 2>&1
            ps -p "$pid" >/dev/null 2>&1 && kill -9 "$pid"
        fi
        rm -f "$PID_FILE"
    else
        pkill -x AdGuardHome >/dev/null 2>&1
    fi
    "$SCRIPT_DIR/iptables.sh" disable
    log "AdGuardHome 已禁用"
    update_description "AdGuardHome 已禁用"
}

toggle_adguardhome() {
    if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" >/dev/null 2>&1; then
        stop_adguardhome
    else
        start_adguardhome
    fi
}

case "$1" in
    start) start_adguardhome;;
    stop) stop_adguardhome;;
    toggle) toggle_adguardhome;;
    *) exit 1;;
esac