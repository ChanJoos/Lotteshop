package ibsheet;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class IBSheetUtil {
	private String TREECOL = "";
	private static final Logger logger = LoggerFactory.getLogger(IBSheetUtil.class);
	public String getXml(HttpServletRequest req){
		
		StringBuffer sb = new StringBuffer();
		String message = "";
		StringBuffer etcData = new StringBuffer();

		try{
			ArrayList<String> paramList = new ArrayList();
			ArrayList<String> sheetData = new ArrayList();
			Boolean isSearchOnly = false;
						
			Enumeration<String> en =  req.getAttributeNames();
			Vector orderKeyVector = new Vector();
			while(en.hasMoreElements()){
				String objname = en.nextElement();
				if(objname.indexOf("SHEETDATA")>-1){
					isSearchOnly = true;
					orderKeyVector.add(objname);
				}else{
					paramList.add(objname);
				}
			}
			
			if( isSearchOnly ){
				String[] savename = req.getParameter("s_SAVENAME").split("@@");
				TREECOL = req.getParameter("s_TREECOL");
				int cnt = 0;
				
				//여러개의 Sheet가 존재할경우  순서가 없으므로 
				//HashMap 의 key를 기준으로  알파벳 순으로 asc sorting을 한다.
				//순서재정렬 
				Collections.sort(orderKeyVector);  
				Iterator it = orderKeyVector.iterator();
		
				//시트의 개수만큼 루프를 돌자.
				while(it.hasNext()){

					String key =(String)it.next();
					List ls = (List)req.getAttribute(key);
					isSearchOnly = true;
					//RDS형이 넘어온 경우 XML테그로 바꿔 ArrayList에 담아두자.
					sheetData.add(getSheetXml(req,ls,savename[cnt++])) ;
					
				}
			}
			
			etcData.append("<ETC-DATA>\n");
			for(int p=0;p<paramList.size();p++){
				if("SHEET_MSG".equals(paramList.get(p))){
					message =  (String)req.getAttribute(paramList.get(p))  ;
				}else{
					etcData.append("<ETC key='"+paramList.get(p)+"'><![CDATA["+req.getAttribute(paramList.get(p))+"]]></ETC>\n");	
				}
			}
			etcData.append("</ETC-DATA>\n");
			
			
			if(sheetData.size()>0){
				for(int i=0;i<sheetData.size();i++){
					if(i>0){
						sb.append("|!|");	
					}
					sb.append("<?xml version='1.0'?>").append("<SHEET>");
					if(i==0){
						sb.append(etcData.toString());
						sb.append(setMessage( message));
					}
					sb.append(sheetData.get(i));
					sb.append("</SHEET>");
					
				}
			}else{
				sb.append("<?xml version='1.0'?>")
				.append("<SHEET>")
				.append(etcData.toString())
				.append(setMessage( message))
				.append("<RESULT Code='0' Message='"+message+"'>")
				.append("</RESULT>")
				.append("</SHEET>");
			}
			

		}
		catch(Exception ex){
			
			sb.append("<?xml version='1.0'?>")
			.append("<SHEET>")
			.append(etcData.toString())
			.append(""+setMessage(message)+"")
			.append("<RESULT Code='-1' Message='"+message+"'>")
			.append("</RESULT>")
			.append("</SHEET>");
			
			return sb.toString();
		}
		return sb.toString();
	}
	

	protected String setMessage(String msg){
		return "<MESSAGE><![CDATA["+msg+"]]></MESSAGE>";
	}
	
	
	/*
	 * name : getSheetXml
	 * param1 : HttpServletRequest 화면으로부터 받은 request 객체
	 * param2 : List 디비로 조회된 결과
	 * param3 : 각시트에 따른 savename 
	 * desc : List에서 시트에 필요한 조회 Xml을 생성한다.
	 */
	protected  String getSheetXml(HttpServletRequest req ,List ls,String S_SAVENAME) throws Exception {
		StringBuffer sb = new StringBuffer();
		try {

			String[] saveNames = S_SAVENAME.split("\\|");
			
			String totRows = (String)req.getAttribute("TOTROWS");
			// sheet tag!!!!!

			//스크롤을 이용한 조회를 위하여 "TOTROWS"attribute가 존재하면 TOTAL테그를 삽입한다.
			if(totRows==null){
				sb.append("\n<DATA").append(" COLSEPARATOR='‡' >").append("\n");
			}else{
				sb.append("\n<DATA TOTAL='"+totRows+"' ").append(" COLSEPARATOR='‡' >").append("\n");					
			}
			
		   

		    if(ls.size()!=0){
		    	if(ls.get(0) instanceof java.util.HashMap){
		    		sb.append(makeDataXmlFromHashMap(ls,saveNames));
		    	}else if(ls.get(0) instanceof java.util.Map){
		    		sb.append(makeDataXmlFromMap(ls,saveNames));
		    	}else{
		    		sb.append(makeDataXmlFromGetSetObject(ls,saveNames));
		    	}
		    }
		    sb.append("</DATA>").append("\n");
		}
		catch(Exception e) {
			throw e;
		}
		return sb.toString();
	}

	public String makeDataXmlFromGetSetObject(List ls,String[] saveNames) throws Exception{
		StringBuffer sb = new StringBuffer();
		 int colLen = saveNames.length;
		 String tsn = "";
		 boolean isTree = TREECOL!=null?true:false;
		///body
	    for (int i=0;i< ls.size();i++ )
	    {
	    	String[] parameters = new String[0];
	    	Object instance = ls.get(i);
	    	sb.append("<TR "+(isTree?("LEVEL='"+"get"+ TREECOL.substring(0,1).toUpperCase()+TREECOL.substring(1)+"'"):"")+"><![CDATA[");
	        for ( int n = 0; n < colLen; n++ )
	        {
	        	try{
	        		tsn = "get"+ saveNames[n].substring(0,1).toUpperCase()+saveNames[n].substring(1);
	        		Object data = ibsheet.ClassBroker.invoke(instance, tsn, parameters);
	        		sb.append(nvl(data)).append("‡");
	        	}catch(Throwable ex){
	        		sb.append("‡");
	        	}
	        }
	    	sb.append("]]></TR>").append("\n");
	    }
		
		return sb.toString();
	}
	
	public String makeDataXmlFromHashMap(List ls,String[] saveNames) throws Exception{
		
		StringBuffer sb = new StringBuffer();
		 int colLen = saveNames.length;
		 boolean isTree = TREECOL!=null?true:false;
		///body
	    for (int i=0;i< ls.size();i++ )
	    {
	    	String[] parameters = new String[0];
	    	HashMap hm = (HashMap)ls.get(i);
	    	sb.append("<TR "+(isTree?("LEVEL='"+hm.get( TREECOL )+"'"):"")+"><![CDATA[");
	        for ( int n = 0; n < colLen; n++ )
	        {
	        	try{
	        		sb.append(nvl(hm.get( saveNames[n] ))).append("‡");
	        	}catch(Throwable ex){
	        		sb.append("‡");
	        	}
	        }
	    	sb.append("]]></TR>").append("\n");
	    }
		return sb.toString();
	}
	
	
	public String makeDataXmlFromMap(List ls,String[] saveNames) throws Exception{
		
		StringBuffer sb = new StringBuffer();
		 int colLen = saveNames.length;
		 boolean isTree = TREECOL!=null?true:false;
		///body
	    for (int i=0;i< ls.size();i++ )
	    {
	    	String[] parameters = new String[0];
	    	Map hm = (Map)ls.get(i);
	    	sb.append("<TR "+(isTree?("LEVEL='"+hm.get( TREECOL )+"'"):"")+"><![CDATA[");
	        for ( int n = 0; n < colLen; n++ )
	        {
	        	try{
	        		sb.append(nvl(hm.get( saveNames[n]))).append("‡");
	        	}catch(Throwable ex){
	        		sb.append("‡");
	        	}
	        }
	    	sb.append("]]></TR>").append("\n");
	    }
		return sb.toString();
	}
	

    public static Object getParam(Map commandMap,Object obj){
    	return getParamArr(commandMap,obj,0);
    }
    public static Object getParam(HttpServletRequest req, Object obj){
    	Map mp = new HashMap();
    	
    	String key = "";
    	Enumeration<String> en =  req.getParameterNames();
    	while(en.hasMoreElements()){
    		key = en.nextElement();
    		try{
    			if(req.getParameterValues(key).length>1){
    				
    				mp.put(key, req.getParameterValues(key));
    			}else{
    				mp.put(key, req.getParameter(key));
    			}
    		
    		}catch(Exception ex){
    			ex.printStackTrace();
    		}
    	}
    	return getParamArr(mp,obj,0);
    }
    
    /*
     * getParam 
     * desc: commandMap으로 부터 넘어온 데이터 중 SAVENAME에 있는 내용을 뽑아
     * vo형태의 객체에 내용을 채워 보내줌.
     * 
     * paramlist
     * 1. 화면으로부터 받은 commandMap 객체
     * 2. 돌려받고자 하는 class유형
     * 3. 여러건의 데이터가 저장되는 경우 몇번째 데이터를 vo형태로 만들것인지 index
     * 4. 여러개의 시트가 동시에 저장되는 경우, 몇번째 시트 객체에 대한 내용을 받을 것인지 index
     */
    public Object nvl(Object obj){
    	if(obj==null){
    		return "";
    	}else{
    		return obj;
    	}
    }
    
    public static ArrayList getParamArr(Map commandMap,Object rtnObj,int sheetIdx){
    	//IBSheet로 부터 넘어온 savename
    	ArrayList rtnArr = new ArrayList();
    	String savename = (String)commandMap.get("s_SAVENAME");
    	String[] savenameArr = savename.split("@@");
    	savenameArr = (savenameArr[sheetIdx]).split("\\|");
    	String method = "";
    	Object indexObj = commandMap.get(savenameArr[0]);
    	
    	int cnt = 0;
    	
    	try{
	    	if(indexObj instanceof String){
	    		//단건
	    		cnt = 1;
	    		if(rtnObj instanceof java.util.HashMap){
	    			for(int r=0;r<cnt;r++){
	    				HashMap instance = new HashMap();
	    				for(int c=0;c<savenameArr.length;c++){
	    					try{
	    						instance.put(savenameArr[c], ((String)(commandMap.get(savenameArr[c]))));
	    					}catch(Throwable ex){
	    		        		
	    		        	}
	    				}
	    				rtnArr.add(instance);
	    			}
	    		}else{
	    			for(int r=0;r<cnt;r++){
	    				
	    					Object instance = ibsheet.ClassBroker.getInstance(rtnObj.getClass().getName());
	    					Object[] parameter = null;
	    					//컬럼의 개수
	    					for(int c=0;c<savenameArr.length;c++){
	    						
	    						try{
	    							method = "set"+ savenameArr[c].substring(0,1).toUpperCase()+savenameArr[c].substring(1);
		    						parameter = new Object[1];
		    						parameter[0] = ((String)(commandMap.get(savenameArr[c])));
		    		    			//setter 메서드 호출
		    						ibsheet.ClassBroker.invoke(instance, method,  parameter);
		    					}catch(Throwable ex){
		        	        		
		        	        	}
	    					}
	    					rtnArr.add(instance);
	    			}
	        	}
	    	}else{
	    		//다건
	    		cnt = ((String[])indexObj).length;
				if(rtnObj instanceof java.util.HashMap){
					for(int r=0;r<cnt;r++){
	    				HashMap instance = new HashMap();
	    				for(int c=0;c<savenameArr.length;c++){
	    					try{
	    						instance.put(savenameArr[c], ((String[])(commandMap.get(savenameArr[c])))[r]);
	    					}catch(Throwable ex){
	    		        		
	    		        	}
	    				}
	    				rtnArr.add(instance);
					}
	    		}else{
	    			for(int r=0;r<cnt;r++){
	    				
    					Object instance = ibsheet.ClassBroker.getInstance(rtnObj.getClass().getName());
    					Object[] parameter = null;
    					//컬럼의 개수
    					for(int c=0;c<savenameArr.length;c++){
    						try{
    							method = "set"+ savenameArr[c].substring(0,1).toUpperCase()+savenameArr[c].substring(1);
        						parameter = new Object[1];
        						parameter[0] = ((String[])(commandMap.get(savenameArr[c])))[r];
    							//setter 메서드 호출
        						ibsheet.ClassBroker.invoke(instance, method,  parameter);
	    					}catch(Throwable ex){

		    	        	}
    					}
    					rtnArr.add(instance);
	    				
	    			}
	        	}
	    	}
    	
    	
    	}catch(Throwable ex){
    		
    	}
    	return rtnArr;
    }
    
    public static void mapPrint(Map mp){
    	String key = "";
    	Iterator it = mp.keySet().iterator();
    	while(it.hasNext()){
    		key = (String)it.next();
//    		System.out.println("Map Print>>>>>   key:"+key+" value:"+mp.get(key));
    	}
    }
    public static void enumPrint(Enumeration<String> en){
    	String key = "";
    	while(en.hasMoreElements()){
    		key = en.nextElement();
//    		System.out.println("Enum Print>>>>>   "+key);
    	}
    }

}
