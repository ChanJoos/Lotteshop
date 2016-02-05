<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"  import="com.util.JsonUtil"%><%
String json = JsonUtil.mapTojson(request);
System.out.println( json );
out.println( json );
%>
