<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>

<%
	/**
	 * @Description : 게시판 리스트 페이지
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
<title>시트예제</title>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta http-equiv="Pragma" content="no-cache" />
<jsp:include page="/WEB-INF/jsp/common/include/inc_head.jsp"></jsp:include>
<script language="javascript">
	/*페이지 EVENT 설정(필수)*/
	function fn_SetEvent() {
		$("#btnSearch").click(function() {
			fn_doSearch();
		});
		$("#btnAdd").click(function() {
			fn_doAdd();
		});
		$("#btnDialog").click(function(){
			UI.Dialog.show( '권한에러' , '권한이 없습니다.<br/>&nbsp&nbsp;확인 후 다시 사용하십시오',[{label:"예",click:"alert('예');",onYN:"Y"},{label:"닫기",click:"alert('닫기');UI.Dialog.hidden();"}], callBackDialog );
		});
	}
	
	function callBackDialog(){
		alert('콜백');
		return true; //true이면 닫는다.
	}	

	/*페이지 로딩후 설정 (필수)*/
	/* 주의사항:화면로딩시 사용되는 이벤트는 무한루프 돌지 않게  */
	function fn_LoadPage() {
		//해더부분 정보 입력하는 것
		setHeaderInfo('시트예제',"/phone/main.moMain");
		//화사텝 HIT 
		//displayInitCompTab('HIT',false);
		//화사텝 LDCC 
		//displayInitCompTab('LDCC',true);
		//선택된 회사텝이 어떤 것인지 조회
		//alert( getCompTab()  );
		
		fn_initSheet();
		fn_doSearch();
	}
	
	/* 회사텝을 넣었을 경우 필수구현 */
	/* 주의사항:화면로딩시 사용되는 이벤트는 무한루프 돌지 않게  */
	function choiceCompTab( tab ){
		if(tab =='ALL' ){
			alert('전체');
		}else if(tab =='LDCC' ){
			alert('롯데정보통신');
		}else if(tab =='HIT' ){
			alert('현대정보통신');
		}
	}

	/*Sheet 기본 설정 */
	function fn_initSheet() {
		var cfg = {
			SearchMode : 2,
			Page : 100
		};
		var headers = [ {Text : "No|제목|아이디|등록일",Align : "Center"} ];
		var info = {Sort : 1,ColMove : 1,ColResize : 1,HeaderCheck : 0};

		/* s4에 width가 잘나오는지 확인 해주세요*/
		var cols = [ {Type : "Text",Width : 10,SaveName : "NO",Edit : false}
		                 , {Type : "Text",Width : 50,SaveName : "TITLE",Edit : false , Ellipsis:true} /* , Ellipsis:true 말줄임 */
		                 , {Type : "Text",Width : 20,SaveName : "EMP_ID",Edit : false}
		                 , {Type : "Text",Width : 20,SaveName : "REGDATE",Edit : false} ];

		mySheet.SetConfig(cfg);
		mySheet.InitHeaders(headers, info);
		mySheet.InitColumns(cols);
		mySheet.FitColWidth();
		/* 시트 폰트 크기 및 기타 설정 */
		SheetUtil.initSheet( "mySheet" , mySheet  );
		/* 시트 폰트 크기 및 기타 설정 */
	}

	function mySheet_OnSearchEnd(cd, msg) {
		//조회 후 처리 시 사용		
		sheetLoadEnd = true;
		loadScroll();
	}

	function mySheet_OnResize() {
		mySheet.FitColWidth();
	}

	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if (Row == 0)
			return; /* 타이틀 에서 클릭하는 것은 제외 시킨다. */
		var no = mySheet.GetCellValue(Row, mySheet.SaveNameCol("NO"));
		fn_doView(no);
	}

	/*조회*/
	function fn_doSearch() {
		//s_SAVENAME 히든 객체에 시트의 SAVENAME을 담는다.
		IBS_SaveName(document.listForm, mySheet);
		var param = FormQueryStringEnc(document.listForm);
		//IBSheetSampleController 호출
		sheetLoadEnd = false;
		mySheet.DoSearch("/phone/example/sheet/simple/doSearch.moSheet", param);
	}

	/*상세페이지 이동*/
	function fn_doView(sNo) {
		location.href = "/phone/example/sheet/simple/goView.moDetail?no=" + sNo;
	}

	/*등록페이지 이동*/
	function fn_doAdd() {
		location.href = "/phone/example/sheet/simple/goForm.moDetail";
	}
</script>
<style>
</style>
</head>
<body>
	


	<ul id="skipNavi">
		<li><a href="#content">본문영역 바로가기</a></li>
	</ul>
	<!--
	 iscroll 관련  style="width:100%;height:100%" 추가
	 -->
	<div class="subLayout" style="width:100%;height:100%">
	
		<div class="wrap">
		
			<!-- header -->
			<jsp:include page="/WEB-INF/jsp/common/include/inc_headerbar.jsp"></jsp:include>
			<!-- //header -->
			
			<hr />
			
			<!-- iscroll start -->
			<div id="wrapper" style="position:relative;z-index:1;width:100%;overflow:auto;"><div id="scroller">			
			<!--// iscroll start -->

			<div id="content">
				<!-- subTab -->
				<div class="subTabWrap">
					<ul class="subTab">
						<%/*
						<jsp:include page="/WEB-INF/jsp/phone/common/include/inc_comptab.jsp"/>
						*/%>
						<jsp:include page="/WEB-INF/jsp/common/include/inc_comptab.jsp">
							<jsp:param value="Y" name="tabALL"/>
						</jsp:include>
					</ul>
					<a href="#" class="btn ar"><img src="/phone/images/content/img_chart.png" alt="차트" id="btnChart" /></a>
					<!-- 
					<a href="#" class="btn ar"><img src="/phone/images/content/img_grid.png" alt="그리드" id="btnGrid" /></a>
				 	-->
				</div> <!--// subTabWrap end -->
				<div class="ib_product" style="width: 100%">
					<!-- content 내용 -->
					<form:form commandName="sheetSimpleVO" id="frmDefault" name="listForm"
						method="post">
						<input type="hidden" name="s_SAVENAME" />
						<input type="hidden" name="no" id="no" />
						<DIV style="font-size:20px;
						">
						<a id="btnSearch" href="#">조회</a> | <a id="btnAdd" href="#">등록</a>| <a id="btnDialog" href="#">다이얼로그확인</a>
						</DIV>
						<br>
						<div class="ib_product">
							<script type="text/javascript">createIBSheet("mySheet", "100%", "100%");</script>
						</div>
					</form:form>
					<!--// content 내용 -->
				</div>  <!--// ib_product end -->
			</div> <!--// content end -->
			
			<!-- iscroll end -->
			</div></div>
			<!--// iscroll end -->
		
		</div> <!--// wrap end -->
		<!-- footer -->
		<jsp:include page="/WEB-INF/jsp/common/include/inc_footerbar.jsp"></jsp:include>
		<!-- //footer -->			
	</div><!--// subLayout end -->
</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>