package com.util;

import ibsheet.BaseMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

import com.vo.PagingVO;

public class JsonUtil {
	
	/**
	 * 반환 값중 널이 있으면 공백으로 치환한다. 
	 * !! json 변환시 값이 null인 것은 치환이 안되서 메소드 적용해야 함 !!
	 * @param map
	 * @return
	 */
	public static BaseMap changeValueNull2Space(BaseMap map){
		Iterator<String> it  = map.keySet().iterator();
		while( it.hasNext() ){
			String k = (String)it.next();
			if( map.get(k) == null ){
				map.put(k, "");
			}
		}	
		return map;
	}
	
	/**
	 * 반환 값중 널이 있으면 공백으로 치환한다. 
	 * !! json 변환시 값이 null인 것은 치환이 안되서 메소드 적용해야 함 !!
	 * @param list
	 * @return
	 */
	public static List<BaseMap> changeValueNull2Space( List list ){
		if( list == null || list.size() == 0 ) return list;
		/* 조회 값 중 null 이 있으면 공백으로 치환한다.*/
		for( int i = 0 ; i < list.size() ; i++ ){
			Map m = (Map)list.get(i);
			Iterator<String> it  = m.keySet().iterator();
			while( it.hasNext() ){
				String k = (String)it.next();
				if( m.get(k) == null ){
					m.put(k, "");
				}
			}			
		}
		return list;
	}
	
	/**
	 * request에서 json데이터를 가져온다 없으면 null 반환
	 * @param request
	 * @return
	 */
	private static Map getRequestJsonData( HttpServletRequest request ){
		if( request.getAttribute("json") != null ){
			return (Map)request.getAttribute("json");
		} else {
			return null;
		} 
	}
	
	/**
	 * request에서 json데이터를 세팅한다.
	 * @param request
	 * @return
	 */
	private static void setRequestJsonData( HttpServletRequest request , Map map ){
		request.setAttribute("json",map);
	}
	
	/**
	 * Map을 Json 문자열로 변환
	 * @param req
	 * @return
	 * @throws Exception
	 */
	public static String mapTojson(HttpServletRequest request ) throws Exception {
		Map map = getRequestJsonData(request);
		return mapTojson(map);
	}
	
	/**
	 * Map을 json구조로 반환한다.
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public static String mapTojson(Map map) throws Exception {
		JSONObject jsonObject = new JSONObject();
		jsonObject.putAll(map);
		return jsonObject.toString();
	}
	

	/**
	 * json반환 문자열 작성 (단건 조회 시 사용)
	 * @param req
	 * @param isSuccess
	 * @param successCd
	 * @param errorCd
	 * @param data
	 * @return
	 */
	public static Map getJsonStructure( HttpServletRequest request , boolean isSuccess , String successCd , String errorCd , Map etcData ){
		Map<String,Object> map = getRequestJsonData(request);
		map = getJsonBaseStructureAddData(map, isSuccess, successCd, errorCd, etcData, null, null);
		setRequestJsonData(request, map);
		return map;
	}

	/**
	 * 기존 json 기본구조가 있다면 추가 한다.
	 * @param map
	 * @param isSuccess
	 * @param successCd
	 * @param errorCd
	 * @param etcData
	 * @param chartData
	 * @param tableData
	 * @return
	 */
	public static Map getJsonBaseStructureRequestAddData( HttpServletRequest request  , boolean isSuccess , String successCd , String errorCd , Map etcData , Map chartData , Map tableData ){
		Map map = getRequestJsonData(request);
		if( map == null ){
			map = new HashMap<String,Object>();
		}
		/* error 발생 */
		map = getJsonBaseStructureAddData(map, isSuccess, successCd, errorCd, etcData, chartData, tableData);
		setRequestJsonData(request, map);		
		return map;
	}
	
	/**
	 * 기존 json 기본구조가 있다면 추가 한다.
	 * @param map
	 * @param isSuccess
	 * @param successCd
	 * @param errorCd
	 * @param etcData
	 * @param chartData
	 * @param tableData
	 * @return
	 */
	public static Map getJsonBaseStructureAddData( Map<String,Object> map , boolean isSuccess , String successCd , String errorCd , Map etcData , Map chartData , Map tableData ){
		if( map == null ){
			map = new HashMap<String,Object>();
		}
		if( isSuccess ){
			// 여기서 에러
			//String msg = MessagesUtil.getInstance().getMessage(successCd);
			map.put("SUCCESS", "true");
			map.put("ERR_NO", "0");
			map.put("ERR_MSG", "");
			//map.put("OK_MSG", msg );
			map.put("OK_MSG", "ok");
		} else {
			String msg = MessagesUtil.getInstance().getMessage(errorCd);
			map.put("SUCCESS", "false");
			map.put("ERR_NO"  , errorCd);
			map.put("ERR_MSG", msg);	
		}
		// 조회데이터
		if(  map.get("data") != null && etcData == null ){
			Map data = (Map)map.get("data");
			data.putAll(etcData);
		}
		map.put("data", etcData);
		
		// 차트데이터
		if( map.get("chart") != null && chartData == null ){
			Map chart = (Map)map.get("chart");
			chart.putAll(chartData);
		}
		map.put("chart", chartData);
		
		// 테이블데이터
		if( map.get("table") != null && tableData == null ){
			Map table = (Map)map.get("table");
			table.putAll(tableData);
		}
		map.put("table", tableData); 
		
		return map;
	}
	
	
	/**
	 * chart json반환 문자열 작성
	 * @param req
	 * @param isSuccess
	 * @param successCd
	 * @param errorCd
	 * @param data
	 * @return
	 */
	public static Map getChartJsonStructure( HttpServletRequest request , boolean isSuccess , String successCd , String errorCd , String[] columnNames , List<BaseMap> list , Map etcData ){

		Map chart = new HashMap();
		
		if( isSuccess ){
			String msg = MessagesUtil.getInstance().getMessage(successCd);
			
			int slen = columnNames.length;
			int alen = list.size();
			
			Map config = new BaseMap();
			List<Map> data = new ArrayList<Map>();
			List<String> xAxisLabels = new ArrayList<String>();
			
			List[] arrList = new List[slen];
			
			for( int i = 0 ; i < slen ; i++ ){
				arrList[i] = new ArrayList<Map>();
			}
			
			Map series = null;
			Map arrData = null;
			Map info = null;
			List pkey = new ArrayList();
			for( int s = 0 ; s < slen ; s++ ){
				series = new BaseMap();
				series.put("seriesName", columnNames[s]);
				for( int i = 0 ; i < alen ; i++  ){
					info = list.get(i);
					if( s == 0 ){
						xAxisLabels.add( (String)info.get("CHART_GROUP") );
						if( info.containsKey("CHART_KEY") ){
							pkey.add(i , (String)info.get("CHART_KEY"));
						}
					}
					arrData = new BaseMap();
					arrData.put("X", ""+ i );
					arrData.put("Y",info.get(columnNames[s]));
					arrList[s].add(arrData);
				}
				series.put("arrData"      , arrList[s]);
				data.add(series);
			}
			
			config.put("xAxisLabels",xAxisLabels);
			chart.put("data", data);
			chart.put("config", config);
			chart.put("pkey", pkey);
		} 
		
		Map<String,Object> map = getJsonBaseStructureRequestAddData(request, isSuccess, successCd, errorCd, etcData, chart, null);
		return map;
	}
	
	/**
	 * vo에 페이지번호 , 페이지당 행갯수 세팅하는 것
	 * @param vo
	 * @param request
	 * @param sheetid
	 */
	public static void setPagingValue( PagingVO vo , HttpServletRequest request , String tableid ){
		vo.setPageIndex( RequestUtil.getParameterInteger(request,tableid+"_pageIndex","1") ); //페이지번호
		vo.setRecordCountPerPage( RequestUtil.getParameterInteger(request,tableid+"_rowPerPage","10")); //페이지당 행갯수
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
	public static Map setReturnPagingTable(HttpServletRequest request,boolean isSuccess, String successCd,String  errorCd, String tableid , List<BaseMap> list  , int totalCount , int pageIndex , Map etcData  ){
		Map returnData = new HashMap();
		Map tabledata = new HashMap();
		
		/* 				
		var tabledata = {
				pageIndex:1
				,perPageRow:10
				,totalCount:100
				,rows:[
				        {"groupName":"sm본부","money1":"10000.00","money2":"10000.00","money3":"10","money4":"30","key1":"CD1000","key2":"CD1001"}
				       ,{"groupName":"전략기획","money1":"-10","money2":"-10","money3":"0","money4":"0","key1":"CD1000","key2":"CD1002"}
				       ,{"groupName":"hidden1","money1":"300","money2":"1","money3":"2","money4":"4","key1":"CD1000","key2":"CD1003"}
				       ,{"groupName":"hidden2","money1":"200","money2":"2","money3":"3","money4":"5","key1":"CD1000","key2":"CD1004"}
				]
			};
		 */
		tabledata.put("pageIndex", pageIndex  );
		tabledata.put("totalCount", totalCount  );
		tabledata.put("perPageRow", RequestUtil.getParameterInteger(request , tableid+"_rowPerPage" , "10"));
		tabledata.put("rows", changeValueNull2Space(list) );
		returnData.put( tableid, tabledata);
		
		Map<String,Object> map = getJsonBaseStructureRequestAddData(request, isSuccess, successCd, errorCd, etcData, null, returnData);
		return map;
		
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
	public static Map setReturnTable(HttpServletRequest request,boolean isSuccess, String successCd,String  errorCd, String tableid , List<BaseMap> list  , Map etcData  ){
		return setReturnTable(request, isSuccess, successCd, errorCd, tableid, list, etcData, null);
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
	public static Map setReturnTable(HttpServletRequest request,boolean isSuccess, String successCd,String  errorCd, String tableid , List<BaseMap> list  , Map etcData , Map sumRow ){
		Map returnData = new HashMap();
		Map tabledata = new HashMap();
		
		/* 				
		var tabledata = {
				pageIndex:1
				,perPageRow:10
				,totalCount:100
				,rows:[
				        {"groupName":"sm본부","money1":"10000.00","money2":"10000.00","money3":"10","money4":"30","key1":"CD1000","key2":"CD1001"}
				       ,{"groupName":"전략기획","money1":"-10","money2":"-10","money3":"0","money4":"0","key1":"CD1000","key2":"CD1002"}
				       ,{"groupName":"hidden1","money1":"300","money2":"1","money3":"2","money4":"4","key1":"CD1000","key2":"CD1003"}
				       ,{"groupName":"hidden2","money1":"200","money2":"2","money3":"3","money4":"5","key1":"CD1000","key2":"CD1004"}
				]
			};
		 */
		
		tabledata.put("pageIndex", 0  );
		tabledata.put("totalCount", list.size()  );
		tabledata.put("perPageRow", list.size() );
		tabledata.put("rows", changeValueNull2Space(list) );
		if( list.size() != 0 && sumRow != null ){
			tabledata.put("sumRow", sumRow );
		}
		returnData.put( tableid, tabledata);
		
		Map<String,Object> map = getJsonBaseStructureRequestAddData(request, isSuccess, successCd, errorCd, etcData, null, returnData);
		
		return map;
		
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
	public static Map setReturnTable(HttpServletRequest request,boolean isSuccess, String successCd,String  errorCd, String tableid , List<BaseMap> list  , int totalCount , int pageIndex , Map etcData  ){
		Map returnData = new HashMap();
		Map tabledata = new HashMap();
		
		/* 				
		var tabledata = {
				pageIndex:1
				,perPageRow:10
				,totalCount:100
				,rows:[
				        {"groupName":"sm본부","money1":"10000.00","money2":"10000.00","money3":"10","money4":"30","key1":"CD1000","key2":"CD1001"}
				       ,{"groupName":"전략기획","money1":"-10","money2":"-10","money3":"0","money4":"0","key1":"CD1000","key2":"CD1002"}
				       ,{"groupName":"hidden1","money1":"300","money2":"1","money3":"2","money4":"4","key1":"CD1000","key2":"CD1003"}
				       ,{"groupName":"hidden2","money1":"200","money2":"2","money3":"3","money4":"5","key1":"CD1000","key2":"CD1004"}
				]
			};
		 */
		tabledata.put("pageIndex", pageIndex  );
		tabledata.put("totalCount", totalCount  );
		tabledata.put("perPageRow", RequestUtil.getParameterInteger(request , tableid+"_rowPerPage" , "10"));		
		tabledata.put("rows", changeValueNull2Space(list) );
		returnData.put( tableid, tabledata);
		
		Map<String,Object> map = getJsonBaseStructureRequestAddData(request, isSuccess, successCd, errorCd, etcData, null, returnData);
		return map;
		
	}
}