package com.mall.search.controller;

import ibsheet.BaseMap;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fis.carte.input.service.CarteInputService;
import com.util.JsonUtil;
import com.vo.CarteVO;


/**
 * @Class Name : CarteInputController.java
 * @Description : 
 * @Modification Information
 * @
 * @ 수정일                         수정자                                      수정내용
 * @ -------------        ---------           -------------------------------
 * @ 2016. 01. 04.  	         김을동                   최초생성
 * @ 2016. 01. 21.          김을동                   식단 입력 화면 완료
 *
 * @author 김을동
 * @since
 * @version 1.0
 * @see
 */


@Controller
@RequestMapping(value = "/fis/carte/input")
public class SearchController {
	
	@Autowired
	private CarteInputService carteInputService;
	
	public static final Logger log = LoggerFactory.getLogger(SearchController.class); // 동작X
	
	
	/* HashMap으로 처리하기 위함 */
	//private static int totalDishNum = 9;
	//private static int totalDayNum = 5;
	
	private String[] dayName = new String[]{ "sdf","mon", "tue", "wed", "thu", "fri" };
	private String[] dishNum = new String[]{ "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine" };
	private String[] carteTypeName = new String[] {"BF", "LC", "DN", "L2"};
	//private ArrayList<String> fullName = new ArrayList<String>(); // monDishOne과 같은 full name
	//private ArrayList<Integer> carteTypeSeq = new ArrayList<Integer>(); // 0 : BF, 1 : LC, 2 : DN
	
	/* User 정보 - 나중에 실제 User 객체 있어야 함 */
	String creatorName = "TESTID"; 
	
	/** 
	 * 메인화면조회
	 * @param sheetSimpleVO
	 * @param req
	 * @param res
	 * @param model
	 * @return
	 */	

	/* 식단 입력 화면에서 기존에 입력된 식단 데이터 조회 부분*/
	@RequestMapping(value = "/getCarte.moJson")
	public String showCarte( @ModelAttribute("carteVO") CarteVO carteVO,
										HttpServletRequest req, HttpServletResponse res, ModelMap model) {
		
		/* 현재 사용X top */
		boolean isSuccess = true;
		BaseMap sum = new BaseMap();
		carteVO = new CarteVO();
		/* 현재 사용X bottom */
		
		List<BaseMap> selectedCarteList = null; // 실제 select된 식단 정보
		BaseMap dataDiff = new BaseMap(); // 날짜 차이 정보
		
		/* 실제로 select 하는 부분 */
		try{
			// test 용
			//selectedCarteList = carteInputService.selectList("20160118", "20160122");
			
			// 원본
			selectedCarteList = carteInputService.selectList(getStartDate(), getEndDate());

			// test용
			//String startDate = "20160118";
			
			// 원본
			String startDate = getStartDate();
						
			
			dataDiff.put("mon_diff", carteInputService.selectDateDiff(startDate, getEactDate("mon")));
			dataDiff.put("tue_diff", carteInputService.selectDateDiff(startDate, getEactDate("tue")));
			dataDiff.put("wed_diff", carteInputService.selectDateDiff(startDate, getEactDate("wed")));
			dataDiff.put("thu_diff", carteInputService.selectDateDiff(startDate, getEactDate("thu")));
			dataDiff.put("fri_diff", carteInputService.selectDateDiff(startDate, getEactDate("fri")));

			if (selectedCarteList.isEmpty() ) {
				System.out.println("기존에 입력된 식단 정보 없음");
			} else {
				System.out.println("기존에 입력된 식단 정보 있음");
			}
			
		} catch (Exception e){
			log.error("getCarte.moJson" , e);
			System.out.println(e);
			isSuccess = false;
		}
		
		JsonUtil.setReturnTable(req, isSuccess, "success getCarte.moJson", "error getCarte.moJson", 
				"mySheet", selectedCarteList, dataDiff, sum);
		
		String returnJsp = "common/ajax/json";
		return returnJsp;
		
	}
	
	@RequestMapping(value = "/insert.moJson", method = RequestMethod.POST)
	public String insertCarte( CarteVO carteVO,
			HttpServletRequest req, HttpServletResponse res, ModelMap model) throws Exception {
		
		Map<String, String> data = new HashMap();
		boolean isSuccess = true;
		List<CarteVO> listCarteVO = new ArrayList<CarteVO>();
		
		try {
			
			for (int i = 0; i < 5; i++) {  //요일
				
				String isChoiceTwo = req.getParameter(dayName[i] + "LC2"); // "mon" + "LC2"
				boolean lcChecked = false;
				
				for (int j = 0; j < 3; j++) {  //아침.점심.저녁
					
					carteVO = new CarteVO();
					
					carteVO.setDate(getEactDate(dayName[i] + carteTypeName[j] + dishNum[0]));
					carteVO.setCarte_type(carteTypeName[j]);
					carteVO.setMenu1(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[0]));
					carteVO.setMenu2(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[1]));
					carteVO.setMenu3(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[2]));
					carteVO.setMenu4(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[3]));
					carteVO.setMenu5(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[4]));
					carteVO.setMenu6(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[5]));
					carteVO.setMenu7(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[6]));
					carteVO.setMenu8(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[7]));
					carteVO.setMenu9(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[8]));
					carteVO.setCreator(creatorName);
					
					// NULL 체크하고 없으면 insert X
					if(carteVO.getMenu1() == "" && carteVO.getMenu2() == "" && carteVO.getMenu3() == "" && 
					carteVO.getMenu4() == "" && carteVO.getMenu5() == "" && carteVO.getMenu6() == "" && 
					carteVO.getMenu7() == "" && carteVO.getMenu8() == "" && carteVO.getMenu9() == "") {
						System.out.println("i=" + i + " / j=" + j + " : 입력하려는 식단의 row가 비어있음");
					}
					else {
						listCarteVO.add(carteVO); // 날짜 및 시간별 메뉴 리스트에 추가
					}
					
					if(j == 1) lcChecked = true; //점심1 (LC) 메뉴가 insert 되면 LC2에 들어갈 준비를 한다
					
					if (isChoiceTwo.equals("1") && lcChecked) {
						
						carteVO = new CarteVO();
						
						carteVO.setDate(getEactDate(dayName[i] + carteTypeName[j] + dishNum[0]));
						carteVO.setCarte_type(carteTypeName[3]); // "L2"로 Set
						carteVO.setMenu1(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[0] + "2"));
						carteVO.setMenu2(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[1] + "2"));
						carteVO.setMenu3(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[2] + "2"));
						carteVO.setMenu4(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[3] + "2"));
						carteVO.setMenu5(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[4] + "2"));
						carteVO.setMenu6(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[5] + "2"));
						carteVO.setMenu7(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[6] + "2"));
						carteVO.setMenu8(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[7] + "2"));
						carteVO.setMenu9(req.getParameter(dayName[i] + carteTypeName[j] + dishNum[8] + "2"));
						carteVO.setCreator(creatorName);
						
						listCarteVO.add(carteVO);
						
						isChoiceTwo = "0"; // 중복 실행 방지
						lcChecked = false; // 중복 실행 방지
						
					} // if
				} // for
			} // for
			
		} catch (Exception e) {
			log.error("insertCarte", e);
			isSuccess = false;
		}
		
		// 원본 DB에서 삭제 후 삽입
		carteInputService.deleteInsertCarte(getStartDate(), getEndDate(), listCarteVO);
		
		// test 용
		//carteInputService.deleteInsertCarte("20160118", "20160122", listCarteVO);
		
		String returnJsp = "redirect:/fis/carte/input/view.moJson"; //redirect
		//JsonUtil.getJsonStructure( req , isSuccess, "success.insert.carte", "error.insert.carte", data);
		
		// test 용
		//JsonUtil.getJsonStructure(req , isSuccess, "success.insert.carte.moJson", "error.insert.carte.moJson", data);
		//String returnJsp = "common/ajax/json";
		return returnJsp;
	}
	
	/* 식단 입력 jsp 화면 연결 */
	@RequestMapping(value = "/view.moJson")
	public String viewCarteInput( @ModelAttribute("carteVO") CarteVO carteVO,
										HttpServletRequest req, HttpServletResponse res, ModelMap model) {
		
		model.addAttribute("week_date" ,nextWeekText());  //뷰에 전달
		
		String returnJsp = "/fis/carte/input_carte";
		return returnJsp;
		
	}

	private Calendar getNextMonCalendar() { // 다음주 월요일 계산 getNextMondayCalendar
		
		Calendar nextMonCal = Calendar.getInstance();
		
		int weekday = nextMonCal.get(Calendar.DAY_OF_WEEK);
		
//		if (weekday != Calendar.MONDAY)
//		{
//		    // calculate how much to add
//		    // the 2 is the difference between Saturday and Monday
//		    int days = (Calendar.SATURDAY - weekday + 2) % 7;
//		    nextMonCal.add(Calendar.DAY_OF_YEAR, days);
//		}
		
		// 금, 토, 일은 다음주로 계산
		// 월, 화, 수, 목은 이번주로 계산
		switch (weekday) { 
		
		case 6: // 금요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 3);
			break;
		
		case 7: // 토요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 2);
			break;
			
		case 1: // 일요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 8);		
			break;
			
		case 2: // 월요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 0);
			break;
			
		case 3: // 화요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, -1);
			break;
			
		case 4: // 수요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, -2);
			break;
			
		case 5: // 목요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, -3);
			break;
	

		default:
			break;
		}
		
		// 무조건 다음주로 계산
		/*
		switch (weekday) { 
		
		case 7: // 토요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 2);
			break;
			
		case 1: // 일요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 8);		
			break;
					
		case 2: // 월요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 7);
			break;
			
		case 3: // 화요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 6);
			break;
			
		case 4: // 수요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 5);
			break;
			
		case 5: // 목요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 4);
			break;
			
		case 6: // 금요일
			nextMonCal.add(Calendar.DAY_OF_YEAR, 3);
			break;

		default:
			break;
		}
		*/
		
		return nextMonCal;
		
	}
	
	//@Test
	public String nextWeekText() { 
		
		String nextWeek = "default";
		
		Calendar nextMonCal = getNextMonCalendar();
		
		/* 화면에 찍히는 요일 */
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd E요일");
		
		String startDateStr = dateFormat.format(nextMonCal.getTime());
		//System.out.println(startDateStr);
		
		nextMonCal.add(Calendar.DAY_OF_YEAR, 4);
		String endDateStr = dateFormat.format(nextMonCal.getTime());
		//System.out.println(endDateStr);
		
		nextWeek = startDateStr + " ~ " + endDateStr;
		
		return nextWeek;
		
	}
	
	//public String getEactDate(String fullName) {
	public String getEactDate(String fullName) {
		
		//TEST
		//String fullName = "friL2One";
		
		String strEachDate = "";
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		
		// test 용
		//Calendar nextMonCal = getNextMonCalendar();
		//nextMonCal.add(Calendar.DAY_OF_YEAR, -7);
		
		// 원본
		Calendar nextMonCal = getNextMonCalendar();
		
		//nextMonCal.add(Calendar.DAY_OF_YEAR, 7);
		
		if(fullName.matches(".*mon.*")) { // 월요일인 경우
			//nextMonCal.add(Calendar.DAY_OF_YEAR, 4);
			strEachDate =  dateFormat.format(nextMonCal.getTime());
		}
		else if(fullName.matches(".*tue.*")) {
			nextMonCal.add(Calendar.DAY_OF_YEAR, 1);
			strEachDate =  dateFormat.format(nextMonCal.getTime());
		}
		else if(fullName.matches(".*wed.*")) {
			nextMonCal.add(Calendar.DAY_OF_YEAR, 2);
			strEachDate =  dateFormat.format(nextMonCal.getTime());
		}
		else if(fullName.matches(".*thu.*")) {
			nextMonCal.add(Calendar.DAY_OF_YEAR, 3);
			strEachDate =  dateFormat.format(nextMonCal.getTime());
		}
		else if(fullName.matches(".*fri.*")) {
			nextMonCal.add(Calendar.DAY_OF_YEAR, 4);
			strEachDate =  dateFormat.format(nextMonCal.getTime());
		}
		
		return strEachDate;
		
	}
	
	public String getEndDate() {
		
		//TEST
		//String fullName = "friL2One";
		
		String strEndDate = "";
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Calendar nextMonCal = getNextMonCalendar();
		
		nextMonCal.add(Calendar.DAY_OF_YEAR, 4);
		strEndDate =  dateFormat.format(nextMonCal.getTime());
		
		return strEndDate;
		
	}
	
	public String getStartDate() {
		
		//TEST
		//String fullName = "friL2One";
		
		String strStartDate = "";
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Calendar nextMonCal = getNextMonCalendar();
		
		//nextMonCal.add(Calendar.DAY_OF_YEAR, 7);
		
		strStartDate =  dateFormat.format(nextMonCal.getTime());
		
		return strStartDate;
		
	}

}

/* 이전 함수 소스코드 보관 */

/*	
@RequestMapping(value = "/view.moJson")
public String showCarte( @ModelAttribute("carteVO") CarteVO carteVO
									, HttpServletRequest req, HttpServletResponse res, ModelMap model) {
	
	List<CarteVO> resultList = null; // select 문
	
	try {
		resultList = carteInputService.selectList("20160125", "20160129");
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
//	for( CarteVO dto : resultList ) {
//
//		System.out.println("=================MEMBER DTO===============");
//		System.out.println("menu1 : "+ dto.getMenu1());
//		System.out.println("menu2 : "+dto.getMenu2());
//
//	}
	
	model.addAttribute("week_date" ,nextWeekText());  //뷰에 전달
	
	 week_date - 0000년 00월 00일 ~ 0000년 00월 00일 출력 
//	CarteVOBuilder builder = new CarteVOBuilder.Builder().menu1(resultList.getMenu1())
//			.menu2(resultList.getMenu2()).menu3(resultList.getMenu3()).menu4(resultList.getMenu4())
//			.menu5(resultList.getMenu5()).menu6(resultList.getMenu6()).menu7(resultList.getMenu7())
//			.menu8(resultList.getMenu8()).menu9(resultList.getMenu9())
//			.week_date(nextWeekText()).build();
	
//	carteVO.setParamsByBuilder(builder);
	
	String returnJsp = "/fis/carte/input_carte";
	return returnJsp;
}
*/

/*
@RequestMapping(value = "/insert.moJson", method = RequestMethod.POST)
public String insertCarte( CarteVO carteVO,
		HttpServletRequest req, HttpServletResponse res, ModelMap model) throws Exception {
	
	int tableRowsCount = Integer.valueOf(req.getParameter("tableRowLen")); // 테이블 row 길이 - 반복문 돌릴 횟수 산출
	int fullNameIndex = 0;
	
	HashMap<String , String> dishMap = convertReqToHashMap(req);
	
	for(int i = 0; i < tableRowsCount; i++) {
		
		// DB에 실제 데이터 삽입하는 부분
		CarteVOBuilder builder = new CarteVOBuilder.Builder().menu1(dishMap.get(fullName.get(fullNameIndex))).
			menu2(dishMap.get(fullName.get(fullNameIndex + 1))).menu3(dishMap.get(fullName.get(fullNameIndex + 2))).
			menu4(dishMap.get(fullName.get(fullNameIndex + 3))).menu5(dishMap.get(fullName.get(fullNameIndex + 4))).
			menu6(dishMap.get(fullName.get(fullNameIndex + 5))).menu7(dishMap.get(fullName.get(fullNameIndex + 6))).
			menu8(dishMap.get(fullName.get(fullNameIndex + 7))).menu9(dishMap.get(fullName.get(fullNameIndex + 8))).
			carte_type(carteTypeName[carteTypeSeq.get(i)]).creator(userName)
			.date(getEactDate(fullName.get(fullNameIndex)))
			.build();
		
		carteVO.setParamsByBuilder(builder);
		
		fullNameIndex += 9;
		
		try{
			
			carteInputService.insertList(carteVO);
			
		} catch (Exception e){
			
			System.out.println(e);
			
		}
		
	}
	
	//String returnJsp = "/fis/carte/input_carte";
	String returnJsp = "redirect:/fis/carte/input/view.moJson"; //redirect
	
	return returnJsp;
}
*/

/*
public HashMap<String, String> convertReqToHashMap(HttpServletRequest req) {
	
	HashMap<String, String> resultHashMap = new HashMap<String , String>();
	
	fullName.clear();
	carteTypeSeq.clear();
	
	for(int i = 0; i < totalDayNum; i++) { // 5번 - 월, 화, 수, 목, 금
		
		String isChoiceTwo = req.getParameter(dayName[i] + "LC2"); // "mon" + "LC2"
		System.out.println(isChoiceTwo);
		
		for(int k = 0; k < 3; k++) {
			
			carteTypeSeq.add(k % 3);
		
			for(int j = 0; j < totalDishNum; j++) { // 9번 - 1~9 
				
				//String dayAndDishNum = dayName[i] + carteTypeName[carteTypeSeq.get(i)] + dishNum[j]; // full name 생성
				String dayAndDishNum = dayName[i] + carteTypeName[carteTypeSeq.get(carteTypeSeq.size() - 1)] + dishNum[j]; // full name 생성
				fullName.add(dayAndDishNum); // full name 보관
				
				String getParamResult = req.getParameter(dayAndDishNum); // req로부터 full name에 해당하는 값 가져옴
				if(getParamResult == "") getParamResult = null;

				resultHashMap.put(dayAndDishNum, getParamResult); //HashMap에 삽입
				
			}
			
			if(isChoiceTwo.equals("1")) {
				
				carteTypeSeq.add(3); // L2는 3
				
				for(int j = 0; j < totalDishNum; j++) { // 9번 - 1~9
					
					String dayAndDishNum = dayName[i] + "LC" + dishNum[j] + "2"; // "mon" + "LC" + "one"
					fullName.add(dayAndDishNum); // full name 보관
					
					String getParamResult = req.getParameter(dayAndDishNum); // req로부터 full name에 해당하는 값 가져옴
					if(getParamResult == "") getParamResult = null;
					//System.out.println(getParamResult);
					
					resultHashMap.put(dayAndDishNum, getParamResult); //HashMap에 삽입
					
				}
				
				isChoiceTwo = "0"; // 한 번만 실행되게 초기화
				
			}
		}
	}
	
	return resultHashMap;
	
}

*/

