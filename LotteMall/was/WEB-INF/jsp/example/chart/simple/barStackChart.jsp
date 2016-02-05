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
<title>Bar Stack 차트</title>
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

/*차트 조회 호출*/
function fn_doSearchChart(){
	var params = $('#chartForm').serialize();
	callJson("/phone/example/chart/simple/searchBarStackChart.moJson", params, fnNmGetter().name  );
}
/*차트정보 조회 후 처리 */
function callBack_$fn_doSearchChart(response , status ){
	/*
	var config = {xAxisLabels:["SM", "SI", "하이테크", "IDC"]
	                                       ,columnColors:["#FF0000", "#C9C9C9", "#C9C9C9"]};
	var data =[{"seriesName":"악성","arrData":[{"X":0,"Y":23},{"X":1,"Y":23},{"X":2,"Y":17},{"X":3,"Y":7}]}
	,{"seriesName":"장기","arrData":[{"X":0,"Y":24},{"X":1,"Y":18},{"X":2,"Y":9},{"X":3,"Y":22}]}
	,{"seriesName":"정상","arrData":[{"X":0,"Y":9},{"X":1,"Y":11},{"X":2,"Y":6},{"X":3,"Y":3}]}];
	*/
	if( status  == false || response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		if( response.chart != undefined ){
			var chart = response.chart;
			var config = chart.config;
			var data = chart.data;
			gfn_drawBarStackChart( "myChart" ,data , config,{ columnColors:['#F73C23','#F6A50E','#08A0DF']} );		
		}
		return;	
	}
}

/* 라벨을 반환하는 메소드 */
function myChart_LabelFormatter(){
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	if(this.series.name !== '악성') return '';
	var totalValue = $('body').data('totalValue');
	return totalValue[this.point.x];
}

/* 툴팁을 반환하는 메소드 */
function myChart_ToolTipFormatter(){
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	return '<span style="color: #4572A7">' + this.series.name + '</span><br/>' + chart.xAxes[0].categories[this.point.x] + ' : ' + this.y + '억';
}
</script>
</head>
<body>
<div style="width:600px">
	<form:form commandName="chartSimpleVO"  id="chartForm" name="chartForm" method="post">
		<input type="hidden" name="no" id="no"/>
       	<a id="btnSearch" href="#">조회</a><br>
		<div class="ib_product" style="width:691">
			<script>ChartUtil.writeChartArea("myChart","100%","700px");</script>
		</div>
	</form:form>
	</div>
</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>