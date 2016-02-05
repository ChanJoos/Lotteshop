<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFDateUtil" %>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>

<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>
<%@ page import="org.apache.poi.openxml4j.opc.*" %>
<%@ page import="org.apache.poi.openxml4j.exceptions.OpenXML4JException" %>
<%@ page import="org.apache.poi.xssf.model.StylesTable" %>
<%@ page import="org.apache.poi.xssf.model.SharedStringsTable" %>
<%@ page import="org.apache.poi.xssf.eventusermodel.XSSFReader" %>
<%@ page import="org.apache.poi.xssf.eventusermodel.ReadOnlySharedStringsTable" %>
<%@ page import="org.apache.poi.xssf.usermodel.*" %>
<%@ page import="org.xml.sax.Attributes" %>
<%@ page import="org.xml.sax.ContentHandler" %>
<%@ page import="org.xml.sax.InputSource" %>
<%@ page import="org.xml.sax.SAXException" %>
<%@ page import="org.xml.sax.XMLReader" %>
<%@ page import="org.xml.sax.helpers.DefaultHandler" %>
<%@ page import="org.xml.sax.helpers.XMLReaderFactory" %>

<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if(request.getProtocol().equals("HTTP/1.1"))
	response.setHeader("Cache-Control", "no-cache");

    //====================================================================================================
    // [ 사용자 환경 설정 #1 ]
    //====================================================================================================
    // Html 페이지의 엔코딩이 utf-8 로 구성되어 있으면 "isUTF8 = true;" 로 설정하십시오.
    // 한글 헤더가 있는 그리드에서 엑셀 로딩이 동작하지 않으면 이 값을 바꿔 보십시오.
    // Down2Excel.jsp 에서의 설정값과 동일하게 바꿔주십시오.
    //====================================================================================================
	//boolean isUTF8 = false;
	boolean isUTF8 = true;

    //====================================================================================================
    // [ 사용자 환경 설정 #2 ]
	//====================================================================================================
	// LoadExcel 용도의 엑셀파일을 업로드하여 임시보관할 임시폴더경로를 지정해 주십시오.
	// 예 : "C:/tmp/"   "/usr/tmp/"
	//====================================================================================================
	String tmpFolder = "d:/";

	//====================================================================================================
	// 이하는 Java Server Page 전문가만 수정을 권장합니다.
	//====================================================================================================
	String MustDeletePath = "";


try{
	String Version = "2013-04-16";

	StringBuffer sb = new StringBuffer();
	StringBuffer jsonData = new StringBuffer();

	// 업로드 엑셀 파일을 수신하고 임시폴더에 저장함
	String contentType = request.getContentType();
	request.setCharacterEncoding("utf-8");

	if ((contentType == null))
	{
		out.println("<script>try { parent.document.getElementById('IBSheetLoadExcelFileFinder').click(); } catch(e) { window.parent.postMessage('IBSheetLoadExcelFileFinder', '*'); } </script>");
	}

	// 자료를 수신한 경우의 로딩자료 리턴
	if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0))
	{
		MyData data = new MyData();

		// 자료를 수신함
		DataInputStream in = new DataInputStream(request.getInputStream());
		int formDataLength = request.getContentLength();
		data.dataBytes = new byte[formDataLength];
		data.LoadRowCount = 0;
		int byteRead = 0;
		int totalBytesRead = 0;
		String rdata="";

		// 수신 자료를 메모리에 담음
		while (totalBytesRead < formDataLength)
		{
			byteRead = in.read(data.dataBytes,totalBytesRead,formDataLength);
			totalBytesRead += byteRead;
		}

		// 수신 자료를 분석함
		if(isUTF8)
		{
			rdata = new String(data.dataBytes,"UTF-8");
		}
		else
		{
			rdata = new String(data.dataBytes);
		}

//System.out.println("수신자료:"+rdata+"<br><br>");
		String ColumnTagValue = "";
		String UploadFileName = "";

		int lastIndex = contentType.lastIndexOf("=");
		String boundary = contentType.substring(lastIndex + 1,contentType.length());

		ColumnTagValue = rdata.substring(rdata.indexOf("name=\"ColumnTag\"") + 20);
		ColumnTagValue = ColumnTagValue.substring(0, ColumnTagValue.indexOf(boundary));
//System.out.println("<textarea>컬럼정보:"+ColumnTagValue+"<br><br>");
//System.out.println(ColumnTagValue);

		UploadFileName = rdata.substring(rdata.indexOf("filename=\"") + 10);
		UploadFileName = UploadFileName.substring(0, UploadFileName.indexOf("\n"));
		UploadFileName = UploadFileName.substring(UploadFileName.lastIndexOf("/") + 1,UploadFileName.indexOf("\""));


		// 첨부파일을 가려냄
		int startPos = 0;
		int endPos = 0;

		startPos = mGetPos(0, data.dataBytes,("name=\"file\"; filename=").getBytes("8859_1"));
		startPos = mGetPos(startPos, data.dataBytes,("\r\n\r\n").getBytes("8859_1"));
		endPos = mGetPos(startPos, data.dataBytes,boundary.getBytes("8859_1"))-boundary.length()-4;

		// 첨부파일을 임시폴더에 저장함
		String UploadFileExt = "";
		String SaveFileName = "";
		UploadFileExt = UploadFileName.substring(UploadFileName.lastIndexOf(".")+1);
//out.println("업로드 확장자:"+UploadFileExt+"<br><br>");

		if(UploadFileExt.indexOf("xls")>=0) // 엑셀 파일들만 로딩 허용함
		{
			Random rnd = new Random();
			int UniqNo = rnd.nextInt(32768*32768);
			SaveFileName = UniqNo+"."+UploadFileExt;

//out.println("저장파일명:"+SaveFileName+"<br><br>");

			MustDeletePath = tmpFolder + SaveFileName;
			FileOutputStream fileOut=null;
			fileOut = new FileOutputStream(tmpFolder + SaveFileName);
			fileOut.write(data.dataBytes, startPos,(endPos - startPos)); // 받은 파일 저장하기
			fileOut.flush();
			fileOut.close();
//System.out.println(ColumnTagValue);
			// LoadExel 인자를 받아 적용함
			data.ColList = ColumnTagValue;
			data.Mode = getPropValue(data.ColList,"Mode");
			data.SearchMode = getPropValue(data.ColList,"SearchMode");
			data.OrgColList = data.ColList;
			data.MaxCols = Integer.parseInt(getPropValue(data.ColList,"MaxCols"));
			data.filePath = tmpFolder + SaveFileName;
			data.headerRows = Integer.parseInt(getPropValue(data.ColList,"HeaderRows"));
			if(data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER"))
			{
				data.headerRows = 0;
			}
			data.saveName = new String[512]; //최대 512 개의 엑셀 컬럼 로딩을 지원함
			data.colType = new String[512];
			data.colFormat = new String[512];

			data.ColumnMapping = getPropValue(data.ColList,"ColumnMapping").split("\\|");
			data.StatusCol = getPropValue(data.ColList,"StatusCol");
			data.saveNameOrg = getPropValue(data.ColList,"SaveNames").split("\\|");
//out.println("<<"+getPropValue(data.ColList,"SaveNames")+">>");
			if(getPropValue(data.ColList,"ColumnMapping").equals("")) data.isColumnMapping = false;
			else data.isColumnMapping = true;

			data.WorkSheetName = getPropValue(data.ColList,"WorkSheetName");
			data.WorkSheetNo = Integer.parseInt(getPropValue(data.ColList,"WorkSheetNo"));
			data.StartRow = Integer.parseInt(getPropValue(data.ColList,"StartRow"));
//			data.bUnMatchColHidden = Integer.parseInt(getPropValue(data.ColList,"UnMatchColHidden"));

			if(data.StartRow < 1)
			{
				data.StartRow=1;
			}
			data.EndRow = Integer.parseInt(getPropValue(data.ColList,"EndRow"));



			String HeaderText   = getPropValue(data.ColList,"HeaderText");
			String SaveName     = getPropValue(data.ColList,"SaveName");
			String RecordType   = getPropValue(data.ColList,"RecordType");
			String RecordFormat = getPropValue(data.ColList,"RecordFormat");
			String DatePattern  = getPropValue(data.ColList,"DatePattern");
			String SheetID      = getPropValue(data.ColList,"SheetID");
			String Append       = getPropValue(data.ColList,"Append");

			String[] temp = RecordType.split("\\^");
			data.SaveName		= new String[temp.length][];
			data.RecordType		= new String[temp.length][];
			data.RecordFormat	= new String[temp.length][];
			data.DatePattern	= new String[temp.length][];

			data.fileSaveName		= new String[temp.length][];
			data.fileRecordType		= new String[temp.length][];
			data.fileRecordFormat	= new String[temp.length][];
			data.fileDatePattern	= new String[temp.length][];

			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				data.RecordType[r]	= temp2.split("\\|", data.MaxCols);
			}
			temp = RecordFormat.split("\\^");
			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				data.RecordFormat[r]	= temp2.split("\\|", data.MaxCols);
			}
			temp = DatePattern.split("\\^");
			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				data.DatePattern[r]	= temp2.split("\\|", data.MaxCols);
			}
			temp = SaveName.split("\\^");
			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				data.SaveName[r]		= temp2.split("\\|", data.MaxCols);
			}
			temp = HeaderText.split("\\^");
			data.HeaderText		= new String[temp.length][];
			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				data.HeaderText[r]	= temp2.split("\\|", data.MaxCols);
			}

			data.HeaderMatch = new boolean[data.RecordType[0].length];
			for(int r=0 ; r<data.HeaderMatch.length ; r++)
			{
				data.HeaderMatch[r] = false;
			}

//System.out.println(Arrays.deepToString(data.HeaderMatch));

			// JSON 결과를 리턴함
			sb.append("<html><head><script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.gJson='");
			jsonData.append("{data:[[");

			if(UploadFileExt.indexOf("xlsx")>=0)
			{
//				jsonData.append(LoadExcelx(out, data));
				jsonData.append(LoadExcelx4LargeFile(out, data));
			}
			else
			{
				jsonData.append(LoadExcel(out, data));
			}

			String sUnMatchColumn = "";

			jsonData.append("]]}");


			if(!SheetID.equals(""))
			{
				out.println("<html><head><script>window.parent.postMessage('IBSheetOnLoadExcel^" + SheetID + "^" + data.LoadRowCount + "^EXCEL^Append=" + Append + "^" + jsonData.toString() + "', '*'); </script></head></html>");
			} else {
				out.print(sb.toString());
				out.print(jsonData.toString());

				sb.setLength(0);
				sb.append("';"+((data.SearchMode.equals("3"))?"targetWnd.Grids[targetWnd.gTargetExcelSheetID].SetTotalRows("+data.LoadRowCount+");":"")+"targetWnd.Grids[targetWnd.gTargetExcelSheetID].DoSearchScript('gJson',{type:'EXCEL', Append:'"+ Append + "'});");

				if(data.bUnMatchColHidden==1)
				{
					sb.append("targetWnd.Grids[targetWnd.gTargetExcelSheetID].mUnMatchColHidden('"+sUnMatchColumn+"');");
				}
				sb.append("</script></head></body></html>");

				out.print(sb.toString());
			}


		}
	}
} catch(Exception e) {
	out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetExcelSheetID].ShowAlert('엑셀 파일을 읽는 도중 예외가 발생하였습니다.', 'U'); targetWnd.Grids[targetWnd.gTargetExcelSheetID].finishDownload(); }catch(e){}</script>");

	e.printStackTrace();
} catch (Error e) {
	out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetExcelSheetID].ShowAlert('엑셀 파일을 읽는 도중 예외가 발생하였습니다.', 'U'); targetWnd.Grids[targetWnd.gTargetExcelSheetID].finishDownload(); }catch(e){}</script>");

	e.printStackTrace();
} finally {
	mDeleteFile(MustDeletePath);
}

%>


<%!

void mDeleteFile(String path) throws Exception
{
	try
	{
		if(!path.equals(""))
		{
			// 사용했던 파일 제거
			File myFile = null;
			myFile = new File(path);
			myFile.delete();
		}
	}
	catch(Exception e)
	{

	}
}


// 엑셀문서의 셀자료를 브라우저로 전송합니다.
String mCellMap(MyData data, int row, int col, String TheText, String TheText2, String TheText3, boolean isDate) throws Exception
{
//	System.out.println("row : " + row + " : " + col + " : " + isDate);
//	System.out.println("TheText : " + TheText + " TheText2 : " + TheText2 + " TheText3 : " + TheText3);

	StringBuffer sb = new StringBuffer();

	int i;
	int ExcelColumnNo = 0;

	// 헤더분석
	if (row == data.headerRows+data.StartRow - 2 && (data.Mode.toLowerCase().equals("headermatch") || data.Mode.toLowerCase().equals("headerskip")) && data.isColumnMapping == false) // 헤더자료면 헤더-컬럼속성 자료 준비
	{
		String headerText = TheText;

		headerText = replace(headerText, "(*)", "");

		if(data.Mode.toLowerCase().equals("headermatch"))
		{
			for (int j = 0; j < data.HeaderText[data.headerRows - 1].length; j++)
			{
				data.HeaderText[data.headerRows - 1][j] = replace(data.HeaderText[data.headerRows-1][j], "\r\n", "\n");
				if (data.HeaderText[data.headerRows - 1][j].equals(headerText) && data.UsedCol[j] == false)
				{
					for (int k = 0; k < data.SaveName.length; k++)
					{
						data.fileSaveName[k][col] = data.SaveName[k][j];
						data.fileRecordType[k][col] = data.RecordType[k][j];
						data.fileRecordFormat[k][col] = data.RecordFormat[k][j];
						data.fileDatePattern[k][col] = data.DatePattern[k][j];
						data.UsedCol[j] = true;
					}
					break;
				}
			}
		} else if(data.Mode.toLowerCase().equals("headerskip")) {
			for (int j = 0; j < data.SaveName[0].length; j++)
			{
				for (int k = 0; k < data.SaveName.length; k++)
				{
					data.fileSaveName[k][j] = data.SaveName[k][j];
					data.fileRecordType[k][j] = data.RecordType[k][j];
					data.fileRecordFormat[k][j] = data.RecordFormat[k][j];
					data.fileDatePattern[k][j] = data.DatePattern[k][j];
				}
			}
		}
	}

	if(row == data.StartRow-1 && data.Mode.toLowerCase().equals("noheader"))
	{
		for (int j = 0; j < data.SaveName[0].length; j++)
		{
			for (int k = 0; k < data.SaveName.length; k++)
			{
				data.fileSaveName[k][j] = data.SaveName[k][j];
				data.fileRecordType[k][j] = data.RecordType[k][j];
				data.fileRecordFormat[k][j] = data.RecordFormat[k][j];
				data.fileDatePattern[k][j] = data.DatePattern[k][j];
			}
		}
	}
	// 데이터 처리
	if (row < data.headerRows+data.StartRow-1) // 데이타이면 헤더컬럼속성 따라 매핑
		return sb.toString();

//	if(data.Mode.toLowerCase().equals("headermatch") && !data.HeaderMatch[col])
//		return;


	int rowNumber = (row - data.headerRows+data.StartRow - 1) % data.RecordType.length;

	if(data.TempRow_StatusCol!=row) //그리드에 상태 컬럼있으면 상태값 I 강제 추가
	{
		if(!data.StatusCol.equals(""))
		{
			sb.append(data.StatusCol+":\"I\",");
			data.TempRow_StatusCol = row;
		}
	}

	if((""+data.fileSaveName[rowNumber][col]).equals("")){return sb.toString();} //SaveName 못찾은 항목은 제외됨

	// 0.0 이 1처럼 체크되는 현상
	if(" CheckBox Radio DelCheck ".indexOf(" "+data.colType[col]+" ")>-1)
	{
		if(TheText.equals("0.0"))
		{
			TheText = "0";
		}
	}

	// 소수타입에서 소수점 짤림 현상
	if(" AutoSum AutoAvg Float NullFloat ".indexOf(" "+data.fileRecordType[rowNumber][col]+" ")>-1)
	{
		//TheText = TheText2;
	}


	if(data.isColumnMapping) //컬럼매핑
	{
		//var col = "|||1||||4|||3||||||||||||||||||||||8";

		for(i=0;i<data.ColumnMapping.length;i++)
		{
			ExcelColumnNo = Integer.parseInt("0"+data.ColumnMapping[i]);
			if(ExcelColumnNo>0 && (col+1)==ExcelColumnNo)
			{
				//if(isDate  || !"".equals(data.DatePattern[rowNumber][i]))		// 날자 데이터 변환
				if(!"".equals(data.DatePattern[rowNumber][i]))		// 날자 데이터 변환
				{
					if(isDate && !"".equals(TheText3))
						TheText = getDateValue(data, TheText3, rowNumber, i);
				}

				// 소수타입에서 소수점 짤림 현상
				if(" Status ".indexOf(" "+data.RecordType[0][i]+" ")>-1)
				{
					;// 레코드별로 엑셀에 상태컬럼없어도 그리드에 상태컬럼있으면 강제로라도 설정해야 해서 일단 여기서 처리하지 않음.
				}
				else
				{
					if(i<data.saveNameOrg.length)
					{
						if(!data.isFirst)
						{
							sb.append(",");
						}
						//out.print(data.SaveName[0][i]+":\""+TheText.replace("\r","\\\\r").replace("\n","\\\\n").replace("\"","\\\\\"").replace("'","\\\'")+"\"");
						TheText = replace(TheText,"\r","\\\\r");
						TheText = replace(TheText,"\n","\\\\n");
						TheText = replace(TheText,"\"","\\\\\"");
						TheText = replace(TheText,"'","\\\'");
						sb.append(data.SaveName[0][i]+":\""+TheText+"\"");

						data.isFirst = false;
					}
				}
			}
		}
	}
	else //일반
	{
		//if(isDate || !"".equals(data.fileDatePattern[rowNumber][col]))		// 날자 데이터 변환
		if(!"".equals(data.fileDatePattern[rowNumber][col]))		// 날자 데이터 변환
		{
//System.out.println("data.DatePattern[" + rowNumber + "][" + col + "] : " + data.DatePattern[rowNumber][col]);
//System.out.println(col + " : " + TheText + " : " + TheText3);
//System.out.println(Arrays.deepToString(data.fileRecordType));
//System.out.println(Arrays.deepToString(data.fileDatePattern));
			if(isDate && !"".equals(TheText3))
				TheText = getDateValue(data, TheText3, rowNumber, col);
		}

		// 소수타입에서 소수점 짤림 현상
		if(" Status ".indexOf(" "+data.fileRecordType[0][col]+" ")>-1)
		{
			return sb.toString(); // 레코드별로 엑셀에 상태컬럼없어도 그리드에 상태컬럼있으면 강제로라도 설정해야 해서 일단 여기서 처리하지 않음.
		}
		if(data.fileSaveName[0][col]!=null)
		{
			if(!data.isFirst)
			{
				sb.append(",");
			}
			//out.print(data.SaveName[0][col]+":\""+TheText.replace("\r","\\\\r").replace("\n","\\\\n").replace("\"","\\\\\"").replace("'","\\\'")+"\"");
			TheText = replace(TheText,"\r","\\\\r");
			TheText = replace(TheText,"\n","\\\\n");
			TheText = replace(TheText,"\"","\\\\\"");
			TheText = replace(TheText,"'","\\\'");
			sb.append(data.fileSaveName[0][col]+":\""+TheText+"\"");

			data.isFirst = false;
		}

	}

	return sb.toString();
}

String getDateValue(MyData data, String date, int row, int col) throws Exception
{
	String datePattern = "";
	if(data.isColumnMapping)
		datePattern = data.DatePattern[row][col];
	else
		datePattern = data.fileDatePattern[row][col];

	if(date == null || "".equals(date) || datePattern == null || "".equals(datePattern) )
		return "";

	String retVal = "";

	retVal = mDateValue(date, datePattern);

	return retVal;
}


// 사용하는 변수들을 선언합니다.
public class MyData
{
	int MaxCols = 0;
	int headerRows = 0;
	int StartRow = 0;
	int EndRow = 0;
	int TempRow_StatusCol = -1;
	int LoadRowCount = 0;
	String SearchMode = "";
	String Mode = "";
	String StatusCol = "";
	String ColList = "";
	String OrgColList = "";
	String filePath = "";
	String saveName[] = null;
	String saveNameOrg[] = null;
	String colType[] = null;
	String colFormat[] = null;
	String dataType[] = null;
	String ColumnMapping[] = null;
	boolean isColumnMapping = false;
	int bUnMatchColHidden = 0; // 사용자가 1 설정하면 1로 들어가서 언매치 컬럼들이 컬럼히든처리됨
	boolean isFirst = false;
	int WorkSheetNo = 0;
	String WorkSheetName = "";
	byte dataBytes[] = null;

	String SaveName[][];
	String HeaderText[][];
	String RecordType[][];
	String RecordFormat[][];
	String DatePattern[][];
	boolean UsedCol[];


	String fileSaveName[][];
	String fileRecordType[][];
	String fileRecordFormat[][];
	String fileDatePattern[][];

	boolean HeaderMatch[];
}

// 속성 값을 얻어 냅니다.
String getPropValue(String Header, String prop) throws Exception
{
	int findS = 0;
	int findE = 0;

	//Header = Header.replace("\r","");
	//prop = prop.replace("\r","");
	Header = replace(Header,"\r","");
	prop = replace(prop,"\r","");

	findS = Header.indexOf("<"+prop+">");
	findE = Header.indexOf("</"+prop+">");

	if(findS != -1 && findE != -1) return Header.substring(findS+prop.length()+2,findE);		// 시작 태그를 제외하고 데이타만 리턴해줌
	else return "";
}


String mDateValue(String dateLongValue, String datePattern) throws Exception
{
	SimpleDateFormat df = null;
	if(datePattern.equals("YmdHmsFormat"))
	{
		df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	}
	if(datePattern.equals("YmdHmFormat"))
	{
		df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	}
	if(datePattern.equals("YmdFormat"))
	{
		df = new SimpleDateFormat("yyyy-MM-dd");
	}
	if(datePattern.equals("YmFormat"))
	{
		df = new SimpleDateFormat("yyyy-MM");
	}
	if(datePattern.equals("MdFormat"))
	{
		df = new SimpleDateFormat("MM-dd");
	}
	if(datePattern.equals("HmsFormat"))
	{
		df = new SimpleDateFormat("HH:mm:ss");
	}
	if(datePattern.equals("HmFormat"))
	{
		df = new SimpleDateFormat("HH:mm");
	}

	return df.format(new Date(Long.parseLong(dateLongValue)));
}

// 받은 내용안에서 첨부파일의 위치를 얻어냅니다.
int mGetPos(int StartPos, byte data[], byte findData[]) throws Exception
{
	int i=0, j=0;

	for(i=StartPos;i<data.length;i++)
	{
		for(j=0;j<findData.length;j++)
		{
			if(data[i+j] != findData[j])
			{
				break;
			}
		}
		if(j==findData.length)
		{
			return i+findData.length;
		}
	}

	return -1;
}
// XLS 문서를 로딩합니다.
String LoadExcel(JspWriter out, MyData data) throws Exception
{
	StringBuffer sb = new StringBuffer();

	POIFSFileSystem excel = new POIFSFileSystem(new FileInputStream(data.filePath));
	HSSFWorkbook workBook = new HSSFWorkbook(new FileInputStream(new File(data.filePath)));
	HSSFSheet sheet = null;
	HSSFRow row = null;
	HSSFCell cell = null;
	DecimalFormat df = new DecimalFormat("#.#################");

//	org.apache.poi.ss.usermodel.FormulaEvaluator evaluator1 = workBook.getCreationHelper().createFormulaEvaluator();
	String TheText = "";
	String TheText2 = "";
	String TheText3 = "";
	boolean isDate = false;

	int sheetNum = workBook.getNumberOfSheets();

	for(int k=0;k<sheetNum;k++)
	{
		if(!data.WorkSheetName.equals(""))
		{
			if(!data.WorkSheetName.equals(workBook.getSheetName(k)))
				continue;
		} else if(data.WorkSheetNo!=0) {
			if(k!=data.WorkSheetNo-1)
				continue;
		}

		sheet = (HSSFSheet)workBook.getSheetAt(k);
		int rows = sheet.getLastRowNum();

		data.UsedCol = new boolean[512];
		for (int r = 0; r < data.SaveName.length; r++)
		{
			data.fileSaveName[r] = new String[512];
			data.fileRecordType[r] = new String[512];
			data.fileRecordFormat[r] = new String[512];
			data.fileDatePattern[r] = new String[512];
		}

		for(int r=data.StartRow-1;r<=rows;r++)
		{
			if(data.EndRow!=0)
			{
				if(r>data.EndRow-1) break;
			}

			row = (HSSFRow)sheet.getRow(r);
			int cells = 0;
			if(row!=null)
			{
				//cells = row.getLastCellNum();//getPhysicalNumberOfCells();
				//cells = data.MaxCols;
				cells = row.getLastCellNum();
			}

			//레코드 1개의 시작
			if(r>=data.headerRows+data.StartRow-1)
			{
				sb.append("{");
			}

			if (r < data.headerRows+data.StartRow-1 || (data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER")) && r==data.StartRow-1) // 헤더자료면 헤더-컬럼속성 자료 준비
			{
				//헤더제외
			}
			else
			{
				if(cells<=0) //빈문서인 경우
				{
					if(!data.StatusCol.equals(""))
					{
						sb.append(data.StatusCol+":\"I\"");
					}
				}
			}

			data.isFirst = true;
			for(short c=0;c<cells;c++)
			{
				isDate = false;

				if(row!=null)
				{
					TheText = "";
					TheText2 = "";
					TheText3 = "";
					cell = (HSSFCell)row.getCell(c);
					if(cell== null)
					{
						TheText = "";
						TheText2 = "";
						TheText3 = "";
					}
					else
					{
						switch(cell.getCellType())
						{
							case 0: // Cell.CELL_TYPE_NUMERIC
								if (HSSFDateUtil.isCellDateFormatted(cell)) {
									isDate = true;
								}
							case 1: // Cell.CELL_TYPE_STRING
							case 2: // Formula
							case 3: // Cell.CELL_TYPE_BLANK
							case 5: // Cell.CELL_TYPE_ERROR
								TheText = "";
								TheText2 = "";
								TheText3 = "";

								try
								{
									TheText = cell.getStringCellValue()+"";
									TheText2 = TheText;
								}
								catch(IllegalStateException e)
								{
									try
									{
										TheText3 = cell.getDateCellValue().getTime()+"";
										//isDate = true;
									} catch(Exception e3) { }
										
									try
									{
										cell.setCellType(1);
										TheText = cell.getStringCellValue()+"";
										TheText2 = TheText;
										
										if(TheText.length()>4)
										{
											if(TheText.indexOf("E")>-1)
											{
												if((TheText+"  ").substring(1,2).equals("."))
												{
													if(TheText.substring(TheText.length()-4,TheText.length()).indexOf("E")>-1)
													{
														TheText = df.format(Double.parseDouble(TheText));
														TheText2 = TheText;
													}
												}
											}
										}
									} catch(Exception e2) // # 등 오류
									{
										TheText = "";
										TheText2 = "";
										TheText3 = "";
									}
								}
								break;
							case 4: //Cell.CELL_TYPE_BOOLEAN
								TheText = Boolean.toString(cell.getBooleanCellValue());
								break;
							default:
						}
						/*
						switch(cell.getCellType())
						{
							case 0: // Cell.CELL_TYPE_NUMERIC
								TheText = "";
								if (HSSFDateUtil.isCellDateFormatted(cell)) 
								{ 
									TheText3 = cell.getDateCellValue().getTime()+"";
									isDate = true;
								} else {
									//DecimalFormat decimalFormat = new DecimalFormat("#.#"); 
									//TheText = decimalFormat.format(cell.getNumericCellValue());
									TheText = String.valueOf(cell.getNumericCellValue());
								}
//								try {
//									TheText3 = cell.getDateCellValue().getTime()+"";
//									isDate = true;
//								} catch(Exception e3) {
//									TheText = String.valueOf(cell.getNumericCellValue());
//								}

								break;
							case 1: // Cell.CELL_TYPE_STRING
							case 2: // Formula
							case 3: // Cell.CELL_TYPE_BLANK
							case 5: // Cell.CELL_TYPE_ERROR

								TheText = "";
								TheText2 = "";
								TheText3 = "";

								try
								{
									TheText = cell.getStringCellValue()+"";
									TheText2 = TheText;
								}
								catch(IllegalStateException e)
								{
									try
									{
										TheText3 = cell.getDateCellValue().getTime()+"";
									}
									catch(Exception e3)
									{
									}

									try
									{

										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										TheText = cell.getStringCellValue()+"";
										TheText2 = TheText;

										if(TheText.length()>4)
										{
											if(TheText.indexOf("E")>-1)
											{
												if((TheText+"  ").substring(1,2).equals("."))
												{
													if(TheText.substring(TheText.length()-4,TheText.length()).indexOf("E")>-1)
													{
														TheText = df.format(Double.parseDouble(TheText));
														TheText2 = TheText;
													}
												}
											}
										}


									}
									catch(Exception e2) // # 등 오류
									{
										TheText = "";
										TheText2 = "";
										TheText3 = "";
									}
								}
								break;


							case 4: //Cell.CELL_TYPE_BOOLEAN
								TheText = Boolean.toString(cell.getBooleanCellValue());
								break;
							default:
						}*/

					}
					sb.append(mCellMap(data, r, c, TheText, TheText2, TheText3, isDate));
				}
			}//cell

			//레코드 1개의 끝
			if(r>=data.headerRows+data.StartRow-1)
			{
				data.LoadRowCount ++;
				sb.append("},");
			}
		}//row
	}//sheet
	return sb.toString();
}

// XLSX 문서를 로딩합니다.

String LoadExcelx(JspWriter out, MyData data) throws Exception
{
	StringBuffer sb = new StringBuffer();

	File excelFile = new File(data.filePath);

	if (!excelFile.exists() || !excelFile.isFile() || !excelFile.canRead()) {
		throw new IOException(data.filePath);
	}

	XSSFWorkbook workBook  =  new XSSFWorkbook(new FileInputStream(excelFile));
	XSSFSheet sheet    =  null;
	XSSFRow row     =  null;
	XSSFCell cell    =  null;

	DecimalFormat df = new DecimalFormat("#.#################");

	String TheText = "";
	String TheText2 = "";
	String TheText3 = "";
	boolean isDate = false;

	int sheetNum = workBook.getNumberOfSheets();

	for(int k=0;k<sheetNum;k++)
	{
		if(!data.WorkSheetName.equals(""))
		{
			if(!data.WorkSheetName.equals(workBook.getSheetName(k)))
				continue;
		}
		else if(data.WorkSheetNo!=0)
		{
			if(k!=data.WorkSheetNo-1)
				continue;
		}
		sheet = (XSSFSheet)workBook.getSheetAt(k);
		int rows = sheet.getLastRowNum();


		data.UsedCol = new boolean[512];
		for (int r = 0; r < data.SaveName.length; r++)
		{
			data.fileSaveName[r] = new String[512];
			data.fileRecordType[r] = new String[512];
			data.fileRecordFormat[r] = new String[512];
			data.fileDatePattern[r] = new String[512];
		}

		for(int r=data.StartRow-1;r<=rows;r++)
		{
//out.println(r+"<br>");
			if(data.EndRow!=0)
			{
				if(r>data.EndRow-1) break;
			}

			row = (XSSFRow)sheet.getRow(r);
			int cells = 0;
			if(row!=null)
			{
				//cells = row.getLastCellNum();//getPhysicalNumberOfCells();
				//cells = data.MaxCols;
				cells = row.getLastCellNum();
			}

			//레코드 1개의 시작
			if(r>=data.headerRows+data.StartRow-1)
			{
				sb.append("{");
			}


			if (r < data.headerRows+data.StartRow-1 || (data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER")) && r==data.StartRow-1) // 헤더자료면 헤더-컬럼속성 자료 준비
			{
				//헤더제외
			}
			else
			{
				if(cells<=0) //빈문서인 경우
				{
					if(!data.StatusCol.equals(""))
					{
						sb.append(data.StatusCol+":\"I\"");
					}
				}
			}

			data.isFirst = true;
			for(short c=0;c<cells;c++)
			{
				isDate = false;
	
				if(row!=null)
				{

					cell = (XSSFCell)row.getCell(c);
					if(cell== null)
					{
						TheText = "";
						TheText2 = "";
						TheText3 = "";
					}
					else
					{
						switch(cell.getCellType())
						{
							case 0: // Cell.CELL_TYPE_NUMERIC
								if (HSSFDateUtil.isCellDateFormatted(cell)) {
									isDate = true;
								}
							case 1: // Cell.CELL_TYPE_STRING
							case 2: // Formula
							case 3: // Cell.CELL_TYPE_BLANK
							case 5: // Cell.CELL_TYPE_ERROR
								TheText = "";
								TheText2 = "";
								TheText3 = "";

								try
								{
									TheText = cell.getStringCellValue()+"";
									TheText2 = TheText;
								}
								catch(IllegalStateException e)
								{
									try
									{
										TheText3 = cell.getDateCellValue().getTime()+"";
									} catch(Exception e3) { }
										
									try
									{
										cell.setCellType(1);
										TheText = cell.getStringCellValue()+"";
										TheText2 = TheText;
										
										if(TheText.length()>4)
										{
											if(TheText.indexOf("E")>-1)
											{
												if((TheText+"  ").substring(1,2).equals("."))
												{
													if(TheText.substring(TheText.length()-4,TheText.length()).indexOf("E")>-1)
													{
														TheText = df.format(Double.parseDouble(TheText));
														TheText2 = TheText;
													}
												}
											}
										}
									} catch(Exception e2) // # 등 오류
									{
										TheText = "";
										TheText2 = "";
										TheText3 = "";
									}
								}
								break;
							case 4: //Cell.CELL_TYPE_BOOLEAN
								TheText = Boolean.toString(cell.getBooleanCellValue());
								break;
							default:
						}
						/*
						switch(cell.getCellType())
						{
							case 0: // Cell.CELL_TYPE_NUMERIC
								if (HSSFDateUtil.isCellDateFormatted(cell)) 
								{ 
									TheText3 = cell.getDateCellValue().getTime()+"";
									isDate = true;
								} else {
									//DecimalFormat decimalFormat = new DecimalFormat("#.#"); 
									//TheText = decimalFormat.format(cell.getNumericCellValue());
									TheText = String.valueOf(cell.getNumericCellValue());
								}
//								try {
//									TheText3 = cell.getDateCellValue().getTime()+"";
//									isDate = true;
//								} catch(Exception e3) {
//									TheText = String.valueOf(cell.getNumericCellValue());
//								}

								break;
							case 1: // Cell.CELL_TYPE_STRING
							case 2: // Formula
							case 3: // Cell.CELL_TYPE_BLANK
							case 5: // Cell.CELL_TYPE_ERROR
								TheText = "";
								TheText2 = "";
								TheText3 = "";

								try
								{
									TheText = cell.getStringCellValue()+"";
									TheText2 = TheText;
								}
								catch(IllegalStateException e)
								{
									try
									{
										TheText3 = cell.getDateCellValue().getTime()+"";
									}
									catch(Exception e3)
									{
									}

									try
									{
										cell.setCellType(Cell.CELL_TYPE_STRING);
										TheText = cell.getStringCellValue()+"";
										TheText2 = TheText;

										if(TheText.length()>4)
										{
											if(TheText.indexOf("E")>-1)
											{
												if((TheText+"  ").substring(1,2).equals("."))
												{
													if(TheText.substring(TheText.length()-4,TheText.length()).indexOf("E")>-1)
													{
														TheText = df.format(Double.parseDouble(TheText));
														TheText2 = TheText;
													}
												}
											}
										}
									}
									catch(Exception e2) // # 등 오류
									{
										TheText = "";
										TheText2 = "";
										TheText3 = "";
									}
								}
								break;


							case 4: //Cell.CELL_TYPE_BOOLEAN
								TheText = Boolean.toString(cell.getBooleanCellValue());
								break;
							default:
						}*/

					}

					sb.append(mCellMap(data, r, c, TheText,TheText2, TheText3, isDate));
				}
			}//cell

			//레코드 1개의 끝
			if(r>=data.headerRows+data.StartRow-1)
			{
				data.LoadRowCount ++;
				sb.append("},");
			}
		}//row
	}//sheet
	return sb.toString();
}


String replace(String sStrString, String sStrOld, String sStrNew)
{
	if (sStrString == null)return null;

	for (int iIndex = 0 ; (iIndex = sStrString.indexOf(sStrOld, iIndex)) >= 0 ; iIndex += sStrNew.length())
	sStrString = sStrString.substring(0, iIndex) + sStrNew + sStrString.substring(iIndex + sStrOld.length());
	return sStrString;
}

// XLSX 문서를 로딩합니다.

String LoadExcelx4LargeFile(JspWriter out, MyData data) throws Exception
{
	StringBuffer sb = new StringBuffer();

	data.UsedCol = new boolean[512];
	for (int r = 0; r < data.SaveName.length; r++)
	{
		data.fileSaveName[r] = new String[512];
		data.fileRecordType[r] = new String[512];
		data.fileRecordFormat[r] = new String[512];
		data.fileDatePattern[r] = new String[512];
	}


	int minColumns = -1;
	minColumns = 2;

	OPCPackage p = OPCPackage.open(data.filePath, PackageAccess.READ);
	XLSX2CSV xlsx2csv = new XLSX2CSV(p, sb, minColumns, data);
	List li = xlsx2csv.process();
	xlsx2csv = null;
	p.close();
	p = null;

	sb.setLength(0);

	for(int r=data.StartRow-1 ; r<li.size() ; r++)
	{
		if(data.EndRow != 0)
		{
			if(r > data.EndRow - 1) break;
		}

		if(r >= data.headerRows + data.StartRow - 1)
		{
			sb.append("{");
		}
		if (r < data.headerRows+data.StartRow-1 || (data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER")) && r==data.StartRow-1) // 헤더자료면 헤더-컬럼속성 자료 준비
		{
			//헤더제외
		}

		data.isFirst = true;

		boolean isDate = false;
		Map mp = (Map)li.get(r);

		TreeMap treeMap = new TreeMap( mp );
		Iterator iterator = treeMap.keySet().iterator();
		while (iterator.hasNext()) {
			isDate = false;
			String key = String.valueOf(iterator.next());
			String value = mp.get(key).toString();
			String values[] = value.split("\u0001", 2);
			if(values[0].equals("D"))
				isDate = true;

//			System.out.println("row = " + r);
//			System.out.println("col = " + key);
//			System.out.println("value = " + values[1]);

			sb.append(mCellMap(data, r, Integer.parseInt(key), values[1], values[1], values[1], isDate));
		}

		//레코드 1개의 끝
		if(r>=data.headerRows+data.StartRow-1)
		{
			data.LoadRowCount ++;
			sb.append("},");
		}
	}

	li = null;

	return sb.toString();
}




public class XLSX2CSV {

	/**
	 * The type of the data value is indicated by an attribute on the cell.
	 * The value is usually in a "v" element within the cell.
	 */

	int countrows = 0;
	List li = new ArrayList();

	public final int BOOL = 0;
	public final int ERROR = 1;
	public final int FORMULA = 2;
	public final int INLINESTR = 3;
	public final int SSTINDEX = 4;
	public final int NUMBER = 5;

	class MyXSSFSheetHandler extends DefaultHandler {

		/**
		 * Table with styles
		 */
		private StylesTable stylesTable;

		/**
		 * Table with unique strings
		 */
		private ReadOnlySharedStringsTable sharedStringsTable;

		/**
		 * Destination for data
		 */
		private final StringBuffer output;

		/**
		 * Number of columns to read starting with leftmost
		 */
		private final int minColumnCount;

		// Set when V start element is seen
		private boolean vIsOpen;

		// Set when cell start element is seen;
		// used when cell close element is seen.
		private int nextDataType;

		// Used to format numeric cell values.
		private short formatIndex;
		private String formatString;
		private final DataFormatter formatter;

		private int thisColumn = -1;
		// The last column printed to the output stream
		private int lastColumnNumber = -1;

		// Gathers characters as they are seen.
		private StringBuffer value;

		List li = new ArrayList();
		Map mp = new HashMap();

		/**
		 * Accepts objects needed while parsing.
		 *
		 * @param styles  Table of styles
		 * @param strings Table of shared strings
		 * @param cols    Minimum number of columns to show
		 * @param target  Sink for output
		 */
		public MyXSSFSheetHandler(
				StylesTable styles,
				ReadOnlySharedStringsTable strings,
				int cols,
				StringBuffer target,
				List li) {

			this.stylesTable = styles;
			this.sharedStringsTable = strings;
			this.minColumnCount = cols;
			this.output = target;
			this.value = new StringBuffer();
			this.nextDataType = NUMBER;
			this.formatter = new DataFormatter();
			this.li = li;
		}

		/*
		* (non-Javadoc)
		* @see org.xml.sax.helpers.DefaultHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes)
		*/
		public void startElement(String uri, String localName, String name, Attributes attributes) throws SAXException {

			if ("inlineStr".equals(name) || "v".equals(name)) {
				vIsOpen = true;
				// Clear contents cache
				value.setLength(0);
			} else if ("c".equals(name)) {	// c => cell
				// Get the cell reference
				String r = attributes.getValue("r");
				int firstDigit = -1;
				for (int c = 0; c < r.length(); ++c) {
					if (Character.isDigit(r.charAt(c))) {
						firstDigit = c;
						break;
					}
				}
				thisColumn = nameToColumn(r.substring(0, firstDigit));

				// Set up defaults.
				this.nextDataType = NUMBER;
				this.formatIndex = -1;
				this.formatString = null;
				String cellType = attributes.getValue("t");
				String cellStyleStr = attributes.getValue("s");
				if ("b".equals(cellType))
					nextDataType = BOOL;
				else if ("e".equals(cellType))
					nextDataType = ERROR;
				else if ("inlineStr".equals(cellType))
					nextDataType = INLINESTR;
				else if ("s".equals(cellType))
					nextDataType = SSTINDEX;
				else if ("str".equals(cellType))
					nextDataType = FORMULA;
				else if (cellStyleStr != null) {
					// It's a number, but almost certainly one
					//  with a special style or format
					int styleIndex = Integer.parseInt(cellStyleStr);
					XSSFCellStyle style = stylesTable.getStyleAt(styleIndex);
					this.formatIndex = style.getDataFormat();
					this.formatString = style.getDataFormatString();
					if (this.formatString == null) {
						this.formatString = BuiltinFormats.getBuiltinFormat(this.formatIndex);
					}
				}
			}
		}

		/*
		* (non-Javadoc)
		* @see org.xml.sax.helpers.DefaultHandler#endElement(java.lang.String, java.lang.String, java.lang.String)
		*/
		public void endElement(String uri, String localName, String name) throws SAXException {

			String thisStr = null;
			String type = "S";
			
			if ("v".equals(name)) {	// v => contents of a cell

				// Process the value contents as required.
				// Do now, as characters() may be called more than once
				switch (nextDataType) {

					case BOOL:
						char first = value.charAt(0);
						thisStr = first == '0' ? "FALSE" : "TRUE";
						break;

					case ERROR:
						thisStr = value.toString();
						break;

					case FORMULA:
						// A formula could result in a string value,
						// so always add double-quote characters.
						thisStr = value.toString();
						break;

					case INLINESTR:
						// TODO: have seen an example of this, so it's untested.
						XSSFRichTextString rtsi = new XSSFRichTextString(value.toString());
						//thisStr = '"' + rtsi.toString() + '"';
						thisStr = rtsi.toString();
						break;

					case SSTINDEX:
						String sstIndex = value.toString();
						try {
							int idx = Integer.parseInt(sstIndex);
							XSSFRichTextString rtss = new XSSFRichTextString(sharedStringsTable.getEntryAt(idx));
							//thisStr = '"' + rtss.toString() + '"';
							thisStr = rtss.toString();
						} catch (NumberFormatException ex) {
							//output.append("Failed to parse SST index '" + sstIndex + "': " + ex.toString());
						}
						break;

					case NUMBER:
						type = "N";
						String n = value.toString();

						//System.out.println("Column => " + thisColumn + " formatIndex : " + formatIndex + " formatString : " + formatString + " value : " + n);

						if (formatString != null) {
							if (HSSFDateUtil.isADateFormat(formatIndex, formatString)) {
							//if (HSSFDateUtil.isValidExcelDate(Double.parseDouble(n))) {
							//if (HSSFDateUtil.isValidExcelDate(Double.parseDouble(n))) {
								type = "D";
								thisStr = String.valueOf(DateUtil.getJavaDate(Double.parseDouble(n)).getTime());
							}  else {
								//thisStr = formatter.formatRawCellContents( Double.parseDouble(n), formatIndex, formatString);
								thisStr = n;
							}
						} else {
							if(formatIndex > -1 && formatString == null) {			// 중요 !!! : mm-dd 포맷 오류 fix
								type = "D";
								thisStr = String.valueOf(DateUtil.getJavaDate(Double.parseDouble(n)).getTime());
							} else if (n.endsWith(".0")) {
								// xlsx only stores doubles, so integers get ".0" appended
								// to them
								thisStr =  n.substring(0, n.length() - 2);
							} else {
								thisStr = n;
							}
						}
						break;

					default:
						thisStr = "( Unexpected type: " + nextDataType + ")";
						break;
				}

				// Output after we've seen the string contents
				// Emit commas for any fields that were missing on this row
				if (lastColumnNumber == -1) {
					lastColumnNumber = 0;
				}

				try {
//System.out.println("Column => " + thisColumn );
//System.out.println(formatIndex + " : " + formatString);
//System.out.println("isADateFormat : " + HSSFDateUtil.isADateFormat(formatIndex, formatString) );
//System.out.println("type : " + type );
//System.out.println("thisStr : " + thisStr );
					mp.put(thisColumn + "", type + "\u0001" + thisStr);
				} catch(Exception e) {
					//e.printStackTrace();
				}

				// Update column
				if (thisColumn > -1)
					lastColumnNumber = thisColumn;

			} else if ("row".equals(name)) {
				li.add(mp);
				mp = new HashMap();

				// Print out any missing commas if needed
				if (minColumns > 0) {
					// Columns are 0 based
					if (lastColumnNumber == -1) {
						lastColumnNumber = 0;
					}
					//for (int i = lastColumnNumber; i < (this.minColumnCount); i++) {
					//	output.print(',');
					//}
				}

				// We're onto a new row

				countrows++;
				lastColumnNumber = -1;
			}
		}

		/**
		 * Captures characters only if a suitable element is open.
		 * Originally was just "v"; extended for inlineStr also.
		 */
		public void characters(char[] ch, int start, int length)
				throws SAXException {
			if (vIsOpen)
				value.append(ch, start, length);
		}

		/**
		 * Converts an Excel column name like "C" to a zero-based index.
		 *
		 * @param name
		 * @return Index corresponding to the specified name
		 */
		private int nameToColumn(String name) {
			int column = -1;
			for (int i = 0; i < name.length(); ++i) {
				int c = name.charAt(i);
				column = (column + 1) * 26 + c - 'A';
			}
			return column;
		}

	}

	///////////////////////////////////////

	private OPCPackage xlsxPackage;
	private int minColumns;
	private StringBuffer output;
	private MyData data;
	/**
	 * Creates a new XLSX -> CSV converter
	 *
	 * @param pkg        The XLSX package to process
	 * @param output     The PrintStream to output the CSV to
	 * @param minColumns The minimum number of columns to output, or -1 for no minimum
	 */
	public XLSX2CSV(OPCPackage pkg, StringBuffer output, int minColumns, MyData data) {
		this.xlsxPackage = pkg;
		this.output = output;
		this.minColumns = minColumns;
		this.data = data;
	}

	/**
	 * Parses and shows the content of one sheet
	 * using the specified styles and shared-strings tables.
	 *
	 * @param styles
	 * @param strings
	 * @param sheetInputStream
	 */
	public void processSheet(
			StylesTable styles,
			ReadOnlySharedStringsTable strings,
			InputStream sheetInputStream) throws IOException, ParserConfigurationException, SAXException {

		InputSource sheetSource = new InputSource(sheetInputStream);
		SAXParserFactory saxFactory = SAXParserFactory.newInstance();
		SAXParser saxParser = saxFactory.newSAXParser();
		XMLReader sheetParser = saxParser.getXMLReader();
		ContentHandler handler = new MyXSSFSheetHandler(styles, strings, this.minColumns, this.output, li);
		sheetParser.setContentHandler(handler);
		sheetParser.parse(sheetSource);
	}

	/**
	 * Initiates the processing of the XLS workbook file to CSV.
	 *
	 * @throws IOException
	 * @throws OpenXML4JException
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 */
	public List process() throws IOException, OpenXML4JException, ParserConfigurationException, SAXException {

		ReadOnlySharedStringsTable strings = new ReadOnlySharedStringsTable(this.xlsxPackage);
		XSSFReader xssfReader = new XSSFReader(this.xlsxPackage);

		StylesTable styles = xssfReader.getStylesTable();
		XSSFReader.SheetIterator iter = (XSSFReader.SheetIterator) xssfReader.getSheetsData();
		int index = -1;
		while (iter.hasNext()) {
			InputStream stream = (InputStream)iter.next();
			String sheetName = iter.getSheetName();
			index++;

			if(!data.WorkSheetName.equals("")) {
				if(!data.WorkSheetName.equals(sheetName))
					continue;
			} else if(data.WorkSheetNo !=0 ) {
				if(index != data.WorkSheetNo - 1)
					continue;
			}
			//this.output.append("");
			//this.output.append(sheetName + " [index=" + index + "]:");
			processSheet(styles, strings, stream);
			stream.close();
		}
		return li;
	}
}

%>
