package com.crawler;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;


public class JsoupCrawler {
    public static void main(String[] args) {
        try {
            String url = "https://example.com";
            Document doc = Jsoup.connect("https://search.naver.com/search.naver?ssc=tab.news.all&where=news&sm=tab_jum&query=%EB%84%A4%EC%9D%B4%EB%B2%84+%EB%89%B4%EC%8A%A4+%EC%95%BC%EA%B5%AC").get();

            Elements elements = doc.getElementsByClass(".body");

            for (Element el : elements) {
                System.out.println(el.text());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
