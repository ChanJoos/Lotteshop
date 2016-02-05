<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>

<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>

<script type="text/javascript">

	$(document).ready(init);
	
	function init() {
		
		fn_setNavActive();
		fn_setEvent();
		fn_setMenuValue();
		fn_inputMaxLengthSet();
		//alert("init executed");
	}
	
	function fn_inputMaxLengthSet() {
		$('div.col-lg-input-carte input').attr('maxlength', '100');
	}
	
	function fn_setNavActive() {
		$('#carte-input').attr('class', 'active');
	}
	
	function fn_setRowLen() {
		
		var table = document.getElementById("carte_input");
		var rowsCount = table.rows.length;

		//alert(rowsCount);
		$("#tableRowLen").val(rowsCount);
		
	}
	
	function fn_getDateObjFromStr(fullDateStr) {
		
		var year = Math.round(fullDateStr / 10000);
		//alert(year);
		var month = Math.round((fullDateStr % 10000) / 100);
		//alert(month);
		var date = fullDateStr % 100;
		//alert(date);
		
		var dateObj = new Date();
		dateObj.setFullYear(year);
		dateObj.setMonth(month - 1);
		dateObj.setDate(date);
		
		return dateObj;
		
	}
	
	function fn_doInsertList() {
		
		fn_setRowLen();
		// 백업
		var formObj = $("form[role='form']");
		formObj.attr("action", "/fis/carte/input/insert.moJson");
		formObj.attr("method", "post");
		formObj.submit();
		
		alert("식단 입력이 완료되었습니다.");
		// test 용
		//var formObj = $("form[role='form']").serialize();
		//callJson("/fis/carte/input/insert.moJson", formObj, fnNmGetter().name);

	}

	/* 
	// test 용
	function callBack_$fn_doInsertList(response, status) {   
		
		alert("callBack_$fn_doInsertList");
		alert(response.SUCCESS);
        if (response.SUCCESS != "true") {
			alert("doInsertList Fail : " + response.ERR_MSG);
			return;
        }
        else {
			alert("doInsertList Success");
			fn_setMenuValueAfterInsert();
			return;
			//fn_setMenuValueAfterInsert();
        	//location.href = 'http://localhost:85/fis/carte/input/view.moJson';
		}
	}
	*/
	
	/* Controller가 전달한 메뉴 value들 set */
	function fn_setMenuValue() { // Contoller에 다시 전달
		
		callJson("/fis/carte/input/getCarte.moJson", null, fnNmGetter().name);
		
	}
	
	/* DATE와 CARTE_TYPE에 따라 알맞게 메뉴를 SEt해준다 */
	function callBack_$fn_setMenuValue(response , status ) { // 실제 Menu Set 기능 수행
		
		if( response.SUCCESS != "true"){ // 실패하면
			alert(response.ERR_MSG);
			return;
		} 
		
		else { // 성공하면
			if( response.data != undefined || response.table!= undefined ){
				//alert(response.OK_MSG);			
				var menuRows = null;
				var rowsCount = 0;
				var dateDiffData = null;
				
				menuRows = response.table.mySheet.rows; // Select한 실제 Row들
				rowsCount = response.table.mySheet.totalCount; // Select한 Row의 전체 길이
				
				//console.log(menuRows);
				
				dateDiffData = response.data;
				
				var tableRowSelector = '#carte_input ' + '.monLC' + ' td div input'; // 테이블 Row의 selector 
				var checkBoxSelector = '.monBF td #btn_check'; // 2식 선택 체크박스 selector 
				
				var presentDate = menuRows[0].DATE; // 시작일
				
				var dayName = 'mon'; // CARTE_TYPE
				
				var dateDiffArray = [dateDiffData.mon_diff, dateDiffData.tue_diff, dateDiffData.wed_diff, 
				                     		dateDiffData.thu_diff, dateDiffData.fri_diff];
				var dateDiffIndex = 0;
				var dateDiff = dateDiffArray[dateDiffIndex];
				
				for(var i = 0; i < rowsCount; i++) { 
					
					rowCarteType = menuRows[i].CARTE_TYPE; 
					rowDate = menuRows[i].DATE;
					
					//var dateObjRowDate = fn_getDateObjFromStr(rowDate); // 행의 Date 객체
					//var dateObjStartDate = fn_getDateObjFromStr(startDate); // 시작일의 Date 객체
					
					//var interval = dateObjRowDate - dateObjStartDate;
					//var day = 1000*60*60*24;

					if(presentDate != rowDate) { // 같지 않으면
						dateDiffIndex++;
						dateDiff = dateDiffArray[dateDiffIndex];
						presentDate = rowDate;
					}
					
					//var diffDays = Math.abs(dateObjRowDate - dateObjStartDate); // 일수 차이 계산
					//alert(dateDiff);
					
					if(dateDiff == 0) {
						//console.log('diffDays == 0');
						dayName = 'mon';
						checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(dateDiff == 1) {
						//console.log('diffDays == 1');
						dayName = 'tue';
						checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(dateDiff == 2) {
						//console.log('diffDays == 2');
						dayName = 'wed';
						checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(dateDiff == 3) {
						//console.log('diffDays == 3');
						dayName = 'thu';
						checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(dateDiff == 4) {
						//console.log('diffDays == 4');
						dayName = 'fri';
						checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
				}
			} // if close
			else {
				alert("response.data undefined");
			}
		} // if close
		
	} //End callBack_$fn_setMenuValue
	
	/*
	function fn_setMenuValueAfterInsert() { // Contoller에 다시 전달
		
		callJson("/fis/carte/input/getCarte.moJson", null, fnNmGetter().name);
		
	}
	
	function callBack_$fn_setMenuValueAfterInsert(response , status ) { // 실제 Menu Set 기능 수행
		
		if( response.SUCCESS != "true"){ // 실패하면
			alert(response.ERR_MSG);
			return;
		} 
		
		else { // 성공하면
			if( response.data != undefined || response.table!= undefined ){
				//alert(response.OK_MSG);			
				var menuRows = null;
				var rowsCount = 0;
				
				menuRows = response.table.mySheet.rows; // Select한 실제 Row들
				rowsCount = response.table.mySheet.totalCount; // Select한 Row의 전체 길이
				
				data = response.data;
				
				var tableRowSelector = '#carte_input ' + '.monLC' + ' td div input'; // 테이블 Row의 selector 
				var checkBoxSelector = '.monBF td #btn_check'; // 2식 선택 체크박스 selector 
				var startDate = menuRows[0].DATE; // 시작일
				var dayName = 'mon'; // CARTE_TYPE
				
				for(var i = 0; i < rowsCount; i++) { 
					
					rowCarteType = menuRows[i].CARTE_TYPE; 
					rowDate = menuRows[i].DATE;
					
					var dateObjRowDate = fn_getDateObjFromStr(rowDate); // 행의 Date 객체
					var dateObjStartDate = fn_getDateObjFromStr(startDate); // 시작일의 Date 객체
					
					var timeDiff = Math.abs(dateObjRowDate.getTime() - dateObjStartDate.getTime());
					var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); // 일수 차이 계산
					//alert(diffDays);
					
					if(diffDays == 0) {
						console.log('diffDays == 0');
						//dayName = 'mon';
						//checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						//tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						checkBoxSelector = '.mon' + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .mon' + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(diffDays == 1) {
						console.log('diffDays == 1');
						//dayName = 'tue';
						//checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						//tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						checkBoxSelector = '.tue' + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .tue' + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(diffDays == 2) {
						console.log('diffDays == 2');
						//dayName = 'wed';
						//checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						//tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						checkBoxSelector = '.wed' + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .wed' + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(diffDays == 3) {
						console.log('diffDays == 3');
						//dayName = 'thu';
						//checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						//tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						checkBoxSelector = '.thu' + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .thu' + rowCarteType + ' td div input';
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
					else if(diffDays == 4) {
						console.log('diffDays == 4');
						//dayName = 'fri';
						//checkBoxSelector = '.' + dayName + rowCarteType + ' td #btn_check';
						//tableRowSelector = '#carte_input .' + dayName + rowCarteType + ' td div input';
						checkBoxSelector = '.fri' + rowCarteType + ' td #btn_check';
						tableRowSelector = '#carte_input .fri' + rowCarteType + ' td div input';
						
						if(rowCarteType == 'L2') {
							checkBoxSelector = '.' + dayName + 'BF' + ' td #btn_check';
							tableRowSelector = '#carte_input .' + dayName + 'LC2' + ' td div input';
							$(checkBoxSelector).attr("checked", true);
							$(checkBoxSelector).trigger('change');
						}
						setRowMenues(tableRowSelector, menuRows[i]);
					}
				}
			} // if close
			else {
				alert("response.data undefined");
			}
		} // if close
		
	} //End callBack_$fn_setMenuValue
	*/
	
	/* input tyep=text의 menu 값들을 set 해준다 - 식단 입력 전 조회 기능 */
	function setRowMenues(selector, menuRow) {
		
		var menuIndex = 0; // MENU1, MENU2 등을 표시해주는 Index
		var rowIndex = 0; // 행의 위치 index (ex. 월요일-아침, 금요일-점심2)
		
		//console.log(selector);
		//console.log(menuRow);
		
		$(selector).each(function(){ // input에 하나씩 set
			
			if(menuIndex % 9 == 0)
				$(this).val(menuRow.MENU1);
			
			if(menuIndex % 9 == 1)
				$(this).val(menuRow.MENU2);
			
			if(menuIndex % 9 == 2)
				$(this).val(menuRow.MENU3);
			
			if(menuIndex % 9 == 3)
				$(this).val(menuRow.MENU4);
			
			if(menuIndex % 9 == 4)
				$(this).val(menuRow.MENU5);
			
			if(menuIndex % 9 == 5)
				$(this).val(menuRow.MENU6);
			
			if(menuIndex % 9 == 6)
				$(this).val(menuRow.MENU7);
			
			if(menuIndex % 9 == 7)
				$(this).val(menuRow.MENU8);
			
			if(menuIndex % 9 == 8) {
				$(this).val(menuRow.MENU9);
				rowIndex++; // 행 index 조정				
			}
			
			menuIndex++; // 메뉴 index 조정
			
		});

		return;
	}
	
	function fn_setEvent() {
		
		$("#insertCarte").click(function() {
			//fn_doSave();
			fn_doInsertList();
		});
		
		
		$(".check_lc").change(function() {
			var dayName = this.value;
			var willBeclonedRowName = dayName + "LC";
			clonedRowName = willBeclonedRowName + "2";
			var willBeclonedRow = $("." + willBeclonedRowName);
			
			if (this.checked) {
				
				var clonedRow = willBeclonedRow.clone();

				$("#" + dayName + "LC2").val("1"); // 메뉴가 2개임을 표시
				
				clonedRow.removeClass(willBeclonedRowName).addClass(clonedRowName); // class 이름 변경

				clonedRow.insertAfter($("#carte_input ." + willBeclonedRowName + ":last")); //carte_input은 table class 이름
				resizeRowspan(dayName, 4);
				
				$('.' + dayName + 'LC2 div input').each(function(){
					var inputName = $(this).attr('name');

					$(this).removeAttr('name');
					$(this).attr('name', inputName + "2");
					$(this).val("");
				});

			} else {
				$("." + clonedRowName).remove();
				$("#" + dayName + "LC2").val("0"); // 메뉴가 1개임을 표시
				
				resizeRowspan(dayName, 3);
			}
		});

		function resizeRowspan(dayName, num) {
			
			var dayNameAndType = dayName + 'BF';
			
			$("." + dayNameAndType + ":first td:eq(0)").attr("rowspan", num);
			$("." + dayNameAndType + ":first td:eq(1)").attr("rowspan", num);
			
		}
		
	}
	
	/* 이전 함수 소스 보관 */
	/*
	function fn_setMenuValue() {
		
		var list = new Array(); 
		
		var cars = ["1", "2", "3", "4", "5", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"];
		//carteVO.menu1
		
		var i = 0;
		$('#carte_input tr td div input').each(function(){
			$(this).val(cars[i]);Ca
			i++;
		});

	}
	*/
	 
</script>

</body>

</html>
