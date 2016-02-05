package com.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.vo.UserVO;

public class SessionUtil {
	private Logger log = LoggerFactory.getLogger(SessionUtil.class);
	
	private static SessionUtil INSTANCE = new SessionUtil();

	private SessionUtil() {
	}
	
	public static SessionUtil getInstance(){
		return INSTANCE;
	}
	
	public boolean isLogin(HttpServletRequest req ){
		try{
			UserVO userVO = getUser(req);
			if( userVO != null ){
				return true;
			} else {
				return false;
			}
		}catch(Exception e){
			return false;
		}
	}
	
	public void setUser(HttpServletRequest req ,UserVO userVO ){
		try{
			req.getSession().setAttribute("user",userVO);
		}catch(Exception e){
		}
	}
	
	public UserVO getUser(HttpServletRequest req ){
		try{
			UserVO userVO = (UserVO)req.getSession().getAttribute("user");
			return userVO;	
		}catch(Exception e){
			return null;
		}
	}
}
