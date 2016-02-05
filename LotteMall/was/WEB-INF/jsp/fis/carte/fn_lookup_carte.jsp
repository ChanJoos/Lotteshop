<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<link rel="stylesheet" href="/fis/common/js/jquery/rateyo/jquery.rateyo.css"/> 

<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<script src="/fis/common/js/jquery/rateyo/jquery.rateyo.js"></script>
<script type="text/javascript">

	// 다음 week이면 1씩 증가, 이전 week이면 -1씩 감소, 현재는 0
	var currentWeek = 0;

	$(document).ready(init);
	
	function init() {
		
		/* 전역 변수 */
		var menuRows = null;
		var rowsCount = 0;	
		var globalDateAndReserveInfo = null;
		
		fn_setNavActive();
		fn_setEvent();
		fn_setCarteInfo();
		rowClone('');
		
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
		
		if ($(window).width() >= 768) { // PC
			
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
		else { // Mobile
			
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
	
	function fn_removePrevRating() {
		
		$('#bf_rt div').remove();
		$('#bf_rt span').remove();
		$('#lc_rt div').remove();
		$('#lc_rt span').remove();
		$('#dn_rt div').remove();
		$('#dn_rt span').remove();
		$('#l2_rt div').remove();
		$('#l2_rt span').remove();
		
	}
	
	function fn_resizeRatingSpan(size) {
		
		$('#bf_rt span').css('fontSize', size);
		$('#lc_rt span').css('fontSize', size);
		$('#dn_rt span').css('fontSize', size);
		$('#l2_rt span').css('fontSize', size);
		
	}
	
	function fn_setNavActive() {
		
		$('#carte-lookup').attr('class', 'active');
		
	}
	
	function fn_setSpan(selector, text) {
		
		$(selector).html(text);
		
	}

	function fn_setSelectedDate(selector) {
		
		$(selector).attr('class', 'selected-date');
		
	}
	
	/* 식단 조회 */
	function setMenues(menuRows, rowsCount) {
		
		deleteL2Row(); // 기존에 추가된 2식 row 삭제 
		initRows(); // 모든 식단 row 초기화 
		
		for(var i = 0; i < rowsCount; i++) {
			// 원본
			// var selectedDate = $(".pager li .selected-date span").text() % 100; // 20160118 % 100 = 18
			
			// test 중
			var selectedDate = $(".pager li .selected-date").parent().attr('value'); // 20160118 % 100 = 18
			
			// 원본
			////var rowsDate = menuRows[i].DATE % 100;
			
			// test 중
			var rowsDate = menuRows[i].DATE;

			if(selectedDate == rowsDate) { // 수정 중
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
				
				//spanSelector = '#BF span'
				//menuNames = 'test';
				
				fn_setSpan(spanSelector, menuNames); 
			}
			//alert(date);
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
	
	/* increment 숫자 만큼 날짜를 증가시킨다 */
	function fn_returnDateObj(dayIncrement) {
		
		var year = $('#yearSpan').text();
		var month = $('#monthSpan').text();
		var date = $(".pager li #monAnchor span").text();
		
		var dateObj = new Date();
		dateObj.setFullYear(year);
		dateObj.setMonth(month - 1);
		dateObj.setDate(date);
		
		// ex) 다다음 주 화요일 - 1(dayInrement) + 2(weekIncrement) * 7 = 15
		dateObj.setDate(dateObj.getDate() + dayIncrement); 
		
		year = dateObj.getFullYear();
		month = dateObj.getMonth() + 1; // 0, 1, 2, 3 ...
		date = dateObj.getDate();
		
		if(month < 10) month = '0' + month;
		if(date < 10) date = '0' + date;
		//alert(year + '' + month + '' + date);

		return (year + '' + month + '' + date);
	}
	
	/* increment 숫자 만큼 날짜를 증가시킨다 */
	/* 
	function fn_returnDateObj(dayIncrement, weekIncrement) {
		
		var year = $('#yearSpan').text();
		var month = $('#monthSpan').text();
		var date = $(".pager li #monAnchor span").text();
		
		var dateObj = new Date();
		dateObj.setFullYear(year);
		dateObj.setMonth(month - 1);
		dateObj.setDate(date);
		
		// ex) 다다음 주 화요일 - 1(dayInrement) + 2(weekIncrement) * 7 = 15
		dateObj.setDate(dateObj.getDate() + dayIncrement + 7 * weekIncrement); 
		
		year = dateObj.getFullYear();
		month = dateObj.getMonth() + 1; // 0, 1, 2, 3 ...
		date = dateObj.getDate();
		
		$('#yearSpan').html(year);
		$('#monthSpan').html(month);
		
		if(month < 10) month = '0' + month;
		if(date < 10) date = '0' + date;
		//alert(year + '' + month + '' + date);

		return (year + '' + month + '' + date);
	} 
	*/
	
	function fn_setPagerListDateValue() {
		
		//alert('fn_setPagerListMonthValue');
		var dateValue = null;
		
		$('.pager li').each(function(){
			var pagerID = $(this).attr('id');
			if(pagerID == 'mon') {
				dateValue = fn_returnDateObj(0);
				$(this).attr('value', dateValue);
			}
			else if(pagerID == 'tue') {
				dateValue = fn_returnDateObj(1);
				$(this).attr('value', dateValue);
			}
			else if(pagerID == 'wed') {
				dateValue = fn_returnDateObj(2);
				$(this).attr('value', dateValue);
			}
			else if(pagerID == 'thu') {
				dateValue = fn_returnDateObj(3);
				$(this).attr('value', dateValue);
			}
			else if(pagerID == 'fri') {
				dateValue = fn_returnDateObj(4);
				$(this).attr('value', dateValue);
			}
		});
		
	}
	
	function fn_setPagerDateSpan() {
		
		var dayNameArray = ['mon', 'tue', 'wed', 'thu', 'fri']; 
		var dateValueArray = ['0', '0', '0', '0', '0'];
		var pagerIndex = 0;
		
		$('.pager li').each(function(){
			
			var pagerID = $(this).attr('id');
			if(pagerID == 'mon') {
				dateValueArray[pagerIndex] = $(this).attr('value') % 100;
				pagerIndex++;
			}
			else if(pagerID == 'tue') {
				dateValueArray[pagerIndex] = $(this).attr('value') % 100;
				pagerIndex++;
			}
			else if(pagerID == 'wed') {
				dateValueArray[pagerIndex] = $(this).attr('value') % 100;
				pagerIndex++;
			}
			else if(pagerID == 'thu') {
				dateValueArray[pagerIndex] = $(this).attr('value') % 100;
				pagerIndex++;
			}
			else if(pagerID == 'fri') {
				dateValueArray[pagerIndex] = $(this).attr('value') % 100;
				pagerIndex++;
			}
			
		});
		
		for(var i = 0; i < 5; i++) {
			var selector = '#' + dayNameArray[i] + 'Span'; 
			fn_setSpan(selector, dateValueArray[i]);
		}
		
	}

	function fn_setMonthYearSpan(selector) {
		
		var text = $(selector).attr('value');
		
		var year = text / 10000; // 20160315 / 10000 = 2016
		var month = (text % 10000) / 100 ; // 20161215 % 10000 = 1215, 1215 / 100 = 12 

		$('#yearSpan').html(Math.round(year));
		$('#monthSpan').html(Math.round(month));
		
	}

	// 월요일의 시작 full date object을 반환한다 - ex) 20160125
	function fn_getDateObjOfMonday() {
		
		var fullDate = $('.pager li#mon').attr('value');
		//alert(fullDate);
		
		var year = Math.round(fullDate / 10000);
		//alert(year);
		var month = Math.round((fullDate % 10000) / 100);
		//alert(month);
		var date = fullDate % 100;
		//alert(date);
		
		var dateObj = new Date();
		dateObj.setFullYear(year);
		dateObj.setMonth(month - 1);
		dateObj.setDate(date);
		
		return dateObj;
		
	}

	function fn_getDateByParams(year, month, date) {
		
		var dateObj = new Date();
		dateObj.setFullYear(year);
		dateObj.setMonth(month - 1);
		dateObj.setDate(date);
		
		return dateObj;
		
	}

	// next나 previous를 눌렀을 때 동작하는 함수 - value 값을 날짜 값으로 세팅해준다
	function fn_setChangedPagerListDateValue(weekIncrement) {
		
		var modayDateObj = fn_getDateObjOfMonday();		

		var mondayYear = modayDateObj.getFullYear();
		var mondayMonth = modayDateObj.getMonth() + 1;
		var mondayDate = modayDateObj.getDate();

		var dayIncrement = 0;
		var dateValue = null;
		
		$('.pager li').each(function(){
			var pagerID = $(this).attr('id');
			if(pagerID == 'mon') {
				var dateObj = fn_getDateByParams(mondayYear, mondayMonth, mondayDate);
				// ex) 다다음 주 화요일 - 1(dayInrement) + 2(weekIncrement) * 7 = 15
				dateObj.setDate(dateObj.getDate() + dayIncrement + 7 * weekIncrement);
				dateValue = fn_convertDateObjString(dateObj);
				$(this).attr('value', dateValue);
				dayIncrement++;
			}
			else if(pagerID == 'tue') {
				var dateObj = fn_getDateByParams(mondayYear, mondayMonth, mondayDate);
				dateObj.setDate(dateObj.getDate() + dayIncrement + 7 * weekIncrement);
				dateValue = fn_convertDateObjString(dateObj);
				$(this).attr('value', dateValue);
				dayIncrement++;
			}
			else if(pagerID == 'wed') {
				var dateObj = fn_getDateByParams(mondayYear, mondayMonth, mondayDate);
				dateObj.setDate(dateObj.getDate() + dayIncrement + 7 * weekIncrement);
				dateValue = fn_convertDateObjString(dateObj);
				$(this).attr('value', dateValue);
				dayIncrement++;
			}
			else if(pagerID == 'thu') {
				var dateObj = fn_getDateByParams(mondayYear, mondayMonth, mondayDate);
				dateObj.setDate(dateObj.getDate() + dayIncrement + 7 * weekIncrement);
				dateValue = fn_convertDateObjString(dateObj);
				$(this).attr('value', dateValue);
				dayIncrement++;
			}
			else if(pagerID == 'fri') {
				var dateObj = fn_getDateByParams(mondayYear, mondayMonth, mondayDate);
				dateObj.setDate(dateObj.getDate() + dayIncrement + 7 * weekIncrement);
				dateValue = fn_convertDateObjString(dateObj);
				$(this).attr('value', dateValue);
				dayIncrement++;
			}
		});
		
	}

	function fn_convertDateObjString(dateObj) {
		
		var year = dateObj.getFullYear();
		var month = dateObj.getMonth() + 1; // 0, 1, 2, 3 ...
		var date = dateObj.getDate();
		
		if(month < 10) month = '0' + month;
		if(date < 10) date = '0' + date;
		
		return (year + '' + month + '' + date); 
		
	}

	/*
	function fn_setReserveYN_DN(dateAndReserveInfo) {
		
		var reserveID = $('.pager li .selected-date').parent().attr('id');
		var selectedDate = $('.pager li .selected-date').parent().attr('value');
		
		//alert(reserveID);
		//alert(dateAndReserveInfo.reserve_yn_mon_dn);
		
		if(reserveID == 'mon') {
			if(dateAndReserveInfo.reserve_yn_mon_dn == 'Y' 
					&& selectedDate == dateAndReserveInfo.presentMon) {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'tue') {
			if(dateAndReserveInfo.reserve_yn_tue_dn == 'Y'
					&& selectedDate == dateAndReserveInfo.presentTue) {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'wed') {
			if(dateAndReserveInfo.reserve_yn_wed_dn == 'Y'
					&& selectedDate == dateAndReserveInfo.presentWed) {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'thu') {
			if(dateAndReserveInfo.reserve_yn_thu_dn == 'Y'
					&& selectedDate == dateAndReserveInfo.presentThu) {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
				
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'fri') {
			if(dateAndReserveInfo.reserve_yn_fri_dn == 'Y'
					&& selectedDate == dateAndReserveInfo.presentFri) {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else {
			alert('reserveID Error');	
		}
			
	}
	*/
	
	function fn_setReserveYN_DN(dateAndReserveInfo) {
		
		var reserveID = $('.pager li .selected-date').parent().attr('id');
		var selectedDate = $('.pager li .selected-date').parent().attr('value');
		
		//alert(reserveID);
		//alert(dateAndReserveInfo.reserve_yn_mon_dn);
		
		if(reserveID == 'mon') {
			if(dateAndReserveInfo.reserve_yn_mon_dn == 'Y') {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'tue') {
			if(dateAndReserveInfo.reserve_yn_tue_dn == 'Y') {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'wed') {
			if(dateAndReserveInfo.reserve_yn_wed_dn == 'Y') {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'thu') {
			if(dateAndReserveInfo.reserve_yn_thu_dn == 'Y') {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
				
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else if(reserveID == 'fri') {
			if(dateAndReserveInfo.reserve_yn_fri_dn == 'Y') {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		else {
			alert('reserveID Error');	
		}
			
	}
	
	function fn_setReserveCount_DN(dateAndReserveInfo) {
		
		var reserveID = $('.pager li .selected-date').parent().attr('id');
		
		//alert(reserveID);
		//alert(dateAndReserveInfo.reserve_yn_mon_dn);
		
		if(reserveID == 'mon') {
			$('#reserveNumDN').html(dateAndReserveInfo.reserve_count_mon_dn); 
		}
		else if(reserveID == 'tue') {
			$('#reserveNumDN').html(dateAndReserveInfo.reserve_count_tue_dn);
		}
		else if(reserveID == 'wed') {
			$('#reserveNumDN').html(dateAndReserveInfo.reserve_count_wed_dn);
		}
		else if(reserveID == 'thu') {
			$('#reserveNumDN').html(dateAndReserveInfo.reserve_count_thu_dn);
		}
		else if(reserveID == 'fri') {
			$('#reserveNumDN').html(dateAndReserveInfo.reserve_count_fri_dn);
		}
		else {
			alert('reserveID Error');	
		}
		
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
		
		/* 
		<input type="hidden" name="date" value="0">
		<input type="hidden" name="carte_type" value="0">
		<input type="hidden" name="reserve_yn" value="0">
		 */
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
        callJson("/fis/carte/lookup/insertReservation.moJson", formObj, fnNmGetter().name);	
		
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
	
	function fn_setEvent() {
		
		$("#nextWeek").click(function() {
			
			currentWeek++;
			//alert("nextWeek clicked");
			//fn_setPagerListDateValue();
			//fn_setPagerDateSpan();
			fn_removePrevRating();
			fn_setChangedPagerListDateValue(currentWeek); // pager 내의 value 값 세팅
			fn_setPagerDateSpan(); // pager 내의 날짜 setting
			$(".pager li a").removeClass("selected-date");
			fn_setSelectedDate('.pager #mon a');
			fn_setMonthYearSpan('.pager #mon');
			setMenues(menuRows, rowsCount);
			currentWeek = 0;
			setCarteInfoNextPrev();
			fn_setReserveYN_DN(globalDateAndReserveInfo);
			fn_setReserveCount_DN(globalDateAndReserveInfo);
			fn_setRating();
			// callJson("/fis/carte/lookup/getCarteInfo.moJson", null, fnNmGetter().name);
			
		});
		
		$("#previousWeek").click(function() {
			
			currentWeek--;
			//alert("previousWeek clicked");
			fn_removePrevRating();
			fn_setChangedPagerListDateValue(currentWeek); // pager 내의 value 값 세팅
			fn_setPagerDateSpan(); // pager 내의 날짜 setting
			$(".pager li a").removeClass("selected-date");
			fn_setSelectedDate('.pager #mon a');
			fn_setMonthYearSpan('.pager #mon');
			setMenues(menuRows, rowsCount);
			currentWeek = 0;
			setCarteInfoNextPrev();
			fn_setReserveYN_DN(globalDateAndReserveInfo);
			fn_setReserveCount_DN(globalDateAndReserveInfo);
			fn_setRating();
			
		});
		
		$("#monAnchor").click(function() {
			
			fn_removePrevRating();
			$(".pager li a").removeClass("selected-date");
			fn_setSelectedDate('.pager #mon a');
			fn_setMonthYearSpan('.pager #mon');
			setMenues(menuRows, rowsCount);
			fn_setReserveYN_DN(globalDateAndReserveInfo);
			fn_setReserveCount_DN(globalDateAndReserveInfo);
			fn_setRating();
			
		});
		
		$("#tueAnchor").click(function() {
					
			fn_removePrevRating();
			$(".pager li a").removeClass("selected-date");
			fn_setSelectedDate('.pager #tue a');
			fn_setMonthYearSpan('.pager #tue');
			setMenues(menuRows, rowsCount);
			fn_setReserveYN_DN(globalDateAndReserveInfo);
			fn_setReserveCount_DN(globalDateAndReserveInfo);
			fn_setRating();
			
		});
				
		$("#wedAnchor").click(function() {
			
			fn_removePrevRating();
			$(".pager li a").removeClass("selected-date");
			fn_setSelectedDate('.pager #wed a');
			fn_setMonthYearSpan('.pager #wed');
			setMenues(menuRows, rowsCount);
			fn_setReserveYN_DN(globalDateAndReserveInfo);
			fn_setReserveCount_DN(globalDateAndReserveInfo);
			fn_setRating();
			
		});
		
		$("#thuAnchor").click(function() {
			
			fn_removePrevRating();
			$(".pager li a").removeClass("selected-date");
			fn_setSelectedDate('.pager #thu a');
			fn_setMonthYearSpan('.pager #thu');
			setMenues(menuRows, rowsCount);
			fn_setReserveYN_DN(globalDateAndReserveInfo);
			fn_setReserveCount_DN(globalDateAndReserveInfo);
			fn_setRating();
			
		});

		$("#friAnchor").click(function() {
			
			fn_removePrevRating();
			$(".pager li a").removeClass("selected-date");
			fn_setSelectedDate('.pager #fri a');
			fn_setMonthYearSpan('.pager #fri');
			setMenues(menuRows, rowsCount);
			fn_setReserveYN_DN(globalDateAndReserveInfo);
			fn_setReserveCount_DN(globalDateAndReserveInfo);
			fn_setRating();
			
		});
		
		/*
		var reserveID = $('.pager li .selected-date').parent().attr('id');
		
		//alert(reserveID);
		//alert(dateAndReserveInfo.reserve_yn_mon_dn);
		
		if(reserveID == 'mon') {
			if(dateAndReserveInfo.reserve_yn_mon_dn == 'Y') {
				$('#reserveDN').html('예약취소');
				$('#reserveDN').attr('class', 'btn btn-default');
			}
			else {
				$('#reserveDN').html('예약하기');
				$('#reserveDN').attr('class', 'btn btn-primary');
			}
		}
		*/
		
		$("#reserveDN").click(function() {
			
			var date = $(".pager li .selected-date").parent().attr('value');
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
		
		callJson("/fis/carte/lookup/getCarteInfo.moJson", null, fnNmGetter().name);
		
	}
	
	/* DATE와 CARTE_TYPE에 따라 알맞게 메뉴를 SEt해준다 */
	function callBack_$fn_setCarteInfo(response , status ){ // 실제 Menu Set 기능 수행
		
		if( response.SUCCESS != "true") { // 실패하면
			alert(response.ERR_MSG);
			return;
		} 
	
		else { // 성공하면
			if( response.data != undefined || response.table!= undefined ) {
				//alert(response.OK_MSG);	
				
				/* 날짜 setting */
				var dayNameArray = ['mon', 'tue', 'wed', 'thu', 'fri']; 
				var selector = "default";
				
				menuRows = response.table.mySheet.rows; // Select한 실제 Row들
				rowsCount = response.table.mySheet.totalCount; // Select한 Row의 전체 길이
				globalDateAndReserveInfo = response.data;
				
				//alert(menuRows[0].DATE % 100);
				
				var dateValueArray = [globalDateAndReserveInfo.presentMon, globalDateAndReserveInfo.presentTue,
				                      globalDateAndReserveInfo.presentWed, globalDateAndReserveInfo.presentThu, 
				                      globalDateAndReserveInfo.presentFri];
				
				//fn_setSpan('#monSpan', dateAndReserveInfo.presentYear);
				// 실제 pager 내부 날짜 setting 해주는 부분
				for(var i = 0; i < 5; i++) {
					selector = '#' + dayNameArray[i] + 'Span'; 
					fn_setSpan(selector, dateValueArray[i]);
				}
				
				fn_setSpan('#yearSpan', globalDateAndReserveInfo.presentYear);
				fn_setSpan('#monthSpan', globalDateAndReserveInfo.presentMonth);
				
				//fn_setSelectedDate('.pager #fri a');
				fn_setSelectedDate('.pager #' + dayNameArray[globalDateAndReserveInfo.presentDate - 
				                                             globalDateAndReserveInfo.presentMon] + ' a');
				
				fn_setPagerListDateValue(); // 날짜 value 우선 set

				setMenues(menuRows, rowsCount); // 이후에 menu set
				
				
				// 예약 여부 확인 BF, LC, L2는 필요하면 추가할 것 
				fn_setReserveYN_DN(globalDateAndReserveInfo);
				fn_setReserveCount_DN(globalDateAndReserveInfo);
			} // if close
			else {
				alert("response.data undefined");
			}
		} // else close
		
		return fn_setRating();
		
	} //End callBack_$fn_setCarteInfo
	
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
		
		switch (reserveInfo.day_name) {
		
		case 'mon':
			globalDateAndReserveInfo.reserve_yn_mon_dn = reserveInfo.reserve_yn;
			globalDateAndReserveInfo.reserve_count_mon_dn = reserveInfo.reserve_count;
			break;
			
		case 'tue':
			globalDateAndReserveInfo.reserve_yn_tue_dn = reserveInfo.reserve_yn;
			globalDateAndReserveInfo.reserve_count_tue_dn = reserveInfo.reserve_count;
			break;
					
		case 'wed':
			globalDateAndReserveInfo.reserve_yn_wed_dn = reserveInfo.reserve_yn;
			globalDateAndReserveInfo.reserve_count_wed_dn = reserveInfo.reserve_count;
			break;
			
		case 'thu':
			globalDateAndReserveInfo.reserve_yn_thu_dn = reserveInfo.reserve_yn;
			globalDateAndReserveInfo.reserve_count_thu_dn = reserveInfo.reserve_count;
			break;
			
		case 'fri':
			globalDateAndReserveInfo.reserve_yn_fri_dn = reserveInfo.reserve_yn;
			globalDateAndReserveInfo.reserve_count_fri_dn = reserveInfo.reserve_count;
			break;

		default:
			alert('Day Name Error');
			break;
		
		}
		
	}
	
	function getReserveInfo() {
		
    	var selectedDate = $('.pager li .selected-date').parent().attr('value');
		var carteType = "DN";
		var empID = 'TESTID';
		var dayName = $('.pager li .selected-date').parent().attr('id');
		
		var params = {
			selected_date : selectedDate,
			emp_id : empID,
			carte_type : carteType,
			day_name : dayName,
			/* mon_date : monDate,
			tue_date : tueDate,
			wed_date : wedDate,
			thu_date : thuDate,
			fri_date : friDate,
			emp_id : empID, */
		};
    	
		callJson("/fis/carte/lookup/getReserveInfo.moJson", params, fnNmGetter().name);
		
	}

	function callBack_$getReserveInfo(response, status) {
		
		reserveInfo = response.data;
		
		if (response.SUCCESS != "true") {
			alert("getReserveInfo error : " + response.ERR_MSG);
			return;
		} 
		else {
			//$("#reserveDN").html(reserveInfo.reserve_yn);
			setReserveInfo(reserveInfo);
		}
		
	}
	
	function setCarteInfoNextPrev() {
		
    	var monDate = $('.pager #mon').attr('value');
    	var tueDate = $('.pager #tue').attr('value');
    	var wedDate = $('.pager #wed').attr('value');
    	var thuDate = $('.pager #thu').attr('value');
    	var friDate = $('.pager #fri').attr('value');
    	
		var carteType = "DN";
		var empID = 'TESTID';
		
		var params = {
				
			emp_id : empID,
			carte_type : carteType,
			
			mon_date : monDate,
			tue_date : tueDate,
			wed_date : wedDate,
			thu_date : thuDate,
			fri_date : friDate,
			
		};
    	
		callJson("/fis/carte/lookup/setCarteInfoNextPrev.moJson", params, fnNmGetter().name);
		
	}
	
	function callBack_$setCarteInfoNextPrev(response, status) {
		
		reserveInfo = response.data;
		
		if (response.SUCCESS != "true") {
			alert("setCarteInfoNextPrev error : " + response.ERR_MSG);
			return;
		} 
		else {
			if( response.data != undefined || response.table!= undefined ) {
				//alert('setCarteInfoNextPrev SUCCESS');
				
				var dayNameArray = ['mon', 'tue', 'wed', 'thu', 'fri']; 
				var selector = "default";
				
				menuRows = response.table.mySheet.rows; // Select한 실제 Row들
				rowsCount = response.table.mySheet.totalCount; // Select한 Row의 전체 길이
				globalDateAndReserveInfo = response.data;
				
				//alert(menuRows[0].DATE % 100);
				
				var dateValueArray = [globalDateAndReserveInfo.presentMon, globalDateAndReserveInfo.presentTue,
				                      globalDateAndReserveInfo.presentWed, globalDateAndReserveInfo.presentThu, 
				                      globalDateAndReserveInfo.presentFri];
				
				//fn_setSpan('#monSpan', dateAndReserveInfo.presentYear);
				// 실제 pager 내부 날짜 setting 해주는 부분
				for(var i = 0; i < 5; i++) {
					selector = '#' + dayNameArray[i] + 'Span'; 
					fn_setSpan(selector, dateValueArray[i]);
				}
				
				fn_setSpan('#yearSpan', globalDateAndReserveInfo.presentYear);
				fn_setSpan('#monthSpan', globalDateAndReserveInfo.presentMonth);
				
				//fn_setSelectedDate('.pager #fri a');
				fn_setSelectedDate('.pager #' + dayNameArray[globalDateAndReserveInfo.presentDate - 
				                                             globalDateAndReserveInfo.presentMon] + ' a');
				
				fn_setPagerListDateValue(); // 날짜 value 우선 set

				setMenues(menuRows, rowsCount); // 이후에 menu set
				
				
				// 예약 여부 확인 BF, LC, L2는 필요하면 추가할 것 
				fn_setReserveYN_DN(globalDateAndReserveInfo);
				fn_setReserveCount_DN(globalDateAndReserveInfo);
			} // if close
			else {
				alert("response.data undefined");
			}
		}
		
	} //End callBack_$fn_setCarteInfoNextPrev

	/*
	function fn_setCarteInfo() { // Contoller에 다시 전달
		
		callJson("/fis/carte/lookup/getCarteInfo.moJson", null, fnNmGetter().name);
		
	}
	
	function callBack_$fn_setCarteInfo(response , status ){ // 실제 Menu Set 기능 수행
		
		if( response.SUCCESS != "true") { // 실패하면
			alert(response.ERR_MSG);
			return;
		} 
	
		else { // 성공하면
			if( response.data != undefined || response.table!= undefined ) {
				//alert(response.OK_MSG);	
				
				var dayNameArray = ['mon', 'tue', 'wed', 'thu', 'fri']; 
				var selector = "default";
				
				menuRows = response.table.mySheet.rows; // Select한 실제 Row들
				rowsCount = response.table.mySheet.totalCount; // Select한 Row의 전체 길이
				globalDateAndReserveInfo = response.data;
				
				//alert(menuRows[0].DATE % 100);
				
				var dateValueArray = [globalDateAndReserveInfo.presentMon, globalDateAndReserveInfo.presentTue,
				                      globalDateAndReserveInfo.presentWed, globalDateAndReserveInfo.presentThu, 
				                      globalDateAndReserveInfo.presentFri];
				
				//fn_setSpan('#monSpan', dateAndReserveInfo.presentYear);
				// 실제 pager 내부 날짜 setting 해주는 부분
				for(var i = 0; i < 5; i++) {
					selector = '#' + dayNameArray[i] + 'Span'; 
					fn_setSpan(selector, dateValueArray[i]);
				}
				
				fn_setSpan('#yearSpan', globalDateAndReserveInfo.presentYear);
				fn_setSpan('#monthSpan', globalDateAndReserveInfo.presentMonth);
				
				//fn_setSelectedDate('.pager #fri a');
				fn_setSelectedDate('.pager #' + dayNameArray[globalDateAndReserveInfo.presentDate - 
				                                             globalDateAndReserveInfo.presentMon] + ' a');
				
				fn_setPagerListDateValue(); // 날짜 value 우선 set

				setMenues(menuRows, rowsCount); // 이후에 menu set
				
				
				// 예약 여부 확인 BF, LC, L2는 필요하면 추가할 것 
				fn_setReserveYN_DN(globalDateAndReserveInfo);
				fn_setReserveCount_DN(globalDateAndReserveInfo);
			} // if close
			else {
				alert("response.data undefined");
			}
		} // else close
		
		return fn_setRating();
		
	} //End callBack_$fn_setCarteInfo
	*/

	
	/*******************************************************************************/
	
	/* 별점 관련 */
	
	function fn_setRating() { //랭킹 데이터 불러오기

		var selectedDate = $('.pager li .selected-date').parent().attr('value');

		var params = {
			selected_date : selectedDate,
		};
		
		callJson("/fis/rating/survey/getSelectedGradeAll.moJson", params, fnNmGetter().name);
	
	}//End of $fn_setRating()
	
	function callBack_$fn_setRating(response , status) { // 랭킹 달기
		
		if( response.SUCCESS != "true"){
			//alert(response.ERR_MSG);
			return;
		} 
		else {
			if( response.data != undefined || response.table!= undefined ){
				var list = null;
				
				fn_removePrevRating();
				
				list = response.table.mySheet.rows;
				/* 조회된 데이터를 table에 세팅한다. */
				
				//console.log(list);
				
				var text_type;
				var i, j;
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
					} // if close
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
					} // else if close
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
					} // else if close
					else if(list[i].CARTE_TYPE == 'L2') {
						//평점 그리기 // td id = l2_col 
						var div_l2_avg = document.createElement("div");
						div_l2_avg.setAttribute('id','rateL2');
						var p_l2_avg = document.createElement("span");
						//p_l2_avg.setAttribute('id','p_l2');
						var text_l2_avg = document.createTextNode(list[i].AVG);
						p_l2_avg.appendChild(text_l2_avg);
						//console.log(div_l2_avg);
						//console.log(document.getElementById("l2_rt"));
						if(document.getElementById("l2_rt") != null)
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
					} // else if close
				} //for close
			} 
			else {
				alert("response.data 정의 안됨 ");
			}
		} // else close
		
		resizeStarRating();
		
	}//End of callBack_$fn_setRating()

</script>

</body>

</html>

