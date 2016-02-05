package com.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.util.ParserUtil;

import ibsheet.BaseMap;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CleanXSS {

	Logger log = LoggerFactory.getLogger(CleanXSS.class);
	
	public static String cleanXSS(String str) {
		
		str = str.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
		str = str.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
		str = str.replaceAll("'", "&#39;");
		str = str.replaceAll("eval\\((.*)\\)", "");
		//str = str.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
		//str = str.replaceAll("script", "");
		
		return str;
	}

	public static String[] cleanXSS(String[] arr) {
		
		for (int i = 0; i < arr.length; i++){
			arr[i] = arr[i].replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			arr[i] = arr[i].replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
			arr[i] = arr[i].replaceAll("'", "&#39;");
			arr[i] = arr[i].replaceAll("eval\\((.*)\\)", "");
			//arr[i] = arr[i].replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
			//arr[i] = arr[i].replaceAll("script", "");
		}
		return arr;
	}
	
	public static Map cleanXSS(Map map) {
		if( map == null ) return map;
		Iterator<String> it  = map.keySet().iterator();
		
		while( it.hasNext() ){
			
			String k = (String)it.next();
			String v = "";
			
			if ( (String)map.get(k) == null ){
				v = "";
			}else{
				v = (String)map.get(k);
				v = v.replaceAll("<", "&lt;").replaceAll(">", "&gt;");              
				v = v.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");        
				v = v.replaceAll("'", "&#39;");                                      
				v = v.replaceAll("eval\\((.*)\\)", "");                               
				//v = v.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
				//v = v.replaceAll("script", "");
			}	
			map.put(k, v);
		}
		return map;
	}
	
	public static List<BaseMap> cleanXSS(List<BaseMap> list) {
		if( list == null || list.size() == 0 ) return list;
		
		for(int i = 0; i < list.size(); i++){
			Map info = list.get(i);		
			Iterator<String> it  = info.keySet().iterator();
			while ( it.hasNext() ){
				String k = (String)it.next();
				String v = "";
				if ( info.get(k) == null ){
					info.put(k,"");
				}else{
					v = (String)info.get(k);
					v = v.replaceAll("<", "&lt;").replaceAll(">", "&gt;");              
					v = v.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");        
					v = v.replaceAll("'", "&#39;");                                      
					v = v.replaceAll("eval\\((.*)\\)", "");  
					info.put(k,v);
				}				
			}
		}
		return list;
	}	
	
	public static List<BaseMap> unCleanXSS(List<BaseMap> list) {
		if( list == null || list.size() == 0 ) return list;
		
		for(int i = 0; i < list.size(); i++){
			Map info = list.get(i);		
			Iterator<String> it  = info.keySet().iterator();
			while ( it.hasNext() ){
				String k = (String)it.next();
				String v = "";
				if ( info.get(k) == null ){
					info.put(k,"");
				}else{
					v = (String)info.get(k);
					v = v.replaceAll("&lt;","<").replaceAll("&gt;",">");              
					v = v.replaceAll("&#40;","\\(").replaceAll("&#41;","\\)");        
					v = v.replaceAll("&#39;","'");
					info.put(k,v);
				}				
			}
		}
		return list;
	}	
		
}
