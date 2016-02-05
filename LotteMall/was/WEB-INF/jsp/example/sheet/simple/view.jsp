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
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>시트예제</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/WEB-INF/jsp/common/include/inc_head.jsp"></jsp:include>
<script language="javascript">
/*페이지 EVENT 설정(필수)*/
function fn_SetEvent(){
	 $("#btnBack").click( function(){ fn_doList(); } );
	 $("#btnEdit").click( function(){ fn_doEdit(); } );
	 $("#btnDel").click( function(){ fn_doDel(); } );
}

/*페이지 로딩후 설정 (필수)*/
function fn_LoadPage() {
	fn_doDetail();
}

/*리스트 페이지 이동*/
function fn_doList(){
	location.href="/phone/example/sheet/simple/list.moDetail";
}

/*수정 페이지 이동*/
function fn_doEdit(){
	var no = $("#no").val();
	location.href="/phone/example/sheet/simple/goForm.moDetail?no="+no;
}

/*상세정보 조회 호출*/
function fn_doDetail(){
	/* 전송정보중 no를 기준으로 상세 정보 조회*/
	$("#no").val("<c:out value="${sheetSimpleVO.no}"/>");
	if( $("#no").val() != "" ){
		var params = {no:$("#no").val()};
		callJson("/phone/example/sheet/simple/doSearchDetail.moJson", params, fnNmGetter().name );
	}
}
/*상세정보 조회 후 처리 */
function callBack_$fn_doDetail(response , status ){
	if(  response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		if( response.data != undefined ){
			var data = response.data;
			$("#no").val( data.NO );
			$("#title").html( data.TITLE );	
			$("#content").val( data.CONTENT );	
		}
		return;	
	}
}

/* 삭제호출 */
function fn_doDel(){
	$("#mode").val("del");
	var params = $('#saveForm').serialize();
	callJson("/phone/example/sheet/simple/doSave.moJson", params, fnNmGetter().name );
}

/* 삭제 후 처리 */
function callBack_$fn_doDel(response , status ){
	if( response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		alert(response.OK_MSG);
		fn_doList();
		return;	
	}
}	

</script>
</head>
<body>
<div style="width:600px">
	<form:form commandName="sheetSimpleVO"  id="saveForm" name="saveForm" method="post">
		<input type="hidden" name="mode" id="mode"/>
		<input type="hidden" name="no" id="no"/>
        <div class="main_content">
        
            <div class="ib_function float_right">
                <a id="btnBack"  href="#"  class="f1_btn_gray lightgray">리스트</a>&nbsp;
                <a id="btnEdit"  href="#"  class="f1_btn_white gray">수정페이지</a>&nbsp;
                <a id="btnDel"    href="#"  class="f1_btn_white gray">삭제</a>                
            </div>

			<div class="clear hidden"></div>  
            
            <div class="ib_product" style="width:691">
            	Title<br/>
				<span id="title"></span> <br/>
				Content<br/>
				<textarea id="content" style="width:100%;height:500px"></textarea>
            </div>
        
        <!--main_content-->
	</form:form>

</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>