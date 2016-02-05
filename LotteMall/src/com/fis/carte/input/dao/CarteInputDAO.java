package com.fis.carte.input.dao;

import ibsheet.BaseMap;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.vo.CarteVO;

public interface CarteInputDAO {
	//List<BaseMap> selectList(CarteVO carteVO) throws Exception;
	void insertCarteRow(CarteVO carteVO) throws Exception;
	//void insertList() throws Exception;
	void deleteCarteRows(@Param("startRow") String startDate,
			@Param("endRow") String endDate) throws Exception;
//	List<CarteVO> selectList(@Param("startDate") String startDate,
//			@Param("endDate") String endDate) throws Exception;
	List<BaseMap> selectList(@Param("startDate") String startDate,
			@Param("endDate") String endDate) throws Exception;
	Integer selectDateDiff(@Param("criteriaDate") String criteriaDate, 
			@Param("inputDate") String inputDate) throws Exception;
}
