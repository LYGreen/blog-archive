+++
date = '2025-01-14T15:49:34+08:00'
draft = false
title = 'OpenWrt 配置 WiFi 中继'
description = "OpenWrt 连接其他 WiFi，然后这个路由器再自己发射出一个 WiFi 信号"
categories = [
    "知识分享",
]
tags = [
    "OpenWrt",
]
+++

## OpenWrt 配置 WiFi 中继
### 连接需要中继的 wifi
去到```Network -> Wireless```，点击 ```Scan```
![](img-openwrt-wifi-setting/img0.png)

选择需要中继的 WiFi 网络，点击加入网络
![](img-openwrt-wifi-setting/img1.png)

```WPA passphrase```意思是要输入 wifi 密码  
```Lock to BSSID```表示这个网络与 MAC 地址绑定，不用担心 wifi 重名问题  
完成之后点击```Submit```
![](img-openwrt-wifi-setting/img2.png)

这里直接默认即可，点击```Save```
![](img-openwrt-wifi-setting/img3.png)

点击```Save & Apply```，此时你的路由器已经连上了要中继的 wifi，并且电脑也可以上网了
![](img-openwrt-wifi-setting/img4.png)

### 开启当前路由器的 wifi
点击```add```
![](img-openwrt-wifi-setting/img5.png)

配置模式为```Access Point```，即网络接入点，或者是说当前路由器的 wifi，怎么样叫它都可以  
```ESSID```也就是 wifi 名字  
```Network```表示当前配置属于哪个网络，选择 lan 网络，意思类似于，一台设备连上了这个 wifi 之后就相当于这个设备接到了这个路由器的 lan 口  
点击```Save```
![](img-openwrt-wifi-setting/img6.png)

接着来到```Wireless Security```，加密方式可以选择这个，设置一下 wifi 密码，点击```Save```
![](img-openwrt-wifi-setting/img7.png)

点击```Save & Apply```
![](img-openwrt-wifi-setting/img8.png)

此时可以看到当前路由器的 wifi  
![](img-openwrt-wifi-setting/img9.png)

