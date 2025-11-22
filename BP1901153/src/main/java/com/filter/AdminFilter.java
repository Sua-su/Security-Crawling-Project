package com.filter;

import com.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 어드민 페이지 접근 권한 체크 필터
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        // 로그인 체크
        if (user == null) {
            httpResponse
                    .sendRedirect(httpRequest.getContextPath() + "/auth/login?redirect=" + httpRequest.getRequestURI());
            return;
        }

        // 어드민 권한 체크
        if (!user.isAdmin()) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index?error=access_denied");
            return;
        }

        // 권한이 있으면 다음 필터 또는 서블릿으로 진행
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 필터 종료
    }
}
