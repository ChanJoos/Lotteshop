<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><% 
ibsheet.IBSheetUtil util = new ibsheet.IBSheetUtil();
String xml = util.getXml(request);
System.out.println(  xml  );
out.println( xml );
%>
