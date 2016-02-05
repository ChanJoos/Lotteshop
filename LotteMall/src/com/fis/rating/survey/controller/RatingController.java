package com.fis.rating.survey.controller;


import com.fis.carte.sample.service.CarteService;
import com.fis.rating.survey.service.RatingService;
import com.util.DateUtil;
import com.util.JsonUtil;
import com.util.SessionUtil;
import com.vo.CarteVO;
import com.vo.RatingVO;
import com.vo.UserVO;

import ibsheet.BaseMap;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mMoin.MmoinUtil;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


/**
 * @Class Name : RatingController.java
 * @Description : 
 * @Modification Information
 * @
 * @  수정일          수정자                  수정내용
 * @ ---------        ---------   -------------------------------
 * @ 2016. 01. 14.  	남현석                   최초생성
 *
 * @author 남현석
 * @since
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/fis/rating/survey")
public class RatingController {

	public static final String MYSHEET = "mySheet";
	public static final String SUCCESS_SEARCH = "success.common.search.01";
	public static final String ERROR_SEARCH = "error.common.search.01";
	public static final String RETURN_JSON = "common/ajax/json";
	public static final String RETURN_RATINGVIEW = "/fis/rating/Rating";
	public static final String RETURN_SURVEYVIEW = "/fis/rating/SurveyForm";
	public static final String RETURN_WEEKVIEW = "/fis/rating/WeekRating";
	
	@Autowired
	private RatingService ratingService;
	private Logger log;
	
	public RatingController() {
		log = LoggerFactory.getLogger(RatingController.class);
	}
	
	/**
	 * 오늘 식단 조회
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_JSON
	 */	
	@RequestMapping(value = "/getTodayMenu.moJson")
	public String getTodayMenu(@ModelAttribute("carteVO") CarteVO carteVO
			,	HttpServletRequest req, HttpServletResponse res, ModelMap model) {

		String returnJsp= RETURN_JSON;
		boolean isSuccess = true;
		
		Map etcData = new HashMap();
		List<BaseMap> list = null;
		
		BaseMap sum = null;
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//오늘의 메뉴 가져오기
			list = ratingService.getTodayMenu(carteVO);
			System.out.println("오늘 메뉴 비었는가? "+list.isEmpty() );
			if (list.isEmpty() ) {
				System.out.println("오늘 메뉴 데이터 없음");
				isSuccess = false;
			} else {
				sum = list.get(0);
			}
		
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
		}
		
		JsonUtil.setReturnTable(req, isSuccess, SUCCESS_SEARCH, ERROR_SEARCH, MYSHEET, list, etcData, sum);
		
		return returnJsp;
	}
	
	
	
	
	/**
	 * (최신)식단 제공여부 조회
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_JSON
	 */	
	@RequestMapping(value = "/surveyRating.moJson")
	public String form(@ModelAttribute("carteVO") CarteVO carteVO
			,	HttpServletRequest req, HttpServletResponse res, ModelMap model) {

		String returnJsp= RETURN_JSON;
		boolean isSuccess = true;
		
		Map<String, String> param = new HashMap();
		List<CarteVO> list = null;
		
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//객체로 리턴 받는 것
			list = ratingService.isTodayMenu(carteVO);
			if (list.isEmpty() ) {
				System.out.println("오늘 메뉴 제공 안함");
				isSuccess = false;
			}
		
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
		}
		
		JsonUtil.getJsonStructure( req , isSuccess, SUCCESS_SEARCH, "error.common.insert.01", param);
		
		return returnJsp;
	}
	
	/**
	 * 설문내용 DB 내 입력
	 * @param ratingVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_JSON
	 */	
	@RequestMapping(value = "/submitRating.moJson", method=RequestMethod.POST)
	public String submit(RatingVO ratingVO,
				HttpServletRequest req, HttpServletResponse res, ModelMap model ) throws Exception {
		
		Map<String, String> data = new HashMap();
		String star1 = req.getParameter("respenses0");
		String star2 = req.getParameter("respenses1");
		String star3 = req.getParameter("respenses2");
		String star4 = req.getParameter("respenses3");
		List<BaseMap> list = null;
		
		String returnJsp =  RETURN_JSON;
		boolean isSuccess = true;
		
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//점심1 과 점심2 중복 설문여부조사 
			if( (Integer.parseInt(star2) !=0) && (Integer.parseInt(star3) != 0) ) {
				isSuccess = false;
			} else {
				for(int i=0; i<4; i++) {
					ratingVO = new RatingVO();
					ratingVO.setEmp_id( "NAMHYUNSUK" ); //tester 추후 로그인세션 기능 추가되는대로 수정
					ratingVO.setCreator( "NAMHYUNSUK" );
					int history_grade=0; //사용자의 이전 평가기록
					switch(i) {
					case 0:
						 ratingVO.setCarte_type("BF");
						 if( Integer.parseInt(star1) == 0 ) {
							ratingService.deleteEvalList(ratingVO);
							 continue;
						}
				         ratingVO.setGrade(Integer.parseInt(star1) );
				         list = ratingService.getUserHistory_type(ratingVO);

				         if(list.isEmpty() ) {
				        	 ratingService.insertEvalList(ratingVO);
				         } else {
				        	 history_grade= Integer.parseInt(list.get(0).get("GRADE").toString());
				        	 ratingService.deleteEvalList(ratingVO);
				        	 ratingService.insertEvalList(ratingVO);
				         }
				         break;
					case 1:
						 ratingVO.setCarte_type("LC");
						 if( Integer.parseInt(star2) == 0 ) {
								ratingService.deleteEvalList(ratingVO);
								 continue;
							}
				         ratingVO.setGrade(Integer.parseInt(star2) );
				         
				         list = ratingService.getUserHistory_type(ratingVO);
				         
				         if(list.isEmpty() ) {
				        	 ratingService.insertEvalList(ratingVO);
				         } else {
				        	 history_grade= Integer.parseInt(list.get(0).get("GRADE").toString());
				        	 ratingService.deleteEvalList(ratingVO);
				        	 ratingService.insertEvalList(ratingVO);
				         }
				         break;
					case 2:
						 ratingVO.setCarte_type("L2");
						 if( Integer.parseInt(star3) == 0 ) {
								ratingService.deleteEvalList(ratingVO);
								 continue;
							}
				         ratingVO.setGrade(Integer.parseInt(star3) );
				         list = ratingService.getUserHistory_type(ratingVO);
				         
				         if(list.isEmpty() ) {
				        	 ratingService.insertEvalList(ratingVO);
				         } else {
				        	 history_grade= Integer.parseInt(list.get(0).get("GRADE").toString());
				        	 ratingService.deleteEvalList(ratingVO);
				        	 ratingService.insertEvalList(ratingVO);
				         }
				         break;
					case 3:
						 ratingVO.setCarte_type("DN");
						 if( Integer.parseInt(star4) == 0 ) {
								ratingService.deleteEvalList(ratingVO);
								 continue;
							}
				         ratingVO.setGrade(Integer.parseInt(star4) );
				         list = ratingService.getUserHistory_type(ratingVO);
				         
				         if(list.isEmpty() ) {
				        	 ratingService.insertEvalList(ratingVO);
				         } else {
				        	 history_grade= Integer.parseInt(list.get(0).get("GRADE").toString());
				        	 ratingService.deleteEvalList(ratingVO);
				        	 ratingService.insertEvalList(ratingVO);
				         }
				         break;
					}
					 list.clear();
				}//end of for
			}//end of else
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
			
		}
        JsonUtil.getJsonStructure( req , isSuccess, SUCCESS_SEARCH, "error.common.insert.01", data);
		
        return returnJsp;
	}
	
	/**
	 * 평점 화면 호출
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_RATINGVIEW
	 */	
	@RequestMapping(value = "/viewRating.moJson")
	public String viewRating( @ModelAttribute("carte") CarteVO carteVO, 
			HttpServletRequest req, HttpServletResponse res, ModelMap model) {

		String returnJsp = RETURN_RATINGVIEW;
		
		return returnJsp;
	}
	
	/**
	 * 평가 입력화면 호출
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/openSurveyForm.moJson")
	public String openSurveyForm( @ModelAttribute("carte") CarteVO carteVO, 
			HttpServletRequest req, HttpServletResponse res, ModelMap model) {
		String returnJsp = RETURN_SURVEYVIEW;
		
		return returnJsp;
	}
	
	/**
	 * 사용자 금일 평점기록여부 조회
	 * @param ratingVO
	 * @param req
	 * @param res
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/checkHistory.moJson")
	public String checkHistory( @ModelAttribute("rating") RatingVO ratingVO, 
			HttpServletRequest req, HttpServletResponse res, ModelMap model) {
		
		String returnJsp = RETURN_JSON;
		boolean isSuccess = true;

		Map etcData = new HashMap();
		List<BaseMap> list = null;
		
		ratingVO = new RatingVO();
		BaseMap sum = null;
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//사용자명 삽입 (추후 로그인 기능 완성될시 수정)
			ratingVO.setEmp_id("NAMHYUNSUK");
			//사용자 금일 기록가져오기
			list = ratingService.getUserHistory(ratingVO);
			if (list.isEmpty() ) {
				System.out.println("금일 기록 없음");
			} else {
				sum = list.get(0);
			}
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
		}
		JsonUtil.setReturnTable(req, isSuccess, SUCCESS_SEARCH, ERROR_SEARCH, MYSHEET, list, etcData, sum);
		
		return returnJsp;
	}
	
	
	/**
	 * 평점 DB조회
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_JSON
	 */	
	@RequestMapping(value = "/getRating.moJson")
	public String getRating( @ModelAttribute("avgTodayRating") CarteVO carteVO,
										HttpServletRequest req, HttpServletResponse res, ModelMap model) {
		String returnJsp = RETURN_JSON;
		boolean isSuccess = true;

		Map etcData = new HashMap();
		List<BaseMap> list = null;
		 
		carteVO = new CarteVO();
		BaseMap sum = null;
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//금일메뉴 평점 가져오기 
			list = ratingService.getGrade(carteVO);
			if (list.isEmpty() ) {
				System.out.println("금일 데이터 무");
			} else {
				sum = list.get(0);
			}
			
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
		}
		JsonUtil.setReturnTable(req, isSuccess, SUCCESS_SEARCH, ERROR_SEARCH, MYSHEET, list, etcData, sum);
		
		return returnJsp;
	}
	
	/**
	 * 이달의 베스트 식단 DB조회
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_JSON
	 */	
	@RequestMapping(value = "/bestGrade.moJson")
	public String getBestRating( @ModelAttribute("bestGrade") CarteVO carteVO,
										HttpServletRequest req, HttpServletResponse res, ModelMap model) {
	
		String returnJsp = RETURN_JSON;
		boolean isSuccess = true;

		Map etcData = new HashMap();
		List<BaseMap> list = null;
		
		carteVO = new CarteVO();
		BaseMap sum = null;
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//이달 베스트 메뉴 가져오기
			list = ratingService.bestGrade(carteVO);
			if (list.isEmpty() ) {
				System.out.println("이달 메뉴 기록 없음");
			} else {
				sum = list.get(0);
			}
			
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
		}
		JsonUtil.setReturnTable(req, isSuccess, SUCCESS_SEARCH, ERROR_SEARCH, MYSHEET, list, etcData, sum);
		
		return returnJsp;
	}

	/**
	 * 이번주 식단 평가화면
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_WEEKVIEW
	 */	
	@RequestMapping(value = "/viewWeek.moJson")
	public String viewWeek( @ModelAttribute("carte") CarteVO carteVO, 
			HttpServletRequest req, HttpServletResponse res, ModelMap model) {
		String returnJsp = RETURN_WEEKVIEW;
		
		return returnJsp;
	}


	/**
	 * 금주 평점 DB조회
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_JSON
	 */	
	@RequestMapping(value = "/weekGrade.moJson")
	public String weekGrade( @ModelAttribute("weekGrade") CarteVO carteVO,
										HttpServletRequest req, HttpServletResponse res, ModelMap model) {

		String returnJsp = RETURN_JSON;
		boolean isSuccess = true;

		Map etcData = new HashMap();
		List<BaseMap> list = null;
		
		//날짜 불러오기
		String selectedDate = req.getParameter("selected_date");
		String end_date = req.getParameter("end_date");
		carteVO = new CarteVO();
		carteVO.setDate(selectedDate); 
		carteVO.setEnd_date(end_date);
		/*
		Calendar cal = Calendar.getInstance();
		//금주 월요일 : df.format(cal.getTime())
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		*/
//		carteVO.setDate(df.format(cal.getTime()));
		BaseMap sum = null;
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//금주 평점 가져오기
			list = ratingService.weekGrade(carteVO);
			if (list.isEmpty() ) {
				System.out.println("데이터 없음");
			} else {
				sum = list.get(0);
			}
			
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
			
		}
		JsonUtil.setReturnTable(req, isSuccess, SUCCESS_SEARCH, ERROR_SEARCH, MYSHEET, list, etcData, sum);
		
		return returnJsp;
	}
	
	/**
	 * 선택된 날 메뉴 조회
	 * @param carteVO
	 * @param req
	 * @param res
	 * @param model
	 * @return RETURN_JSON
	 */	
	@RequestMapping(value = "/getSelectedDay.moJson")
	public String getSelectedDay(@ModelAttribute("carteVO") CarteVO carteVO
			,	HttpServletRequest req, HttpServletResponse res, ModelMap model) {

		String returnJsp= RETURN_JSON;
		boolean isSuccess = true;
		
		Map etcData = new HashMap();
		List<BaseMap> list = null;
		
		BaseMap sum = null;
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//선택된 날과 타입 불러오기
			String selectedDate = req.getParameter("selected_date");
			String carteType = req.getParameter("carte_type");
			
			//VO설정
			carteVO.setDate(selectedDate); 
			carteVO.setCarte_type(carteType);
			
			list = ratingService.getSelectedMenu(carteVO);
			if (list.isEmpty() ) {
				isSuccess = false;
			} else {
				sum = list.get(0);
			}
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
		}
		
		JsonUtil.setReturnTable(req, isSuccess, SUCCESS_SEARCH, ERROR_SEARCH, MYSHEET, list, etcData, sum);
		
		return returnJsp;
	}
	
	@RequestMapping(value = "/getSelectedGradeAll.moJson")
	public String getSelectedDayAll(@ModelAttribute("carteVO") CarteVO carteVO
			,	HttpServletRequest req, HttpServletResponse res, ModelMap model) {

		String returnJsp= RETURN_JSON;
		boolean isSuccess = true;
		
		Map etcData = new HashMap();
		List<BaseMap> list = null;
		
		BaseMap sum = null;
		try{
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			//선택된 날과 타입 불러오기
			String selectedDate = req.getParameter("selected_date");
			
			//VO설정
			carteVO.setDate(selectedDate); 
			
			list = ratingService.getSelectedGradeAll(carteVO);
			if (list.isEmpty() ) {
				isSuccess = false;
			} else {
				sum = list.get(0);
			}
		} catch (Exception e){
			log.error("doSearchDetailJson" , e );
			System.out.println(e);
			isSuccess = false;
		}
		
		JsonUtil.setReturnTable(req, isSuccess, SUCCESS_SEARCH, ERROR_SEARCH, MYSHEET, list, etcData, sum);
		
		return returnJsp;
	}
}

