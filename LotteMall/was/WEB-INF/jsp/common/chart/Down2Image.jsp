<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@	page import="java.io.*"	%>
<%@	page import="org.apache.fop.svg.*" %>
<%@	page import="org.apache.batik.transcoder.image.*" %>
<%@	page import="org.apache.batik.transcoder.TranscoderInput" %>
<%@	page import="org.apache.batik.transcoder.TranscoderOutput" %>
<%
	//========================================================================================================================
	// [사용자 환경 설정] svg 업로드와 jpg 등의 이미지 다운로드할 임시 폴더를 설정해 주십시오.
	//========================================================================================================================
 	String TempFolder = "c:/web/32/temp/";	// 마지막에 / 로 끝나야 합니다.
	//boolean isUTF8 = false;							// IBChart가 포함되어 있는 웹페이지의 charset=utf-8 이면 true 로 설정해 주십시오.
	boolean isUTF8 = true;

	//========================================================================================================================
	// IBChart 에서 전송한 자료를 받음
	//========================================================================================================================
	if (isUTF8)
	{
		request.setCharacterEncoding("utf-8");
	}
	else
	{
		request.setCharacterEncoding("euc-kr");
	}

	String SVG = request.getParameter("svg");
	String FileName = request.getParameter("filename");
	String ImageWidth = request.getParameter("width");
	Float fImageWidth = new Float(ImageWidth);
	if(fImageWidth>8000.0)
	{
		fImageWidth=8000f; // 최대 8000 픽셀까지만 지원함
	}
	String ImageType = request.getParameter("type");
	
	//========================================================================================================================
	// svg 파일을 생성함
	//========================================================================================================================
	String MustDeletePath = TempFolder + "temp.svg";
	Writer w1 = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(MustDeletePath), "UTF8")); // SVG에서 UTF8로 하지 않으면 SVG툴 들에서 한글 깨짐
	w1.append(SVG);
	w1.flush();
	w1.close();

	//========================================================================================================================
	// 이미지로 변환함
	//========================================================================================================================
    String DestFileName = "";
    
	String svgURI = new File(MustDeletePath).toURL().toString();
	TranscoderInput input = new TranscoderInput(svgURI);
	OutputStream ostream = null;
	TranscoderOutput output = null;
    
	//========================================================================================================================
	// PDF 의 처리
	//========================================================================================================================
	if(ImageType.indexOf("application/pdf")>-1)
	{
		DestFileName = FileName+".pdf";
		ostream = new FileOutputStream(TempFolder+DestFileName);
		output = new TranscoderOutput(ostream);
    	PDFTranscoder t0 = new PDFTranscoder();
		t0.transcode(input, output);
		ostream.flush();
		ostream.close();
	}
    
	//========================================================================================================================
	// PNG 의 처리
	//========================================================================================================================
	if(ImageType.indexOf("image/png")>-1)
	{
		DestFileName = FileName+".png";
		ostream = new FileOutputStream(TempFolder+DestFileName);
		output = new TranscoderOutput(ostream);
    	PNGTranscoder t1 = new PNGTranscoder();
 		t1.addTranscodingHint(PNGTranscoder.KEY_WIDTH, fImageWidth);		
		t1.transcode(input, output);
		ostream.flush();
		ostream.close();
	}
	
	//========================================================================================================================
	// JPG 의 처리
	//========================================================================================================================
	if(ImageType.indexOf("image/jpeg")>-1)
	{
		DestFileName = FileName+".jpg";
		ostream = new FileOutputStream(TempFolder+DestFileName);
		output = new TranscoderOutput(ostream);
	    JPEGTranscoder t2 = new JPEGTranscoder();
		t2.addTranscodingHint(JPEGTranscoder.KEY_QUALITY, new Float(1.0));
 		t2.addTranscodingHint(JPEGTranscoder.KEY_WIDTH, fImageWidth);		
		t2.transcode(input, output);
		ostream.flush();
		ostream.close();
	}

	//========================================================================================================================
	// SVG 의 처리
	//========================================================================================================================
	if(ImageType.indexOf("image/svg")>-1)
	{
		DestFileName = FileName+".svg";
	}


	//========================================================================================================================
	// 헤더문과 파일을 전송함
	//========================================================================================================================
	response.setHeader("Content-Type", "application/octet-stream");
	response.setHeader("Content-Disposition", "attachment;filename="+DestFileName+";");
	response.setHeader("Content-Description", "JSP Generated Data");
	
	//========================================================================================================================
	// SVG 파일 요청시 그대로 전송 / 이미지는 변환하여 전송함
	//========================================================================================================================
	File readFile = null;
	if(ImageType.indexOf("image/svg")>-1)
	{
		readFile = new File(MustDeletePath);
	}
	else
	{
		readFile = new File(TempFolder+DestFileName);
	}

	//========================================================================================================================
	// 다운로드할 파일이 있으면 다운로드 전송을 보냄
	//========================================================================================================================
	byte b[] = new byte[1024];
	if(readFile.isFile())
	{
		try{
			BufferedInputStream fin = new BufferedInputStream(new FileInputStream(readFile));
			BufferedOutputStream out2 = new BufferedOutputStream(response.getOutputStream());
			int read = 0;
			while((read = fin.read(b)) != -1)
			{
				out2.write(b,0,read);
			}
			out2.flush();
			out2.close();
			fin.close();
		}
		catch(Exception e)
		{
		}
	}

	//========================================================================================================================
	// 임시파일 svg 파일을 청소함
	//========================================================================================================================
	mDeleteFile(MustDeletePath);
	mDeleteFile(TempFolder+DestFileName);
%>        

<%!
//========================================================================================================================
// 임시파일 청소용 함수
//========================================================================================================================
void mDeleteFile(String path) throws Exception
{
	if(path.equals("")) return;

	try
	{
		// 사용했던 파일 제거
		File myFile = null;
		myFile = new File(path);
		myFile.delete();
	}
	catch(Exception e)
	{

	}
}
%>