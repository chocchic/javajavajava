<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>list</title>
	<link href="/resources/css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<br />
	<h1 align="center"> 게시판 </h1>
	<table>
		<tr>
			<td colspan="5" align="left">
				<button onclick="window.location='/board/write'">글작성</button>
			</td>
		</tr>
		<tr>
			<td>No.</td>
			<td>제목</td>
			<td>작성자</td>
			<td>작성일</td>
			<td>수정일</td>
		</tr>
		<%-- board : BoardVO 객체 담기는 변수 
			 items : 컨트롤러로부터 전달받은 List<BoardVO> 리스트 
					리스트의 요소 개수만큼 자동으로 반복하며, 하나씩 꺼내서 board변수에 체워줌 --%>
		<c:forEach var="board" items="${list}">
			<tr>
				<td>${board.bno}</td>
				<td align="left"><a href="/board/content?bno=${board.bno}">${board.title}</a></td>
				<td>${board.writer}</td>
				<td><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd" /> </td>
				<td><fmt:formatDate value="${board.updateDate}" pattern="yyyy-MM-dd" /></td>
			</tr>	
		</c:forEach>
	</table>

	<script>
		// 글작성후 list로 리다이렉트 되었을때 alert 띄워주기 
		let result = "${result}"; 
		checkResult(result); // alert띄울지 함수호출 
		
		// 글작성 처리 post -> 리스트로 이동, alert뜨고 -> content 갔다 "브라우저 뒤로가기" -> alert 뜬다(이상함)
		//			  		<-X-	* 히스토리 삭제 
		history.replaceState({}, null, null); // history 기록 조작 
		
		function checkResult(result) {
			// result값이 없거나 history 기록이 없으면 그냥 함수 종료 
			if(result === "" || history.state){
				return; 
			}
			// result 넘어와서 글 고유번호가 0보다 크면, alert 띄워라 
			if(result == "success"){
				alert("요청처리가 잘 처리되었습니다.");
			}else if(parseInt(result) > 0){
				alert("게시글 " + result + "번이 등록되었습니다.");
			}
		}
		
	</script>

</body>
</html>