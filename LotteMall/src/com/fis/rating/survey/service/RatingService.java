package com.fis.rating.survey.service;

import ibsheet.BaseMap;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fis.carte.sample.dao.CarteDAO;
import com.fis.rating.survey.dao.RatingDAO;
import com.vo.CarteVO;
import com.vo.RatingVO;

/**
 * @Class Name : carteService.java
 * @Description : 
 * @Modification Information
 * @
 * @  수정일          수정자                  수정내용
 * @ ---------        ---------   -------------------------------
 * @ 2016. 01. 14.  	남현석                   최초생성
 *
 * @author NP007
 * @since
 * @version 1.0
 * @see
 */
@Service("com.fis.rating.servey.service.RatingService")
public class RatingService {
	Logger log = LoggerFactory.getLogger(RatingService.class);
	
	@Autowired
	private RatingDAO ratingDAO;
	
	//평점조회
	public List<BaseMap> getGrade(CarteVO carteVO) throws Exception {
		return ratingDAO.getGrade(carteVO);
	}
	//이달 베스트 조회
	public List<BaseMap> bestGrade(CarteVO carteVO) throws Exception {
		return ratingDAO.bestGrade(carteVO);
	}
	//금주 평점조회
	public List<BaseMap> weekGrade(CarteVO carteVO) throws Exception {
		return ratingDAO.weekGrade(carteVO);
	}
	//금일 메뉴존재여부 확인
	public List<CarteVO> isTodayMenu(CarteVO carteVO) throws Exception {
		return ratingDAO.isTodayMenu(carteVO);
	}
	//사용자 평점기록 조회
	public List<BaseMap> getUserHistory(RatingVO ratingVO) throws Exception {
		return ratingDAO.getUserHistory(ratingVO);
	}
	//금일 메뉴조회
	public List<BaseMap> getTodayMenu(CarteVO carteVO) throws Exception {
		return ratingDAO.getTodayMenu(carteVO);
	}
	//선택된 날, 타입의 메뉴조회
	public List<BaseMap> getSelectedMenu(CarteVO carteVO) throws Exception {
		return ratingDAO.getSelectedMenu(carteVO);
	}
	
	// 추가 선택된 날, 모든 타입의 메뉴조회 (추가)
	public List<BaseMap> getSelectedGradeAll(CarteVO carteVO) throws Exception {
		return ratingDAO.getSelectedGradeAll(carteVO);
	}
		
	//사용자 평점기록 조회(타입별)
	public List<BaseMap> getUserHistory_type(RatingVO ratingVO) throws Exception {
		return ratingDAO.getUserHistory(ratingVO);
	}
	//평점기록
	public void insertEvalList(RatingVO ratingVO) throws Exception {
		ratingDAO.insertEvalList(ratingVO);
	}
	//기록제거
	public void deleteEvalList(RatingVO ratingVO) throws Exception {
		ratingDAO.deleteEvalList(ratingVO);
	}
}