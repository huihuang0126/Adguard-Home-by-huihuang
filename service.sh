SCRIPT_DIR="/data/adb/agh/scripts"
AGH_DIR="/data/adb/agh"
BIN_DIR="$AGH_DIR/bin"
PID_FILE="$BIN_DIR/agh_pid"

"$SCRIPT_DIR/NoAdsService.sh" >/dev/null 2>&1 &

until [ $(getprop init.svc.bootanim) = "stopped" ]; do
  sleep 12
done

/data/adb/agh/scripts/tool.sh start

inotifyd /data/adb/modules/AdGuardHome:d,n &