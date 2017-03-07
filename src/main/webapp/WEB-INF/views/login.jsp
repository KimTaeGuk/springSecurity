<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>login.jsp</h1>

<!-- 빈 상태입니다. -->
<c:if test="${not empty pageContext.request.userPrincipal }" >
	<p>[Original]is Log-in</p>
</c:if>
<!-- 값이 들어있는 상태입니다. -->
<c:if test="${empty pageContext.request.userPrincipal }" >
	<p>[Original]is Log-out</p>
</c:if>

<!-- 빈 상태입니다. -->
<s:authorize ifAllGranted="ROLE_USER">
<p>[taglibs]is log-in</p>
</s:authorize>
<!-- 값이 들어있는 상태입니다. -->
<s:authorize ifNotGranted="ROLE_USER">
<p>[taglibs]is log-out</p>
</s:authorize>

USER ID[Original] : ${pageContext.request.userPrincipal.name }<br />
USER ID[taglibs] : <s:authentication property="name"/><br/>


<!-- default 인 로그인 상태가 되면서 index 페이지로 이동합니다. -->
<a href="${pageContext.request.contextPath }/j_spring_security_logout">Log Out</a><br />
</body>
</html>