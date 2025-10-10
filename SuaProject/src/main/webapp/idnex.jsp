<%@ page import="com.crawler.JsoupCrawler" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Jsoup Crawling Test</title>
</head>
<body>
    <h1>Jsoup Crawling test</h1>
    <div>
        <%
        JsoupCrawler crawler = new JsoupCrawler();
        String result = crawler.crawlNaverNews();   
        out.print(crawler.crawlNaverNews());
        %>
    </div>
</body>
</html>
