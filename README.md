#### 보안이란?
- **크리덴셜 기반 인증** : 우리가 웹에서 사용하는 대부분의 인증방식입니다. 즉 권한을 부여받는데 1차례의 인증과정이 필요하며 대개 사용자명과 비밀번호를 입력받아 입력한 비밀번호가 저장된 비밀번호화 일치하는지 확인합니다. (일반적으로 스프링 시큐리티에서는 **아이디를 프린시플(principle)**, **비밀번호를 크리덴셜(credential)**이라고 부르기도 합니다.)

- **이중 인증** : 한 번에 2가지 방식으로 인증을 받는 것을 말합니다. 예를 들어 금융, 은행 웹 어플리케이션을 이용해 온라인 거래를 하실 때에는 로그인과 보안 인증서, 2가지 방법으로 인증을 받곤 합니다. 별 것 아닌 것 같지만 Authentication이 하나 추가됨으로서 프로그래밍 적으로 변화해야할 부분은 상당히 광범위해집니다.

- **물리 인증** : 이 부분은 웹을영역을 벗어난 것이지만 가장 효과적인 보안 수단 중에 하나입니다. 예를 들어 컴퓨터를 킬 때 지문을 인식받는다거나 키를 삽입해야하는 것들 말입니다.

#### web-xml

웹이 처음 시작하였을 떄 받아오는 값을 뜻합니다.

	    <context-param>
		<param-name>contextConfigLocation</param-name>
		<param-value>
			/WEB-INF/spring/root-context.xml
			/WEB-INF/spring/security-context.xml	
		</param-value>
	</context-param>
	<!-- filter 이름은 반드시 springSecurityFilterChain 이여야 합니다. -->
    <filter>
	  	<filter-name>springSecurityFilterChain</filter-name>
	  	<filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
	</filter>
	<filter-mapping>
	  	<filter-name>springSecurityFilterChain</filter-name>
	  	<url-pattern>/*</url-pattern>
	</filter-mapping>

#### security-context.xml

xml의 스키마를 버전에 맞게 작성하지 않을 시 404에러가 표출 됩니다.

    <?xml version="1.0" encoding="UTF-8"?>
    <beans:beans xmlns="http://www.springframework.org/schema/security"
      xmlns:beans="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
           http://www.springframework.org/schema/security
           http://www.springframework.org/schema/security/spring-security-3.2.xsd">
           
           <http auto-config="true">
           		<form-login login-page="/loginForm"
           			authentication-failure-url="/loginForm?ng"/>
	           	<intercept-url pattern="/login" access="ROLE_USER"/>
	           	<intercept-url pattern="/welcome" access="ROLE_ADMIN"/>
           </http>

			<authentication-manager>
				<authentication-provider>
					<user-service>
						<user name="guest" password="guest" authorities="ROLE_USER"/>
						<user name="admin" password="admin" authorities="ROLE_ADMIN"/>
					</user-service>
				</authentication-provider>
			</authentication-manager>

    </beans:beans>

#### loginForm.jsp

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

#### login.jsp
	
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

#### pom.xml

		<!-- 상단 작성(스프링 프레임워크 설정) -->
		<properties>
			<java-version>1.6</java-version>
			<org.springframework-version>4.0.2.RELEASE</org.springframework-version>
			<org.aspectj-version>1.6.10</org.aspectj-version>
			<org.slf4j-version>1.6.6</org.slf4j-version>
		</properties>	
			<!-- security -->
			<dependency>
	  			<groupId>org.springframework.security</groupId>
	    		<artifactId>spring-security-taglibs</artifactId>
	    		<version>3.2.3.RELEASE</version>
			</dependency>
			<dependency>
				<groupId>org.springframework.security</groupId>
				<artifactId>spring-security-core</artifactId>
				<version>3.2.3.RELEASE</version>
			</dependency>
			<dependency>
				<groupId>org.springframework.security</groupId>
				<artifactId>spring-security-web</artifactId>
				<version>3.2.3.RELEASE</version>
			</dependency>
			<dependency>
				<groupId>org.springframework.security</groupId>
				<artifactId>spring-security-config</artifactId>
				<version>3.2.3.RELEASE</version>
			</dependency>

#### HomeController.java

		@RequestMapping("/login")
		public String login(){
			System.out.println("login()");
			return "login";
		}
		
		@RequestMapping("/welcome")
		public String welcome(){
			System.out.println("welcome()");
			return "welcome";
		}
		
		@RequestMapping("loginForm")
		public String loginForm(){
			System.out.println("loginForm()");
			return "loginForm";
		}
