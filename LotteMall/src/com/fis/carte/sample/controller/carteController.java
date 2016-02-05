package com.fis.carte.sample.controller;

import com.fis.carte.sample.service.CarteService;
import com.util.DateUtil;
import com.util.JsonUtil;
import com.util.SessionUtil;
import com.vo.CarteVO;
import com.vo.UserVO;

import ibsheet.BaseMap;

import java.util.Calendar;
import java.util.List;
import java.util.Map;

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
 * @Class Name : carteController.java
 * @Description : 
 * @Modification Information
 * @
 * @  수정일          수정자                  수정내용
 * @ ---------        ---------   -------------------------------
 * @ 2016. 01. 06.  	허용준                   최초생성
 *
 * @author 허용준
 * @since
 * @version 1.0
 * @see
 */


@Controller
@RequestMapping(value = "/fis/carte/sample")
public class carteController {
	
	private CarteService carteService;
	
	public carteController() {
		// TODO Auto-generated constructor stub
	}
	
	/** 
	 * 메인화면조회
	 * @param sheetSimpleVO
	 * @param req
	 * @param res
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/doSearchCarte")
	
	public String searchCarte( @ModelAttribute("carteVO") CarteVO carteVO
										,	HttpServletRequest req, HttpServletResponse res, ModelMap model) {
		Logger log = LoggerFactory.getLogger(carteController.class);
		
		String returnJsp = "/fis/carte/input_carte";
		boolean isSuccess = true;
		
		List<BaseMap> list = null ;
		
		try{
			
			//세션정보 가져오는 것
			UserVO session = SessionUtil.getInstance().getUser(req);
			
			list = carteService.selectList(carteVO);
			
		} catch (Exception e){
			
			log.error("doSearchDetailJson" , e );
			isSuccess = false;
			
		}
		//JsonUtil.setReturnTable(req, isSuccess, "success.common.search.01", "error.common.search.01", "mySheet", list, null);
		
		return returnJsp;
	}
	
	
}
