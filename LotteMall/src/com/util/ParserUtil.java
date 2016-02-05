package com.util;

import ibsheet.BaseMap;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class ParserUtil {

	/**
	 * 반환 값중 널이 있으면 공백으로 치환한다. 
	 * !! json 변환시 값이 null인 것은 치환이 안되서 메소드 적용해야 함 !!
	 * @param map
	 * @return
	 */
	public static Map changeValueNull2Space(Map map){
		if( map == null ) return map;
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
	 * @param baseMap
	 * @return
	 */
	public static BaseMap changeValueNull2Space(BaseMap baseMap){
		if( baseMap == null ) return baseMap;
		Iterator<String> it  = baseMap.keySet().iterator();
		while( it.hasNext() ){
			String k = (String)it.next();
			if( baseMap.get(k) == null ){
				baseMap.put(k, "");
			}
		}	
		return baseMap;
	}
	
	/**
	 * 반환 값중 널이 있으면 공백으로 치환한다. 
	 * !! json 변환시 값이 null인 것은 치환이 안되서 메소드 적용해야 함 !!
	 * @param list
	 * @return
	 */
	public static List<BaseMap> changeValueNull2Space( List<BaseMap> list ){
		if( list == null || list.size() == 0 ) return list;
		/* 조회 값 중 null 이 있으면 공백으로 치환한다.*/
		for( int i = 0 ; i < list.size() ; i++ ){
			Map m = list.get(i);
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
	
	public static String[] changeValueNull2Space( String[] list ){
		if( list == null || list.length == 0 ) return list;
		/* 조회 값 중 null 이 있으면 공백으로 치환한다.*/
		for( int i = 0 ; i < list.length ; i++ ){
			String[] m = list;
			if ( m[i] == null){
				m[i] = "";
			}			
		}
		return list;
	}

	public static String changeValueNull2Space( String list ){

		String m = list;
		if ( m == null){
			m = "";
		}			
		return list;
	}
	
	
	/**
	 * Object형으로 있는 것을 json 스트링으로 반환한다.
	 * !! 키의 값이 null이면 치환 시 해당 키는 포함이 안됩니다. !!
	 * @param object
	 * @return
	 */
	public static String objectToJson( Object object ) {
		//클래스에 있는 데이터를 Json문자열로 반환한다.
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		return gson.toJson(object);
	}
	
	/**
	 * 관계형 코드에서 부모 , 자식 관계 , 최상위 코드여부 및 해당 코드에 대한 정보를 문자열로 결합되어있는 것을 map형으로 변경 시켜줌 
	 * 조건절에서 사용하기 위한 것임
	 * @param relation_cd
	 * @return
	 */
	public static Map relationConfig(String relation_cd){
		String sp_nm = "!!name!!";
		String sp_cd = "!!cd!!";
		String[] names =   relation_cd.substring( 0 , relation_cd.indexOf(sp_cd) ).replaceAll(sp_nm,"").split("[|]");
		String[] cds =   relation_cd.substring( relation_cd.indexOf(sp_cd) , relation_cd.length() ).replaceAll(sp_cd,"").split("[|]");
		Map info = new HashMap();
		for( int i = 0 ; i < names.length ; i++ ){
			info.put(names[i],cds[i]);
		}
		return info;
	}
}
