---
author: huji0624
comments: true
date: 2012-03-18 06:45:43+00:00
layout: post
slug: '%e6%8a%98%e8%85%bewebpy%e4%b9%8blinux-dos2unix%e5%91%bd%e4%bb%a4'
title: 折腾webpy之Linux dos2Unix命令
wordpress_id: 401
categories:
- Linux
---

背景：这是在把webpy整合到apache中去的时候遇到的问题，说起来这个地方很容易把人搞崩溃，因为经常不会注意到某个档案的格式。

我在把webpy整到apache中以cgi脚本的方式运行webpy的时候，一开始怎么都不行，总会报错

No such file or directory: exec of '/var/www/cgi-bin/hellowork.cgi' failed
[Sun Mar 18 14:36:19 2012] [error] [client ::1] Premature end of script headers: hellowork.cgi

总说不能执行脚本，我总觉得是脚本写得有问题，反复修改，还是会报这个错误，后来还是别人提点，才发现是档案格式的问题。
鸟哥关于这个有专门的描述，曾经看过，但出现问题的时候又忘记了...：

我們在第七章裡面談到 cat 這個指令時，曾經提到過 DOS 與 Linux 斷行字元的不同。 而我們也可以利用 cat -A 來觀察以 DOS (Windows 系統) 建立的檔案的特殊格式， 也可以發現在 DOS 使用的斷行字元為 ^M$ ，我們稱為 CR 與 LF 兩個符號。 而在 Linux 底下，則是僅有 LF ($) 這個斷行符號。這個斷行符號對於 Linux 的影響很大喔！ 為什麼呢？

我們說過，在 Linux 底下的指令在開始執行時，他的判斷依據是 『Enter』，而 Linux 的 Enter 為 LF 符號， 不過，由於 DOS 的斷行符號是 CRLF ，也就是多了一個 ^M 的符號出來， 在這樣的情況下，如果是一個 shell script 的程式檔案，呵呵～將可能造成『程式無法執行』的狀態～ 因為他會誤判程式所下達的指令內容啊！這很傷腦筋吧！

-----转自鸟哥的私房菜

