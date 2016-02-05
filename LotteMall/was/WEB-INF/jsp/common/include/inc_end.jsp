<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<style>
/*
#wrapper {
    position:relative;
    z-index:1;
    width:100%;
    overflow:auto;
}
*/
</style>
<script>
function getMobileName(){
	var uAgent = navigator.userAgent.toLowerCase();
	var mobilePhones = ['iphone','ipad', 'firefox', 'android', 'chrome'];
	for(var i=0;i<mobilePhones.length;i++){
		if(uAgent.indexOf(mobilePhones[i]) != -1){
			return mobilePhones[i];
		}
	}
	return 'unknown';
}

//스크롤 만드는 것
function loadScroll(){
	var fht = $(window).height() - $("#footer").height();
	var cht =  0;
	
	/* centent위에 있는 경우 + 70을 더한다 */
	if( $(".subTabWrap").length > 0 ){/* 회사 선택 텝이 있는 경우  */
		if( "iphone" == getMobileName() ){
			cht = $(window).height() - ( $("#header").height() + $("#footer").height() + $(".subTabWrap").height() + 8 );
		}else {
			cht = $(window).height() - ( $("#header").height() + $("#footer").height() + $(".subTabWrap").height() + 16 );	
		}
	} else { 
		cht = $(window).height() - (  $("#header").height() + $("#footer").height()  );
	}
	
	$("#footer").css({top:fht+"px"});
	$("#content").height( cht );
}

//로딩중 마크를 만든다.
function loadingMark(){
	$("#h_loading").remove();
	if( $("body").has("#h_loading").html() == null ){
		$("body").prepend("<div id='h_loading' style='display:none;'><h1>잠시만 기다려주세요....</h1></div>");
	}
}

$(window).resize( function(e){
	//loadScroll();
});
	
//화면 처음 로딩중 메소드를 호출한다.
$(document).ready(function() {
	//setTimeout(loadScroll, 200);
	loadScroll();
	loadingMark();
	fn_LoadPage(); 
	fn_SetEvent();
});
</script>