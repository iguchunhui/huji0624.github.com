---
author: huji0624
comments: true
date: 2012-03-13 07:15:37+00:00
layout: post
slug: java-synchronized-%e7%ad%89%e5%be%85%e9%a1%ba%e5%ba%8f
title: Java  synchronized 等待顺序
wordpress_id: 393
categories:
- JAVA
---

最近项目中因为多线程的东西比较多，需要用到 synchronized 的地方比较多，以前看Think in java的时候也很认真地看了 synchronized 的用法，但用的时候还是有些小疑惑，主要是关于被挂起的方法的执行顺序的。

 synchronized 是Java中的同步锁关键字，可以加在方法上或者某个某一块代码之前，如果其他线程正在使用这个方法或者代码块，再要执行此方法的线程就会等待，但是等待的顺序是怎样的呢，我曾经听得比较多的说法叫同步队列，所谓队列，应该就是先进先出，但是还是验证一下比较好，结果写了如下一段代码实验了一下：


    
    
    public class SyncLizeExperiement {
    	
    	public void start(){
    		
    		for(int i=0;i<6;i++){
    			AnotherThread t=new AnotherThread();
    			t.setPriority(10-i);
    			t.start();
    		}
    	}
    	
    	class AnotherThread extends Thread{
    		@Override
    		public void run() {
    			// TODO Auto-generated method stub
    			super.run();
    			System.out.println("before print "+"id:"+getName());
    			print("id:"+getName());
    //			System.out.println("after print "+"id:"+getId());
    		}
    	}
    	
    	private synchronized void print(String what){
    		
    		System.out.println("in print!!"+what);
    		
    		try {
    			Thread.sleep(5000);
    		} catch (InterruptedException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
    		
    		System.out.println("synchronized print done.--"+what);
    	}
    	
    }
    



标准输出如下：

before print id:Thread-0
before print id:Thread-2
in print!!id:Thread-0
before print id:Thread-1
before print id:Thread-3
before print id:Thread-4
before print id:Thread-5
synchronized print done.--id:Thread-0
in print!!id:Thread-5
synchronized print done.--id:Thread-5
in print!!id:Thread-4
synchronized print done.--id:Thread-4
in print!!id:Thread-3
synchronized print done.--id:Thread-3
in print!!id:Thread-1
synchronized print done.--id:Thread-1
in print!!id:Thread-2
synchronized print done.--id:Thread-2

可见被挂起的线程恢复执行的顺序并不是队列，而是栈的方式，后进先出，我本以为可能是线程优先级或者锁的某些用法不合适，但修改了几个版本，得出的结果还是一样，等待的线程恢复执行的顺序是后进先出，而不是所谓的同步队列。

但既然大家都说同步队列，显然是有原因的，还是我的什么理解有问题，或者代码错误，希望大神指点下。
