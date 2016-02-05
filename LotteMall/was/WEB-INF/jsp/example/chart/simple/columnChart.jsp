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
<title>컬럼차트</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/WEB-INF/jsp/common/include/inc_head.jsp"></jsp:include>
<script language="javascript">
/*페이지 EVENT 설정(필수)*/
function fn_SetEvent(){

}

/*페이지 로딩후 설정 (필수)*/
function fn_LoadPage() {
	$("#menu_cd").val("<c:out value="${menu_cd}"/>");
	fn_doSearchChart();
}

/*차트 조회 호출*/
function fn_doSearchChart(){
	var params = $('#chartForm').serialize();
	callJson("/phone/example/chart/simple/searchColumnChart.moJson", params, fnNmGetter().name  );
}
/*차트정보 조회 후 처리 */
function callBack_$fn_doSearchChart(response , status ){
	/*
	var config = {xAxisLabels:["A등급", "B등급", "C등급", "합계"]};
	var data = [ 
	  {seriesName:'전년동기', arrData:[{X:"0", Y:"75"},{X:"1", Y:"20"},{X:"2", Y:"47"},{X:"3", Y:"142"}]}
	, {seriesName:'조회건수', arrData:[{X:"0", Y:"15"},{X:"1", Y:"48"},{X:"2", Y:"87"},{X:"3", Y:"150"}]} 
	];
	*/
	if( status  == false || response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		if( response.chart != undefined ){
			var chart = response.chart;
			var config = chart.config;
			var data = chart.data;
			//컬럼차트 그릴때 호출
			//gfn_drawColumnChart( "myChart" ,data , config ,{gradient:"linear"}); //gradient을 linear효과로 했을때
			//gfn_drawColumnChart( "myChart" ,data , config ,{gradient:"radial"}); //gradient을 radial효과로 했을때		
			//gfn_drawColumnChart( "myChart" ,data , config ); //단색
			var options = { columnColors:['#FA7703','#0BADE8']};
			gfn_drawColumnChart( "myChart" ,data , config , options ); //사용자정의
		}
		return;	
	}
}

/* 라벨을 반환하는 메소드 */
function myChart_LabelFormatter(){
	//차트의 x값 명칭 붙여주는 것
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	var seriesDesc = (this.series.name == "조회건수") ? "건" : "억";
	return this.point.y + seriesDesc;
}

/* 툴팁을 반환하는 메소드 */
function myChart_ToolTipFormatter(){
	//차트의 x값 명칭 붙여주는 것
	var chart = ChartUtil.getChartOfToolTipName( fnNmGetter().name );
	return '<span style="color: #4572A7">' + this.series.name + '</span><br/>' 
	            + chart.xAxes[0].categories[this.point.x] + '시 : ' + this.y ;
}

</script>
</head>
<body>

<div style="width:600px">
	<form:form commandName="chartSimpleVO"  id="chartForm" name="chartForm" method="post">
	<input type="hidden" name="menu_cd" id="menu_cd" value=""/> 
       	<a id="btnSearch" href="#">조회</a><br>
		<div class="ib_product" style="width:691">
		
			<script>ChartUtil.writeChartArea("myChart",700,600);</script>
		</div>
	</form:form>
	</div>

</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>