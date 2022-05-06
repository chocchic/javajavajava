<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>modifyPro</title>
	<link href="/resources/css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<br />
	<c:if test="${result == 1}">
		<table>
			<tr>
				<td>
					<sec:authentication property="principal.username" /> 님의 회원 정보가 수정되었습니다. 
				</td>
			</tr>
			<tr>
				<td>
					<button onclick="window.location='/common/main'">메인</button>
					<button onclick="window.location='/member/mypage'">마이페이지</button>
				</td>
			</tr>
		</table>
	</c:if>
	<c:if test="${result != 1}">
		<script>
			alert("수정 실패... 다시 시도해주세요...");
			history.go(-1);
		</script>
	</c:if>
	

</body>
</html>