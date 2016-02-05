<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>

	<script src="/fis/common/js/jquery/rateyo/jquery.rateyo.js"></script>
	
	<script language="javascript"> 
		$(document).ready(init);
		
		//TO CONTROLLER
		var MOJSON_WEEKGRADE = "/fis/rating/survey/weekGrade.moJson";
		var MOJSON_GETSELECTEDDAY = "/fis/rating/survey/getSelectedDay.moJson";
		
		// 이전 week이면 1씩 증가, 현재는 0
		var currentWeek = 0;
		var element = [];
		var rateYo = [];
		function init() {
			window.onload = function() { 
				resizeStarRating(); 
			};
			var date = new Date();
			var m = date.getMonth();
			var day = date.getDate();
			element = [document.getElementById("monBf"), document.getElementById("monLc"), document.getElementById("monDn"), document.getElementById("monL2"), 
		                document.getElementById("tueBf"), document.getElementById("tueLc"), document.getElementById("tueDn"), document.getElementById("tueL2"), 
		                document.getElementById("wedBf"), document.getElementById("wedLc"), document.getElementById("wedDn"), document.getElementById("wedL2"), 
		                document.getElementById("thuBf"), document.getElementById("thuLc"), document.getElementById("thuDn"), document.getElementById("thuL2"), 
		                document.getElementById("friBf"), document.getElementById("friLc"), document.getElementById("friDn"), document.getElementById("friL2")];
			
			rateYo = [$("#rateMonBf"),$("#rateMonLc"),$("#rateMonL2"),$("#rateMonDn"), 
			          $("#rateTueBf"),$("#rateTueLc"),$("#rateTueL2"),$("#rateTueDn"),
			          $("#rateWedBf"),$("#rateWedLc"),$("#rateWedL2"),$("#rateWedDn"),
			          $("#rateThuBf"),$("#rateThuLc"),$("#rateThuL2"),$("#rateThuDn"),
			          $("#rateFriBf"),$("#rateFriLc"),$("#rateFriL2"),$("#rateFriDn")];
			fn_setWeek(); //주 셋팅
			fn_weekGrade(); //주별 조회
			fn_setEvent(); //이벤트 삽입
			
			window.onresize = function() { 
				resizeStarRating(); 
			};
		}
		
		// 리사이즈가 변화에 따라 한 번만 실행되도록 mode 값 활용
		var mode = null; // 1이면 PC 상태, 0이면 MOBILE 상태
		
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
					for (i = 0; i< 20 ; i++)	rateYo[i].rateYo("option", "starWidth", "30px"); //returns a jQuery Element
		       		
		       		$('.jq-ry-container').each(function(){
						$(this).css({
					    	'margin': '0 auto'
					    });
					});
		       		fn_resizeHead('26px');
		       		fn_resizeTable('22px');
		       		fn_resizeRatingSpan('20px');
				}
	       		
			} else {
				
				var old_mode = mode;
	            mode = 0;
				if(old_mode != mode) {
					var i;
					for (i = 0; i< 20 ; i++)	rateYo[i].rateYo("option", "starWidth", "10px"); //returns a jQuery Element
		       		
		       		$('.jq-ry-container').each(function(){
						$(this).css({
					    	'margin': '0 auto'
					    });
					});
		       		fn_resizeHead('14px');
		       		fn_resizeTable('12px');
		       		fn_resizeRatingSpan('10px');
				}
	   		}
		}
		function fn_resizeHead(size) {
			$('#thisweek').css('fontSize', size);	$('#selected_menu').css('fontSize', size); $('#textWeek').css('fontSize', size);
		}
		function fn_resizeTable(size) {
			$('#table_rating').css('fontSize', size);	$('#selectedMenu').css('fontSize', size);
		}
		function fn_resizeRatingSpan(size) {
			$('#monBf p').css('fontSize', size);	$('#monLc p').css('fontSize', size);	$('#monL2 p').css('fontSize', size);	$('#monDn p').css('fontSize', size);
			$('#tueBf p').css('fontSize', size);	$('#tueLc p').css('fontSize', size);	$('#tueL2 p').css('fontSize', size);	$('#tueDn p').css('fontSize', size);
			$('#wedBf p').css('fontSize', size);	$('#wedLc p').css('fontSize', size);	$('#wedL2 p').css('fontSize', size);	$('#wedDn p').css('fontSize', size);
			$('#thuBf p').css('fontSize', size);	$('#thuLc p').css('fontSize', size);	$('#thuL2 p').css('fontSize', size);	$('#thuDn p').css('fontSize', size);
			$('#friBf p').css('fontSize', size);	$('#friLc p').css('fontSize', size);	$('#friL2 p').css('fontSize', size);	$('#friDn p').css('fontSize', size);
		}
		
		function fn_setWeek() {
			var textWeek = document.getElementById("textWeek");
			while (textWeek.firstChild) {
				textWeek.removeChild( textWeek.firstChild );
			}
			switch (currentWeek) {
			case 0:
				textWeek.appendChild(  document.createElement("p").appendChild( document.createTextNode("이번 주"))  ); break;
			case 1:
				textWeek.appendChild(  document.createElement("p").appendChild( document.createTextNode("1주 전"))  ); break;
			case 2:
				textWeek.appendChild(  document.createElement("p").appendChild( document.createTextNode("2주 전"))  ); break;
			case 3:
				textWeek.appendChild(  document.createElement("p").appendChild( document.createTextNode("3주 전"))  ); break;
			default :
				break;
				
			} 
		}
		function fn_setEvent() {
			
			$("#nextWeek").click(function() {
				if(currentWeek !=0) {
					currentWeek--;
  					var i;
					for (i = 0; i<20; i++) {
						if ( element[i].firstChild == null) continue;
						while (element[i].firstChild) {
							element[i].removeChild( element[i].firstChild );
						}
					}
					fn_setWeek();
					fn_weekGrade();
				}
			});
			
			$("#previousWeek").click(function() {
				if(currentWeek !=2) {
					currentWeek++;
	 				var i;
					for (i = 0; i<20; i++) {
						if ( element[i].firstChild == null) continue;
						while ( element[i].firstChild ) {
							element[i].removeChild( element[i].firstChild );
						}
					} 
					fn_setWeek();
					fn_weekGrade();
				}
			});
			
		}
	
		//주별 조회
		function fn_weekGrade() {
			//요일 함수
			Number.prototype.to2=function(){return this<10?'0'+this:this;};
			Date.prototype.get=function(){ 
			     return this.getFullYear() + (this.getMonth()+1).to2() 
			          + this.getDate().to2(); 
			};
			// 이번주 월요일: get( yoil.월 )
			function get(d,w){
			     w=(w||0)*7; 
			     var cDate = new Date(); 
			     cDate.setDate( (cDate.getDate()-w)-(cDate.getDay()-d) ); 
			     return cDate.get(); 
			};
			var yoil = {'일':0,'월':1,'화':2,'수':3,'목':4,'금':5,'토':6}; 
			
			var params = {
					selected_date : get( yoil.월, currentWeek ),
					end_date : get( yoil.금, currentWeek )
			};
			
			try {
				callJson(MOJSON_WEEKGRADE, params, fnNmGetter().name);
			} catch (Exception) {
				log.error("menu", e);
				System.out.println(e);
			}
		}
	
		function callBack_$fn_weekGrade(response , status ){
			if( response.SUCCESS != "true"){
				alert(response.ERR_MSG);
				return;
			} else if( response.table.mySheet.totalCount == 0) {
//				alert("데이터 없음");
			} else {
				if( response.data != undefined || response.table!= undefined ){
					//요일 함수
					Number.prototype.to2=function(){return this<10?'0'+this:this;};
					Date.prototype.get=function(){ 
					     return this.getFullYear() + (this.getMonth()+1).to2() 
					          + this.getDate().to2(); 
					};
					// 이번주 월요일: get( yoil.월 )
					function get(d,w){
					     w=(w||0)*7; 
					     var cDate = new Date(); 
					     cDate.setDate( (cDate.getDate()-w)-(cDate.getDay()-d) ); 
					     return cDate.get(); 
					};
					var yoil = {'일':0,'월':1,'화':2,'수':3,'목':4,'금':5,'토':6}; 
					var date = [];
					var type = {'아침':'BF', '점심':'LC', '점심2':'L2', '저녁':'DN'};
					var list = response.table.mySheet.rows;
					var totalCount = response.table.mySheet.totalCount;
					
					var i;
					for( i=0; i < totalCount ; i++) {
						date[i]=list[i].DATE;
						if ( !list[i].AVG ) continue;
						
						if( list[i].DATE == get( yoil.월 ) ||  list[i].DATE == get( yoil.월, 1) ||  list[i].DATE == get( yoil.월, 2) ||  list[i].DATE == get( yoil.월, 3)  ) {
							switch(list[i].CARTE_TYPE ) {
							case 'BF' :
								//평점 그리기
								var div_monBf_avg = document.createElement("div");
								var node_monBf = document.createElement("p");
								var text_monBf = document.createTextNode(list[i].AVG); 
								
								div_monBf_avg.setAttribute('id','rateMonBf');
								node_monBf.appendChild(text_monBf);
								document.getElementById("monBf").appendChild(div_monBf_avg);
								document.getElementById("monBf").appendChild(node_monBf);
								
								//별점 설정
								$(function() {
									$("#rateMonBf").rateYo({
										precision: 2,
										readOnly: true,
										starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동
								div_monBf_avg.addEventListener("click", function () {
									daily_menu(date[0], type.아침);
								}, false);
								node_monBf.addEventListener("click", function () {
									daily_menu(date[0], type.아침);
								}, false);
								break;
							case 'LC' :
								//평점 그리기
								var div_monLc_avg = document.createElement("div");
								var node_monLc = document.createElement("p");
								var text_monLc = document.createTextNode(list[i].AVG);
								
								div_monLc_avg.setAttribute('id','rateMonLc');
								node_monLc.appendChild(text_monLc);
								document.getElementById("monLc").appendChild(div_monLc_avg);
								document.getElementById("monLc").appendChild(node_monLc);
								
								//별점 설정
								$(function() {
									$("#rateMonLc").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_monLc_avg.addEventListener("click", function () {
									daily_menu(date[0], type.점심);
								}, false);
								node_monLc.addEventListener("click", function () {
									daily_menu(date[0], type.점심);
								}, false);
								break;
							case 'DN' :
								//평점 그리기 
								var div_monDn_avg = document.createElement("div");
								var node_monDn = document.createElement("p");
								var text_monDn = document.createTextNode(list[i].AVG);
								
								div_monDn_avg.setAttribute('id','rateMonDn');
								node_monDn.appendChild(text_monDn);
								document.getElementById("monDn").appendChild(div_monDn_avg);
								document.getElementById("monDn").appendChild(node_monDn);
								
								//별점 설정
								$(function() {
									$("#rateMonDn").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_monDn_avg.addEventListener("click", function () {
									daily_menu(date[0], type.저녁);
								}, false);
								node_monDn.addEventListener("click", function () {
									daily_menu(date[0], type.저녁);
								}, false);
								break;
							case 'L2' :
								//평점 그리기
								var visibility = document.getElementById("tbl_L2");
								var visibility_mon = document.getElementById("monL2");
								var visibility_tue = document.getElementById("tueL2");
								var visibility_wed = document.getElementById("wedL2");
								var visibility_thu = document.getElementById("thuL2");
								var visibility_fri = document.getElementById("friL2");
								
								//스타일 변경 hidden -> visible
								visibility.setAttribute("class", "visible");
								visibility_mon.setAttribute("class", "visible");
								visibility_tue.setAttribute("class", "visible");
								visibility_wed.setAttribute("class", "visible");
								visibility_thu.setAttribute("class", "visible");
								visibility_fri.setAttribute("class", "visible");
								
								var div_monL2_avg = document.createElement("div");
								var node_monL2 = document.createElement("p");
								var text_monL2 = document.createTextNode(list[i].AVG);
								
								div_monL2_avg.setAttribute('id','rateMonL2');
								node_monL2.appendChild(text_monL2);
								document.getElementById("monL2").appendChild(div_monL2_avg);
								document.getElementById("monL2").appendChild(node_monL2);
								
								//별점 설정
								$(function() {
									$("#rateMonL2").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_monL2_avg.addEventListener("click", function () {
									daily_menu(date[0], type.점심2);
								}, false);
								node_monL2.addEventListener("click", function () {
									daily_menu(date[0], type.점심2);
								}, false);
								break;
							default : break;
							}
						} else if( list[i].DATE == get( yoil.화 ) ||  list[i].DATE == get( yoil.화, 1) ||  list[i].DATE == get( yoil.화, 2)||  list[i].DATE == get( yoil.화, 3)  ) {
							switch(list[i].CARTE_TYPE ) {
							case 'BF' :
								//평점 그리기 
								var div_tueBf_avg = document.createElement("div");
								var node_tueBf = document.createElement("p");
								var text_tueBf = document.createTextNode(list[i].AVG);
								
								div_tueBf_avg.setAttribute('id','rate_tueBf');
								node_tueBf.appendChild(text_tueBf);
								document.getElementById("tueBf").appendChild(div_tueBf_avg);
								document.getElementById("tueBf").appendChild(node_tueBf);
								
								//별점 설정
								$(function() {
									$("#rate_tueBf").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_tueBf_avg.addEventListener("click", function () {
									daily_menu(date[1], type.아침);
								}, false);
								node_tueBf.addEventListener("click", function () {
									daily_menu(date[1], type.아침);
								}, false);
								break;
							case 'LC' :
								//평점 그리기 
								var div_tueLc_avg = document.createElement("div");
								var node_tueLc = document.createElement("p");
								var text_tueLc = document.createTextNode(list[i].AVG);
								
								div_tueLc_avg.setAttribute('id','rate_tueLc');
								node_tueLc.appendChild(text_tueLc);
								document.getElementById("tueLc").appendChild(div_tueLc_avg);
								document.getElementById("tueLc").appendChild(node_tueLc);
								
								//별점 설정
								$(function() {
									$("#rate_tueLc").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_tueLc_avg.addEventListener("click", function () {
									daily_menu(date[1], type.점심);
								}, false);
								node_tueLc.addEventListener("click", function () {
									daily_menu(date[1], type.점심);
								}, false);
								break;
							case 'DN' :
								//평점 그리기
								var div_tueDn_avg = document.createElement("div");
								var node_tueDn = document.createElement("p");
								var text_tueDn = document.createTextNode(list[i].AVG);
								
								div_tueDn_avg.setAttribute('id','rate_tueDn');
								node_tueDn.appendChild(text_tueDn);
								document.getElementById("tueDn").appendChild(div_tueDn_avg);
								document.getElementById("tueDn").appendChild(node_tueDn);
								
								//별점 설정
								$(function() {
									$("#rate_tueDn").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_tueDn_avg.addEventListener("click", function () {
									daily_menu(date[1], type.저녁);
								}, false);
								node_tueDn.addEventListener("click", function () {
									daily_menu(date[1], type.저녁);
								}, false);
								break;
							case 'L2' :
								//평점 그리기 
								var visibility = document.getElementById("tbl_L2");
								var visibility_mon = document.getElementById("monL2");
								var visibility_tue = document.getElementById("tueL2");
								var visibility_wed = document.getElementById("wedL2");
								var visibility_thu = document.getElementById("thuL2");
								var visibility_fri = document.getElementById("friL2");
								
								//스타일 변경 hidden -> visible
								visibility.setAttribute("class", "visible");
								visibility_mon.setAttribute("class", "visible");
								visibility_tue.setAttribute("class", "visible");
								visibility_wed.setAttribute("class", "visible");
								visibility_thu.setAttribute("class", "visible");
								visibility_fri.setAttribute("class", "visible");
								
								var div_tueL2_avg = document.createElement("div");
								var node_tueL2 = document.createElement("p");
								var text_tueL2 = document.createTextNode(list[i].AVG);
								
								div_tueL2_avg.setAttribute('id','rateTueL2');
								node_tueL2.appendChild(text_tueL2);
								document.getElementById("tueL2").appendChild(div_tueL2_avg);
								document.getElementById("tueL2").appendChild(node_tueL2);
								
								//별점 설정
								$(function() {
									$("#rateTueL2").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_tueL2_avg.addEventListener("click", function () {
									daily_menu(date[1], type.점심2);
								}, false);
								node_tueL2.addEventListener("click", function () {
									daily_menu(date[1], type.점심2);
								}, false);
								break;
							default : break;
							}
						} else if( list[i].DATE == get( yoil.수 ) ||  list[i].DATE == get( yoil.수, 1) ||  list[i].DATE == get( yoil.수, 2) ||  list[i].DATE == get( yoil.수, 3)  ) {
							switch(list[i].CARTE_TYPE ) {
							case 'BF' :
								//평점 그리기
								var div_wedBf_avg = document.createElement("div");
								var node_wedBf = document.createElement("p");
								var text_wedBf = document.createTextNode(list[i].AVG);
								
								div_wedBf_avg.setAttribute('id','rate_wedBf');
								node_wedBf.appendChild(text_wedBf);
								document.getElementById("wedBf").appendChild(div_wedBf_avg);
								document.getElementById("wedBf").appendChild(node_wedBf);
								
								//별점 설정
								$(function() {
									$("#rate_wedBf").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_wedBf_avg.addEventListener("click", function () {
									daily_menu(date[2], type.아침);
								}, false);
								node_wedBf.addEventListener("click", function () {
									daily_menu(date[2], type.아침);
								}, false);
								break;
							case 'LC' :
								//평점 그리기
								var div_wedLc_avg = document.createElement("div");
								var node_wedLc = document.createElement("p");
								var text_wedLc = document.createTextNode(list[i].AVG);
								
								div_wedLc_avg.setAttribute('id','rate_wedLc');
								node_wedLc.appendChild(text_wedLc);
								document.getElementById("wedLc").appendChild(div_wedLc_avg);
								document.getElementById("wedLc").appendChild(node_wedLc);
								
								//별점 설정
								$(function() {
									$("#rate_wedLc").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_wedLc_avg.addEventListener("click", function () {
									daily_menu(date[2], type.점심);
								}, false);
								node_wedLc.addEventListener("click", function () {
									daily_menu(date[2], type.점심);
								}, false);
								break;
							case 'DN' :
								//평점 그리기
								var div_wedDn_avg = document.createElement("div");
								var node_wedDn = document.createElement("p");
								var text_wedDn = document.createTextNode(list[i].AVG);
								
								div_wedDn_avg.setAttribute('id','rate_wedDn');
								node_wedDn.appendChild(text_wedDn);
								document.getElementById("wedDn").appendChild(div_wedDn_avg);
								document.getElementById("wedDn").appendChild(node_wedDn);
								
								//별점 설정
								$(function() {
									$("#rate_wedDn").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_wedDn_avg.addEventListener("click", function () {
									daily_menu(date[2], type.저녁);
								}, false);
								node_wedDn.addEventListener("click", function () {
									daily_menu(date[2], type.저녁);
								}, false);
								break;
							case 'L2' :
								//평점 그리기
								var visibility = document.getElementById("tbl_L2");
								var visibility_mon = document.getElementById("monL2");
								var visibility_tue = document.getElementById("tueL2");
								var visibility_wed = document.getElementById("wedL2");
								var visibility_thu = document.getElementById("thuL2");
								var visibility_fri = document.getElementById("friL2");
								
								//스타일 변경 hidden-> visible
								visibility.setAttribute("class", "visible");
								visibility_mon.setAttribute("class", "visible");
								visibility_tue.setAttribute("class", "visible");
								visibility_wed.setAttribute("class", "visible");
								visibility_thu.setAttribute("class", "visible");
								visibility_fri.setAttribute("class", "visible");
								
								var div_wedL2_avg = document.createElement("div");
								var node_wedL2 = document.createElement("p");
								var text_wedL2 = document.createTextNode(list[i].AVG);
								
								div_wedL2_avg.setAttribute('id','rateWedL2');
								node_wedL2.appendChild(text_wedL2);
								document.getElementById("wedL2").appendChild(div_wedL2_avg);
								document.getElementById("wedL2").appendChild(node_wedL2);
								
								//별점 설정
								$(function() {
									$("#rateWedL2").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});

								//메뉴 이동메뉴 이동
								div_wedL2_avg.addEventListener("click", function () {
									daily_menu(date[2], type.점심2);
								}, false);
								node_wedL2.addEventListener("click", function () {
									daily_menu(date[2], type.점심2);
								}, false);
								break;
							default : break;
							}
						} else if(list[i].DATE == get( yoil.목 ) ||  list[i].DATE == get( yoil.목, 1) ||  list[i].DATE == get( yoil.목, 2)||  list[i].DATE == get( yoil.목, 3)  ) {
							switch(list[i].CARTE_TYPE ) {
							case 'BF' :
								//평점 그리기
								var div_thuBf_avg = document.createElement("div");
								var node_thuBf = document.createElement("p");
								var text_thuBf = document.createTextNode(list[i].AVG);
								
								div_thuBf_avg.setAttribute('id','rate_thuBf');
								node_thuBf.appendChild(text_thuBf);
								document.getElementById("thuBf").appendChild(div_thuBf_avg);
								document.getElementById("thuBf").appendChild(node_thuBf);
								
								//별점 설정
								$(function() {
									$("#rate_thuBf").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_thuBf_avg.addEventListener("click", function () {
									daily_menu(date[3], type.아침);
								}, false);
								node_thuBf.addEventListener("click", function () {
									daily_menu(date[3], type.아침);
								}, false);
								break;
							case 'LC' :
								//평점 그리기
								var div_thuLc_avg = document.createElement("div");
								var node_thuLc = document.createElement("p");
								var text_thuLc = document.createTextNode(list[i].AVG);
								
								div_thuLc_avg.setAttribute('id','rate_thuLc');
								node_thuLc.appendChild(text_thuLc);
								document.getElementById("thuLc").appendChild(div_thuLc_avg);
								document.getElementById("thuLc").appendChild(node_thuLc);
								
								//별점 설정
								$(function() {
									$("#rate_thuLc").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_thuLc_avg.addEventListener("click", function () {
									daily_menu(date[3], type.점심);
								}, false);
								node_thuLc.addEventListener("click", function () {
									daily_menu(date[3], type.점심);
								}, false);
								break;
							case 'DN' :
								//평점 그리기 
								var div_thuDn_avg = document.createElement("div");
								var node_thuDn = document.createElement("p");
								var text_thuDn = document.createTextNode(list[i].AVG);
								
								div_thuDn_avg.setAttribute('id','rate_thuDn');
								node_thuDn.appendChild(text_thuDn);
								document.getElementById("thuDn").appendChild(div_thuDn_avg);
								document.getElementById("thuDn").appendChild(node_thuDn);
								
								//별점 설정
								$(function() {
									$("#rate_thuDn").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_thuDn_avg.addEventListener("click", function () {
									daily_menu(date[3], type.저녁);
								}, false);
								node_thuDn.addEventListener("click", function () {
									daily_menu(date[3], type.저녁);
								}, false);
								break;
							case 'L2' :
								//평점 그리기
								var visibility = document.getElementById("tbl_L2");
								var visibility_mon = document.getElementById("monL2");
								var visibility_tue = document.getElementById("tueL2");
								var visibility_wed = document.getElementById("wedL2");
								var visibility_thu = document.getElementById("thuL2");
								var visibility_fri = document.getElementById("friL2");
								
								visibility.setAttribute("class", "visible");
								visibility_mon.setAttribute("class", "visible");
								visibility_tue.setAttribute("class", "visible");
								visibility_wed.setAttribute("class", "visible");
								visibility_thu.setAttribute("class", "visible");
								visibility_fri.setAttribute("class", "visible");
								
								var div_thuL2_avg = document.createElement("div");
								var node_thuL2 = document.createElement("p");
								var text_thuL2 = document.createTextNode(list[i].AVG);
								
								div_thuL2_avg.setAttribute('id','rateThuL2');
								node_thuL2.appendChild(text_thuL2);
								document.getElementById("thuL2").appendChild(div_thuL2_avg);
								document.getElementById("thuL2").appendChild(node_thuL2);
								
								//별점 설정
								$(function() {
									$("#rateThuL2").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_thuL2_avg.addEventListener("click", function () {
									daily_menu(date[3], type.점심2);
								}, false);
								node_thuL2.addEventListener("click", function () {
									daily_menu(date[3], type.점심2);
								}, false);
								break;
							default : break;
							}
						} else if(list[i].DATE == get( yoil.금 ) ||  list[i].DATE == get( yoil.금, 1) ||  list[i].DATE == get( yoil.금, 2)||  list[i].DATE == get( yoil.금, 3) ) {
							switch(list[i].CARTE_TYPE ) {
							case 'BF' :
								//평점 그리기 
								var div_friBf_avg = document.createElement("div");
								var node_friBf = document.createElement("p");
								var text_friBf = document.createTextNode(list[i].AVG);
								
								div_friBf_avg.setAttribute('id','rate_friBf');
								node_friBf.appendChild(text_friBf);
								document.getElementById("friBf").appendChild(div_friBf_avg);
								document.getElementById("friBf").appendChild(node_friBf);
								
								//별점 설정
								$(function() {
									$("#rate_friBf").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_friBf_avg.addEventListener("click", function () {
									daily_menu(date[4], type.아침);
								}, false);
								node_friBf.addEventListener("click", function () {
									daily_menu(date[4], type.아침);
								}, false);
								break;
							case 'LC' :
								//평점 그리기
								var div_friLc_avg = document.createElement("div");
								var node_friLc = document.createElement("p");
								var text_friLc = document.createTextNode(list[i].AVG);
								
								div_friLc_avg.setAttribute('id','rate_friLc');
								node_friLc.appendChild(text_friLc);
								document.getElementById("friLc").appendChild(div_friLc_avg);
								document.getElementById("friLc").appendChild(node_friLc);
								
								//별점 설정
								$(function() {
									$("#rate_friLc").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_friLc_avg.addEventListener("click", function () {
									daily_menu(date[4], type.점심);
								}, false);
								node_friLc.addEventListener("click", function () {
									daily_menu(date[4], type.점심);
								}, false);
								break;
							case 'DN' :
								//평점 그리기 
								var div_friDn_avg = document.createElement("div");
								var node_friDn = document.createElement("p");
								var text_friDn = document.createTextNode(list[i].AVG);
								
								div_friDn_avg.setAttribute('id','rate_friDn');
								node_friDn.appendChild(text_friDn);
								document.getElementById("friDn").appendChild(div_friDn_avg);
								document.getElementById("friDn").appendChild(node_friDn);
								
								//별점 설정
								$(function() {
									$("#rate_friDn").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_friDn_avg.addEventListener("click", function () {
									daily_menu(date[4], type.저녁);
								}, false);
								node_friDn.addEventListener("click", function () {
									daily_menu(date[4], type.저녁);
								}, false);
								break;
							case 'L2' :
								//평점 그리기
								var visibility = document.getElementById("tbl_L2");
								var visibility_mon = document.getElementById("monL2");
								var visibility_tue = document.getElementById("tueL2");
								var visibility_wed = document.getElementById("wedL2");
								var visibility_thu = document.getElementById("thuL2");
								var visibility_fri = document.getElementById("friL2");
								
								visibility.setAttribute("class", "visible");
								visibility_mon.setAttribute("class", "visible");
								visibility_tue.setAttribute("class", "visible");
								visibility_wed.setAttribute("class", "visible");
								visibility_thu.setAttribute("class", "visible");
								visibility_fri.setAttribute("class", "visible");
								
								var div_friL2_avg = document.createElement("div");
								var node_friL2 = document.createElement("p");
								var text_friL2 = document.createTextNode(list[i].AVG);
								
								div_friL2_avg.setAttribute('id','rateFriL2');
								node_friL2.appendChild(text_friL2);
								document.getElementById("friL2").appendChild(div_friL2_avg);
								document.getElementById("friL2").appendChild(node_friL2);
								
								//별점 설정
								$(function() {
									$("#rateFriL2").rateYo({
										precision: 2,
										readOnly: true, starWidth: "10px",
										rating: list[i].AVG
									});
								});
								
								//메뉴 이동메뉴 이동
								div_friL2_avg.addEventListener("click", function () {
									daily_menu(date[4], type.점심2);
								}, false);
								node_friL2.addEventListener("click", function () {
									daily_menu(date[4], type.점심2);
								}, false);
								break;
							default : break;
							}
						} else{
							alert("오류데이터 존재 : 주말");				
						}
					} //end of for
				} else {
					alert("response.data 정의 안됨 ");
				}
			}
			resizeStarRating();
		} //End callBack_$fn_doSearch
		
		//별점 클릭시 메뉴 이동
		 function daily_menu( selectedDate, carteType){
			var params = {
					selected_date : selectedDate,
					carte_type : carteType,
			};
			
			callJson( MOJSON_GETSELECTEDDAY , params, fnNmGetter().name);
		}
		
		 function callBack_$daily_menu(response , status ){
				if( response.SUCCESS != "true"){
					alert(response.ERR_MSG);
					return;
				} else if( response.table.mySheet.totalCount == 0) {
//					alert("데이터 없음");
				} else {
					var list = response.table.mySheet.rows;
					var menu = [ document.getElementById("menu1"), document.getElementById("menu2"), document.getElementById("menu3")];
					var text_menu = [document.createTextNode(list[0].MENU1), document.createTextNode(list[0].MENU2), document.createTextNode(list[0].MENU3), 
					                 document.createTextNode(list[0].MENU4), document.createTextNode(list[0].MENU5), document.createTextNode(list[0].MENU6), 
					                 document.createTextNode(list[0].MENU7), document.createTextNode(list[0].MENU8), document.createTextNode(list[0].MENU9)];
					
					var i;
					for (i = 0; i<3; i++) {
						while (menu[i].firstChild) {
							menu[i].removeChild( menu[i].firstChild );
						}
					}
					for ( i = 0; i<9; i++) {
						menu[i%3].appendChild( document.createElement("span").appendChild(text_menu[i]) );
						
						if( i<6)	
							menu[i%3].appendChild( document.createElement("br") );
					}
				} //end of if else
		 }//end of callBack_$daily_menu
		
	</script>