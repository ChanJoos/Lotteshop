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
<title>Bar 차트</title>
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
	callJson("/phone/example/chart/simple/searchBarChart.moJson", params, fnNmGetter().name  );
}
/*차트정보 조회 후 처리 */
function callBack_$fn_doSearchChart(response , status ){
	/*
	var config = {xAxisLabels:["SM", "SI", "하이테크", "IDC"]};

	var data = [{"seriesName":"매출목표","arrData":[{"X":0,"Y":27},{"X":1,"Y":30},{"X":2,"Y":47},{"X":3,"Y":40}]}
    				 ,{"seriesName":"매출실적","arrData":[{"X":0,"Y":12},{"X":1,"Y":16},{"X":2,"Y":35},{"X":3,"Y":35}]}];
	*/
	if( status  == false || response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		if( response.chart != undefined ){
			var chart = response.chart;
			var config = chart.config;
			var data = chart.data;
			gfn_drawBarChart( "myChart" ,data , config );
		}
		return;	
	}
}
/* 라벨을 반환하는 메소드 */
function myChart_LabelFormatter(){
	//차트의 x값 명칭 붙여주는 것
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	if(this.series.name === '매출목표') return '';
	var  resultArr = $('body').data('resultArr'); //
	return roundXL(resultArr.arrData[this.point.x]['rate'], 2) + "%";
}
/* 툴팁을 반환하는 메소드 */
function myChart_ToolTipFormatter(){
	//차트의 x값 명칭 붙여주는 것
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	return '<div style="font-size:3em;"><span style="color: #4572A7">' + this.series.name + '</span><br/>' + chart.xAxes[0].categories[this.point.x] + '시 : ' + this.y+"</div>" ;
	
	if(this.series.name === '매출목표') {
		var aim = $('body').data('aimArr');
		return '<div style="font-size:3em;"><span style="color: #4572A7">' + this.series.name + '</span><br/>' + chart.xAxes[0].categories[this.point.x] + ' : ' + aim.arrData[this.x].Y + '억'+"</div>";
	}
	var aimDesc = '',
	resultArr = $('body').data('resultArr');
	if(resultArr.arrData[this.point.x]['rate'] > 100) {
		var aim = $('body').data('aimArr');
		aimDesc = '<span style="color: #4572A7">' + aim.seriesName + '</span><br/>' + chart.xAxes[0].categories[this.point.x] + ' : ' + aim.arrData[this.x].Y + '억<br>';
	}
	return '<div style="font-size:3em;">' + aimDesc + '<span style="color: #4572A7">' + this.series.name + '</span><br/>' + chart.xAxes[0].categories[this.point.x] + ' : ' + this.y + '억'+"</div>";
}

</script>
</head>
<body>
<div style="width:600px">
	<form:form commandName="chartSimpleVO"  id="chartForm" name="chartForm" method="post">
		<input type="hidden" name="no" id="no"/>
       	<a id="btnSearch" href="#">조회</a><br>
		<div class="ib_product" style="width:691">
			<script>ChartUtil.writeChartArea("myChart",700,700);</script>
		</div>
	</form:form>
	</div>
</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>