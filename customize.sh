SKIPUNZIP=1

AGH_DIR="/data/adb/agh"
BIN_DIR="$AGH_DIR/bin"
SCRIPT_DIR="$AGH_DIR/scripts"
PID_FILE="$AGH_DIR/bin/agh.pid"

unzip -o "$ZIPFILE" "action.sh" "module.prop" "service.sh" -d "$MODPATH" >/dev/null 2>&1

extract_no_config() {
  rm -rf "$AGH_DIR" && mkdir -p "$AGH_DIR/bin" && chmod -R 755 "$AGH_DIR" && chown root:root "$AGH_DIR" 2>/dev/null
  extract_all && [ -f "$AGH_DIR/bin/AdGuardHome" ] && chmod +x "$_" 2>/dev/null
}

extract_all() {
  unzip -o "$ZIPFILE" "scripts/*" "bin/*" "settings.conf" -d "$AGH_DIR" >/dev/null 2>&1
}

[ -d "$AGH_DIR" ] && (pkill -f "AdGuardHome" || pkill -9 -f "AdGuardHome") && extract_no_config || (mkdir -p "$AGH_DIR" "$BIN_DIR" "$SCRIPT_DIR" && extract_all)

chmod +x "$BIN_DIR/AdGuardHome"
chown root:net_raw "$BIN_DIR/AdGuardHome"
chmod +x "$SCRIPT_DIR"/*.sh "$MODPATH"/*.sh