---
author: huji0624
comments: true
date: 2012-03-29 07:02:38+00:00
layout: post
slug: '%e4%bd%bf%e7%94%a8chrome%e6%9f%a5%e7%9c%8bhttp%e8%af%b7%e6%b1%82'
title: 使用chrome查看http请求
wordpress_id: 416
categories:
- Util
---

这两天项目中有个需求是要利用httppost方法上传文件，折腾了好久也不行，基本上确定是自己构造的http包有问题，但是正确的http包应该是怎么样的却不是知道。

于是去[tools.ietf.org](http://tools.ietf.org/)看了看http协议中关于multipart部分的内容，看得似懂非懂的，再试了试重新构造，还是出错，于是想看看浏览器发出的multipart格式的http请求是什么样子的，请教了下益龙大哥知道chrome就可以查看自己的http请求，试了一把。很简单。

打开chrome中的Tools>Developer Tools

点击Network tab.然后使用浏览器进行操作,然后在network窗口中就会出现刚才执行的http请求。

点击tab中的headers，可以看到请求的header，form-data等数据。

[![](http://www.whoslab.me/blog/wp-content/uploads/2012/03/Screenshot-at-2012-03-29-150244.png)](http://www.whoslab.me/blog/wp-content/uploads/2012/03/Screenshot-at-2012-03-29-150244.png)

然后就可以先试试在浏览器中用html构造http请求，然后自己依葫芦画瓢就行了，这可能比直接看协议要更形象些。
