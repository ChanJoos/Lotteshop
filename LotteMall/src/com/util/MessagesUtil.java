package com.util;

import java.io.InputStream;
import java.io.Serializable;
import java.util.Iterator;
import java.util.Properties;

public class MessagesUtil implements  Serializable {
	
	private static final long serialVersionUID = 100100100L;
	static Properties props = null;
	static MessagesUtil instance = new MessagesUtil();
	
	static String spring = "spring.";
	
	private MessagesUtil() {
		init();
	}

	/**
	 * message_ko_KR.properties의 내용을 가져와서 PropertyResource객채를 생성하는 메소드
	 * <pre>
	 * Comment : message_ko_KR.properties의 내용을 가져와서 PropertyResource객채를 생성하는 메소드 
	 * </pre>
	 * @return PropertyResource message_ko_KR.properties의 내용을 가지고 있는 PropertyResource반환
	 */
	public static MessagesUtil getInstance()  {
		InputStream is = null;		
		if( props == null ){
			try {
				props = new Properties();				
				is = MessagesUtil.class.getResourceAsStream( "/resources/message_ko_KR.properties" );
				props.load(is);
				
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally{
				try{ if( is != null ) is.close(); }catch( Exception e ){}
			}
		}
		return instance;
	}
	
	private void init(){

	}
	
	private String getSpringKey(String key){
		return spring +key;
	}
	
	public boolean containsKey( String key ){
		if( props.containsKey( getSpringKey(key) ) ){
			return true; 
		} else{
			return false;
		}
	}

	public String getMessage(String key) {
		if( !containsKey( key ) ){
			return "";
		} else{
			return props.getProperty( getSpringKey(key) ).trim();
		}
	}	
}
