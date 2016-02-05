package com.util;

import ibsheet.BaseMap;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.vo.PagingVO;

public class RequestUtil {
	
	public static String getParameter( HttpServletRequest request , String key , String def ){
		String val = request.getParameter(key);
		return val  == null || "".equals( val ) ? def : val;
	}
	
	public static int getParameterInteger( HttpServletRequest request , String key , String def ){
		String val = getParameter(request, key, def);
		return Integer.parseInt(val,10);
	}

	/**
	 * vo에 페이지번호 , 페이지당 행갯수 세팅하는 것
	 * @param vo
	 * @param request
	 * @param sheetid
	 */
	public static void setPagingValue( PagingVO vo , HttpServletRequest request , String sheetid ){
		vo.setPageIndex( getParameterInteger(request,sheetid+"_pageIndex","1") ); //페이지번호
		vo.setRecordCountPerPage( getParameterInteger(request,sheetid+"_rowPerPage","10")); //페이지당 행갯수
	}
	
	/**
	 * 반환 값 세팅할때 etc데이터에 행수 페이지번호 총행수와 페이징 데이터를 추가하는 함수 
	 * @param req
	 * @param list
	 * @param sheetid
	 * @param totalCount
	 * @param pageIndex
	 * @param rowPerPage
	 */
	public static void setReturnValue(HttpServletRequest req , int sheetIndex , List<BaseMap> list , String sheetid , int totalCount , int pageIndex , int rowPerPage ){
		req.setAttribute(sheetid+"_rowPerPage", ""+rowPerPage ); //페이지당 행수
		req.setAttribute(sheetid+"_pageIndex", ""+pageIndex );//페이지번호
		req.setAttribute(sheetid+"_totalCount", ""+totalCount );//총 행수 
		req.setAttribute("SHEETDATA"+sheetIndex, list);	
	}
	
}
