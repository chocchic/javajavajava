<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>Test02 Page</h2>
	<%-- # 1. 변수 생성 : set 
				var : 변수명. 표현식, EL, 정적테스트 사용해 값 지정 가능
				property : 프로퍼티 이름 지정. 자바 빈의 경우 변수명(-> set 메서드 호출)
				target : 값 설정할 대상 객체. EL을 사용하여 지정--%>
	<c:set var="name">피카츄</c:set>
	<c:set var="id" value="java"/>
	<h4>name : ${name}</h4>
	<h4>id : ${id}</h4>
	
	<h3>dto 설정 전</h3>
	<h4> dto.id : ${dto.id }</h4>
	<h4> dto.pw : ${dto.pw }</h4>
	
	<h3>dto 설정 후</h3>
	<c:set target="${dto}" property="id" value="test"/>
	<c:set target="${dto}" property="pw" value="1234"/>
	
	<h4> dto.id : ${dto.id }</h4>
	<h4> dto.pw : ${dto.pw }</h4>
	
	<%-- #2. 변수 삭제 : remove --%>
	<c:remove var="name"/>
	<c:remove var="id"/>
	<h4>name : ${name}</h4>
	<h4>id : ${id}</h4>

	<%-- # 3. c:if  : 조건문. 자바에서 if문만 쓰는 형태
			<c:if test="${조건식}">
				//조건식이 참일 경우에 실행될 코드들 ...  (화면에 보여줄 태그들 작성... )
			</c:if>
	--%>
	<c:set var="num" value="100"/>
	<c:if test="${num>100}">
		<h4> num:${num}은 100보다 크다</h4>
	</c:if>
	<c:if test="${num==100}">
		<h4> num:${num}은 100과 같다</h4>
	</c:if>
	<c:if test="${num<100}">
		<h4> num:${num}은 100보다 작다</h4>
	</c:if>
	
	<%-- #4. c:choose,c:when, c:otherwise --%>
	<c:choose>
		<c:when test="${num >100}">
			<h4> num:${num}은 100보다 크다</h4>
		</c:when>
		<c:when test="${num == 100}">
			<h4> num:${num}은 100과 같다</h4>
		</c:when>
		<c:otherwise>
			<h4> num:${num}은 100보다 작다</h4>
		</c:otherwise>
	</c:choose>
	
	<%-- #5. c:forEach
		for(int i: arr) {} --%>
	<c:forEach var="i" items="${arr}" varStatus="status">
		<h4>${i},index:${status.index},count:${status.count}</h4>
	</c:forEach>
	
	<c:forEach var="a" begin="1" end="10" step="1">
		${a} 
	</c:forEach>
	<br/>
	<%-- 구구단 2~9까지 출력 : 2* 1 =2--%>
	<c:forEach var="f" begin ="2" end="9" step="1">
		<h5>${f}단</h5>
		<c:forEach var="b" begin = "1" end ="9" step="1">
			${f} * ${b} = ${f*b}
		</c:forEach>
		<br/>
	</c:forEach>
	
	<%-- #6. c:forTokens : 반복문, 구분자를 이용하여 토큰 방식으로 잘라서 반복구현 --%>
	<c:forTokens var="a" items="a,b,c,d,e" delims=",">
		${a}
	</c:forTokens>
	<br/>
	
	<%-- # 7. c:import:include와 비슷 --%>
	<%--<c:import url="/day04/test01"/>  --%>
	
	<%-- # 8. c:redirect : 단순 이동(새로 요청)
			해당 url의 요청이 controller로 다시 들어감 (GET) --%>
	<%-- <c:redirect url="/day04/test01"/> --%>
	
	<%--# 9. c:url : url 주소 만들 때
			/day04/test01?id=java&pw=1234 --%>
	<%--<c:url var="u" value="/day04/test01">
		<c:param name="id" value="java"/>
		<c:param name="pw" value="1234"/>
	</c:url>
	<c:redirect url="${u}"/>--%>
	
	<c:set var="num2" value="50"/>
	<%-- #10. c:out : 출력태그 --%>
	num2 el : ${num2}
	num2 c out : <c:out value="${num2}"/>
	
	<input type="text" name = "test" value="${num2}"/>
	<input type="text" name = "test" value="<c:out value='${num2}'/>"/>
</body>
</html>