package com.fis.carte.input.service;

import ibsheet.BaseMap;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fis.carte.input.dao.CarteInputDAO;
import com.vo.CarteVO;

/**
 * @Class Name : CarteInputService.java
 * @Description : 
 * @Modification Information
 * @
 * @ 수정일                         수정자                                      수정내용
 * @ -------------        ---------           -------------------------------
 * @ 2016. 01. 04.  	         김을동                   최초생성
 * @ 2016. 01. 21.          김을동                   deleteCarteRows, selectList 추가
 *
 * @author 김을동
 * @since
 * @version 1.0
 * @see
 */

@Service("com.fis.carte.input.service.CarteInputService")
public class CarteInputService {

	Logger log = LoggerFactory.getLogger(CarteInputService.class);
	
	@Autowired
	private CarteInputDAO carteInputDAO;
	
	public void insertCarteRow(CarteVO carteVO) throws Exception {
		carteInputDAO.insertCarteRow(carteVO);
	}
	
	public void deleteCarteRows(String startDate, String endDate) throws Exception {
		carteInputDAO.deleteCarteRows(startDate, endDate);
	}
	
//	public List<CarteVO> selectList(String startDate, String endDate) throws Exception {
//		return carteInputDAO.selectList(startDate, endDate);
//	}
	
	public List<BaseMap> selectList(String startDate, String endDate) throws Exception {
		return carteInputDAO.selectList(startDate, endDate);
	}
	
	public Integer selectDateDiff(String criteriaDate, String inputDate) throws Exception {
		return carteInputDAO.selectDateDiff(criteriaDate, inputDate);
	}
	
	@Transactional
	public void deleteInsertCarte(String delStartDate, String delEndDate, List<CarteVO> listCarteVO) throws Exception{
        
		int sizeOfList = listCarteVO.size();
        
        carteInputDAO.deleteCarteRows(delStartDate, delEndDate); // 삭제
        
        if( sizeOfList > 0 ) { // 삽입 
        	
        	for( int i = 0 ; i < sizeOfList ; i++ ){
        		System.out.println("---------serviece ------------" );
        		carteInputDAO.insertCarteRow(listCarteVO.get(i));
        	}
        }
        
	}

	
}
