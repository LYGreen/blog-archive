+++
date = '2024-10-26T00:43:41+08:00'
draft = false
title = 'Arch Linux 离线安装教程'
description = "给一台没有网的设备安装 Arch Linux"
categories = [
    "Linux",
]
tags = [
    "Arch Linux",
]
+++

# 虚拟机离线安装 Arch Linux

____

## 需要准备：

* 可联网并使用 pacman 的 Arch Linux ( 可以是 Live 环境 )

* 虚拟机 ( VMware 或 VirtualBox )

____

## 下载软件包 ( 此处使用虚拟机的 Live 环境 )：

先做好磁盘相关工作 ( lsblk 可以检查磁盘状态 )：

```bash
lsblk
```

![](img-arch-linux-offline-install/img1.png)

接下来对磁盘进行操作

```bash
fdisk /dev/sda
```

出现 Command (m for help): 之后输入 n 创建分区

```
Command (m for help):n
```

之后一直按回车直到再次出现 Command (m for help): 之后输入 w 进行写入

```
Command (m for help):w
```

此时输入 lsblk 会出现一个新的分区

![](img-arch-linux-offline-install/img2.png)

接下来将 sda1 分区进行格式化

```bash
mkfs.ext4 /dev/sda1
```

将该分区挂载到目录 /mnt

```bash
mount /dev/sda1 /mnt
```

进入到 /mnt 目录，并在该目录创建文件夹

```bash
cd /mnt
mkdir -p /mnt/var/lib/pacman/sync
mkdir -p /mnt/var/cache/pacman/pkg
```

下载存储库 ( 由于该目录挂载的是 sda1 分区，所以下载之后会保存在磁盘当中 )

```bash
pacman --root /mnt --cachedir /mnt/var/lib/pacman/pkg -Sy
```

下载软件包，此处为下载 base, linux, linux-firmware, grub, vim, dhcpcd 包，如果有需要其他的包可以在后面进行添加 ( Live 镜像里的包可以在此处看到 [pkglist.x86_64.txt](https://geo.mirror.pkgbuild.com/iso/latest/arch/pkglist.x86_64.txt) )

```bash
pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -Sw base linux linux-firmware grub vim dhcpcd
```

下载好之后进行压缩

```bash
tar -czvf packages.tar.gz var
```

接下来可以用 pscp 等工具将该压缩包进行复制到当前计算机 ( 此处以 pscp 为例，将文件复制到 pscp 根目录 )

```bash
pscp -r root@192.168.x.x:/mnt/packages.tar.gz .
```

若在连接的过程中提示需要密码，则可以先在 Arch Linux 创建一个密码

```bash
passwd
```

![](img-arch-linux-offline-install/img3.png)

该虚拟机可以作废了

____

## 安装软件包 ( 此处新建了一个 Arch Linux 虚拟机 )

### 安装系统

和刚才一样，先将磁盘进行分区，格式化

```bash
fdisk /dev/sda
```

fdisk 命令( 新建分区，写入 )

```
Command (m for help):n
Command (m for help):w
```

格式化，挂载，进入到该目录

```bash
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
cd /mnt
```

然后进行局域网传输 ( 或其他可行的方法 )，在当前计算机开启一个网页服务器 ( 可用 nginx, Visual Studio Code 的 Live Server 等 )，在 Arch Linux 里面根据当前计算机的 __ip__，__端口__ 和 __文件路径__ 输入命令，把当前计算机的 packages.tar.gz 文件传输到虚拟机里

```bash
curl -O 192.168.x.x:xx/path/to/packages.tar.gz
```

解压

```bash
tar -xzvf packages.tar.gz
```

此时可以输入 ls 检查当前目录

```bash
ls
```

![](img-arch-linux-offline-install/img4.png)

接下来进行安装 ( 设置 /mnt 目录为根，软件包为 /mnt/var/cache/pacman/pkg )

```bash
pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -S base linux linux-firmware grub vim dhcpcd
```

之后一直默认，进行安装

![](img-arch-linux-offline-install/img5.png)

__此处安装过程中会遇到错误如下：__

![](img-arch-linux-offline-install/img6.png)

因为 /mnt/dev 文件夹是空的，换句话说 /mnt/dev 没有和 Live 环境里的设备 /dev 进行绑定，因此需要进行绑定 ( 挂载虚拟文件系统 )

```bash
mount --bind /dev /mnt/dev
```

此外，另外2个目录也需要进行绑定

```bash
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
```

再次进行安装

```bash
pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -S base linux linux-firmware grub vim dhcpcd
```

安装完成之后即可进入该系统

```bash
arch-chroot /mnt
```

### 设置时区

例如设置为上海

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
```

### 本地化

使用 vim 编辑 /etc/locale.gen，取消注释所需的语言（ 如 en_US.UTF-8 ）:

```bash
vim /etc/locale.gen
```

然后生成本地化：

```bash
locale-gen
```

设置系统语言：

```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### 主机名

设置主机名：

```bash
echo "myhostname" > /etc/hostname
```

用 vim 编辑 /etc/hosts ，添加：

```
127.0.0.1 localhost
::1       localhost
127.0.1.1 myhostname.localdomain myhostname
```

### 设置 root 密码

__一定要设置密码，否则之后启动系统密码怎么输都不行__

```bash
passwd
```

### 安装 grub ( 引导加载程序 )

```bash
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

### 退出 chroot 并重启系统

退出 chroot：

```bash
exit
```

取消挂载 sda1：

```bash
umount -R /mnt
```

重启：

```bash
reboot
```

____

## 完成

选择 Arch Linux 即可进入系统

![](img-arch-linux-offline-install/img7.png)

## 解决无网络问题

若启动系统之后没有网络，则需要启动 dhcpcd 服务

```bash
systemctl start dhcpcd
```

设置开机自启动：

```bash
systemctl enable dhcpcd
```

___
## 参考
* [Arch 离线安装教程](https://aquarium39.moe/posts/install-arch-offline/)
* [ChatGPT](https://chatgpt.com/)
