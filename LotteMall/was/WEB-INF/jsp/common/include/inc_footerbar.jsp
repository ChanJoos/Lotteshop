<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<!--   
<div id="footer" style="bottom: 0;left:0;width:100%;position:fixed;">
-->
<div id="footer">
 
	<ul class="nav">
		<li><a id='footerLink1'  href="#">경영<br />정보</a></li>
		<li><a id='footerLink2'  href="#">영업<br />정보</a></li>
		<li><a id='footerLink0'  href="#" class="home"><img src="/phone/images/common/btn_home.png" alt="홈으로 이동" /></a></li>
		<li><a id='footerLink3'  href="#">프로젝트<br />정보 </a></li>
		<li><a id='footerLink4'  href="#">장애<br />정보</a></li>
	</ul>
</div>
<script>

/*상단 마진을 넣어본다.*/




var FooterMenus = {
		list:{
			menuIDs:[]
			,menuOBJs:{}
		}
		,show:function( bcd ){
			if ($('#wrapPop').length == 0) { // .modal_overlay exists
				$('body').append(  this.getDialogString(bcd) );		
			}
			var popObj = $('#MENU_DK');
	        var style = "width:65.08em;";
	        popObj.attr("style",style);
			
			var objWidth = popObj.outerWidth();
			var objHeight = popObj.outerHeight();

	        var iHeight = ( ( $(window).height() - popObj.outerHeight()  ) / 2 ) + $(window).scrollTop();
	        var iWidth =  ( ( $(window).width() - popObj.outerWidth()  ) / 2 ) + $(window).scrollLeft();

	        $.blockUI({ message: popObj,css:{width:"65.08em",left:iWidth,top:iHeight}});

			 /* 메뉴창 닫기 */
			 $("#MENU_POPUP_CLOSE").click(function(){
				 FooterMenus.close( bcd );
			 }); 
		}
		,getDialogString:function(bcd){
			//{bnm}
			var mobj = this.list.menuOBJs[bcd];
			var list = [];
			
			for( var i = 0 ; i < mobj.list.length ; i++ ){
				var tmp = this.body.list.split("{slink}").join( mobj.list[i].slink  )
				                                     .split("{sname}").join( mobj.list[i].sname );
				list.push( tmp );
			}
			var tmpFrame = this.body.frame;
			
			tmpFrame = tmpFrame.split("{bnm}").join( mobj.name  )
                                               .split("[list]").join( list.join('') );
			
			return tmpFrame;
		}
		,close:function(){
			//레이어팝업닫기		
			$('#MENU_POPUP').remove();
			$('#MENU_DK').remove();
			/* 화면닫을때 호출 */
			$.unblockUI();
		}
		,body:{
			frame:( "<div ID=\"MENU_POPUP\"><div ID=\"MENU_DK\" class=\"layer_Pop\"><h1 style=\"text-align:left\">{bnm}</h1>	<div class=\"layout1\"><ul class=\"menu_list\" style=\"text-align:left\">[list]</ul></div>	<a href=\"#\" ID='MENU_POPUP_CLOSE' class=\"btn_close\"><img src=\"/phone/images/common/btn_pop_close.png\" alt=\"닫기\" /></a></div></div>")
			,list:( "<li><a href=\"{slink}\">{sname}</a></li>")
		}
};
/*
FooterMenus.list.menuIDs.push( "1000" );
FooterMenus.list.menuIDs.push( "2000" );
FooterMenus.list.menuIDs.push( "3000" );
FooterMenus.list.menuIDs.push( "4000" );
FooterMenus.list.menuOBJs[ "1000"] = {name:"경영정보",list:[]};
FooterMenus.list.menuOBJs[ "2000"] = {name:"영업정보",list:[]};
FooterMenus.list.menuOBJs[ "3000"] = {name:"프로젝트정보",list:[]};
FooterMenus.list.menuOBJs[ "4000"] = {name:"프로젝트정보",list:[]};

var bmenu = FooterMenus.list.menuOBJs[ "1000"];
bmenu.list.push({sname:"경영현황",slink:"/phone/mgmt/stat/mgmt_rslt/goList.moDetail"});
bmenu.list.push({sname:"주가현황",slink:"/phone/mgmt/stat/stock/goList.moMain"});

bmenu = FooterMenus.list.menuOBJs[ "2000"];
bmenu.list.push({sname:"부문별실적",slink:"/phone/busi/sell/busi_rslt/goList.moDetail"});
bmenu.list.push({sname:"사업기회",slink:"/phone/busi/act/busi_opp/busi_opp_group.moDetail"});
bmenu.list.push({sname:"재고/채권현황",slink:"/phone/busi/crd/creditstat/division_list.moDetail  "});


bmenu = FooterMenus.list.menuOBJs[ "3000"];
bmenu.list.push({sname:"프로젝트현황",slink:"/phone/pjt/stat/pjtStat/goList.moDetail"});


 bmenu = FooterMenus.list.menuOBJs[ "4000"];
bmenu.list.push({sname:"장애현황",slink:"/phone/oper/stat/trouble/goMain.moMain"});
*/



//for 빅메뉴

<c:forEach var="info" items="${bmenulist}" varStatus="status">
FooterMenus.list.menuIDs.push( "${info.LV1_CD}" );
FooterMenus.list.menuOBJs[ "${info.LV1_CD}"] = {name:"${info.LV1_NM}",list:[]};
</c:forEach>

//for 서부메뉴

<c:forEach var="info" items="${smenulist}" varStatus="status">
var bmenu = FooterMenus.list.menuOBJs[ "${info.LV1_CD}"];
bmenu.list.push({sname:"${info.LV2_NM}",slink:"${info.MENU_LINK}"});
</c:forEach>

/*홈*/
$("#footerLink0").click(function(){
	location.href ="/phone/main.moMain";
});
/*경영정보*/
$("#footerLink1").click(function(){
	FooterMenus.show('1000');
});
/*영업정보*/
$("#footerLink2").click(function(){
	FooterMenus.show('2000');
});
/*프로잭트정보*/   
$("#footerLink3").click(function(){
	FooterMenus.show('3000');
});
/*장애정보*/
 $("#footerLink4").click(function(){
	 FooterMenus.show('4000');
 }); 
</script>