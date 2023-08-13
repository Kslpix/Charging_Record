#!/system/bin/sh
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
# 该脚本将在设备开机后作为延迟服务启动
MODDIR=${0%/*}

while [ "$(getprop sys.boot_completed)" != "1" ]; do
sleep 30
done

date=$(date "+%Y-%m-%d %H:%M:%S")

#查看出厂设计容量
cfd=$(cat $(find /sys/devices -iname "charge_full_design" -type f | head -n 1))
charge_full_design=$(($cfd / 1000))

#查看当前电池容量
cf=$(cat $(find /sys/devices -iname "charge_full" -type f | head -n 1))
charge_full=$(($cf / 1000))

#查看电池循环次数
cc=$(cat $(find /sys/devices -iname "cycle_count" -type f | head -n 1))

#计算剩余容量百分比
bfb=$(printf "%d" $((${cf}*100/${cfd})))


battery=$(echo "出厂设计容量为：${charge_full_design}mAh，当前电池容量为：${charge_full}mAh，电池循环次数为：$cc次，估算剩余容量百分比为：$bfb%")

sed -i '/^description=/d' $MODDIR/module.prop
echo "description=$battery" >>$MODDIR/module.prop



echo "$date - 电池健康记录脚本已运行" >> /data/media/0/Documents/电池健康度.log
echo "$battery" >> /data/media/0/Documents/电池健康度.log
echo " " >> /data/media/0/Documents/电池健康度.log

