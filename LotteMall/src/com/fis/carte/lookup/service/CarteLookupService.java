package com.fis.carte.lookup.service;

import ibsheet.BaseMap;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fis.carte.input.dao.CarteInputDAO;
import com.fis.carte.lookup.dao.CarteLookupDAO;
import com.vo.CarteReserveInfoVO;
import com.vo.CarteVO;

/**
 * @Class Name : CarteLookupService.java
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

@Service("com.fis.carte.lookup.service.CarteLookupService")
public class CarteLookupService {

	Logger log = LoggerFactory.getLogger(CarteLookupService.class);
	
	@Autowired
	private CarteLookupDAO carteLookupDAO;
	
	public void deleteCarteRows(String startDate, String endDate) throws Exception {
		carteLookupDAO.deleteCarteRows(startDate, endDate);
	}
	
//	public List<CarteVO> selectList(String startDate, String endDate) throws Exception {
//		return carteInputDAO.selectList(startDate, endDate);
//	}
	
	public List<BaseMap> selectCarteList(String startDate, String endDate) throws Exception {
		return carteLookupDAO.selectCarteList(startDate, endDate);
	}
	
	public void insertReservation(CarteReserveInfoVO carteReserveInfoVO) throws Exception {
		carteLookupDAO.insertReservation(carteReserveInfoVO);
	}
	
	//	List<BaseMap> selectReserveList(@Param("date") String date,
	//@Param("carte_type") String carte_type, @Param("emp_id") String emp_id) throws Exception;
	public String selectReserveList(String date, String carte_type, String emp_id) throws Exception {
		return carteLookupDAO.selectReserveList(date, carte_type, emp_id);
	}
		
	public Integer selectReserveCount(String date, String carte_type) throws Exception {
		return carteLookupDAO.selectReserveCount(date, carte_type);
	}
	
}
