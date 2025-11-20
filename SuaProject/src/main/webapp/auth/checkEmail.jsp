<%@ page import="com.dao.UserDAO" %> <%@ page contentType="application/json;
charset=UTF-8" pageEncoding="UTF-8"%> 
<% String email = request.getParameter("email"); UserDAO userDAO = new UserDAO();
boolean exists = userDAO.isEmailExists(email); out.print("{\"available\": " + !exists + "}"); %>
