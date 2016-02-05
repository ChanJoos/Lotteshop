<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<%
	String cp = request.getContextPath();
%>


<%@include file="../main/forward_main.jsp"%>

<!-- 공백 -->
<div id="blank" style="height: 50.5px; width: 100%"></div>

<div id="blank" style="width: 100%; align: center;">
	<center>
		<h4 id="nextWeek">${week_date}</h4>
	</center>
</div>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="<%=cp%>/fis/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<title>공지 입력 테스트</title>
</head>

<body>
	<script src="http://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
	<script src="<%=cp%>/fis/resources/bootstrap/js/bootstrap.min.js"></script>
	<div class="container">
		<form role="contentsForm" method="post">
			<input type="hidden" id="user_name" name="user_name" value=${user_name}> <label for="title">제목 : </label> <input
				type="text" id="title" name="title" style="width: 100%;" > <br> <label for="contents">내용 : </label>
			<textarea id="contents" name="contents" style="height: 400px; width: 100%"></textarea>
			<br>
		</form>
		<div style align="center">
			<button class="btn btn-danger" id="btn_write" name="btn_wirte" style="width: 30%">완료</button>
			<button class="btn btn-danger" id="btn_back" name="btn_back" style="width: 30%">뒤로</button>
		</div>
	</div>
</body>
</html>

<%@include file="../board/noticeScripts.jsp"%>