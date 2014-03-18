---
author: huji0624
comments: true
date: 2012-07-17 11:44:03+00:00
layout: post
slug: objective-c%e4%b8%ad%e7%9a%84kvc
title: objective-c中的KVC
wordpress_id: 533
categories:
- Objective-C
---

首先感谢[marshal.easymorse.com](http://marshal.easymorse.com/)的文章，是偶然读到这片文章才让我意识到应该研究一下OC中这个很有意思的特性。

KVC 也就是 Key-Value Coding，总的来说我感觉有点类似Java中利用发射的方法，对对象的实力进行访问的方式，不过感觉java中的反射（我了解的比较少），由于无法进行编译时的类型安全检查以及一些安全问题，是不推荐这么使用的，但在Objective c中却称为了一种特性。

利用KVC，可以用键值对的方式访问实力的property或者instance variable.Typically, a key corresponds to the name of an accessor method or instance variable in the receiving object. key都是NSString 类型的参数，用来表示你要访问的实力的变量名.文档中说用小写字母开头，不能包含空白.key-Path和key类似，只是key-path更厉害，可以访问变量的变量.

比如 AClass 中有一个实例变量叫 thevalue:


    
    
    
    @interface AClass : NSObject
    {
         NSString *thevalue;
    }
    @end
    
    



那么可以这样来访问这个实例变量:


    
    
    
    AClass *aclass = [ [AClass aollc] init];
    
    //为它赋值
    [aclass setValue:@"this is a value" forKey:@"thevalue"];
    
    //取值
    [aclass valueForKey:@"thevalue"];
    
    



如果AClass是另外一个BClass的实例变量,那么就可以用keyPath来设置变量AClass的变量thevalue的值,类似：

    
    
    [bclass setValue:"this is a value" forKeyPath:@"aclass.thevalue"];
    



还有以集合的方式来设置keyValue,方法类似.如果不存在相应的key，NSObject还提供了相应的方法可以复写进行处理.
不过这种方式略复杂，官方文档有详细的说明，使用的时候可以具体细看.

关于kvc我看文档中还将了很多，但还是不太明白有些特性的意义，平时也几乎没有使用这些特性.所以目前来讲，我觉得这些特性在增加了语言的复杂性和功能性上来说，前者的影响更大，真心希望Objcetive c能越来越好，最好能集简洁和功能于一身。
