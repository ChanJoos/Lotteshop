<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<link rel="stylesheet" href="/fis/common/js/jquery/rateyo/jquery.rateyo.css"/> 

<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<script src="/fis/common/js/jquery/rateyo/jquery.rateyo.js"></script>
<script type="text/javascript">

	$(document).ready(init);
	
	var todayDate = null;
	
	function init() {
		
		/* 전역 변수 */
		
		fn_setEvent();
		fn_setCarteInfo();
		rowClone('');
		
		window.onresize = function() { 
			resizeStarRating(); 
		};
		
	}
	
	// 리사이즈가 변화에 따라 한 번만 실행되도록 mode 값 활용
	var mode = null; // 0이면 PC 상태, 1이면 MOBILE 상태
	
	function resizeStarRating() {
		if ($(window).width() >= 768) {
			
			var old_mode = mode;
            mode = 1;
			if(old_mode != mode) {
	       		$("#rtBf").rateYo("option", "starWidth", "30px"); //returns a jQuery Element
	       		$("#rateL2").rateYo("option", "starWidth", "30px"); //returns a jQuery Element
	       		$("#rtLc").rateYo("option", "starWidth", "30px"); //returns a jQuery Element
	       		$("#rtDn").rateYo("option", "starWidth", "30px"); //returns a jQuery Element
	       		
	       		$('.jq-ry-container').each(function(){
					$(this).css({
				    	'margin': '0 auto'
				    });
				});
	       		
	       		fn_resizeRatingSpan('20px');
			}
       		
		} 
		else {
			
			var old_mode = mode;
            mode = 0;
			if(old_mode != mode) {
				$("#rtBf").rateYo("option", "starWidth", "10px"); //returns a jQuery Element
	       		$("#rateL2").rateYo("option", "starWidth", "10px"); //returns a jQuery Element
	       		$("#rtLc").rateYo("option", "starWidth", "10px"); //returns a jQuery Element
	       		$("#rtDn").rateYo("option", "starWidth", "10px"); //returns a jQuery Element
	       		
	       		$('.jq-ry-container').each(function(){
					$(this).css({
				    	'margin': '0 auto'
				    });
				});
	       		
	       		fn_resizeRatingSpan('12px');
			}
			
   		}
	}

	function fn_resizeRatingSpan(size) {
		
		$('#bf_rt span').css('fontSize', size);
		$('#lc_rt span').css('fontSize', size);
		$('#dn_rt span').css('fontSize', size);
		$('#l2_rt span').css('fontSize', size);
		
	}
	
	function fn_setSpan(selector, text) {
		
		$(selector).html(text);
		
	}

	function fn_setTodayDate(dateAndReserveInfo) {
		
		var year = dateAndReserveInfo.presentYear;
		var month = dateAndReserveInfo.presentMonth;
		var date = dateAndReserveInfo.presentDate;
		
		if(month < 10) month = '0' + month;
		if(date < 10) date = '0' + date;
		
		todayDate = year + '' + month + '' + date; 
		
	}
	
	/* input tyep=text의 menu 값들을 set 해준다 - 식단 입력 전 조회 기능 */
	function setMenues(menuRows, rowsCount) {
		
		deleteL2Row(); // 기존에 추가된 2식 row 삭제 
		initRows(); // 모든 식단 row 초기화 
		
		for(var i = 0; i < rowsCount; i++) {
			var selectedDate = todayDate % 100; // 20160118 % 100 = 18
			var rowsDate = menuRows[i].DATE % 100;
			if(selectedDate == rowsDate) {
				//alert(rowsDate);
				 var spanSelector = '#' + menuRows[i].CARTE_TYPE + ' span';
				 
				 if(menuRows[i].CARTE_TYPE == 'L2') {
					 rowClone('LC');
				 }
				
				var menuNames = '';
				var menuNameArray = [menuRows[i].MENU1, menuRows[i].MENU2, menuRows[i].MENU3,
				                     menuRows[i].MENU4, menuRows[i].MENU5, menuRows[i].MENU6, menuRows[i].MENU7, 
				                     menuRows[i].MENU8, menuRows[i].MENU9];
				
				for(var j = 0; j < 9; j++) {
					if(menuNameArray[j] != '') menuNames = menuNames + menuNameArray[j] + '<br/>'; 
				}
				
				fn_setSpan(spanSelector, menuNames); 
			}
		}
		
		// 만약에 입력된 데이터가 없다면 입력된 데이터가 없음을 표시
		checkAndInitRows(); 
		
		return;
	}
	
	function fn_setRowLen() {
		
		var table = document.getElementById("carte_input");
		var rowsCount = table.rows.length;

		alert(rowsCount);
		$("#tableRowLen").val(rowsCount);
		
	}
	
	function rowClone(selector) {
		
		if(selector != '') {
			selector = 'tr.' + selector;
			var willBeclonedRow = $(selector);
			var clonedRow = willBeclonedRow.clone();
			
			clonedRow.insertAfter($("table " + selector)); //carte_input은 table class 이름
			
			var index = 0;
			$('tr.LC').each(function(){
				if(index != 0) {
					$(this).attr('class', 'L2');
					$('tr.L2 #LC').attr('id', 'L2');
					$('tr.L2 #L2 spanLC').attr('id', 'spanLC');
					$('tr.L2 #lc_rt').attr('id', 'l2_rt');
				}
				index++;
			});
		}
		
	}
	
	function deleteL2Row() {
		
		$('tr.L2').each(function(){
			$(this).remove();
		});
		
	}
	
	function initRows() {
		
		var text = '입력된 식단 데이터가 없습니다.';
		$('tr td span.carte').each(function(){
			$(this).html(text);
		});
		
	}
	
	function checkAndInitRows() {
		var defaultText = '입력된 식단 데이터가 없습니다.';
		$('tr td span').each(function(){
			var text = $(this).text();
			//alert(text);
			if(text == '' || text == null) {
				$(this).html(defaultText);
			}
			//else alert(text);
		});
	}
    
	function fn_setInputData(selector, date, carte_type, reserve_yn) {
		
		$('tr.' + selector + ' td input').each(function(){
			var inputName = $(this).attr('name');
			if(inputName == 'date') $(this).val(date);
			else if(inputName == 'carte_type') $(this).val(carte_type);
			else if(inputName == 'reserve_yn') $(this).val(reserve_yn);
		});
	}
	
	function fn_doInsertReservation() {
		
		//var formObj = $("form[role='form']");
		//formObj.attr("action", "/fis/carte/lookup/insertReservation.moJson");
		//formObj.attr("method", "post");
		//formObj.submit();
		
		var formObj = $("form[role='form']").serialize();
        callJson("/fis/login/move/insertReservation.moJson", formObj, fnNmGetter().name);	
		
	}
	
    function callBack_$fn_doInsertReservation(response, status) {
    	
        if (response.SUCCESS != "true") {
			alert("Fail " + response.ERR_MSG);
            return;
        }
        else {
    		if($('#reserveDN').html() == "예약하기") {
    			alert("예약이 완료되었습니다.");
    		}
    		else {
    			alert("예약이 취소되었습니다.");
    		}
			
			getReserveInfo(); // 다시 예약 정보 가져온다
        }
        
	}
    
	function getReserveInfo() {
		
    	var selectedDate = todayDate;
		var carteType = "DN";
		var empID = 'TESTID';
		
		var params = {
			selected_date : selectedDate,
			emp_id : empID,
			carte_type : carteType,
		};
    	
		callJson("/fis/login/move/getReserveInfo.moJson", params, fnNmGetter().name);
		
	}

	function callBack_$getReserveInfo(response, status) {
		
		reserveInfo = response.data;
		
		if (response.SUCCESS != "true") {
			alert("getReserveInfo error : " + response.ERR_MSG);
			return;
		} 
		else {
			setReserveInfo(reserveInfo);
		}
		
	}
	
	function setReserveInfo(reserveInfo) {
		
		$('#reserveNumDN').html(reserveInfo.reserve_count); // 인원 수 set
		
		// 버튼 모양 및 버튼 내부 텍스트 set
		if(reserveInfo.reserve_yn == 'N') {
			$('#reserveDN').html('예약하기'); 
			$("#reserveDN").attr('class', 'btn btn-primary');
		}
		else if(reserveInfo.reserve_yn == 'Y') {
			$('#reserveDN').html('예약취소');
			$("#reserveDN").attr('class', 'btn btn-default');
		}
		else {
			alert('setReserveInfo reserve_yn error');
		}
		
	}
	
	function fn_setEvent() {
		
		$("#reserveDN").click(function() {
			
			var date = todayDate;
			var carte_type = 'DN';
			var reserve_yn = 'N';

			// 이미 예약돼 있기 때문에 한 번 더 누르면 예약 상태가 취소된다.
			if($(this).attr('class') == 'btn btn-default') reserve_yn = 'N';
			// 예약돼 있지 않기 때문에 누르면 예약 상태가 된다.
			else if($(this).attr('class') == 'btn btn-primary') reserve_yn = 'Y'; // 이미 예약돼 있기 때문에
			else if($(this).attr('class') == 'btn btn-primary') reserve_yn = 'N';
			 
			fn_setInputData('DN', date, carte_type, reserve_yn);
			fn_doInsertReservation();
			
		});
		
	}
	
	/* Controller가 전달한 메뉴 value들 set */
	function fn_setCarteInfo() { // Contoller에 다시 전달
		
		callJson("/fis/login/move/getCarteInfo.moJson", null, fnNmGetter().name);
		
	}
	
	/* DATE와 CARTE_TYPE에 따라 알맞게 메뉴를 SEt해준다 */
	function callBack_$fn_setCarteInfo(response , status ){ // 실제 Menu Set 기능 수행
		
		if( response.SUCCESS != "true"){ // 실패하면
			alert(response.ERR_MSG);
			return;
		} 
		
		else { // 성공하면
			if( response.data != undefined || response.table!= undefined ){
				//alert(response.OK_MSG);	
				
				/* 날짜 setting */
				var dayNameArray = ['mon', 'tue', 'wed', 'thu', 'fri']; 
				var selector = "default";
				
				menuRows = response.table.mySheet.rows; // Select한 실제 Row들
				rowsCount = response.table.mySheet.totalCount; // Select한 Row의 전체 길이
				dateAndReserveInfo = response.data;
				
				//alert(menuRows[0].DATE % 100);
				
				fn_setTodayDate(dateAndReserveInfo);
				
				var dateValueArray = [dateAndReserveInfo.presentMon, dateAndReserveInfo.presentTue,
				                      dateAndReserveInfo.presentWed, dateAndReserveInfo.presentThu, 
				                      dateAndReserveInfo.presentFri];
				
				//fn_setSpan('#monSpan', dateAndReserveInfo.presentYear);
				
				for(var i = 0; i < 5; i++) {
					selector = '#' + dayNameArray[i] + 'Span'; 
					fn_setSpan(selector, dateValueArray[i]);
				}
				
				fn_setSpan('#yearSpan', dateAndReserveInfo.presentYear);
				fn_setSpan('#monthSpan', dateAndReserveInfo.presentMonth);
				fn_setSpan('#dateSpan', dateAndReserveInfo.presentDate);
				
				setMenues(menuRows, rowsCount);
				
				getReserveInfo(); // 예약 여부 확인
				// 예약 여부 확인 BF, LC, L2는 필요하면 추가할 것 
				
			}
			else {
				alert("response.data undefined");
			}
		}
		return fn_setRating();
		
	} //End callBack_$fn_setCarteInfo

	
	
	
	
	
	
	
	
	/*******************************************************************************/
	
	/* 별점 관련 소스코드 */
	
	function fn_setRating() { //랭킹 데이터 불러오기

		callJson("/fis/rating/survey/getRating.moJson", null, fnNmGetter().name);
			
	}//End of $fn_setRating()
		
	function callBack_$fn_setRating(response , status ){ // 랭킹 달기
			
		if( response.SUCCESS != "true"){
			alert(response.ERR_MSG);
			return;
		} 
		else {
			
			if( response.data != undefined || response.table!= undefined ){
				
				var list = null;
				list = response.table.mySheet.rows;
				/* 조회된 데이터를 table에 세팅한다. */
				//console.log(list);
				
				var text_type;
				var i,j;
				var length;
				
				for(i=0; i<response.table.mySheet.totalCount; i++) {
					
					if(list[i].CARTE_TYPE == 'BF') {
						//평점 그리기 // < td id = bf_col>   <div id='rateYo'></div><p>점수</p> </td>
						var div_bf_avg = document.createElement("div");
						div_bf_avg.setAttribute('id','rtBf');
						var p_bf_avg = document.createElement("span");
						var text_bf_avg = document.createTextNode(list[i].AVG);
						p_bf_avg.appendChild(text_bf_avg);
						document.getElementById("bf_rt").appendChild(div_bf_avg);
						if(typeof(list[i].AVG) != "undefined") 
							document.getElementById("bf_rt").appendChild(p_bf_avg);
							
						//별표 
						$(function() {
							$("#rtBf").rateYo({
								precision: 2,
								readOnly: true,
								rating: list[i].AVG
							});
						});
						
					} 
					else if(list[i].CARTE_TYPE == 'LC') {
						var div_lc_avg = document.createElement("div");
						div_lc_avg.setAttribute('id','rtLc');
						var p_lc_avg = document.createElement("span");
						p_lc_avg.setAttribute('id','p_lc');
						var text_lc_avg = document.createTextNode(list[i].AVG);
						p_lc_avg.appendChild(text_lc_avg);
						document.getElementById("lc_rt").appendChild(div_lc_avg);
						if(typeof(list[i].AVG) != "undefined") 
							document.getElementById("lc_rt").appendChild(p_lc_avg);
							
							//별표 
						$(function() {
							$("#rtLc").rateYo({
								precision: 2,
								readOnly: true,
								rating: list[i].AVG
							});
						});
					} 
					else if(list[i].CARTE_TYPE == 'DN') {
						//평점 그리기 // td id = dn_col 
						var div_dn_avg = document.createElement("div");
						div_dn_avg.setAttribute('id','rtDn');
						var p_dn_avg = document.createElement("span");
						var text_dn_avg = document.createTextNode(list[i].AVG);
						p_dn_avg.appendChild(text_dn_avg);
						document.getElementById("dn_rt").appendChild(div_dn_avg);
						if(typeof(list[i].AVG) != "undefined") 
							document.getElementById("dn_rt").appendChild(p_dn_avg);
						
						//별표 
						$(function() {
							$("#rtDn").rateYo({
								precision: 2,
								readOnly: true,
								rating: list[i].AVG
							});
						});
					}
					else if(list[i].CARTE_TYPE == 'L2') {
						//평점 그리기 // td id = l2_col 
						var div_l2_avg = document.createElement("div");
						div_l2_avg.setAttribute('id','rateL2');
						var p_l2_avg = document.createElement("span");
						var text_l2_avg = document.createTextNode(list[i].AVG);
						//console.log(list[i].AVG);
						p_l2_avg.appendChild(text_l2_avg);
						document.getElementById("l2_rt").appendChild(div_l2_avg);
						if(typeof(list[i].AVG) != "undefined") 
							document.getElementById("l2_rt").appendChild(p_l2_avg);
						
						//rateyo
						$(function() {
							$("#rateL2").rateYo({
								precision: 2,
								readOnly: true,
								rating: list[i].AVG
							});
						});
					}//end of if else
						
				}//end of for
					
			} 
			else {
				alert("response.data 정의 안됨 ");
			}
				
		}
	
		resizeStarRating();
		
	}//End of callBack_$fn_setRating()

</script>
