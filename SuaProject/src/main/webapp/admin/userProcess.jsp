<%@ page import="com.dao.UserDAO" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    // 관리자 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    
    Integer adminUserId = (Integer) session.getAttribute("userId");
    UserDAO userDAO = new UserDAO();
    User admin = userDAO.getUserById(adminUserId);
    
    if (!admin.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    String action = request.getParameter("action");
    int targetUserId = Integer.parseInt(request.getParameter("userId"));
    
    // 본인 계정은 수정 불가
    if (targetUserId == adminUserId) {
        response.sendRedirect("users.jsp?message=" + 
            java.net.URLEncoder.encode("본인 계정은 수정할 수 없습니다.", "UTF-8"));
        return;
    }
    
    try {
        User targetUser = userDAO.getUserById(targetUserId);
        
        if ("activate".equals(action)) {
            // 활성화
            boolean result = userDAO.updateUserStatus(targetUserId, true);
            
            if (result) {
                response.sendRedirect("users.jsp?message=" + 
                    java.net.URLEncoder.encode(targetUser.getName() + " 회원이 활성화되었습니다.", "UTF-8"));
            } else {
                response.sendRedirect("users.jsp?message=" + 
                    java.net.URLEncoder.encode("활성화 실패", "UTF-8"));
            }
            
        } else if ("deactivate".equals(action)) {
            // 비활성화
            boolean result = userDAO.updateUserStatus(targetUserId, false);
            
            if (result) {
                response.sendRedirect("users.jsp?message=" + 
                    java.net.URLEncoder.encode(targetUser.getName() + " 회원이 비활성화되었습니다.", "UTF-8"));
            } else {
                response.sendRedirect("users.jsp?message=" + 
                    java.net.URLEncoder.encode("비활성화 실패", "UTF-8"));
            }
            
        } else if ("makeAdmin".equals(action)) {
            // 관리자로 승격
            boolean result = userDAO.updateUserRole(targetUserId, true);
            
            if (result) {
                response.sendRedirect("users.jsp?message=" + 
                    java.net.URLEncoder.encode(targetUser.getName() + " 회원이 관리자로 승격되었습니다.", "UTF-8"));
            } else {
                response.sendRedirect("users.jsp?message=" + 
                    java.net.URLEncoder.encode("관리자 승격 실패", "UTF-8"));
            }
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("users.jsp?message=" + 
            java.net.URLEncoder.encode("오류가 발생했습니다: " + e.getMessage(), "UTF-8"));
    }
%>