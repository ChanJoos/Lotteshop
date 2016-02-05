package com.fis.carte.sample.service;

import ibsheet.BaseMap;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fis.carte.sample.dao.CarteDAO;
import com.vo.CarteVO;

/**
 * @Class Name : carteService.java
 * @Description : 
 * @Modification Information
 * @
 * @  수정일          수정자                  수정내용
 * @ ---------        ---------   -------------------------------
 * @ 2016. 01. 14.  	허용준                   최초생성
 *
 * @author NP007
 * @since
 * @version 1.0
 * @see
 */
@Service("com.fis.carte.sample.service.CarteService")
public class CarteService {

	Logger log = LoggerFactory.getLogger(CarteService.class);
	
	@Autowired
	private CarteDAO carteDAO;

	public List<BaseMap> selectList(CarteVO carteVO) throws Exception {
		return carteDAO.selectList(carteVO);
	}
		
}
