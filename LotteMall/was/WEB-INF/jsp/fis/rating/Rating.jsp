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
	
	
<div id="today">월 일</div>
	
<button id="btToSurvey"  class="bt" onclick="fn_toSurvey();"> 평점 입력</button>
<button id="btToViewWeek"  class="bt" onclick="window.location.replace('/fis/rating/survey/viewWeek.moJson')"> 주별 조회</button>

<table id="table_rating" class="table table-hover table-bordered" >
	<tbody>
		<tr id="ti_row">
			<th width="15%" class = "col1">종류</th>
			<th width="50%" class = "col2">식단</th>
			<th width="35%" class = "col3">평가</th>
		</tr>
		
	    <tr id="tbl_bf">
	      <td class="col1">아침</div>
	      <td id="bf_menu" class="col2">

		  </td>
	      <td id="bf_col" class="col3">
	      </td>
	    </tr>
	    
	    <tr id="tbl_lc">
	      <td  class="col1">점심</td>
	      
	      <td id="lc_menu" class="col2">

	      </td>
	      <td id="lc_col" class="col3">
	      </td>
	    </tr>
	    
	    <tr id="tbl_l2" class = "hidden">
	      <td id="l2_type" class="col1">점심(2)</td>
	      <td id="l2_menu" class="col2">
	      </td>
	      <td id="l2_col" class="col3">
	      </td>
	    </tr>
	    
	    <tr id="tbl_dn">
	      <td class="col1">저녁</td>
	      <td id="dn_menu" class="col2">

		  </td>
	      <td id="dn_col" class="col3">
	      </td>
	    </tr>
	</tbody>
</table> 

<div id="thisMonth">이달의 베스트</div>

<table id="table_best_rating" class="table table-hover table-bordered" >
	<tbody>
		<tr id="ti_row">
			<th width="15%" class = "col1">종류</th>
			<th width="50%" class = "col2">식단</th>
			<th width="35%" class = "col3">평가</th>
		</tr>
		
	    <tr>
	      <td id="best_type"></td>
	      <td id="best_menu" class="col2"></td>
	      <td id="best_rating" class="col3"></td>
	    </tr>
	 </tbody>
</table> 

	<%@include  file="fn_Rating.jsp" %>
</body>
</html>
