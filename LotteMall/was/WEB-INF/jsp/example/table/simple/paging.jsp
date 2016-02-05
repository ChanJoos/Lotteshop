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
<title>테이블예제</title>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta http-equiv="Pragma" content="no-cache" />
<jsp:include page="/WEB-INF/jsp/common/include/inc_head.jsp"></jsp:include>
<script language="javascript">
	/*페이지 EVENT 설정(필수)*/
	function fn_SetEvent() {
		 $("#btnSearch").click(function(){ //임시로 당월을 클릭하였을 경우 조회 되도록 하였습니다.
			 fn_doSearch(1);	 
		 });
	}

	/*페이지 로딩후 설정 (필수)*/
	/* 주의사항:화면로딩시 사용되는 이벤트는 무한루프 돌지 않게  */
	function fn_LoadPage() {
		//해더부분 정보 입력하는 것
		setHeaderInfo('테이블예제',"/phone/main.moMain");
		//화사텝 HIT 
		//displayInitCompTab('HIT',false);
		//화사텝 LDCC 
		//displayInitCompTab('LDCC',true);
		//선택된 회사텝이 어떤 것인지 조회
		//alert( getCompTab()  );
		 initTable();
		 fn_doSearch(1);
	}
	
	function initTable(){/* 테이블 초기화 한다. */
		var config = {
			    columns:[/* 컬럼에 대한 내용을 세팅한다. */
			             {name:"GNM",type:"text"}
				          ,{name:"MONEY1",type:"int"}
				          ,{name:"MONEY2",type:"int"}
				          ,{name:"MONEY3",type:"int"}
				          ,{name:"MONEY4",type:"int"}
				          ,{name:"KEY1",type:"text",key:true}
				          ,{name:"KEY2",type:"text",key:true}
				  ]
				,images:{/*테이블에서 이미지를 사용을 할 때 미리 선언한다.*/
					green:"/phone/images/content/bg_bead_gn.png"
					,red:"/phone/images/content/bg_bead_rd.png"
					,yellow:"/phone/images/content/bg_bead_yl.png"
				}
		};
		/* 환경을 세팅한다 */
		UI.Tables.setConfig(  "mySheet" ,  config  );
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
		
	/*조회*/
	function fn_doSearch( pageNo ) {
		$("#mySheet_pageIndex").val(  pageNo  );
		/*
		FORM에 있는 name , value 가 쿼리스트링이로 만들어짐
		?startDate=20130807&endDate=20130807&title=.......
		*/
		var params = $('#listForm').serialize();
		callJson("/phone/example/table/simple/paging.moJson", params, fnNmGetter().name  );
	}
	
	function callBack_$fn_doSearch(response , status ){
		if( response.SUCCESS != "true"){
			alert(response.ERR_MSG);
			return;
		} else {
			if( response.table != undefined ){
				//alert(response.OK_MSG);			
/* 				
				var tabledata = {
						pageIndex:1
						,perPageRow:10
						,totalCount:100
						,rows:[
						        {"groupName":"sm본부","money1":"10000.00","money2":"10000.00","money3":"10","money4":"30","key1":"CD1000","key2":"CD1001"}
						       ,{"groupName":"전략기획","money1":"-10","money2":"-10","money3":"0","money4":"0","key1":"CD1000","key2":"CD1002"}
						       ,{"groupName":"hidden1","money1":"300","money2":"1","money3":"2","money4":"4","key1":"CD1000","key2":"CD1003"}
						       ,{"groupName":"hidden2","money1":"200","money2":"2","money3":"3","money4":"5","key1":"CD1000","key2":"CD1004"}
						]
					};
 */
 				/* 조회 데이터  */
 				var tabledata = response.table.mySheet;
				/* 조회된 데이터를 table에 세팅한다. */
				UI.Tables.setDataRows(  "mySheet" ,  tabledata  );
				return;
			}	
		}
	}//End callBack_$fn_doSearch
	
	/* 테이블 행을 클릭을 하면 호출된다. */
	function mySheet_OnClick( row  , col , rowdata ){
		alert(row   +":"+ col    +":"+ rowdata.KEY1 +":"+ rowdata.KEY2 );
	}

	/*테이블에 페이징하여 페이지 번호를 클릭 할 경우 호출된다. (페이징사용시 필수 구현)*/
	function mySheet_GoToPage( pageno , tableID ){
		//alert( pageno +":"+tableID );
		fn_doSearch( pageno );
	}	
</script>
</head>
<body>

<ul id="skipNavi">
	<li><a href="#content">본문영역 바로가기</a></li>
</ul>
<div class="subLayout">
	<div class="wrap">
			<!-- header -->
			<jsp:include page="/WEB-INF/jsp/common/include/inc_headerbar.jsp"></jsp:include>
			<!-- //header -->
		
		<hr />
			<!-- iscroll start -->
			<!-- <div id="wrapper" style="position:relative;z-index:1;width:100%;overflow:auto;"><div id="scroller"> -->			
			<!--// iscroll start -->
		<!-- subTab -->
		<div class="subTabWrap">
			<!-- 활성화 되었을경우 class="on"처리 -->
			<ul class="subTab">
				<%/* 전체 빼고 
				<jsp:include page="/WEB-INF/jsp/phone/common/include/inc_comptab.jsp"/>
				*/%>
				<!-- 전체포함 -->
				<jsp:include page="/WEB-INF/jsp/common/include/inc_comptab.jsp">
					<jsp:param value="Y" name="tabALL"/>
				</jsp:include>
			</ul>
			<a href="#" class="btn icon"><img src="/phone/images/content/btn_grp_up.png" alt="롯데정보통신" /></a>
		</div>
		<!-- //subTab -->

		<div id="content" class="scroll_y">
			<div class="topCont">
				<p class="date"><input type="text" value="2013년 7월" /></p>	
				<!-- 활성화 경우 : a태그에 class="on" 처리 -->
				<ul class="tab">
					<li><span class="btn small"><span class="singColor gr1"><a id="btnSearch" href="#" class="on">당월</a></span></span></li>
					<li><span class="btn small"><span class="singColor gr1"><a href="sub1_1_2.html">누계</a></span></span></li>
				</ul>
			</div>
			<div class="tbl_wrap">
			<form:form commandName="sheetSimpleVO" id="listForm" name="listForm" method="post">
				<!-- 현제페이지 번호 , 페이지당 보이는 행수   -->
				<input type="hidden" name="mySheet_pageIndex" id="mySheet_pageIndex" value="1"/>
				<input type="hidden" name="mySheet_rowPerPage" id="mySheet_rowPerPage" value="5"/>
				<!-- 아이디 추가 id="mySheet"   -->
				<table id="mySheet" class="tbl th_al" summary="부분별 실적의 SM본부, SI부문, 하이테크부문, BSP부문, ISC본부, 정보기술연수소의 매출/이익에 대한 표입니다.">
					<caption>당월 부문별 실적</caption>
					<colgroup>
						<col width="*" />
						<col width="19%" />
						<col width="20%" />
						<col width="19%" />
						<col width="20%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col" rowspan="2" >부분</th>
							<th scope="colgroup" colspan="2">매출</th>
							<th scope="colgroup" colspan="2">이익</th>
						</tr>
						<tr class="dep2">
							<th scope="col">목표</th>
							<th scope="col">이익</th>
							<th scope="col">목표</th>
							<th scope="col">이익</th>
						</tr>
					</thead>
					<!-- 아이디 추가 id="mySheet_SumRow" style="display:none"  -->
					<tfoot id="mySheet_SumRow" style="display:none">
						<tr>
							<th scope="col">합계</th>
							<td class="ar size1"><span>{MONEY1}</span>억원</td>
							<td class="ar size2"><span class="bl">{MONEY2}</span>억원</td>
							<td class="ar size1"><span>{MONEY3}</span>억원</td>
							<td class="ar size2"><span class="bl">{MONEY4}</span>억원</td>
						</tr>
					</tfoot>
					<!-- 아이디 추가 id="mySheet_DataArea"  -->
					<tbody id="mySheet_DataArea">
						<!-- 아이디 추가 id="mySheet_BasicRow"  style="display:none" -->
						<tr id="mySheet_BasicRow" style="display:none">
							<th scope="row">{GNM}</th>
							<td class="ar size1"><span class="gr">{MONEY1}</span>억원</td>
							<td class="ar size2"><span class="bl">{MONEY2}</span>억원</td>
							<td class="ar size1"><span class="gr">{MONEY3}</span>억원</td>
							<td class="ar size2"><span class="bl">{MONEY4}</span>억원</td>
						</tr>
						</tbody>
				</table>
				</form:form>
			</div> <!-- //End tbl_wrap  -->
			<!-- 페이징구현시 사용 -->
			<div id="mySheet_PagingIndex">&nbsp;</div>
		</div>
	</div>
			<!-- iscroll end -->
			<!-- </div></div> -->
			<!--// iscroll end -->
	<hr />

		<!-- footer -->
		<jsp:include page="/WEB-INF/jsp/common/include/inc_footerbar.jsp"></jsp:include>
		<!-- //footer -->
</div>
</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>