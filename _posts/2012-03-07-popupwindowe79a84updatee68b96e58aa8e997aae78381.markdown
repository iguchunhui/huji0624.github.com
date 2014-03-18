---
author: huji0624
comments: true
date: 2012-03-07 14:34:37+00:00
layout: post
slug: popupwindow%e7%9a%84update%e6%8b%96%e5%8a%a8%e9%97%aa%e7%83%81
title: popUpWindow的update拖动闪烁
wordpress_id: 387
categories:
- Android
---

应用场景是这样的，在popupwindow中放置了自定义的view，然后想利用它的update方法来实现拖动整个popupwindow移动。因为前段时间经常写在View中的画线什么的，觉得这样的逻辑很简单，就习惯性写了如下代码。


    
    
            PopupWindow mPop;
    
    	int mScreenX=10, mScreenY=10;
    	
    	int mX,mY;
    
    	OnTouchListener mTouchLis = new OnTouchListener() {
    
    		@Override
    		public boolean onTouch(View v, MotionEvent event) {
    			// TODO Auto-generated method stub
    
    			if (event.getAction() == MotionEvent.ACTION_DOWN) {
    
    				mX=(int) event.getX();
    				mY=(int) event.getY();
    				
    			} else if (event.getAction() == MotionEvent.ACTION_MOVE) {
    
    				int delX = (int) (event.getX() - mX);
    				int delY = (int) (event.getY() - mY);
    
    				mScreenX+=delX;
    				mScreenY+=delY;
    				
    				mPop.update(mScreenX, mScreenY, -1, -1);
    				
    				mX=(int) event.getX();
    				mY=(int) event.getY();
    			}
    
    			return false;
    		}
    	};
    



说实话，这个地方不仔细想还真的很容易中陷阱。

这个代码实现出来的效果就是被拖动的popupwindow断的闪烁，开始我还以为是因为触摸屏的抖动造成的，因为手指移动时，很可能会造成在一个方向的上下抖动。打印了log，也确实是这样的，event返回的x，y值确实存在抖动，但突然想起以前在视图中绘制矩形框进行拖动时，也没有进行特别的防抖动处理，也没有出现这样的闪烁情况，应该是别的方面的原因（由此应该可以说明Android在绘制图形时在底层做了防抖动处理）。

想了半天没搞懂，后来还是公司的小周同学提醒，原因如下：

popupwindow中的event所取得的x，y值是相对于popupwindow这个window的左上角的坐标而言的，而不是activity所在的window或者整个屏幕.所以当你拖动时，pop被更新到mscreenXX+delXX的位置，然后继续传过来的x，y值就已经是相对于popupwindow的最新值了，所以正确的代码应该是注释如下两行就行了：

//				mX=(int) event.getX();
//				mY=(int) event.getY();

搞定收工。
