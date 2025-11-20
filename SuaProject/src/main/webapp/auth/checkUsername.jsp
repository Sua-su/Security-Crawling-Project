<%@ page import="com.dao.UserDAO" %> <%@ page contentType="application/json;
charset=UTF-8" pageEncoding="UTF-8"%> <% String username =
request.getParameter("username"); UserDAO userDAO = new UserDAO(); boolean
exists = userDAO.isUsernameExists(username); out.print("{\"available\": " +
!exists + "}"); %>
