---
author: huji0624
comments: true
date: 2012-04-03 04:07:02+00:00
layout: post
slug: '%e4%bd%bf%e7%94%a8httpurlconnection%e6%9e%84%e9%80%a0%e6%b2%a1multipartform-data%e7%b1%bb%e5%9e%8bpost%e8%a1%a8%e5%8d%95%e4%b8%8a%e4%bc%a0%e5%a4%9a%e7%a7%8d%e7%b1%bb%e5%9e%8b%e6%95%b0%e6%8d%ae'
title: 使用HttpURLConnection构造multipart/form-data类型Post表单上传多种类型数据
wordpress_id: 418
categories:
- Android
tags:
- 协议
---

首先感谢一下几篇文章，读了这几篇文章，才对如何构造http协议包传输混合数据有了个大致的了解。
[使用Javascript XMLHttpRequest模拟表单（Form）提交上传文件](http://www.gooseeker.com/cn/node/742)
[上传文件multipart form-data boundary 说明](http://blog.csdn.net/zfrong/article/details/3604191)
[如何使用multipart/form-data格式上传文件](http://blog.csdn.net/mspinyin/article/details/6141638)


本来几乎没有和协议大过什么交道，习惯了用库了。这次项目中需要上传文件以及一些文本信息，使用java.net.HttpURLConnection，本来可以使用org.apache.http.client.methods.HttpPost，非常简单，网上也有很多示例代码，但因为之前的代码一直用的前者这个API，没有直接的上传文件的方法，为了改动较少，所以打算自己构造上传文件的表单。

在网上看了几篇文章，找了几段示例代码，但都没能成功实现功能，后来通过查协议，抓包的方式，终于搞通了。其实原因也很简单，就是自己构造的http数据的格式不对，协议对格式的要求非常严格，很多地方的换行都是很必要的，不然就会产生错误。

上代码，已运行测试。服务器端用php接收，正常。


    
    
            public static final String HTTP_METHOD_GET = "GET";
    	public static final String HTTP_METHOD_POST = "POST";
    	public static final String BOUNDARYSTR = "aifudao7816510d1hq";
    	public static final String BOUNDARY = "--" + BOUNDARYSTR + "\r\n";
    
    
    				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    				String cookie = bp_rfn_bp_session_id + "=" + Aifudao.globalBpSid;
    				Log.d("cookie:" + cookie);
    				conn.addRequestProperty("cookie", cookie);
    				conn.setConnectTimeout(5 * 1000);
    				conn.setRequestMethod(mMethod);
    
    				if (mMethod.equals(HTTP_METHOD_POST)) {
    					conn.setDoOutput(true);
    					conn.setUseCaches(false);
    
    					if (mFiles.size() > 0) {
    						conn.setRequestProperty("Content-type", "multipart/form-data;boundary=" + BOUNDARYSTR);
    					}
    
    					conn.connect();
    
    					BufferedOutputStream out = new BufferedOutputStream(conn.getOutputStream());
    
    					StringBuilder sb = new StringBuilder();
    					if (mFiles.size() > 0) {
    						Iterator<string> it = mPostMap.keySet().iterator();
    						while (it.hasNext()) {
    							String str = it.next();
    							sb.append(BOUNDARY);
    							sb.append("Content-Disposition:form-data;name=\"");
    							sb.append(str);
    							sb.append("\"\r\n\r\n");
    							sb.append(mPostMap.get(str));
    							sb.append("\r\n");
    						}
    					} else {
    						Iterator<string> it = mPostMap.keySet().iterator();
    						while (it.hasNext()) {
    							String str = it.next();
    							sb.append(";");
    							sb.append(str);
    							sb.append("=");
    							sb.append(mPostMap.get(str));
    						}
    					}
    
    					// post the string data.
    					out.write(sb.toString().getBytes());
    
    					// post file data
    					if (mFiles != null && mFiles.size() > 0) {
    
    						for (int i = 0; i < mFiles.size(); i++) {
    
    							File file = mFiles.get(i);
    
    							if (!file.exists()) {
    								Log.e("cant find post file.");
    								continue;
    							}
    
    							Log.d("start upload file.");
    							out.write(BOUNDARY.getBytes());
    
    							StringBuilder filenamesb = new StringBuilder();
    							filenamesb
    									.append("Content-Disposition:form-data;Content-Type:application/octet-stream;name=\"uploadfile");
    							filenamesb.append(i);
    							filenamesb.append("\";filename=\"");
    							filenamesb.append(file.getName() + "\"\r\n\r\n");
    							out.write(filenamesb.toString().getBytes());
    
    							FileInputStream fis = new FileInputStream(file);
    							byte[] buffer = new byte[8192]; // 8k
    							int count = 0;
    							// 读取文件
    							while ((count = fis.read(buffer)) != -1) {
    								out.write(buffer, 0, count);
    							}
    
    							 out.write("\r\n\r\n".getBytes());
    							fis.close();
    						}
    					}
    
    					out.write(("--" + BOUNDARYSTR + "--\r\n").getBytes());
    
    					out.flush();
    
    					out.close();
    				}
    
    



然后后面的接收相应的代码就和普通的get方法没有什么区别了。

注意的几个重要而且容易出错的地方：

1.设置头信息
conn.setRequestProperty("Content-type", "multipart/form-data;boundary=" + BOUNDARYSTR);

这里需要在头信息里把类型设置为multipart/form-data,boundary设为一个一般不会和数据冲突的随机字符串，这是用来区分你的多种数据的。

2.构造POST数组

在服务器端一般都有一个post数组来接收post数据，这段代码就是用来构造post数据的。


    
    
    while (it.hasNext()) {
    							String str = it.next();
    							sb.append(BOUNDARY);
    							sb.append("Content-Disposition:form-data;name=\"");
    							sb.append(str);
    							sb.append("\"\r\n\r\n");
    							sb.append(mPostMap.get(str));
    							sb.append("\r\n");
    						}
    



注意其中的那几个换行，貌似都是很有必要的。之前换行格式没有正确，就老是拿不到post数据。

3.在合适的地方插入分界字符串和换行

out.write(BOUNDARY.getBytes());

协议默认使用 --BOUNDARYSTR 的格式来作为分界字符串，而在结尾的时候使用 --BOUNDARYSTR-- 的格式作为结束标志

4.在某些数据后面加入必要换行


    
    
    StringBuilder filenamesb = new StringBuilder();
    							filenamesb
    									.append("Content-Disposition:form-data;Content-Type:application/octet-stream;name=\"uploadfile");
    							filenamesb.append(i);
    							filenamesb.append("\";filename=\"");
    							filenamesb.append(file.getName() + "\"\r\n\r\n");
    							out.write(filenamesb.toString().getBytes());
    
    							FileInputStream fis = new FileInputStream(file);
    							byte[] buffer = new byte[8192]; // 8k
    							int count = 0;
    							// 读取文件
    							while ((count = fis.read(buffer)) != -1) {
    								out.write(buffer, 0, count);
    							}
    
    							 out.write("\r\n\r\n".getBytes());
    							fis.close();
    
    



这里注意的是，在文件名后的两个换行很必要，否则可能出现文件名包含一部分文件数据的情况。文件二进制数据写入完成后，也有两个换行（这个地方我记不清是否是必须的了，但这段代码是能正常运行的）。

如果还不行，那肯定是构造格式的问题，最好自己把自己发送的数据打印出来仔细对比和抓到的http包数据之间的区别，注意，很多换行和数据分界字符串都很严格。
