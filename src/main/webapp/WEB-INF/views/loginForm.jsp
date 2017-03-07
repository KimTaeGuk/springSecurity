<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>LoginForm.jsp</h1>
	<form action="<c:url value="j_spring_security_check"/>" method="POST">
		<c:if test="${param.ng != null }">
		<p>
			LoginNG!<br/>
			<c:if test="${SPRING_SECURITY_LAST_EXCEPTION != null }">
				message : <c:out value="${SPRING_SECURITY_LAST_EXCEPTION.message }" />
			</c:if>
		</p>
		</c:if>
		ID : <input type="text" name="j_username" id="j_username"><br />
		PW : <input type="text" name="j_password" id="j_password"><br />
		<input type="submit" value="전송">
	</form>
</body>
</html>