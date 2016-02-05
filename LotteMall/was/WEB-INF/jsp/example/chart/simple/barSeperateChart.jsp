<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<%
/**
 * @Description : 컬럼차트 페이지
 * @Modification Information
 * @
 * @  수정일          수정자                  수정내용
 * @ ---------        ---------   -------------------------------
 * @ 2013. 8. 7.  정상국                   최초생성
 *  
 */
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>Bar Multi 차트</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/WEB-INF/jsp/common/include/inc_head.jsp"></jsp:include>
<script language="javascript">
/*페이지 EVENT 설정(필수)*/
function fn_SetEvent(){

}
/*페이지 로딩후 설정 (필수)*/
function fn_LoadPage() {
	fn_doSearchChart();
}
/*차트정보 조회 호출*/
function fn_doSearchChart(){
	var params = $('#chartForm').serialize();
	callJson("/phone/example/chart/simple/searchBarSeperateChart.moJson", params, fnNmGetter().name  );
}
/*차트정보 조회 후 처리 */
function callBack_$fn_doSearchChart(response , status ){
	/*
	var config = {xAxisLabels:["SM부문", "ISC부문", "하이테크부문", "SM본부", "SM본부","정보기술연구소"]};

	var data = [{"seriesName":"건수","arrData":[{"X":0,"Y":27},{"X":1,"Y":30},{"X":2,"Y":47},{"X":3,"Y":40}]}
    				 ,{"seriesName":"규모","arrData":[{"X":0,"Y":12},{"X":1,"Y":16},{"X":2,"Y":35},{"X":3,"Y":35}]}];
	*/
	if( status  == false || response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		if( response.chart != undefined ){
			var chart = response.chart;
			var config = chart.config;
			var data = chart.data;
			//var options = { columnColors:['#00B7CF','#F4361C']}; //사업기획현황
			var options = { columnColors:['#00B7CF','#F6A70E']}; //프로잭트현황
			gfn_drawBarSeperateChart( "chartsArea" ,  "myChart" , "100%", "80%" ,data , config , options );		
		}
		return;	
	}
}

/* 라벨을 반환하는 메소드 */
function BarSeperate_LabelFormatter(){
	var seriesDesc = (this.series.name == "조회건수") ? "건" : "억";
	return this.point.y + seriesDesc;
}
/* 툴팁을 반환하는 메소드 */
function BarSeperate_ToolTipFormatter(){
	var seriesDesc = (this.series.name == "조회건수") ? "건" : "억";
	return '<span style="color: #4572A7">' + this.series.name + '</span><br/>'+ this.y + seriesDesc;
}
</script>
</head>
<body>
<div style="width:100%">
	<form:form commandName="chartSimpleVO"  id="chartForm" name="chartForm" method="post">
		<input type="hidden" name="no" id="no"/>
       	<a id="btnSearch" href="#">조회</a><br>
		<div class="ib_product" style="width:100%">
			<div id="chartsArea"></div>
		</div>
	</form:form>
	</div>
</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>