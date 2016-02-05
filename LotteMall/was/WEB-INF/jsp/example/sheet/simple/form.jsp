<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<%
/**
 * @Description : 게시판 등록 페이지
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
	$("#btnSave").click( function(){ fn_doSave(); } );
	$("#btnDel").click( function(){ fn_doDel(); } );
}

/*페이지 로딩후 설정 (필수)*/
function fn_LoadPage() {
	fn_doDetail();
}

/*리스트페이지 이동*/
function fn_doList(){
	location.href="/phone/example/sheet/simple/list.moDetail";
}

/*상세페이지 이동*/
function fn_doView( sNo ){
	location.href="/phone/example/sheet/simple/goView.moDetail?no="+sNo;
}

/*상세정보 조회 호출*/
function fn_doDetail(){
	$("#no").val("<c:out value="${sheetSimpleVO.no}"/>");
	if( $("#no").val() != "" ){
		$("#btnDel").show();
		var params = {no:$("#no").val()};
		callJson("/phone/example/sheet/simple/doSearchDetail.moJson", params, fnNmGetter().name  );
	}
}

/*상세정보 조회 후 처리 */
function callBack_$fn_doDetail(response , status ){
	if( response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		if( response.data != undefined ){
			var data = response.data;
			$("#no").val( data.NO );
			$("#title").val( data.TITLE );	
			$("#content").val( data.CONTENT );	
		}
		return;	
	}
}

/* 저장 호출 */
function fn_doSave(){
	/* 등록 번호가 없으면 입력 있으면 수정 */
	if( $("#no").val() == "" ){
		$("#mode").val("add");	
	} else {
		$("#mode").val("edit");
	}
	/*
	FORM에 있는 name , value 가 쿼리스트링이로 만들어짐
	?startDate=20130807&endDate=20130807&title=.......
	*/
	var params = $('#saveForm').serialize();
	callJson("/phone/example/sheet/simple/doSave.moJson", params, fnNmGetter().name  );
}

/* 저장 후 처리 */
function callBack_$fn_doSave(response , status ){
	if( response.SUCCESS != "true"){
		alert(response.ERR_MSG);
		return;
	} else {
		if( response.data != undefined ){
			alert(response.OK_MSG);			
			if( $("#mode").val() == "add"){
				fn_doView(response.data.NO);
			} else {
				var no = $("#no").val();
				fn_doView(no);	
			}
			return;
		}	
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
<div>
	<a id="btnBack"  href="#">리스트</a>&nbsp;
	<a id="btnSave"  href="#">저장</a>&nbsp; 
	<a id="btnDel"    href="#" style="display:none">삭제</a>                
</div>
<form:form commandName="sheetSimpleVO"  id="saveForm" name="saveForm" method="post">
	<input type="hidden" name="mode" id="mode"/>
	<input type="hidden" name="no" id="no"/>
	
	<input type="text" name="title" id="title" maxlength="50"> <br/>
	<textarea name="content" id="content" rows="5" style="width:100%"></textarea>
</form:form>
</body>
<jsp:include page="/WEB-INF/jsp/common/include/inc_end.jsp"></jsp:include>
</html>








