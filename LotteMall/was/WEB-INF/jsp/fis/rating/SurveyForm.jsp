<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>

<meta http-equiv="X-UA-Compatible" content="IE=edge">

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
	<div id="today2"> 월 일</div>
	
	<form role="surveyRating" method="post" accept-charset="utf-8">
		<table id="table_menu" class="table table-hover table-bordered" >
			<tbody>
				<tr id="ti_row">
					<th width="15%" class = "col1">종류</th>
					<th width="50%" class = "col2">식단</th>
					<th width="35%" class = "col3">평가</th>
				</tr>
				
			    <tr id="tbl_bf">
					<td class="col1">아침</td>
					<td id="bf_menu" class="col2"></td>
					<td class="col3">
						<select id="bf_select" name="respenses0"> 
							<option id = "bf_blk" selected="selected" value= "0"></option> 
							<option id = "bf_5" value= "5">5점 ★★★★★</option> 
							<option id = "bf_4" value= "4">4점 ★★★★</option>
							<option id = "bf_3" value= "3">3점 ★★★</option> 
							<option id = "bf_2" value= "2">2점 ★★</option> 
							<option id = "bf_1" value= "1">1점 ★</option> 
						</select>
					</td>
			    </tr>
			    
			    <tr id="tbl_lc">
			    	<td  class="col1">점심</td>
			      	<td id="lc_menu" class="col2"></td>
			    	<td class="col3">
				      	<select id="lc_select" name="respenses1"> 
					      	<option id = "lc_blk" selected="selected" value= "0"></option> 
					      	<option id = "lc_5" value= "5">5점 ★★★★★</option> 
					      	<option id = "lc_4" value= "4">4점 ★★★★</option>
					      	<option id = "lc_3" value= "3">3점 ★★★</option> 
					      	<option id = "lc_2" value= "2">2점 ★★</option> 
					      	<option id = "lc_1" value= "1">1점 ★</option> 
				      	</select>
			    	</td>
			    </tr>
	
				<tr id="tbl_lc2" class="hidden">
			    	<td  class="col1">점심(2)</td>
			    	<td id="l2_menu" class="col2"></td>
			    	<td class="col3">
				      	<select id="l2_select" name="respenses2"> 
					      	<option id = "l2_blk" selected="selected" value= "0"></option> 
					      	<option id = "l2_5" value= "5">5점 ★★★★★</option> 
					      	<option id = "l2_4" value= "4">4점 ★★★★</option>
					      	<option id = "l2_3" value= "3">3점 ★★★</option> 
					      	<option id = "l2_2" value= "2">2점 ★★</option> 
					      	<option id = "l2_1" value= "1">1점 ★</option> 
				      	</select>
			    	</td>
			    </tr>
			    		    
			    <tr id="tbl_dn">
			    	<td class="col1">저녁</td>
			    	<td id="dn_menu" class="col2"></td>
			    	<td class="col3">
						<select id="dn_select" name="respenses3"> 
					      	<option id = "dn_blk" selected="selected" value= "0"></option> 
					      	<option id = "dn_5" value= "5">5점 ★★★★★</option> 
					      	<option id = "dn_4" value= "4">4점 ★★★★</option>
					      	<option id = "dn_3" value= "3">3점 ★★★</option> 
					      	<option id = "dn_2" value= "2">2점 ★★</option> 
					      	<option id = "dn_1" value= "1">1점 ★</option> 
				      	</select>
			      </td>
			    </tr>
			</tbody>
		</table> 
		<button type="submit" id="bt_save" class="bt"> 저 장</button>
	</form>
 

<%@include  file="../main/backward_main.jsp" %>
<%@include  file="fn_SurveyForm.jsp" %>