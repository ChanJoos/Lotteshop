package com.fis.carte.lookup.dao;

import ibsheet.BaseMap;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.vo.CarteReserveInfoVO;
import com.vo.CarteVO;

/**
 * @Class Name : CarteLookupDao.java
 * @Description : 
 * @Modification Information
 * @
 * @ 수정일                         수정자                                      수정내용
 * @ -------------        ---------           -------------------------------
 * @ 2016. 01. 21.  	         김을동                   최초생성
 * @ 2016. 01. 22.          김을동                   식단 조회 기능 완료
 * @ 2016. 01. 25.          김을동                   저녁 예약 기능 구현 완료
 * @ 2016. 01. 26.          김을동                   저녁 예약 인원수 조회 기능 완료
 * 
 * @author 김을동
 * @since
 * @version 1.0
 * @see
 */

public interface CarteLookupDAO {
	void deleteCarteRows(@Param("startRow") String startDate,
			@Param("endRow") String endDate) throws Exception;
	
	List<BaseMap> selectCarteList(@Param("startDate") String startDate,
			@Param("endDate") String endDate) throws Exception;
	
	void insertReservation(CarteReserveInfoVO carteReserveInfoVO) throws Exception;
	
	//WHERE DATE = #{date} AND CARTE_TYPE = #{carte_type} AND EMP_ID = #{emp_id}
	String selectReserveList(@Param("date") String date,
			@Param("carte_type") String carte_type, @Param("emp_id") String emp_id) throws Exception;
	
	//selectReserveCount
	Integer selectReserveCount(@Param("count_date") String date,
			@Param("count_carte_type") String carte_type) throws Exception;
	
}
