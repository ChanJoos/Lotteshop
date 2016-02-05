<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>

<script language="javascript">
	$(document).ready(init);
	
	//TO CONTROLLER
	var MOJSON_GETTODAYMENU = "/fis/rating/survey/getTodayMenu.moJson";
	var MOJSON_CHECKHISTORY = "/fis/rating/survey/checkHistory.moJson";
	var MOJSON_SUBMITRATING = "/fis/rating/survey/submitRating.moJson";
	
    function init() {
        var date2 = new Date();
        var m2 = date2.getMonth();
        var day2= date2.getDate();
        
        getTodayMenu(); //금일메뉴 불러오기
        haveSurveyed(); //사용자의 기록여부 확인
        
        //월일 표시
        document.getElementById("today2").innerHTML = (m2+1) +"월 "+ (day2) +"일";
        clickSaveButton();
	}

    //금일메뉴 불러오기
    function getTodayMenu() {
    	callJson( MOJSON_GETTODAYMENU , null, fnNmGetter().name);
    	
    }
    
    function callBack_$getTodayMenu(response, status) {                    
        if (response.SUCCESS != "true") {
       		alert("실패" + response.ERR_MSG);
        } else if(response.table== undefined || response.table.mySheet.totalCount == 0  ) {
//        	alert("오늘 메뉴 없음");
        } else {
        	var list = null;
			list = response.table.mySheet.rows;
			totalCount = response.table.mySheet.totalCount;
			
			var i, j;
			var length;
			for(i=0; i<totalCount; i++) {
				length=9;
				if(list[i].MENU9 ==null || list[i].MENU9 =="") length = 8;	if(list[i].MENU8 ==null || list[i].MENU8 =="") length = 7;	if(list[i].MENU7 ==null || list[i].MENU7 =="") length = 6;
				if(list[i].MENU6 ==null || list[i].MENU6 =="") length = 5;	if(list[i].MENU5 ==null || list[i].MENU5 =="") length = 4;	if(list[i].MENU4 ==null || list[i].MENU4 =="") length = 3;
				if(list[i].MENU3 ==null || list[i].MENU3 =="") length = 2;	if(list[i].MENU2 ==null || list[i].MENU2 =="") length = 1;	if(list[i].MENU1 ==null || list[i].MENU1 =="") length = 0;
			
				if(list[i].CARTE_TYPE == 'BF') {
					var node_bf_menu = [];
					var br_bf_menu = [];
					var text_bf_menu= [];
					
					//메뉴 그리기
					text_bf_menu[1] = document.createTextNode(list[i].MENU1); text_bf_menu[2] = document.createTextNode(list[i].MENU2); text_bf_menu[3] = document.createTextNode(list[i].MENU3);
					text_bf_menu[4] = document.createTextNode(list[i].MENU4); text_bf_menu[5] = document.createTextNode(list[i].MENU5); text_bf_menu[6] = document.createTextNode(list[i].MENU6);
					text_bf_menu[7] = document.createTextNode(list[i].MENU7); text_bf_menu[8] = document.createTextNode(list[i].MENU8);	text_bf_menu[9] = document.createTextNode(list[i].MENU9);
					
					if (length <= 1) 
						document.getElementById("bf_select").setAttribute("class", "hidden");
					
					for(j=1; j<=length; j++) {
						node_bf_menu[j] = document.createElement("span");
						br_bf_menu[j] = document.createElement("br");
						
						node_bf_menu[j].appendChild(text_bf_menu[j]);
						document.getElementById("bf_menu").appendChild(node_bf_menu[j]);
						document.getElementById("bf_menu").appendChild(br_bf_menu[j]);
					}
				} else if(list[i].CARTE_TYPE == 'LC') {
					var node_lc_menu = [];
					var br_lc_menu = [];
					var text_lc_menu= [];
					//메뉴 그리기
					text_lc_menu[1] = document.createTextNode(list[i].MENU1);	text_lc_menu[2] = document.createTextNode(list[i].MENU2);	text_lc_menu[3] = document.createTextNode(list[i].MENU3);
					text_lc_menu[4] = document.createTextNode(list[i].MENU4);	text_lc_menu[5] = document.createTextNode(list[i].MENU5);	text_lc_menu[6] = document.createTextNode(list[i].MENU6);
					text_lc_menu[7] = document.createTextNode(list[i].MENU7);	text_lc_menu[8] = document.createTextNode(list[i].MENU8);	text_lc_menu[9] = document.createTextNode(list[i].MENU9);
					
					if (length <= 1) 
						document.getElementById("lc_select").setAttribute("class", "hidden");
					
					for(j=1; j<=length; j++) {
						node_lc_menu[j] = document.createElement("span");
						br_lc_menu[j] = document.createElement("br");
						
						node_lc_menu[j].appendChild(text_lc_menu[j]);
						document.getElementById("lc_menu").appendChild(node_lc_menu[j]);
						document.getElementById("lc_menu").appendChild(br_lc_menu[j]);
					}
					
				} else if(list[i].CARTE_TYPE == 'DN') {
					var node_dn_menu = [];
					var br_dn_menu = [];
					var text_dn_menu= [];
					//메뉴 그리기
					text_dn_menu[1] = document.createTextNode(list[i].MENU1); text_dn_menu[2] = document.createTextNode(list[i].MENU2); text_dn_menu[3] = document.createTextNode(list[i].MENU3);
					text_dn_menu[4] = document.createTextNode(list[i].MENU4); text_dn_menu[5] = document.createTextNode(list[i].MENU5); text_dn_menu[6] = document.createTextNode(list[i].MENU6);
					text_dn_menu[7] = document.createTextNode(list[i].MENU7); text_dn_menu[8] = document.createTextNode(list[i].MENU8); text_dn_menu[9] = document.createTextNode(list[i].MENU9);
					
					if (length <= 1) 
						document.getElementById("dn_select").setAttribute("class", "hidden");
					
					for(j=1; j<=length; j++) {
						node_dn_menu[j] = document.createElement("span");
						br_dn_menu[j] = document.createElement("br");
						
						node_dn_menu[j].appendChild(text_dn_menu[j]);
						document.getElementById("dn_menu").appendChild(node_dn_menu[j]);
						document.getElementById("dn_menu").appendChild(br_dn_menu[j]);
					}
				} else if(list[i].CARTE_TYPE == 'L2') {
					//중식메뉴 2가지 일경우 hidden -> visible 전환
			      	var visible = document.getElementById("tbl_lc2");
			      	visible.setAttribute("class", "visible");
			      	
					var node_l2_menu = [];
					var br_l2_menu = [];
					var text_l2_menu= [];
					
					//메뉴 그리기
					text_l2_menu[1] = document.createTextNode(list[i].MENU1); text_l2_menu[2] = document.createTextNode(list[i].MENU2); text_l2_menu[3] = document.createTextNode(list[i].MENU3);
					text_l2_menu[4] = document.createTextNode(list[i].MENU4); text_l2_menu[5] = document.createTextNode(list[i].MENU5); text_l2_menu[6] = document.createTextNode(list[i].MENU6);
					text_l2_menu[7] = document.createTextNode(list[i].MENU7); text_l2_menu[8] = document.createTextNode(list[i].MENU8); text_l2_menu[9] = document.createTextNode(list[i].MENU9);
					
					if (length <= 1) 
						document.getElementById("l2_select").setAttribute("class", "hidden");
					
					for(j=1; j<=length; j++) {
						node_l2_menu[j] = document.createElement("span");
						br_l2_menu[j] = document.createElement("br");
						
						node_l2_menu[j].appendChild(text_l2_menu[j]);
						document.getElementById("l2_menu").appendChild(node_l2_menu[j]);
						document.getElementById("l2_menu").appendChild(br_l2_menu[j]);
					}
				}
			} //end of for
        }
	} //end of callBack_$getTodayMenu
    
    //사용자의 기록여부 확인
    function haveSurveyed() {
    	callJson(MOJSON_CHECKHISTORY, null, fnNmGetter().name);
    	
    }
    
    function callBack_$haveSurveyed(response, status) {        
        if (response.SUCCESS != "true") {
       		alert("실패" + response.ERR_MSG);
       		
        } else if(response.table== undefined || response.table.mySheet.totalCount == 0  ) {
//        	alert("금일 기록 이력없음");
        	
        } else {
//        	alert("이전에 기록한 데이터 불러옵니다.");	
        	
        	var list = null;
			list = response.table.mySheet.rows;
			totalCount = response.table.mySheet.totalCount;

			var i;
			for( i=0; i < totalCount ; i++) {
				switch(list	[i].CARTE_TYPE ) {
					case 'BF' :
						//평점 그리기 
						var changeToUnselected = document.getElementById("bf_blk");
						changeToUnselected.setAttribute("selected", "unselected");
						var changeToSelected = document.getElementById("bf_"+list[i].GRADE);
						changeToSelected.setAttribute("selected", "selected");
						break;
					case 'LC' :
						//평점 그리기 
						var changeToUnselected = document.getElementById("lc_blk");
						changeToUnselected.setAttribute("selected", "unselected");
						var changeToSelected = document.getElementById("lc_"+list[i].GRADE);
						changeToSelected.setAttribute("selected", "selected");
						break;
					case 'DN' :
						//평점 그리기
						var changeToUnselected = document.getElementById("dn_blk");
						changeToUnselected.setAttribute("selected", "unselected");
						var changeToSelected = document.getElementById("dn_"+list[i].GRADE);
						changeToSelected.setAttribute("selected", "selected");
						break;
					case 'L2' :
						//평점 그리기 
						var changeToUnselected = document.getElementById("l2_blk");
						changeToUnselected.setAttribute("selected", "unselected");
						if (list[i].GRADE == 0 )  continue;
						var changeToSelected = document.getElementById("l2_"+list[i].GRADE);
						changeToSelected.setAttribute("selected", "selected");
						break;
					default:
						break;
				}
			} //end of for	
        } 
	} //end of callBack_$haveSurveyed
	
	//평점 기록
    function doInputRating() {
        var formObj = $("form[role='surveyRating']").serialize();
        
        callJson(MOJSON_SUBMITRATING, formObj, fnNmGetter().name);
	}

    function callBack_$doInputRating(response, status) {                    
        if (response.SUCCESS != "true") {
                   alert("실패: 점심은 한 가지만 입력해야합니다.");
        } else {
//                   alert("기록 성공");
        }
	}

    //저장버튼 기능 추가
	function clickSaveButton() {
	        $("#bt_save").click(function() {
	                   doInputRating();
	        });
	}

</script>


</body>
</html>