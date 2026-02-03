#!/system/bin/sh
AGH_DIR="/data/adb/agh"

# 防止重复启动
[ $(pgrep -f "$0" | wc -l) -gt 1 ] && exit

# 广告屏蔽核心函数
block_rw() {
  [ -e "$1" ] && rm -rf "$1" 2>/dev/null
  [ -d "$(dirname "$1")" ] && { [ "${1: -1}" = "/" ] && mkdir -p "$1" || touch "$1"; } && chattr +i "$1" 2>/dev/null
}

# 执行循环
while true; do

# 添加完屏蔽路径以后必须重启手机生效
    # 美团外卖
    block_rw "/data/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/ad/"
    block_rw "/data/media/0/Android/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/promotion/"
    
    # 中国广电
    block_rw "/data/data/com.ai.obc.cbn.app/files/splashShow/"
    
    #酷我音乐
     block_rw "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.screenad/"
    
    #大麦App
    block_rw "/data/data/cn.damai/files/ad_dir/"
    
    #小米有品
    block_rw "/data/data/com.xiaomi.youpin/shared_prefs/ad_prf.xml"
    
    #小爱音箱
    block_rw "/data/media/0/Android/data/com.xiaomi.mico/files/data_cache/journal"
    
    #高德地图
    block_rw "/data/data/com.autonavi.minimap/files/splash/"
    block_rw "/data/data/com.autonavi.minimap/files/LaunchDynamicResource/"
    
    #中国移动
    block_rw "/data/data/com.greenpoint.android.mc10086.activity/shared_prefs/default.xml"
    
    #YY
    block_rw "/data/data/com.duowan.mobile/shared_prefs/CommonPref.xml"
    
    #哔哩哔哩国内版
    block_rw "/data/data/tv.danmaku.bili/files/splash2/"  
    
    #米游社
    block_rw "/data/media/0/Android/data/com.mihoyo.hyperion/cache/splash/"
    
    #知乎App
    block_rw "/data/data/com.zhihu.android/files/ad/"
    
    #米家
    block_rw "/data/data/com.xiaomi.smarthome/files/sh_ads_file/"
    
    #小米社区
    block_rw "/data/data/com.xiaomi.vipaccount/files/mmkv/mmkv.default"
    
    #天翼云盘
    block_rw "/data/data/com.cn21.ecloud/files/ecloud_current_screenad.obj"
    
    #顺丰速递
    block_rw "/data/data/com.sf.activity/files/openScreenADsImg/"
    
    #网易云音乐
    block_rw "/data/media/0/Android/data/com.netease.cloudmusic/cache/Ad/"
    block_rw "/data/data/com.netease.cloudmusic/cache/MusicWebApp"
    
    #猫耳FM
    block_rw "/data/data/cn.missevan/cache/splash/"
    
    #小福家
    block_rw "/data/data/com.coocaa.familychat/app_e_qq_com_setting_7d767d052a5753acb54b111c8a40c128/sdkCloudSetting.cfg"
    
   #堆糖
    block_rw "/data/data/com.duitang.main/shared_prefs/name.xml"
    
    #同花顺
    block_rw "/data/data/com.hexin.plat.android/cache/splash_images/"
    
    #酷狗
    block_rw "/data/media/0/Android/data/com.kugou.android/files/kugou/.splash_v4/"
     
     #腾讯地图
    block_rw "/data/data/com.tencent.map/files/8c597f8d3cda22e1405f01f31a0709fb2026013000002026020323594306splash.jpg"
    block_rw "/data/data/com.tencent.map/files/aa713ed87396091b66515e25999fc02b2026012900002027013023594265splash.jpg"
    
    #驾考宝典
    block_rw "/data/data/com.handsgo.jiakao.android/shared_prefs/mucangData.db.xml"
    
# 自动关闭私人DNS
settings get global private_dns_mode | grep off || settings put global private_dns_mode off

# 专清/data/data卸载残留
for d in /data/data/*==deleted==;do [ -d "$d" ]&&chattr -R -i "$d"&&rm -rf "$d";done

# 延迟启动
  sleep 5
done