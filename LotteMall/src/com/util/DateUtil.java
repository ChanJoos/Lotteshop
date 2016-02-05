package com.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class DateUtil {

	/**
	 * 오늘 날짜 구하는 것
	 * @param format
	 * @return
	 */
	public static String getToday( String format ){
		SimpleDateFormat fmt = new SimpleDateFormat( format );
		GregorianCalendar cal = new GregorianCalendar();
		Date date = cal.getTime(); // 연산된 날자를 생성.
		return fmt.format(date);
	}
	
	/**
	 * 날짜 문자열을 가지고 데이트를 구한다.
	 * @param dateString
	 * @param format
	 * @return
	 * @throws Exception
	 */
	public static Date getDate( String dateString , String format ) throws Exception {
		return (Date)( new SimpleDateFormat( format ) ).parse(dateString);
	}
	
	/**
	 * 날짜 문자열을 가지고 Calendar를 구한다.
	 * @param dateString
	 * @param format
	 * @return
	 * @throws Exception
	 */
	public static Calendar getCalendar( String dateString , String format ) throws Exception {
		Calendar cal = Calendar.getInstance();
		cal.setTime(getDate(dateString, format));
		return cal;
	}
	
	/**
	 * 입력받는 값 만큼 Calendar field 를 더하기 빼기를 연산 처리 한다.
	 * @param value
	 * @param calendar_field Calendar.DATE
	 * @param format
	 * @return
	 */
	public static Calendar getOperationCalendar( Calendar baseCal , int calendar_field ,  int value  ) {
		baseCal.add( calendar_field , value); // 현재날짜에 value 값을 더하거나 뺀다.
		return baseCal; 
	}
	
	/**
	 * 입력받는 값 만큼 Calendar field 를 더하기 빼기를 연산 처리 한다.
	 * @param value
	 * @param calendar_field Calendar.DATE
	 * @param format
	 * @return
	 */
	public static String getOperationDateToString(  String dateString  , String format  ,  int value , int calendar_field  ) throws Exception {
		return getOperationDateToString(getDate(dateString, format), value, format, calendar_field);
	}
	
	/**
	 * 입력받는 값 만큼 Calendar field 를 더하기 빼기를 연산 처리 한다.
	 * @param value
	 * @param calendar_field Calendar.DATE
	 * @param format
	 * @return
	 */
	public static String getOperationDateToString( Date baseDate ,  int value  , String format , int calendar_field  ) {
		SimpleDateFormat fmt = new SimpleDateFormat( format );
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(baseDate);
		cal.add( calendar_field , value); // 현재날짜에 value 값을 더하거나 뺀다.
		Date date = cal.getTime(); // 연산된 날자를 생성.
		String setDate = fmt.format(date);
		return setDate;
	}
	
	/**
	 * 입력된 기준 시간에 Calendar 필드 기준으로 앞뒤 간격  안에 들어 가는지 확인 한다. 
	 * @param dateString
	 * @param format
	 * @param range
	 * @param calendar_field
	 * @return
	 * @throws Exception
	 */
	public static boolean isBetween( String dateString  , String format  , int range, int calendar_field ) throws Exception {
		Calendar startCal = Calendar.getInstance();
		Calendar endCal =  Calendar.getInstance();
		startCal.add(calendar_field, -range );
		endCal.add(calendar_field, range );
		Calendar baseCal = getCalendar(dateString, format);
		
		Logger log = LoggerFactory.getLogger(DateUtil.class);
		
		log.debug(  "########################### 입력 기준 시간 확인 허용준 추가	###########################");
		log.debug(  " startCal :"+startCal);
		log.debug(  " endCal :"+endCal);
		log.debug(  " baseCal :"+baseCal);
		
		if( baseCal.after(startCal) && baseCal.before(endCal) ){
			return true;
		} else {
			return false;
		}
	}
	
	
	
}
