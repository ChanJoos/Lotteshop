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


<!-- 공백 -->
<div id="blank" style="height:50.5px; width:100%">
</div>

<div id="blank" style="width:100%; align: center;">
    <center><h4 id="nextWeekInput">${week_date}</h4></center>
</div>

<form role="form" method="post" accept-charset ="utf-8">
	<table class="table table-hover table-bordered" id="carte_input" >
		<tbody>
		
		<tr class="monBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="mon"></td>
				<td width="1%" rowspan=3>월</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFOne" placeholder="1찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFTwo" placeholder="2찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFThree" placeholder="3찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFFour" placeholder="4찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFFive" placeholder="5찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFSix" placeholder="6찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFSeven" placeholder="7찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFEight" placeholder="8찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFNine" placeholder="9찬" >
	     			</div>
				</td>
			</tr>
			<tr class="monLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCOne" placeholder="1찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCTwo" placeholder="2찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCThree" placeholder="3찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCFour" placeholder="4찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCFive" placeholder="5찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCSix" placeholder="6찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCSeven" placeholder="7찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCEight" placeholder="8찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCNine" placeholder="9찬" >
	     			</div>
				</td>
			</tr>
			<tr class="monDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNOne" placeholder="1찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNTwo" placeholder="2찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNFour" placeholder="4찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNFive" placeholder="5찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNSix" placeholder="6찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNSeven" placeholder="7찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNEight" placeholder="8찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNNine" placeholder="9찬" >
	     			</div>
				</td>
			</tr>
			
			<tr class="active tueBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="tue"></td>
				<td width="1%" rowspan=3>화</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFFour" placeholder="4찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			<tr class="active tueLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCSeven" placeholder="7찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			<tr class="active tueDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNOne" placeholder="1찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="wedBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="wed"></td>
				<td width="1%" rowspan=3>수</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFOne" placeholder="1찬" >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFTwo" placeholder="2찬"  ">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFThree" placeholder="3찬"  ">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFFour" placeholder="4찬"  ">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFFive" placeholder="5찬"  ">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFSix" placeholder="6찬"  ">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFSeven" placeholder="7찬"  ">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFEight" placeholder="8찬"  ">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFNine" placeholder="9찬"  ">
	     			</div>
				</td>
			</tr>
			<tr class="wedLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			<tr class="wedDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="active thuBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="thu"></td>
				<td width="1%" rowspan=3>목</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			<tr class="active thuLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			<tr class="active thuDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="friBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="fri"></td>
				<td width="1%" rowspan=3>금</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			<tr class="friLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCNine" placeholder="9찬"  >
	     			</div>
				</td>
			</tr>
			<tr class="friDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNOne" placeholder="1찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNTwo" placeholder="2찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNThree" placeholder="3찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNFour" placeholder="4찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNFive" placeholder="5찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNSix" placeholder="6찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNSeven" placeholder="7찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNEight" placeholder="8찬"  >
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNNine" placeholder="9찬" >
	     			</div>
				</td>
			</tr>
		
		<!-- input에 value 값 존재 (test용) -->
		<!-- 
		<tr class="monBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="mon"></td>
				<td width="1%" rowspan=3>월</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFOne" placeholder="1찬" value="monBFOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFTwo" placeholder="2찬" value="monBFTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFThree" placeholder="3찬" value="monBFThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFFour" placeholder="4찬" value="monBFFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFFive" placeholder="5찬" value="monBFFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFSix" placeholder="6찬" value="monBFSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFSeven" placeholder="7찬" value="monBFSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFEight" placeholder="8찬" value="monBFEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFNine" placeholder="9찬" value="monBFNine">
	     			</div>
				</td>
			</tr>
			<tr class="monLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCOne" placeholder="1찬" value="monLCOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCTwo" placeholder="2찬" value="monLCTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCThree" placeholder="3찬" value="monLCThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCFour" placeholder="4찬" value="monLCFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCFive" placeholder="5찬" value="monLCFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCSix" placeholder="6찬" value="monLCSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCSeven" placeholder="7찬" value="monLCSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCEight" placeholder="8찬" value="monLCEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCNine" placeholder="9찬" value="monLCNine">
	     			</div>
				</td>
			</tr>
			<tr class="monDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNOne" placeholder="1찬" value="monDNOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNTwo" placeholder="2찬" value="monDNTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNThree" placeholder="3찬" value="monDNThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNFour" placeholder="4찬" value="monDNFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNFive" placeholder="5찬" value="monDNFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNSix" placeholder="6찬" value="monDNSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNSeven" placeholder="7찬" value="monDNSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNEight" placeholder="8찬" value="monDNEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNNine" placeholder="9찬" value="monDNNine">
	     			</div>
				</td>
			</tr>
			
			<tr class="active tueBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="tue"></td>
				<td width="1%" rowspan=3>화</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFOne" placeholder="1찬"  value="tueBFOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFTwo" placeholder="2찬"  value="tueBFTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFThree" placeholder="3찬"  value="tueBFThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFFour" placeholder="4찬"  value="tueBFFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFFive" placeholder="5찬"  value="tueBFFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFSix" placeholder="6찬"  value="tueBFSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFSeven" placeholder="7찬"  value="tueBFSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFEight" placeholder="8찬"  value="tueBFEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFNine" placeholder="9찬"  value="tueBFNine">
	     			</div>
				</td>
			</tr>
			<tr class="active tueLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCOne" placeholder="1찬"  value="tueLCOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCTwo" placeholder="2찬"  value="tueLCTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCThree" placeholder="3찬"  value="tueLCThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCFour" placeholder="4찬"  value="tueLCFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCFive" placeholder="5찬"  value="tueLCFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCSix" placeholder="6찬"  value="tueLCSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCSeven" placeholder="7찬"  value="tueLCSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCEight" placeholder="8찬"  value="tueLCEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCNine" placeholder="9찬"  value="tueLCNine">
	     			</div>
				</td>
			</tr>
			<tr class="active tueDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNOne" placeholder="1찬"  value="tueDNOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNTwo" placeholder="2찬"  value="tueDNTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNThree" placeholder="3찬"  value="tueDNThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNFour" placeholder="4찬"  value="tueDNFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNFive" placeholder="5찬"  value="tueDNFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNSix" placeholder="6찬"  value="tueDNSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNSeven" placeholder="7찬"  value="tueDNSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNEight" placeholder="8찬"  value="tueDNEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNNine" placeholder="9찬"  value="tueDNNine">
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="wedBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="wed"></td>
				<td width="1%" rowspan=3>수</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFOne" placeholder="1찬"  value="wedBFOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFTwo" placeholder="2찬"  value="wedBFTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFThree" placeholder="3찬"  value="wedBFThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFFour" placeholder="4찬"  value="wedBFFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFFive" placeholder="5찬"  value="wedBFFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFSix" placeholder="6찬"  value="wedBFSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFSeven" placeholder="7찬"  value="wedBFSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFEight" placeholder="8찬"  value="wedBFEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFNine" placeholder="9찬"  value="wedBFNine">
	     			</div>
				</td>
			</tr>
			<tr class="wedLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCOne" placeholder="1찬"  value="wedLCOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCTwo" placeholder="2찬"  value="wedLCTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCThree" placeholder="3찬"  value="wedLCThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCFour" placeholder="4찬"  value="wedLCFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCFive" placeholder="5찬"  value="wedLCFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCSix" placeholder="6찬"  value="wedLCSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCSeven" placeholder="7찬"  value="wedLCSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCEight" placeholder="8찬"  value="wedLCEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCNine" placeholder="9찬"  value="wedLCNine">
	     			</div>
				</td>
			</tr>
			<tr class="wedDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNOne" placeholder="1찬"  value="wedDNOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNTwo" placeholder="2찬"  value="wedDNTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNThree" placeholder="3찬"  value="wedDNThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNFour" placeholder="4찬"  value="wedDNFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNFive" placeholder="5찬"  value="wedDNFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNSix" placeholder="6찬"  value="wedDNSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNSeven" placeholder="7찬"  value="wedDNSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNEight" placeholder="8찬"  value="wedDNEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNNine" placeholder="9찬"  value="wedDNNine">
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="active thuBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="thu"></td>
				<td width="1%" rowspan=3>목</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFOne" placeholder="1찬"  value="thuBFOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFTwo" placeholder="2찬"  value="thuBFTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFThree" placeholder="3찬"  value="thuBFThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFFour" placeholder="4찬"  value="thuBFFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFFive" placeholder="5찬"  value="thuBFFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFSix" placeholder="6찬"  value="thuBFSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFSeven" placeholder="7찬"  value="thuBFSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFEight" placeholder="8찬"  value="thuBFEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFNine" placeholder="9찬"  value="thuBFNine">
	     			</div>
				</td>
			</tr>
			<tr class="active thuLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCOne" placeholder="1찬"  value="thuLCOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCTwo" placeholder="2찬"  value="thuLCTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCThree" placeholder="3찬"  value="thuLCThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCFour" placeholder="4찬"  value="thuLCFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCFive" placeholder="5찬"  value="thuLCFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCSix" placeholder="6찬"  value="thuLCSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCSeven" placeholder="7찬"  value="thuLCSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCEight" placeholder="8찬"  value="thuLCEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCNine" placeholder="9찬"  value="thuLCNine">
	     			</div>
				</td>
			</tr>
			<tr class="active thuDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNOne" placeholder="1찬"  value="thuDNOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNTwo" placeholder="2찬"  value="thuDNTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNThree" placeholder="3찬"  value="thuDNThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNFour" placeholder="4찬"  value="thuDNFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNFive" placeholder="5찬"  value="thuDNFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNSix" placeholder="6찬"  value="thuDNSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNSeven" placeholder="7찬"  value="thuDNSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNEight" placeholder="8찬"  value="thuDNEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNNine" placeholder="9찬"  value="thuDNNine">
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="friBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="fri"></td>
				<td width="1%" rowspan=3>금</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFOne" placeholder="1찬"  value="friBFOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFTwo" placeholder="2찬"  value="friBFTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFThree" placeholder="3찬"  value="friBFThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFFour" placeholder="4찬"  value="friBFFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFFive" placeholder="5찬"  value="friBFFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFSix" placeholder="6찬"  value="friBFSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFSeven" placeholder="7찬"  value="friBFSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFEight" placeholder="8찬"  value="friBFEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFNine" placeholder="9찬"  value="friBFNine">
	     			</div>
				</td>
			</tr>
			<tr class="friLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCOne" placeholder="1찬"  value="friLCOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCTwo" placeholder="2찬"  value="friLCTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCThree" placeholder="3찬"  value="friLCThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCFour" placeholder="4찬"  value="friLCFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCFive" placeholder="5찬"  value="friLCFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCSix" placeholder="6찬"  value="friLCSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCSeven" placeholder="7찬"  value="friLCSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCEight" placeholder="8찬"  value="friLCEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCNine" placeholder="9찬"  value="friLCNine">
	     			</div>
				</td>
			</tr>
			<tr class="friDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNOne" placeholder="1찬"  value="friDNOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNTwo" placeholder="2찬"  value="friDNTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNThree" placeholder="3찬"  value="friDNThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNFour" placeholder="4찬"  value="friDNFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNFive" placeholder="5찬"  value="friDNFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNSix" placeholder="6찬"  value="friDNSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNSeven" placeholder="7찬"  value="friDNSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNEight" placeholder="8찬"  value="friDNEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNNine" placeholder="9찬"  value="friDNNine">
	     			</div>
				</td>
			</tr>
		 -->
			
			
		<!-- 
			<tr class="monBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="mon"></td>
				<td width="1%" rowspan=3>월</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFOne" placeholder="1찬" value="monBFOne">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFTwo" placeholder="2찬" value="monBFTwo">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFThree" placeholder="3찬" value="monBFThree">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFFour" placeholder="4찬" value="monBFFour">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFFive" placeholder="5찬" value="monBFFive">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFSix" placeholder="6찬" value="monBFSix">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFSeven" placeholder="7찬" value="monBFSeven">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFEight" placeholder="8찬" value="monBFEight">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monBFNine" placeholder="9찬" value="monBFNine">
	     			</div>
				</td>
			</tr>
			<tr class="monLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCOne" placeholder="1찬" value="">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monLCNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="monDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="monDNNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			-->
			
			<!-- 
			<tr class="active tueBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="tue"></td>
				<td width="1%" rowspan=3>화</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueBFNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="active tueLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueLCNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="active tueDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="tueDNNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="wedBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="wed"></td>
				<td width="1%" rowspan=3>수</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedBFNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="wedLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedLCNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="wedDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="wedDNNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="active thuBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="thu"></td>
				<td width="1%" rowspan=3>목</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuBFNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="active thuLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuLCNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="active thuDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="thuDNNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			
			
			
			<tr class="friBF">
				<td width="1%" rowspan=3><input type="checkbox" id="btn_check" class="check_lc" value="fri"></td>
				<td width="1%" rowspan=3>금</td>
				<td width="15%">아침</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friBFNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="friLC">
				<td>점심</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friLCNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			<tr class="friDN">
				<td>저녁</td>
				<td width="83%">
					<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNOne" placeholder="1찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNTwo" placeholder="2찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNThree" placeholder="3찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNFour" placeholder="4찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNFive" placeholder="5찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNSix" placeholder="6찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNSeven" placeholder="7찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNEight" placeholder="8찬">
	     			</div>
	     			<div class="col-lg-input-carte">
						<input type="text" class="form-control" name="friDNNine" placeholder="9찬">
	     			</div>
				</td>
			</tr>
			-->
		</tbody>
	</table> 
	<div class="form-group" id="formDiv" align="center">
		<button type="reset" class="btn btn-default" id="inputCancle">Cancel</button>
		<button type="submit" class="btn btn-primary" id="insertCarte">Submit</button>
	</div>
	<input type="hidden" name="tableRowLen" id="tableRowLen">
	<input type="hidden" name="monLC2" id="monLC2" value="0">
	<input type="hidden" name="tueLC2" id="tueLC2" value="0">
	<input type="hidden" name="wedLC2" id="wedLC2" value="0">
	<input type="hidden" name="thuLC2" id="thuLC2" value="0">
	<input type="hidden" name="friLC2" id="friLC2" value="0">
</form>

<%@include  file="../main/backward_main.jsp" %>

<%@include  file="fn_input_carte.jsp" %>