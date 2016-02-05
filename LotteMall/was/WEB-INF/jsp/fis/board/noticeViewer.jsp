<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<script src="/fis/common/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/fis/common/js/jquery/jquery.blockUI.js"></script>
<script src="/fis/common/js/common/common.js"></script>
<script src="/fis/common/js/common/datetime.js"></script>
<script src="/fis/common/js/common/ajax_common.js"></script>
<script src="/fis/common/js/common/json2.js"></script>

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

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="<%=cp%>/fis/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<title>공지 사항 테스트</title>
</head>

<body>
	<script src="http://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
	<script src="<%=cp%>/fis/resources/bootstrap/js/bootstrap.min.js"></script>
	<div class="container">
		<form role="contentsForm" method="post">
			<input type="hidden" name="num" id="num" value=${num}> <input type="hidden" name="pageNo" id="pageNo" value=${pageNo}>
			<input type="hidden" name="user_name" id="user_name" value=${user_name}><input type="hidden" id="searchWord"
				name="searchWord" value=${searchWord}>
			<div>
				<h1>${title}</h1>
				<div>
					<div align="right">
						<h5>
							<span class="glyphicon glyphicon-user" aria-hidden="true" /> : ${creator}
						</h5>
					</div>
				</div>
				<div align="right">
					<h5>
						<span class="glyphicon glyphicon-calendar" aria-hidden="true" /> : ${date}
					</h5>
				</div>
			</div>
			<br>
			<div style="background: black">
				<span class="hr"></span>
			</div>
			<br>
			<div>
				<%
					String str = request.getAttribute("contents").toString();
					String test = "test";
					str = str.replaceAll("\n", "<br>");
				%><%=str%>
				<br>
			</div>
		</form>
		<br> <br> <br>
		<div align="center">
			<button class="btn btn-danger" id="btn_edit" name="btn_edit" style="width: 30%;">
				<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
			</button>
			<button class="btn btn-danger" id="btn_delete" name="btn_delete" style="width: 30%;">
				<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
			</button>
			<button class="btn btn-danger" id="btn_back" name="btn_back" style="width: 30%;">
				<span class="glyphicon glyphicon-arrow-left" aria-hidden="true"></span>
			</button>
		</div>
	</div>
	<br>

	<%@include file="./noticeComment.jsp"%>

</body>
</html>

<%@include file="./noticeList.jsp"%>
<%@include file="../board/noticeScripts.jsp"%>