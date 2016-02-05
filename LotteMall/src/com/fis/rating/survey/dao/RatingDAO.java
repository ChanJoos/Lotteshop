package com.fis.rating.survey.dao;

import ibsheet.BaseMap;

import java.util.List;
import java.util.Map;

import com.vo.CarteVO;
import com.vo.RatingVO;
import com.vo.SheetSimpleVO;

public interface RatingDAO {
	List<BaseMap> getGrade(CarteVO carteVO) throws Exception;
	List<BaseMap> bestGrade(CarteVO carteVO) throws Exception;
	List<BaseMap> weekGrade(CarteVO carteVO) throws Exception;
	List<CarteVO> isTodayMenu(CarteVO carteVO) throws Exception;
	List<BaseMap> getTodayMenu(CarteVO carteVO) throws Exception;
	List<BaseMap> getSelectedMenu(CarteVO carteVO) throws Exception;
	List<BaseMap> getSelectedGradeAll(CarteVO carteVO) throws Exception;
	List<BaseMap> getUserHistory(RatingVO ratingVO) throws Exception;
	List<BaseMap> getUserHistory_type(RatingVO ratingVO) throws Exception;
	void insertEvalList(RatingVO ratingVO) throws Exception;
	void deleteEvalList(RatingVO ratingVO) throws Exception;
}
