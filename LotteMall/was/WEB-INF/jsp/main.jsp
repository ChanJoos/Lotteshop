<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<%
/**
 * @Description : 게시판 상세 페이지
 * @Modification Information
 * @
 * @  수정일          수정자                  수정내용
 * @ ---------        ---------   -------------------------------
 * @ 2013. 8. 7.  정상국                   최초생성
 *  
 */
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">

<title>EIS(Executive Information System</title>
<%@ include file="/WEB-INF/jsp/common/include/inc_head.jsp"%>
<script language="javascript">
/*페이지 EVENT 설정(필수)*/
function fn_SetEvent(){
	
}

/*페이지 로딩후 설정 (필수)*/
function fn_LoadPage() {
	$("#emp_id").val("<c:out value="${mainmenuVO.emp_id}"/>");
	setVisitHistory();
	setGraphInfo();
	drawMenu();
}
k
function setVisitHistory(){

	/**1. 방문기록 출력  시작**/
	var graph = [];
	<c:forEach var="info" items="${visithistorylist}" varStatus="status">
	//실적
	$("#todayTotal").html(UTIL.Format.number("<c:out value="${info.TODAYTOTAL}"/>"));
	//목표
	$("#monthTotal").html(UTIL.Format.number("<c:out value="${info.MONTHTOTAL}"/>"));
	//달성%
	$("#myHistory").html(UTIL.Format.number("<c:out value="${info.MYHISTORY}"/>"));
	</c:forEach>
	/**1. 방문기록 출력  끝**/
}

function setGraphInfo(){

	/**2. 상단 그래프 출력  시작**/
	var graph = [];
	<c:forEach var="info" items="${graphlist}" varStatus="status">
	//마감년, 월
	$("#final_year").html( "<c:out value="${info.year}"/>" );
	$("#final_month").html( "<c:out value="${info.month}"/>" );
	
	//실적
	$("#perform<c:out value="${status.count}"/>").html(UTIL.Format.number("<c:out value="${info.PERFORM}"/>"));
	//목표
	$("#goal<c:out value="${status.count}"/>").html(UTIL.Format.number("<c:out value="${info.GOAL}"/>")+"억");
	//달성%
	$("#performpct<c:out value="${status.count}"/>").html("<c:out value="${info.PERFORMPCT}"/>"+"%");
	//그래프 수치 %
	graph.push( <c:out value="${info.PERFORMPCT}"/> );
	</c:forEach>
	
	fn_drawGraph( graph );
	/**2. 상단 그래프 출력  끝**/
}

//빅메뉴에서 서버메뉴 보이고 숨기는 것	
function changeBigMenu( bmenu_cd ){
   //alert("bmenu_cd{"+bmenu_cd+"}");
	if( $("#"+bmenu_cd).hasClass("on") ){
		$("#"+bmenu_cd).removeClass("on");
		$("#"+bmenu_cd+"area").hide();
	} else {
		$("#"+bmenu_cd).addClass("on");
		$("#"+bmenu_cd+"area").show();
		//alert("#"+bmenu_cd+"area" );
	}
	//alert("!2");
	for( var i = 0 ; i < bmenuList.length ; i++ ){
		if( bmenuList[i] != bmenu_cd ) {
			$("#"+bmenuList[i]).removeClass("on");
			$("#"+bmenuList[i]+"area").hide();
		}
	}
	//alert("!3");
}
var bmenuList = [];

function drawMenu(){
	/**3. 하단 메뉴리스트 출력 시작**/
//for 빅메뉴
	<c:forEach var="info" items="${bmenulist}" varStatus="status">
		var bcd ="bm<c:out value="${info.LV1_CD}"/>";
		var bnm ="<c:out value="${info.LV1_NM}"/>";
		bmenuList.push( bcd );
		$("#menuArea").append("<li id='bm<c:out value="${info.LV1_CD}"/>'><a id='"+bcd+"title' href='#"+bcd+"title'>"+bnm+"</a><div id='"+bcd+"area' class='navCon' style='display:none'></div></li>");
		$("#"+bcd+"title").click(function(){
			changeBigMenu( 'bm<c:out value="${info.LV1_CD}"/>' );
		});
	</c:forEach>
	
//for 서부메뉴
<c:forEach var="info" items="${smenulist}" varStatus="status">
    bcd ="bm<c:out value="${info.LV1_CD}"/>";
	var scd ="sm<c:out value="${info.LV2_CD}"/>";
	var snm ="<c:out value="${info.LV2_NM}"/>";

	$("#"+bcd+"area").append("<a id='"+scd+"' href='#''>"+snm+"</a>");
	$("#"+scd).click(function(){
		//alert(menulink);
		location.href = "<c:out value="${info.MENU_LINK}"/>";
	});
</c:forEach>
	/**3. 하단 메뉴리스트 출력 끝**/

}

/*상세정보 조회 호출*/
function fn_mainInfo(){
	var graph = {bar1:31,bar2:25,bar3:10};
	fn_drawGraph( graph );
	return;
	/* 전송정보중 no를 기준으로 상세 정보 조회*/
	var params = {no:$("#no").val()};
	callJson("/phone/example/sheet/simple/doSearchDetail.moJson", params, fnNmGetter().name,  {dataType:"txt"}  );
}
/*상세정보 조회 후 처리 */
function callBack_$fn_mainInfo(response){
	/* 에러코드가 0 이 아니면 에러 메세지 출력 */
	if(response.ERR_NO != "0"){
		alert(response.ERR_MSG);
		return;
	} else {
		/* 조회결과 반된 되면 */
		/*
		var response =	{  ERR_NO:0
			                     , ERR_MSG:0
			                     , OK_MSG:0
			                     , data: { NO:"1"
			                    	         ,TITLE:"제목"
			                    	         ,CONTENT:"내용"}
		                         };
		*/
		if( response.data != undefined ){
			var data = response.data;
			var graph = data.graph;
			var menu = data.menu;
		}
		return;	
	}
}

function fn_drawGraph( graph ){
	
	var bar1Rate = graph[0]; //대외수주 달성률
	var bar2Rate = graph[1]; //매출 달성률
	var bar3Rate = graph[2]; //영업이익 달성률
	
	if(bar1Rate>100) bar1Rate = 100;	
	if(bar2Rate>100) bar2Rate = 100;
	if(bar3Rate>100) bar3Rate = 100;
	
	var graph_width = $("#graphbg").width();
	
	var bar1_width = Math.round( graph_width*(bar1Rate/100) );
	var bar2_width = Math.round( graph_width*(bar2Rate/100) );
	var bar3_width = Math.round( graph_width*(bar3Rate/100) );
	
	$( "#bar1" ).animate({width: bar1_width}, 1000 );
	$( "#bar2" ).animate({width: bar2_width}, 1000 );
	$( "#bar3" ).animate({width: bar3_width}, 1000 );		
}
</script>
</head>
<body id="wrapper">
<ul id="skipNavi">
	<li><a href="#content">본문영역 바로가기</a></li>
</ul>
<div class="mainLayout">
	<div class="mainHeader">
		<div class="logo">
			<h1><img src="/phone/images/main/img_mainHead_logo.png" alt="EIS(Executive Information System)"/></h1>
			<!--<p><img src="/phone/images/main/img_mainHead_txt.png" alt="EIS(Executive Information System)" /></p> -->
			<!-- 방문자기록 -->
			<div class="visit_write2">
				<dl>
					<dd><span id="final_year">0</span><span class="w">년&nbsp;</span></dd>
					<dd><span id="final_month">0</span><span class="w">월 누계</span></dd>
				</dl>
			</div>
			<div class="visit_write">
				<dl>
					<dt>TODAY TOTAL</dt>
					<dd id="todayTotal">1000</dd>
				</dl>
				<dl>
					<dt>MONTH TOTAL</dt>
					<dd id="monthTotal">30</dd>
				</dl>
				<dl>
					<dt>MY HISTORY</dt>
					<dd id="myHistory">100</dd>
				</dl>
			</div>
			<!-- //방문자기록 -->
		</div>
		<!-- 그래프영역 -->
			<ul class="range">
				<li>
					<h2>대외수주</h2>
					<dl class="mark">
						<dt>실적</dt>
						<dd class="result" ><span id="perform1">0</span>억</dd>
						<dt>목표</dt>
						<dd id ="goal1">0억</dd>
					</dl>
					<dl class="ach">
						<dt>달성</dt>
						<dd id="performpct1">0%</dd>
					</dl>
					<!-- 개발영역 span에 width: %로 함 -->
					<p class="progress">
						<span id="bar1" style="width:0%"><span class="hide">달성 0%</span></span>
					</p>
					<!-- //개발영역 -->
				</li>
				<li>
					<h2>매출</h2>
					<dl class="mark">
						<dt>실적</dt>
						<dd class="result" ><span id="perform2">0</span>억</dd>
						<dt>목표</dt>
						<dd id ="goal2">0억</dd>
					</dl>
					<dl class="ach">
						<dt>달성</dt>
						<dd id ="performpct2">0%</dd>
					</dl>
					<!-- 개발영역 span에 width: %로 함 -->
					<p id="graphbg" class="progress">
						<span id="bar2" style="width:0%"><span class="hide">달성 0%</span></span>
					</p>
					<!-- //개발영역 -->
				</li>
				<li>
					<h2>영업이익</h2>
					<dl class="mark">
						<dt>실적</dt>
						<dd class="result" ><span id="perform3">0</span>억</dd>
						<dt>목표</dt>
						<dd id ="goal3">0억</dd>
					</dl>
					<dl class="ach">
						<dt>달성</dt>
						<dd id="performpct3">0%</dd>
					</dl>
					<!-- 개발영역 span에 width: %로 함 -->
					<p class="progress">
						<span id="bar3" style="width:0%"><span class="hide">달성 0%</span></span>
					</p>
					<!-- //개발영역 -->
				</li>
			</ul>
		</div>

	<hr />

	
		<div id="content" class="scroll_y">
		<!-- 열릴경우 class="on" 처리-->
		<form:form commandName="mainmenuVO"  id="listForm" name="listForm"  method="POST" >
		<input type="hidden" name="s_SAVENAME"/>
		<input type="hidden" name="emp_id"  id="emp_id"/>
					
			<ul id="menuArea" class="menuList">
			</ul>
		</form:form>	
			<!-- 
			<ul class="menuList">
				<li  onclick="javascript:fn_menuShow('BS')"><a href="#">경영정보</a></li>
					<div class="navCon" id="divshowBS" style="display:none">
						<li><a href="sub.html">경영실적</a></li>
						<li><a href="sub.html">주가현황</a></li>
					</div>
				<li onclick="javascript:fn_menuShow('SL')"><a href="#">영업정보</a></li>
					<div class="navCon" id="divshowSL" style="display:none">
						<li><a href="sub.html">부문실적</a></li>
						<li><a href="sub.html">사업기회</a></li>
						<li><a href="sub.html">재고/채권현황</a></li>
					</div>
				<li onclick="javascript:fn_menuShow('PR')"><a href="#">프로젝트정보</a></li>
					<div class="navCon" id="divshowPJ" style="display:none">
						<li><a href="sub.html">프로젝트현황</a></li>
					</div>
				<li onclick="javascript:fn_menuShow('OP')"><a href="#">장애정보</a></li>
					<div class="navCon" id="divshowOP" style="display:none">
						<li><a href="sub.html">장애현황판</a></li>
						<li><a href="sub.html">장애현황</a></li>
				   </div>
			</ul>
			 -->	

	</div>
			   


	<hr />

	<div id="footer">
		<p><img src="/phone/images/common/footer_logo.png" alt="롯데정보통신 | 현대정보기술" /></p>
	</div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/common/include/inc_end.jsp"%>
</html>