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

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>

	<form role="pageInfoForm" method="post">
		<input type="hidden" id="pageNo" name="pageNo" value=${pageNo}> <input type="hidden" name="contents_num" id="contents_num" value=${num}><input
			type="hidden" id="user_name" name="user_name" value=${user_name}> <input type="hidden" id="searchWord"
			name="searchWord" value=${searchWord}><input type="hidden" id="board_type" name="board_type" value=${board_type}>
	</form>
	<div class="container">
		<div align="center">
			<br> <br> <br> <br>
			<div>
				<h4>삭제 권한이 없습니다.</h4>
			</div>
			<br> <br>
			<div>
				<button class="btn btn-danger" id="btn_back" name="btn_back" style="width: 30%;" onclick="backFromWarning()">
					<span class="glyphicon glyphicon-arrow-left"></span>
				</button>
			</div>
		</div>
	</div>

	<script language="javascript">
		$( document ).ready( init );
		function backFromWarning()
		{
			var obj = $( "form[role = 'pageInfoForm']" );
			var upper;
			var num = $('<input></input>');
			if ("${board_type}" == "voc")
				upper = "Voc";
			else
				upper = "Notice";
			
			num.attr("type", "hidden");
			num.attr("name", "num");
			num.attr("id", "num");
			num.attr("value", "${num}");
			
			obj.append(num);
			
			obj.attr( "action", "/fis/board/${board_type}/show" + upper
					+ "Contents.moJson" );
			obj.submit();
		}
	</script>
</body>
</html>