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
<title>공지사항</title>

</head>

<body>

	<%@include file="../board/vocScripts.jsp"%>
	<script src="http://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
	<script src="<%=cp%>/fis/resources/bootstrap/js/bootstrap.min.js"></script>

	<%@include file="./vocList.jsp"%>

</body>
</html>
<%@include file="../main/backward_main.jsp"%>

