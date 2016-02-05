package com.fis.carte.sample.dao;

import ibsheet.BaseMap;

import java.util.List;
import java.util.Map;

import com.vo.CarteVO;
import com.vo.SheetSimpleVO;

public interface CarteDAO {
	List<BaseMap> selectList(CarteVO carteVO) throws Exception;
}
