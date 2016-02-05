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
	callJson("/phone/example/chart/simple/searchBarStackPercentageChart.moJson", params, fnNmGetter().name  );
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
			gfn_drawBarStackPercentageChart( "myChart" ,data , config ,{ columnColors:['#ABABAB','#06ADD5']} );		
		}
		return;	
	}
}

/* 라벨을 반환하는 메소드 */
function myChart_LabelFormatter(){
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	var rAimArr = $('body').data('rAimArr');
	var rRltArr  = $('body').data('rRltArr');
	var pArr = $('body').data('pArr');
	var prefix = '', suffix = ' ' + this.point.y + '%', content = rRltArr[this.point.x].Y;
	if(this.series.name === '매출목표') {
		prefix = '목표';
		suffix = '';
		content = rAimArr[this.point.x].Y;
	}
	if(this.point.y < 30) return '';
	return prefix + content + '억' + suffix;
}

/* 툴팁을 반환하는 메소드 */
function myChart_ToolTipFormatter(){
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	var rAimArr = $('body').data('rAimArr');
	var rRltArr  = $('body').data('rRltArr');
	var pArr = $('body').data('pArr');
	
	return '<span style="color: #4572A7">매출목표</span><br/>' + rAimArr[this.point.x].Y  + '억' 
	+'<br/><span style="color: #4572A7">매출실적</span><br/>' + rRltArr[this.point.x].Y  + '억' 
	+'<br/><span style="color: #4572A7">달성률</span><br/>' + pArr[this.point.x]  + '%' ;
}
</script>
</head>
<body>
<div style="width:600px">
	<form:form commandName="chartSimpleVO"  id="chartForm" name="chartForm" method="post">
<input type="hidden" name="no" id="no"/>
<a id="btnSearch" href="#">조회</a><br>
<script>ChartUtil.writeChartArea("myChart","100%","700px");</script>
	</form:form>
	</div>
</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>