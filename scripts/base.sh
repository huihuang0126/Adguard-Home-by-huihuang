function log() {
  local str="$1"
  echo "$str" | tee -a "$AGH_DIR/history.log"
}

function update_description() {
  local d="$1";sed -i "/^description=/c\description=$d" "$MOD_PATH/module.prop"
}