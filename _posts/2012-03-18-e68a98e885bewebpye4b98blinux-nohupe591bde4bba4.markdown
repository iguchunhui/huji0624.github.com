---
author: huji0624
comments: true
date: 2012-03-18 05:51:03+00:00
layout: post
slug: '%e6%8a%98%e8%85%bewebpy%e4%b9%8blinux-nohup%e5%91%bd%e4%bb%a4'
title: 折腾webpy之Linux nohup命令
wordpress_id: 399
categories:
- Linux
---

背景：最近在折腾webpy，关于webpy的hellowword官方有很详细的教程，但是在把webpy整到服务器上运行的时候，在最初的版本的里就需要用到nohup这个命令了。

在写好webpy的helloword程序以后，我把他上传到租用的dreamhost服务器上，ssh登录以后，使用 
    python helloword.py 
来启动webpy，这时服务器就在8080端口等待http请求了，但是terminal一直都在显示python的标准输出，当你用ctrl + c 退出以后，webpy也就停止了。即使你使用
    python hellword.py &
来启动，在你logout以后，webpy程序也会停止。[这里](http://os.51cto.com/art/200912/172706.htm)有为什么会这样的原因，这时nohup就有用武之地了。

man一下nohup会看到nohup的详细用法和全称，其实就是no hang up的意思，并且把标准输入输出重定向到文件中。于是就可以这样来启动

nohup python helloword.py & 

这样，即使在你退出了以后，属于你这个UID的进程也不会被终止了。

但是，后来我发现，我的webpy程序在隔几天以后还是会停掉，因为我是把服务开启在dreamhost服务器上的，一台机子有很多用户，我猜想是不是由于安全考虑，dreamhost的管理猿会定期清除这些“非法”的进程还是服务器定期重启造成的，所以后来我就不得不把webpy折腾到apache中去，这个以后再写。
