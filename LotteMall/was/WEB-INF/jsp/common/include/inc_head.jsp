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
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, target-densitydpi=device-dpi">
<meta name = "format-detection" content = "telephone=no" />
   
<script src="/phone/common/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/phone/common/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<script src="/phone/common/js/jquery/jquery.blockUI.js"></script>
<!-- 캐쉬지우는 방법
 <script src="/phone/common/js/ibsheet/ibsheet_ext.js?a=<%= Calendar.getInstance().getTimeInMillis() %>"></script>
 -->

<!-- 
<script src="/phone/common/js/ibsheet/ibsheetinfo.js"></script>
<script src="/phone/common/js/ibsheet/ibsheet.js"></script>
<script src="/phone/common/js/ibsheet/ibsheet_ext.js?a=<%= Calendar.getInstance().getTimeInMillis() %>"></script>
 -->
 
<script src="/phone/common/js/ibchart/ibchart.js"></script>
<script src="/phone/common/js/ibchart/ibchartinfo.js"></script>
<script src="/phone/common/js/ibchart/ltScript.js?a=<%= Calendar.getInstance().getTimeInMillis() %>"></script>
<script src="/phone/common/js/ibchart/ibchart_ext.js?a=<%= Calendar.getInstance().getTimeInMillis() %>"></script>

<script src="/phone/common/js/common/common.js"></script>
<script src="/phone/common/js/common/datetime.js"></script>
<script src="/phone/common/js/common/ajax_common.js"></script>
<script src="/phone/common/js/common/json2.js"></script>
<script src="/phone/common/js/common/UI-0.1.min.js?a=<%= Calendar.getInstance().getTimeInMillis() %>"></script>

<link rel="stylesheet" type="text/css" href="/phone/common/css/eis/common.css" />
<link rel="stylesheet" type="text/css" href="/phone/common/css/eis/device.css">

<!-- 
 <link rel="stylesheet" type="text/css" href="/phone/common/css/eis/contenscss.css" />
   -->
<script>
var ctx = "${ctx}";
var AJAX_PREFIX_URL = "";
</script>