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

<div id="divLookupMonth" >
   	<span id="yearSpan"></span>년 
   	<span id="monthSpan"></span>월
</div>

<ul class="pager">
	<li class="previous" id="previousWeek"><a href="#">&larr;</a></li>
	<li id="mon">
		<a href="#" id='monAnchor'>
			<span id="monSpan"></span>
		</a>
	</li>
	<li id="tue">
		<a href="#" id='tueAnchor'>
			<span id="tueSpan"></span>
		</a>
	</li>
	<li id="wed">
		<a href="#" id='wedAnchor'>
			<span id="wedSpan"></span>
		</a>
	</li>
	<li id="thu">
		<a href="#" id='thuAnchor'>
			<span id="thuSpan"></span>
		</a>
	</li>
	<li id="fri">
		<a href="#" id='friAnchor'>
			<span id="friSpan"></span>
		</a>
	</li>
	<li class="next" id="nextWeek"><a href="#">&rarr;</a></li>
</ul>

<section id="carteSection">
	<table class="table table-hover" >
		<tbody>
			<tr class='BF'>
				<td width="15%" >아침</td>
				<td width="50%" id='BF'>
					<span id='spanBF' class='carte'>
					</span>
				</td>
				<td id="bf_rt" width="15%"></td>
				<td width="20%"></td>
		    </tr>
			<tr class='LC'>
				<td>점심</td>
				<td id='LC'>
					<span id='spanLC' class='carte'>
					</span>
				</td>
				<td id="lc_rt"></td>
				<td></td>
		    </tr>
	    	<tr class='DN'>
				<td>저녁</td>
				<td id='DN'>
					<span id='spanDN' class='carte'>
					</span>
				</td>
				<td id="dn_rt"></td>
				<td>
					<form role="form" method="post" accept-charset ="utf-8">
						<input type="hidden" name="date" value="0">
						<input type="hidden" name="carte_type" value="0">
						<input type="hidden" name="reserve_yn" value="0">
					</form>
					예약 인원<br/>
					<span id="reserveNumDN">0</span>명
					<br/>
					<button type="submit" class="btn btn-primary reserve" id="reserveDN" >예약하기</button>
				</td>
		    </tr>
	  </tbody>
	</table> 
</section>

<%@include  file="../main/backward_main.jsp" %>

<%@include  file="fn_lookup_carte.jsp" %>