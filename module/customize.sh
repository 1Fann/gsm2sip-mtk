#!/system/bin/sh
set +x
[ "$KSU" = true ] || abort "KernelSU/BakaSU is required."
[ "$(getprop ro.product.cpu.abi)" = arm64-v8a ] || abort "ARM64 only."
[ "$(getprop ro.board.platform)" = mt6893 ] || abort "This experimental package targets MT6893."
[ "$API" -ge 31 ] || abort "Android 12 or later is required."
[ -f "$MODPATH/system/priv-app/GSM2SIP/GSM2SIP.apk" ] || abort "Build and package the APK first."
set_perm_recursive "$MODPATH/system" 0 0 0755 0644 u:object_r:system_file:s0
ui_print "- GSM2SIP: BakaSU + MT6893 adaptations only"
ui_print "- Compatible mounting metamodule required."
ui_print "- Grant app Root/runtime permissions manually."
ui_print "- Upstream autoconnect, permission and SMS behavior is retained."
ui_print "- Cellular two-way audio remains experimental."
