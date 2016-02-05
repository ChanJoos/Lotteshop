<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>

<meta http-equiv="X-UA-Compatible" content="IE=edge">

<script src="/fis/common/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/fis/common/js/jquery/jquery.blockUI.js"></script>
<script src="/fis/common/js/common/common.js"></script>
<script src="/fis/common/js/common/datetime.js"></script>
<script src="/fis/common/js/common/ajax_common.js"></script>
<script src="/fis/common/js/common/json2.js"></script>

<link rel="stylesheet" href="/fis/common/js/jquery/rateyo/jquery.rateyo.css"/>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<% String cp = request.getContextPath(); %>

<%@include  file="../main/forward_main.jsp" %>

    
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Bootstrap Core CSS -->
    <link rel="stylesheet" href="../../resources/css/bootstrap.min.css" type="text/css">

    <!-- Custom Fonts -->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="../../resources/font-awesome/css/font-awesome.min.css" type="text/css">
    
    <!-- Custom Style -->
	<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
	<link rel="stylesheet" href="../../resources/css/Rating.css" media="screen">
	<link rel="stylesheet" href="../../resources/bootstrap/css/bootstrap.css" media="screen">

	<div id="blank" style="height:50.5px; width:100%"></div>

	<%@include  file="../main/backward_main.jsp" %>
	<div id="thisweek">주별 조회</div>
	
	<button id="btToDaily"  class="bt" onclick="window.location.replace('/fis/rating/survey/viewRating.moJson')"> 일별 조회</button>
	
	<ul id = "moveBt" class="pager">
		<li class="previous" id="previousWeek"><a href="#">&larr;</a></li>
		<li id = 'textWeek'></li>
		<li class="next" id="nextWeek"><a href="#">&rarr;</a></li>
	</ul>

	<table id="table_rating" class="table table-hover table-bordered" >
		<tr id="ti_row">
			<th class = "col1"></th>
			<th class = "col2">아 침</th>
			<th class = "col3">점 심</th>
			<th id="tbl_L2" class = "hidden" >점 심(2)</th>
			<th class = "col5">저 녁</th>
		</tr>
		
	    <tr id="tbl_mon">
	    	<td class="col1">월</td>
	    	<td id="monBf" class="col2"></td>
	    	<td id="monLc" class="col3"></td>
	    	<td id="monL2"  class = "hidden" ></td>
	    	<td id="monDn" class="col5"></td>
	    </tr>
	    
	    <tr id="tbl_tue">
	    	<td class="col1">화</td>
	    	<td id="tueBf" class="col2"></td>
	    	<td id="tueLc" class="col3"></td>
	    	<td id="tueL2"  class = "hidden" ></td>
	    	<td id="tueDn" class="col5"></td>
	    </tr>
	    
	    <tr id="tbl_wed">
	    	<td class="col1">수</td>
	    	<td id="wedBf" class="col2"></td>
	    	<td id="wedLc" class="col3"></td>
	        <td id="wedL2"  class = "hidden" ></td>
	        <td id="wedDn" class="col5"></td>
	    </tr>
	    
	    <tr id="tbl_thu">
	        <td class="col1">목</td>
	        <td id="thuBf" class="col2"></td>
	        <td id="thuLc" class="col3"></td>
	        <td id="thuL2"  class = "hidden" ></td>
	        <td id="thuDn" class="col5"></td>
	    </tr>
	    
	    <tr id="tbl_fri">
	        <td class="col1">금</td>
	        <td id="friBf" class="col2"></td>
	        <td id="friLc" class="col3"></td>
	        <td id="friL2"  class = "hidden" ></td>
	        <td id="friDn" class="col5"></td>
	    </tr>
	</table> 
	<div id="selected_menu">메 뉴</div>
	<table id="selectedMenu" class="table table-hover table-bordered" >
		<tr>
			<td id="menu1" class = "col1"></td>
			<td id="menu2" class = "col2"></td>
			<td id="menu3" class = "col3"></td>
		</tr>
	</table> 
	<%@include  file="fn_WeekRating.jsp" %>
	
</body>
</html>
