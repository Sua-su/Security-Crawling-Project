package com.crawler;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class JsoupCrawler {
    public String crawlNaverNews() {
        StringBuilder sb = new StringBuilder();

        try {
            String url = "https://search.naver.com/search.naver?where=news&query=MLB";
            Document doc = Jsoup.connect(url).get();

            // 뉴스 블록 선택 (최상위 div)
            Elements newsBlocks = doc.select("div.sds-comps-vertical-layout.sds-comps-full-layout");

            for (Element block : newsBlocks) {
                // 제목
                Element titleEl = block.selectFirst(".sds-comps-text-type-headline1");
                // 요약문
                Element previewEl = block.selectFirst(".sds-comps-text-type-body1");
                // 링크 (a 태그 href)
                Element linkEl = block.selectFirst("a");
                // 회사 
                Element companyEl = block.selectFirst(".sds-comps-text-weight-sm");

                if (titleEl != null && previewEl != null && linkEl != null && companyEl != null) {
                    String title = titleEl.text();
                    String preview = previewEl.text();
                    String company = companyEl.text();
                    String link = linkEl.attr("href");

                    sb.append("제목: ").append(title).append("<br>");
                    sb.append("요약: ").append(preview).append("<br>");
                    sb.append("회사이름: ").append(company).append("<br>");
                    sb.append("링크: <a href='").append(link).append("' target='_blank'>기사 보기</a><br><br>");
                }
            }
         

        } catch (Exception e) {
            sb.append("오류 발생: ").append(e.getMessage());
        }

        return sb.toString();
    }

    public static String getNewsResult() {
        return new JsoupCrawler().crawlNaverNews();
    }
}


//news build test 




