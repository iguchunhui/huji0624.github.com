---
author: huji0624
comments: true
date: 2012-08-28 14:15:31+00:00
layout: post
slug: uipopovercontroller-%e4%bd%bf%e7%94%a8%e5%b0%8f%e8%8a%82
title: UIPopoverController 使用小节
wordpress_id: 561
categories:
- iOS
---

UIPopoverController是iPad上的iOS开发会常用到的一个组件（在iPhone设备上不允许使用），这个组件上手很简单，因为他的显示方法很少，而且参数简单，但我在使用过程中还常碰到各种问题，直到今天我感觉才把他的用法完全搞明白。

先看他的继承关系，UIPopoverController是直接继承自NSObject，它和UIViewController没有半毛线关系.那它是怎么实现弹出在所有View之上的，我猜测是利用了keywindow，把这个View加在keywindow里面，我做了个试验，一般我们会在AppDelegate的didFinishLauch（大概是这么个方法）中来初始化我们的window，把应用的第一个viewcontroller加到window中去，并在最后调用window的makekeyandvisible方法。于是我尝试在window实例调用makekeyandvisible方法的之前弹出一个UIPopoverController，于是得到了下面的错误：

    
    
    *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UIPopoverController presentPopoverFromRect:inView:permittedArrowDirections:animated:]: Popovers cannot be presented from a view which does not have a window.'
    


所以我猜UIPopoverController就是把你提供的Viewcontroller包起来加一个arrow框和背景，加到keywindow中去。另外如果你在显示地时候传入的BarButtonItem为nil，也会报这个错误，但实际上和window无关。

UIPopoverController的方法:

    
    
    – initWithContentViewController: //很简单的初始化方法，把你要展示的Viewcontroller传给它
    – setContentViewController:animated: //可以在UIPopoverController还在显示的时候动态地更换ContentViewController.
    
    – setPopoverContentSize:animated://设置PopOverController的展示框大小，虽然文档中说它会根据ContentViewController的大小来设置自己的宽高，但我发现如果你不显示地调用这个方法并传入ContentViewController的size，一般情况它的大小会小于ContentViewController。
    
    – presentPopoverFromRect:inView:permittedArrowDirections:animated://显示这个UIPopoverController,下面详细说
    – presentPopoverFromBarButtonItem:permittedArrowDirections:animated://显示这个UIPopoverController，比较简单，传入BarButtonItem的实例
    – dismissPopoverAnimated:／／让它消失
    
    


关于显示方法,
– presentPopoverFromRect:inView:permittedArrowDirections:animated:
这个方法需要传入一个CGRect和一个View，而只有这个CGRect的值是相对于这个View的，这个Arrow才能指到正确的位置。我猜测它是在视图树中向上搜索把它转化为在keywindow中的值再显示。举个例子，如果你要箭头指向被点击的这个button，那么一种方法是：

    
    
    [xxx presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:xx animated:YES];
    


一种方法是转换为他的父视图中的CGRect：

    
    
    [xxx presentPopoverFromRect:button.frame inView:button.superview permittedArrowDirections:xx animated:YES];
    



**UIPopoverController的外观**
通过popoverBackgroundViewClass属性和popoverLayoutMargins，你就可以自己定制Popover的外观了，popoverLayoutMargins是指你的popover相对于整个window上下左右的margin，当你设置的值大于它目前的值的时候，它才会调整（也就是让它自己更小的margin才会被实现).另外通过subclass UIPopoverBackgroundView，并把该class指定给popoverBackgroundViewClass属性，你就可以随意改变他的外观了。

**UIPopoverController的内存管理**
根据目前我使用的情况来看，我常用的使用方式是在属性中声明一个 retain 的 UIPopoverController，然后在创建的时候指向创建的临时变量，然后释放临时变量.我还没有发现更方便的内存管理的方法，UIPopoverController和UIActionSheet有点不一样，你必须自己来retain这个UIPopoverController，如果在UIPopoverController还没有dismiss的时候你就release掉了，就会出错。当然，你可以把UIPopoverController的delegate设为self，然后在popoverControllerDidDismissPopover中释放他，但我感觉这样还不如采用属性更方便，因为你没法代码控制popover的消失了，总得维护一个引用，当然，象我这种方法得话，你很多时候是在延迟释放这个popOver了。一般来说，你可以经常使用这样得代码:

    
    
    [self.pop dismissPopoverAnimate:xx];
    self.pop=nil;
    


因为给nil发送一个dismissxx是没有问题的，然后再释放，这样可以保证内存不混出错。当然，如果实在不放心，可以总是在前面加一个if(!=nil)的判断.

**UIPopoverController防止点击区域外消失**
UIPopoverController的默认行为是，当你点击UIPopoverController以外的区域时，它会消失，改变这种行为就要利用属性passthroughViews.它的意思是，UIPopoverController点击在它的区域外，如果点到了passthroughViews中的View的时候，是不会消失的。我写了demo试了一下，passthroughView中被点击的View以及其SubView都不会让UIPopoverController消失。
