<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<%
response.setHeader("Cache-Control","no-cache");
response.setHeader("Pragma","no-cache"); 
response.setDateHeader("Expires",0);
%>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache"/> 
<meta http-equiv="Expires" content="0"/> 
<meta http-equiv="Pragma" content="no-cache"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maxium-scale=1.0, minimum-scale=1.0, user-scalable=no">
<meta name = "format-detection" content = "telephone=no" />

<!-- <link rel="stylesheet" type="text/css" href="/phone/common/css/eis/jquery.mobile-1.4.4.css"> -->
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.4/jquery.mobile-1.4.4.min.css" />
<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="http://code.jquery.com/mobile/1.4.4/jquery.mobile-1.4.4.min.js"></script>

<!-- datepicker -->
<link rel="stylesheet" type="text/css" href="/phone/common/css/eis/jquery.mobile.datepicker.css">
<script src="/phone/common/js/jquery/jquery.ui.datepicker.js"></script>
<script src="/phone/common/js/jquery/jquery.mobile.datepicker.js"></script>
<!-- datepicker -->

<script src="/phone/common/js/common/ajax_common.js"></script>
<script src="/phone/common/js/common/json2.js"></script>

<script>
var ctx = "${ctx}";
var AJAX_PREFIX_URL = "";
</script>