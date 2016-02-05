<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<c:set var="compAuth" value="${user.comp_auth}"/>
<% request.setAttribute("tabALL",  request.getParameter("tabALL")); %>
<c:set var="tabALL" value="${tabALL}"/>
<script>
var CompTab = {
		config:{
			on:"on"
			,off:""
			,all:"ALL"
			,ldcc:"LDCC"
			,hit:"HIT"
			,link_all:"compTabLinkAll"
			,link_ldcc:"compTabLinkLdcc"
			,link_hit:"compTabLinkHit"
		}
		,getClassNames:function( tabname ){
			var classNames = {all:"",ldcc:"",hit:""};
			switch( tabname ){
			case CompTab.config.all :
				classNames.all    = "on";
				classNames.ldcc  = "";
				classNames.hit   = "";
				break;
			case CompTab.config.ldcc :
				classNames.all    = "";
				classNames.ldcc  = "on";
				classNames.hit   = ""
				break;
			case CompTab.config.hit :
				classNames.all    = "";
				classNames.ldcc  = "";
				classNames.hit   = "on";
				break;
			}
			return classNames;
		}
		,setClassNames:function( tabname ){
			var classNames = CompTab.getClassNames(tabname);
			$("#"+CompTab.config.link_all).attr("class",classNames.all);
			$("#"+CompTab.config.link_ldcc).attr("class",classNames.ldcc);
			$("#"+CompTab.config.link_hit).attr("class",classNames.hit);
		}
		,getChooseCompTabName:function(){
			var src = $("#"+CompTab.config.link_all).attr("class");
			if( src.indexOf("on") != -1 ) return CompTab.config.all;
			src = $("#"+CompTab.config.link_ldcc).attr("class");
			if( src.indexOf("on") != -1 ) return CompTab.config.ldcc;
			src = $("#"+CompTab.config.link_hit).attr("class");
			if( src.indexOf("on") != -1 ) return CompTab.config.hit;
		}
};

/*초기 선택 값이 어떤 것인지 알아보는 것*/
function getCompTab(){
	try{
		return CompTab.getChooseCompTabName();
	}catch(e){}
}
/* 화면텝 초기 선택 및 초기 이벤트 발생 (발생여부에 따라 동작)*/
function displayInitCompTab( tabname , eventYN ){
	try{
		CompTab.setClassNames(tabname);
		if( eventYN !== undefined && eventYN == true ){
			choiceCompTab( tabname );	
		}
	}catch(e){}
}
/* 회사 텝 클릭 시 온 오프 하는 것*/
function displayChangeCompTab( tabname ){
	try{	
		CompTab.setClassNames(tabname);
		choiceCompTab( tabname );
	}catch(e){}
}
</script>

<c:choose>
    <c:when test="${compAuth == 'A'}">
		<c:choose>
		    <c:when test="${tabALL == 'Y'}">
				<li><a id="compTabLinkAll"  href="javascript:displayChangeCompTab('ALL');" class="on">전&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;체</a></li>
				<li><a id="compTabLinkLdcc"  href="javascript:displayChangeCompTab('LDCC');">롯데정보통신</a></li>
				<li><a id="compTabLinkHit"  href="javascript:displayChangeCompTab('HIT');">현대정보기술</a></li>
			</c:when>
			<c:otherwise>
				<li style="display:none"><a id="compTabLinkAll"  href="javascript:void();" >전체</a></li>
				<li><a id="compTabLinkLdcc"  href="javascript:displayChangeCompTab('LDCC');" class="on">롯데정보통신</a></li>
				<li><a id="compTabLinkHit"  href="javascript:displayChangeCompTab('HIT');">현대정보기술</a></li>
			</c:otherwise>    
		</c:choose>
    </c:when>
    <c:when test="${compAuth == 'L'}">
		<li style="display:none"><a id="compTabLinkAll"  href="javascript:void();" >전체</a></li>
		<li><a id="compTabLinkLdcc"  href="javascript:displayChangeCompTab('LDCC');" class="on">롯데정보통신</a></li>
		<li style="display:none"><a id="compTabLinkHit"  href="javascript:displayChangeCompTab('HIT');">현대정보기술</a></li>
    </c:when>
	<c:when test="${compAuth == 'H'}">
		<li style="display:none"><a id="compTabLinkAll"  href="javascript:void();" >전체</a></li>
		<li style="display:none"><a id="compTabLinkLdcc"  href="javascript:displayChangeCompTab('LDCC');">롯데정보통신</a></li>
		<li><a id="compTabLinkHit"  href="javascript:displayChangeCompTab('HIT');"  class="on">현대정보기술</a></li>
    </c:when>
</c:choose>