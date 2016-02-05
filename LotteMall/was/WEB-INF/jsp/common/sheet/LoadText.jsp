<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
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

//out.println(XSSFCell.CELL_TYPE_NUMERIC+"//");

try{
	StringBuffer sb = new StringBuffer();
	StringBuffer jsonData = new StringBuffer();

	// 업로드 엑셀 파일을 수신하고 임시폴더에 저장함
	String contentType = request.getContentType();
	request.setCharacterEncoding("utf-8");

	if ((contentType == null))
	{
		out.println("<script>try { parent.document.getElementById('IBSheetLoadTextFileFinder').click(); } catch(e) { window.parent.postMessage('IBSheetLoadTextFileFinder', '*'); } </script>");
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

		if(UploadFileExt.indexOf("txt")>=0) // 엑셀 파일들만 로딩 허용함
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

			// LoadText 인자를 받아 적용함
			data.ColList = ColumnTagValue;
			data.Deli = getPropValue(data.ColList,"Deli");
			data.Mode = getPropValue(data.ColList,"Mode");
			data.SearchMode = getPropValue(data.ColList,"SearchMode");

			data.MaxCols = Integer.parseInt(getPropValue(data.ColList,"MaxCols"));
			data.filePath = tmpFolder + SaveFileName;
			data.headerRows = Integer.parseInt(getPropValue(data.ColList,"HeaderRows"));
			if(data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER"))
			{
				data.headerRows = 0;
			}

			data.ColumnMapping = getPropValue(data.ColList,"ColumnMapping").split("\\|");
			data.StatusCol = getPropValue(data.ColList,"StatusCol");
			if(getPropValue(data.ColList,"ColumnMapping").equals("")) data.isColumnMapping = false;
			else data.isColumnMapping = true;


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
			int r = 0;
			for (String temp2 : temp) {
				data.RecordType[r++]	= temp2.split("\\|", data.MaxCols);
			}
			r = 0;
			temp = RecordFormat.split("\\^");
			for (String temp2 : temp) {
				data.RecordFormat[r++]	= temp2.split("\\|", data.MaxCols);
			}
			r = 0;
			temp = DatePattern.split("\\^");
			for (String temp2 : temp) {
				data.DatePattern[r++]	= temp2.split("\\|", data.MaxCols);
			}
			r = 0;
			temp = SaveName.split("\\^");
			for (String temp2 : temp) {
				data.SaveName[r++]		= temp2.split("\\|", data.MaxCols);
			}
			temp = HeaderText.split("\\^");
			data.HeaderText		= new String[temp.length][];
			r = 0;
			for (String temp2 : temp) {
				data.HeaderText[r++]	= temp2.split("\\|", data.MaxCols);
			}


			// JSON 결과를 리턴함

			sb.append("<html><head><script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.gJson='");
			jsonData.append("{data:[[");

			jsonData.append(LoadText(out, data, isUTF8));

			jsonData.append("]]}");

			mDeleteFile(MustDeletePath);


			String sUnMatchColumn = "";


			if(!SheetID.equals(""))
			{
				out.println("<html><head><script>window.parent.postMessage('IBSheetOnLoadExcel^" + SheetID + "^" + data.LoadRowCount + "^TEXT^Append=" + Append + "^" + jsonData.toString() + "', '*'); </script></head></html>");
			} else {
				out.print(sb.toString());
				out.print(jsonData.toString());

				sb.setLength(0);
				sb.append("';"+((data.SearchMode.equals("3"))?"targetWnd.Grids[targetWnd.gTargetTextSheetID].SetTotalRows("+data.LoadRowCount+");":"")+"targetWnd.Grids[targetWnd.gTargetTextSheetID].DoSearchScript('gJson',{type:'Text', Append:'"+ Append + "'});");

				if(data.bUnMatchColHidden==1)
				{
					sb.append("targetWnd.Grids[targetWnd.gTargetTextSheetID].mUnMatchColHidden('"+sUnMatchColumn+"');");
				}
				sb.append("</script></head></body></html>");

				out.print(sb.toString());
			}

		}
	}

} catch(Exception e) {
	out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetTextSheetID].ShowAlert('텍스트 파일을 읽는 도중 예외가 발생하였습니다.', 'U'); targetWnd.Grids[targetWnd.gTargetTextSheetID].finishDownload(); }catch(e){}</script>");

	e.printStackTrace();
} catch (Error e) {
	out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetTextSheetID].ShowAlert('텍스트 파일을 읽는 도중 예외가 발생하였습니다.', 'U'); targetWnd.Grids[targetWnd.gTargetTextSheetID].finishDownload(); }catch(e){}</script>");

	e.printStackTrace();
} finally {
	mDeleteFile(MustDeletePath);
}
%>


<%!

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




// 사용하는 변수들을 선언합니다.
public class MyData
{
	int MaxCols = 0;
	int headerRows = 0;

	int LoadRowCount = 0;
	String SearchMode = "";
	String Deli = "";
	String Mode = "";
	String StatusCol = "";
	String ColList = "";
	String filePath = "";
	String ColumnMapping[] = null;
	boolean isColumnMapping = false;
	int bUnMatchColHidden = 0; // 사용자가 1 설정하면 1로 들어가서 언매치 컬럼들이 컬럼히든처리됨
	boolean isFirst = false;
	byte dataBytes[] = null;

	String SaveName[][];
	String HeaderText[][];
	String RecordType[][];
	String RecordFormat[][];
	String DatePattern[][];
}

// 속성 값을 얻어 냅니다.
String getPropValue(String Header, String prop) throws Exception
{
	int findS = 0;
	int findE = 0;

	Header = Header.replace("\r","");
	prop = prop.replace("\r","");

	findS = Header.indexOf("<"+prop+">");
	findE = Header.indexOf("</"+prop+">");

	if(findS != -1 && findE != -1) return Header.substring(findS+prop.length()+2,findE);		// 시작 태그를 제외하고 데이타만 리턴해줌
	else return "";
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


// TEXT 문서를 로딩합니다.
String LoadText(JspWriter out, MyData data, boolean isUTF8) throws Exception
{
	BufferedReader in = null;

	if(isUTF8)
		in = new BufferedReader( new InputStreamReader( new FileInputStream(data.filePath), "UTF-8" ) );
	else
		in = new BufferedReader( new InputStreamReader( new FileInputStream(data.filePath) ) );

	String line;
	String cell[];
	StringBuffer sb = new StringBuffer();

	int dataRows = data.RecordType.length;	// 단위데이터행 row 갯수
	int rowNumber = 0;

	int textLineNumber = 0;					// text 파일에서 읽은 라인 번호
	while ((line = in.readLine()) != null)
	{
		cell = line.split(data.Deli, data.MaxCols);

		// 헤더분석
		if (textLineNumber == data.headerRows - 1 && data.Mode.toLowerCase().equals("headermatch")) // 헤더자료면 헤더-컬럼속성 자료 준비
		{
			for(int col=0 ; col<cell.length ; col++)
			{
				String headerText = cell[col];

				headerText = headerText.replace("(*)", "");

				if(!headerText.equals( data.HeaderText[data.headerRows-1][col] ))
				{
					for(int j=col+1; j<data.HeaderText[data.headerRows-1].length ; j++)
					{
						if(headerText.equals( data.HeaderText[data.headerRows-1][j] ))
						{
							swap(data, col, j);
						}
					}
				}
			}
		}


		textLineNumber++;

		if(textLineNumber <= data.headerRows)
			continue;

		sb.append("{");
		if(!data.StatusCol.equals(""))
		{
			sb.append(data.StatusCol+":\"I\",");
		}

		rowNumber = (textLineNumber - data.headerRows - 1) % dataRows;

		for(int col=0 ; col<cell.length ; col++)
		{

//System.out.println("data.SaveName[" + rowNumber + "][" + col + "] : " + data.SaveName[rowNumber][col]);
//System.out.println("data.RecordType[" + rowNumber + "][" + col + "] : " + data.RecordType[rowNumber][col]);
//System.out.println("data.RecordFormat[" + rowNumber + "][" + col + "] : " + data.RecordFormat[rowNumber][col]);
//System.out.println("data.DatePattern[" + rowNumber + "][" + col + "] : " + data.DatePattern[rowNumber][col]);


			// 상태 컬럼 건너뜀
			if(" Status ".indexOf(" "+data.RecordType[rowNumber][col]+" ")>-1)
				continue;

			// 0.0 이 1처럼 체크되는 현상
			if(" CheckBox Radio DelCheck ".indexOf(" "+data.RecordType[rowNumber][col]+" ")>-1)
			{
				if(cell[col].equals("0.0"))
				{
					cell[col] = "0";
				}
			}

			// 날자 컬럼 변환
			if("date".equals(data.RecordType[rowNumber][col].toLowerCase()) && !"".equals(cell[col]))
			{
				try {
					SimpleDateFormat df = new SimpleDateFormat(data.RecordFormat[rowNumber][col]);
					Date date = df.parse(cell[col]);
					cell[col] = getDateString(date, data.DatePattern[rowNumber][col]);
				} catch (Exception e) {
					e.printStackTrace();
					cell[col] = "";
				}
			}

			sb.append(data.SaveName[0][col]+":\""+cell[col].replace("\r","\\\\r").replace("\n","\\\\n").replace("\"","\\\\\"").replace("'","\\\'")+"\"");

			if(col < cell.length - 1)
				sb.append(",");
		}

		data.LoadRowCount ++;
		sb.append("},");
	}
	in.close();

//	System.out.println(sb.toString());

	return sb.toString();
}

String getDateString(Date date, String datePattern) throws Exception
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

	return df.format(date);
}


void swap(MyData data, int i, int j)
{
	if(i == j)
		return;

	String temp1, temp2, temp3, temp4 = "";

	for(int k=0 ; k<data.RecordType.length ; k++)
	{
		temp1 = data.SaveName[k][i];
		temp2 = data.RecordType[k][i];
		temp3 = data.RecordFormat[k][i];
		temp4 = data.DatePattern[k][i];

		data.SaveName[k][i]    = data.SaveName[k][j];
		data.RecordType[k][i]  = data.RecordType[k][j];
		data.RecordFormat[k][i]= data.RecordFormat[k][j];
		data.DatePattern[k][i] = data.DatePattern[k][j];

		data.SaveName[k][j]   = temp1;
		data.RecordType[k][j]   = temp2;
		data.RecordFormat[k][j] = temp3;
		data.DatePattern[k][j]  = temp4;
	}
	for(int k=0 ; k<data.HeaderText.length ; k++)
	{
		temp1 = data.HeaderText[k][i];
		data.HeaderText[k][j]   = data.HeaderText[k][i];
		data.HeaderText[k][i]   = temp1;
	}
}

%>
