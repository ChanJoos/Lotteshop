<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>

<script src="/fis/common/js/jquery/rateyo/jquery.rateyo.js"></script>
<script type="text/javascript">

	$(document).ready(init);
	//TO CONTROLLER
	var MOJSON_SURVEYRATING = "/fis/rating/survey/surveyRating.moJson";
	var MOJSON_OPENSURVEYFORM = "/fis/rating/survey/openSurveyForm.moJson";
	var MOJSON_GETRATING = "/fis/rating/survey/getRating.moJson";
	var MOJSON_BESTGRADE = "/fis/rating/survey/bestGrade.moJson";
	var rateYo = [];
	
	function init() {
		
		var date = new Date();
		var m = date.getMonth();
		var day = date.getDate();
		
		//월일 표시
		document.getElementById("today").innerHTML = (m+1) +"월"+ (day) +"일";
		
		fn_getTodayRating(); //금일 평점 가져오기

        rateYo = [$("#rateBf"), $("#rateLc"),$("#rateL2"),$("#rateDn")];
		
        window.onresize = function() { 
			resizeStarRating(); 
		};
	}

	// 리사이즈가 변화에 따라 한 번만 실행되도록 mode 값 활용
	var mode = null; // 0이면 PC 상태, 1이면 MOBILE 상태
	
	function setResizeMode() {
		if ($(window).width() >= 768) {
			mode = 0;
		}
		else {
			mode = 1;
		}
	}
	
	function resizeStarRating() {
		
		setResizeMode();
		
		if ($(window).width() >= 768) {
			
			var old_mode = mode;
            mode = 1;
			if(old_mode != mode) {
				var i;
				for (i = 0; i< 4 ; i++)	rateYo[i].rateYo("option", "starWidth", "30px"); //returns a jQuery Element
	       		
	       		$('.jq-ry-container').each(function(){
					$(this).css({
				    	'margin': '0 auto'
				    });
				});
	       		fn_resizeHead('30px');
	       		fn_resizeRatingTable('26px');
	       		fn_resizeRatingSpan('24px');
			}
       		
		} 
		else {
			
			var old_mode = mode;
            mode = 0;
			if(old_mode != mode) {
				var i;
				for (i = 0; i< 4 ; i++)	rateYo[i].rateYo("option", "starWidth", "4px"); //returns a jQuery Element
	       		
	       		$('.jq-ry-container').each(function(){
					$(this).css({
				    	'margin': '0 auto'
				    });
				});
	       		fn_resizeHead('14px');
	       		fn_resizeRatingTable('12px');
	       		fn_resizeRatingSpan('10px');
			}
   		}
	}
	
	function fn_resizeRatingSpan(size) {
		$('#bf_col p').css('fontSize', size);
		$('#lc_col p').css('fontSize', size);
		$('#l2_col p').css('fontSize', size);
		$('#dn_col p').css('fontSize', size);
		$('#best_rating p').css('fontSize', size);
	}
	
	function fn_resizeRatingTable(size) {
		$('#table_rating').css('fontSize', size);
		$('#table_best_rating').css('fontSize', size);
	}
	
	function fn_resizeHead(size) {
		$('#today').css('fontSize', size);
		$('#thisMonth').css('fontSize', size);
	}
	
	//평가입력버튼 클릭시
	function fn_toSurvey() {
		try {
			callJson(MOJSON_SURVEYRATING, null, fnNmGetter().name);
		} catch (Exception) {
			log.error("menu", e);
			System.out.println(e);
		}
	}

	function callBack_$fn_toSurvey(response , status ){
        if (response.SUCCESS != "true") {
            alert("오늘 식단 미제공");
		 } else {
			 //식단 제공시 surveyForm 띄우기
			 var  SurveyURL = MOJSON_OPENSURVEYFORM;
			 document.location.href = SurveyURL;
		 }
		
	}
	
	//금일 평점 가져오기
	function fn_getTodayRating() {
		try {
			callJson(MOJSON_GETRATING, null, fnNmGetter().name);
		} catch (Exception) {
			log.error("menu", e);
			System.out.println(e);
		}
	}

	//금일 평점 가져오기
	function callBack_$fn_getTodayRating(response , status ){
		if( response.SUCCESS != "true"){
			alert(response.ERR_MSG);
			return;
		} else {
			if( response.data != undefined || response.table!= undefined ){
				var list = response.table.mySheet.rows;
				var totalCount = response.table.mySheet.totalCount;
				var i,j;
				var length;
				for(i=0; i < totalCount; i++) {
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
						text_bf_menu[7] = document.createTextNode(list[i].MENU7); text_bf_menu[8] = document.createTextNode(list[i].MENU8); text_bf_menu[9] = document.createTextNode(list[i].MENU9);
						
						for(j=1; j<=length; j++) {
							node_bf_menu[j] = document.createElement("span");
							br_bf_menu[j] = document.createElement("br");
							
							node_bf_menu[j].appendChild(text_bf_menu[j]);
							document.getElementById("bf_menu").appendChild(node_bf_menu[j]);
							document.getElementById("bf_menu").appendChild(br_bf_menu[j]);
						}
						
						if (length >= 1 && list[i].AVG) { 
							//평점 그리기
							var div_bf_avg = document.createElement("div");
							div_bf_avg.setAttribute('id','rateBf');
							var p_bf_avg = document.createElement("p");
							var text_bf_avg = document.createTextNode(list[i].AVG);
							p_bf_avg.appendChild(text_bf_avg);
							document.getElementById("bf_col").appendChild(div_bf_avg);
							document.getElementById("bf_col").appendChild(p_bf_avg);
							
							//별점 기능 삽입
							$(function() {
								$("#rateBf").rateYo({
									precision: 2,
									readOnly: true,
									rating: list[i].AVG
								});
							});
						}
					} else if(list[i].CARTE_TYPE == 'LC') {
						var node_lc_menu = [];
						var br_lc_menu = [];
						var text_lc_menu= [];
						//메뉴 그리기
						text_lc_menu[1] = document.createTextNode(list[i].MENU1); text_lc_menu[2] = document.createTextNode(list[i].MENU2); text_lc_menu[3] = document.createTextNode(list[i].MENU3);
						text_lc_menu[4] = document.createTextNode(list[i].MENU4); text_lc_menu[5] = document.createTextNode(list[i].MENU5); text_lc_menu[6] = document.createTextNode(list[i].MENU6);
						text_lc_menu[7] = document.createTextNode(list[i].MENU7); text_lc_menu[8] = document.createTextNode(list[i].MENU8); text_lc_menu[9] = document.createTextNode(list[i].MENU9);
						
						for(j=1; j<=length; j++) {
							node_lc_menu[j] = document.createElement("span");
							br_lc_menu[j] = document.createElement("br");
							
							node_lc_menu[j].appendChild(text_lc_menu[j]);
							document.getElementById("lc_menu").appendChild(node_lc_menu[j]);
							document.getElementById("lc_menu").appendChild(br_lc_menu[j]);
						}
						
						if (length >= 1 && list[i].AVG) { 
							//평점 그리기
							var div_lc_avg = document.createElement("div");
							var p_lc_avg = document.createElement("p");
							var text_lc_avg = document.createTextNode(list[i].AVG);
							
							div_lc_avg.setAttribute('id','rateLc');
							p_lc_avg.appendChild(text_lc_avg);
							document.getElementById("lc_col").appendChild(div_lc_avg);
							document.getElementById("lc_col").appendChild(p_lc_avg);
							
							//별점 기능 삽입
							$(function() {
								$("#rateLc").rateYo({
									precision: 2,
									readOnly: true,
									rating: list[i].AVG
								});
							});
						}
					} else if(list[i].CARTE_TYPE == 'DN') {
						var node_dn_menu = [];
						var br_dn_menu = [];
						var text_dn_menu= [];
						
						//메뉴 그리기
						text_dn_menu[1] = document.createTextNode(list[i].MENU1); text_dn_menu[2] = document.createTextNode(list[i].MENU2); text_dn_menu[3] = document.createTextNode(list[i].MENU3);
						text_dn_menu[4] = document.createTextNode(list[i].MENU4); text_dn_menu[5] = document.createTextNode(list[i].MENU5); text_dn_menu[6] = document.createTextNode(list[i].MENU6);
						text_dn_menu[7] = document.createTextNode(list[i].MENU7); text_dn_menu[8] = document.createTextNode(list[i].MENU8); text_dn_menu[9] = document.createTextNode(list[i].MENU9);
						
						for(j=1; j<=length; j++) {
							node_dn_menu[j] = document.createElement("span");
							br_dn_menu[j] = document.createElement("br");
							
							node_dn_menu[j].appendChild(text_dn_menu[j]);
							document.getElementById("dn_menu").appendChild(node_dn_menu[j]);
							document.getElementById("dn_menu").appendChild(br_dn_menu[j]);
						}
						
						if (length >= 1 && list[i].AVG) { 
							//평점 그리기
							var div_dn_avg = document.createElement("div");
							var p_dn_avg = document.createElement("p");
							var text_dn_avg = document.createTextNode(list[i].AVG);
							
							div_dn_avg.setAttribute('id','rateDn');
							p_dn_avg.appendChild(text_dn_avg);
							document.getElementById("dn_col").appendChild(div_dn_avg);
							document.getElementById("dn_col").appendChild(p_dn_avg);
							
							//별점 기능 삽입
							$(function() {
								$("#rateDn").rateYo({
									precision: 2,
									readOnly: true,
									rating: list[i].AVG
								});
							});
						}
					} else if(list[i].CARTE_TYPE == 'L2') {
						//점심 2종류일경우 
						var visibility = document.getElementById("tbl_l2");
						visibility.setAttribute("class", "visible");
						
						var node_l2_menu = [];
						var br_l2_menu = [];
						var text_l2_menu= [];
						
						//메뉴 그리기
						text_l2_menu[1] = document.createTextNode(list[i].MENU1); text_l2_menu[2] = document.createTextNode(list[i].MENU2); text_l2_menu[3] = document.createTextNode(list[i].MENU3);
						text_l2_menu[4] = document.createTextNode(list[i].MENU4); text_l2_menu[5] = document.createTextNode(list[i].MENU5); text_l2_menu[6] = document.createTextNode(list[i].MENU6);
						text_l2_menu[7] = document.createTextNode(list[i].MENU7); text_l2_menu[8] = document.createTextNode(list[i].MENU8); text_l2_menu[9] = document.createTextNode(list[i].MENU9);
						
						
						
						for(j=1; j<=length; j++) {
							node_l2_menu[j] = document.createElement("span");
							br_l2_menu[j] = document.createElement("br");
							
							node_l2_menu[j].appendChild(text_l2_menu[j]);
							document.getElementById("l2_menu").appendChild(node_l2_menu[j]);
							document.getElementById("l2_menu").appendChild(br_l2_menu[j]);
						}
						
						//평점 그리기
						if (length >= 1 && list[i].AVG) {
							var div_l2_avg = document.createElement("div");
							div_l2_avg.setAttribute('id','rateL2');
							var p_l2_avg = document.createElement("p");
							var text_l2_avg = document.createTextNode(list[i].AVG);
							p_l2_avg.appendChild(text_l2_avg);
							document.getElementById("l2_col").appendChild(div_l2_avg);
							document.getElementById("l2_col").appendChild(p_l2_avg);
							
							//별점 기능 삽입
							$(function() {
								$("#rateL2").rateYo({
									precision: 2,
									readOnly: true,
									rating: list[i].AVG
								});
							});
						}
					}//end of if else
				}//end of for
			} else {
				alert("response.data 정의 안됨 ");
			}
			resizeStarRating();
			return fn_bestGrade();
		}
	}//End callBack_$fn_getTodayRating
	
	//베스트 식단 조회
	function fn_bestGrade() {
		try {
			callJson(MOJSON_BESTGRADE, null, fnNmGetter().name);
		} catch (Exception) {
			log.error("menu", e);
			System.out.println(e);
		}
	}

	function callBack_$fn_bestGrade(response , status ){
		if( response.SUCCESS != "true"){
			alert(response.ERR_MSG);
			return;
		} else {
			if( response.data != undefined || response.table!= undefined ){

				var list = response.table.mySheet.rows;
				var j;
				var node_menu = [];
				var br_menu = [];
				var text_menu= [];
				var node_type = document.createElement("span");
				var length=9;
				
				if(list[0].MENU9 ==null || list[0].MENU9 =="") length = 8;	if(list[0].MENU8 ==null || list[0].MENU8 =="") length = 7;	if(list[0].MENU7 ==null || list[0].MENU7 =="") length = 6;
				if(list[0].MENU6 ==null || list[0].MENU6 =="") length = 5;	if(list[0].MENU5 ==null || list[0].MENU5 =="") length = 4;	if(list[0].MENU4 ==null || list[0].MENU4 =="") length = 3;
				if(list[0].MENU3 ==null || list[0].MENU3 =="") length = 2;	if(list[0].MENU2 ==null || list[0].MENU2 =="") length = 1;	if(list[0].MENU1 ==null || list[0].MENU1 =="") length = 0;
				
				//메뉴 그리기
				text_menu[1] = document.createTextNode(list[0].MENU1);
				text_menu[2] = document.createTextNode(list[0].MENU2);
				text_menu[3] = document.createTextNode(list[0].MENU3);
				text_menu[4] = document.createTextNode(list[0].MENU4);
				text_menu[5] = document.createTextNode(list[0].MENU5);
				text_menu[6] = document.createTextNode(list[0].MENU6);
				text_menu[7] = document.createTextNode(list[0].MENU7);
				text_menu[8] = document.createTextNode(list[0].MENU8);
				text_menu[9] = document.createTextNode(list[0].MENU9);
			
				for(j=1; j<=length; j++) {
					node_menu[j] = document.createElement("span");
					br_menu[j] = document.createElement("br");
					
					node_menu[j].appendChild(text_menu[j]);
					document.getElementById("best_menu").appendChild(node_menu[j]);
					document.getElementById("best_menu").appendChild(br_menu[j]);
				}
				
				var yyyymmdd =  list[0].DATE;
				var mm;
				var dd;
				
				//형식전환: 20160106 -> 1월 6일 
				if( yyyymmdd.substring(4, 5) == "0" ) {
					mm= yyyymmdd.substring(5, 6) + "월";
				} else {
					mm=yyyymmdd.substring(4, 6) + "월";
				}
				if( yyyymmdd.substring(6, 7) == "0" ) {
					dd= yyyymmdd.substring(7, 8) + "일";
				} else {
					dd=yyyymmdd.substring(6, 8) + "일";
				}

				var text_type;
				switch(list[0].CARTE_TYPE) {
					case 'BF' : text_type = document.createTextNode(mm+dd+"아침"); break;
					case 'LC' : text_type = document.createTextNode(mm+dd+"점심"); break;
					case 'DN' : text_type = document.createTextNode(mm+dd+"저녁"); break;
					case 'L2' : text_type = document.createTextNode(mm+dd+"점심(2)"); break;
					default : text_type = document.createTextNode("없음"); break;
				}
				//타입을 월일에 붙이기
				node_type.appendChild(text_type);
				document.getElementById("best_type").appendChild(node_type);
		
				
				
				//평점 그리기 
				var div_avg = document.createElement("div");
				var p_avg = document.createElement("p");
				var text_avg = document.createTextNode(list[0].AVG);
				
				div_avg.setAttribute('id','rateBest');
				p_avg.appendChild(text_avg);
				document.getElementById("best_rating").appendChild(div_avg);
				document.getElementById("best_rating").appendChild(p_avg);
				
				//별점 기능 삽입
				$(function() {
					$("#rateBest").rateYo({
						precision: 2,
						readOnly: true,
						rating: list[0].AVG
					});
				});
			} else {
				alert("response.data 정의 안됨 ");
			}
			resizeStarRating();
		}
	}//End callBack_$fn_bestGrade
	
</script>