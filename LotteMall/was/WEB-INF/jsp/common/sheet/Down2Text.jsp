<%@	page language="java" contentType="text/html;charset=utf-8" %><%@	page import="java.io.*"	%><%@	page import="java.util.*" %><%
	//====================================================================================================
	// [ 사용자	환경 설정 #1 ]
	//====================================================================================================
	// Html	페이지의 엔코딩이 utf-8	로 구성되어	있으면 "isUTF8 = true;"	로 설정하십시오.
	// 텍스트 문서의 한글이 깨지면 이 값을 바꿔 보십시오.
	// LoadExcel.jsp 도	동일한 값으로 바꿔 주십시오.
	//====================================================================================================
	//boolean	isUTF8 = false;
	boolean isUTF8 = true;

	//====================================================================================================
	// [ 사용자	환경 설정 #3 ]
	//====================================================================================================
	// 트리	컬럼에서 레벨별로 … 를	덧붙여서 레벨별로 보기 좋게	만듭니다.
	// 만약	… 대신	다른 문자를	사용하기를 원하시면	아래 유니코드 \u2026 (16진수형태) 대신 다른	문자를 입력하십시오.
	//====================================================================================================
	//String sTreeChar = "";		// 레벨별 들여쓰기처리 대신	트리글자들을 다닥다닥 붙임.
	//String sTreeChar = "\u119E";	// ㆍ
	//String sTreeChar = "\u2500";	// ─
	String sTreeChar = "\u2026";	// …

	// isDebug = true; // 디버그전용
//FileOutputStream fos = new FileOutputStream("D:/receive_debug.txt");


	request.setCharacterEncoding("euc-kr");

	try
	{
		StringBuffer sb = new StringBuffer();

		//====================================================================================================
		// 수신자료를 수집합니다.
		//====================================================================================================
		BufferedReader br =	null;
		if(isUTF8)
		{
			br = new BufferedReader(new	InputStreamReader(request.getInputStream(),"UTF-8"));
		}
		else
		{
			br = new BufferedReader(new	InputStreamReader(request.getInputStream()));
		}

		int	NewSheetNo = 0;
		String SheetNames = "";
		String str;
		String sHeader = "";
		String sData = "";
		String CellType = "";
		StringBuffer sbData = new StringBuffer();

		boolean	isHeaderParse = true;

		while((str = br.readLine()) != null)
		{
			str += "\r\n";
			if(isHeaderParse) // 헤더를	분석함
			{
				if(str.indexOf("\u007F") >= 0 && str.indexOf("\u0005") >= 0)
				{
					isHeaderParse = false;	// 이제부터는 데이타 분석하기
					sHeader += str.substring(0, str.indexOf("\u0005"));
					sbData.append(str.substring(str.indexOf("\u0005")));
				}
				else
				{
					sHeader += str;
				}
			}
			else //	데이타를 모음
			{
				sbData.append(str);
			}
		}
		br.close();
		sData = sbData+"";

		//====================================================================================================
		// 텍스트 자료의 헤더부분만 정리합니다.
		//====================================================================================================
		sHeader = sHeader.substring(sHeader.indexOf("\u0004") + 1);

		//====================================================================================================
		// 텍스트 자료의 데이터 부분을 정리합니다.(버퍼링대비)
		//====================================================================================================
		sData = sData.substring(0, sData.lastIndexOf("\u0005") + 1);

		String LastBufferPack = "";
		LastBufferPack = sHeader + sData;

//fos.write(LastBufferPack.getBytes());

		String[] SheetDatas = LastBufferPack.split("\u0003");

		int kLoop = 1;
		if(LastBufferPack.indexOf("\u0003") != -1)
		{
			kLoop = SheetDatas.length - 0;
		}

		for(int	k=0 ; k<kLoop ; k++) //최대	n개의 시트를 모아받기 가능.
		{
			sHeader = SheetDatas[k].substring(0, SheetDatas[k].indexOf("\u0005"));
			sData   = SheetDatas[k].substring(SheetDatas[k].indexOf("\u0005"));
			SheetDatas[k] = "";

			//====================================================================================================
			// 전달받은	Down2Text 인자를 준비합니다.
			//====================================================================================================
			int	arrSize	= 0;

			String ColDelim				= getPropValue(sHeader,"ColDelim");
			String RowDelim				= getPropValue(sHeader,"RowDelim");

			String TitleText			= getPropValue(sHeader,"TitleText");//"위글\u007F위글2\u007F위글3\u0005밑글\u007F밑글2\u007F밑글3";
			String sColVisibles			= getPropValue(sHeader,"ColVisibles");
			String TheDownloadFileName	= getPropValue(sHeader,"FileName");
			String TheSheetName			= getPropValue(sHeader,"SheetName");
			String RecordTypes			= getPropValue(sHeader,"RecordTypes");
			String RecordFormats		= getPropValue(sHeader,"RecordFormats");
			String RecordOrgFormats		= getPropValue(sHeader,"RecordOrgFormats");

			String arrColVisibles[]			= sColVisibles.split("\\|");
			String arrRecordType[]			= RecordTypes.split("\\|");
			String arrRecordFormat[]		= RecordTypes.split("\\|");
			String arrRecordOrgFormat[]		= RecordTypes.split("\\|");
			String arrRecordFormat2[]		= RecordFormats.split("\\|");
			String arrRecordOrgFormat2[]	= RecordOrgFormats.split("\\|");
			String arrRecordTypeNumeric[]	= RecordTypes.split("\\|");

//fos.write((" TitleText0 :"+TitleText+"\n").getBytes());
			TitleText =	TitleText.replace("\u0002","\u0005");

			int HeaderRows = Integer.parseInt("0"+getPropValue(sHeader,"HeaderRows"));
			int DownHeader = Integer.parseInt("0"+getPropValue(sHeader,"DownHeader"));

			if(RowDelim.equals(""))
				RowDelim = "\r\n";

			if(ColDelim.equals(""))
				ColDelim = " ";

			//====================================================================================================
			// 다운로드	파일명을 설정합니다.
			//====================================================================================================
			if(TheDownloadFileName.indexOf(".txt") == -1)
			{
				TheDownloadFileName +=".txt";
				//TheDownloadFileName =	java.net.URLEncoder.encode(TheDownloadFileName); //한글파일명깨짐방지
			}

			if(k==0)
			{
				String sEncodingFileName = new String(TheDownloadFileName.getBytes("euc-kr"), "8859_1");

				response.setHeader("Content-Type", "application/octet-stream");
				response.setHeader("Content-Disposition", "attachment;filename=" + sEncodingFileName + ";");
				response.setHeader("Content-Description", "IBSheet Generated Data");
			}

			//====================================================================================================
			// 워크시트명을	설정합니다.
			//====================================================================================================
			if(TheSheetName=="")
			{
				TheSheetName ="sheet";
			}

			int sTitleRow =	0;

/*			if (!TitleText.equals(""))
			{
				sTitleRow =	TitleText.split("\u0005").length;
				TitleText =	"\u0005"+TitleText;
			}
*/
			sData = TitleText+sData;
			String[] lines = (sData+"").split("\u0005");
			//====================================================================================================
			// 데이타 를 표현합니다.
			//====================================================================================================
			boolean isFirst = true;
			for	(int iR=1 ; iR<lines.length ; iR++)
			{

//fos.write((iR+" Row :"+lines.length+"\n").getBytes());



				if(lines[iR].indexOf("\u0002")!=-1)	// 널자료시의 대응
				{
					lines[iR] = " ";
				}

				String [] cells = lines[iR].split("\u007F");

				CellType = "TITLE";

				arrSize = arrRecordType.length;
				if(iR <= sTitleRow)
				{
					arrSize = cells.length;
				}

				isFirst = true;
				for (int iC=0 ; iC<arrSize ; iC++)
				{
					if (iC<cells.length)
					{
						if(isFirst==false)
						{
							sb.append(ColDelim);
						}
						sb.append(cells[iC]);
						isFirst = false;
/*						if(CellType.equals("TITLE")	|| CellType.equals("HEAD") || arrRecordTypeNumeric[iC].equals("")) //널은 숫자,날짜가 아님.
						{
							sb.append(cells[iC]);
						}
						else
						{
							sb.append(cells[iC]);
						}
*/
					}
					else
					{
						sb.append(ColDelim);
					}
				} //for

				if(iR < lines.length - 1)
					sb.append(RowDelim);
			}

			if(k < kLoop - 1)
				sb.append(RowDelim);
		} // sheet
		out.print(sb.toString());
	} catch (Exception e) {
		out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetExcelSheetID].finishDownload(); targetWnd.Grids[targetWnd.gTargetExcelSheetID].ShowAlert('다운로드중 에러가 발생하였습니다.', 'U');}catch(e){}</script>");
		
		e.printStackTrace();
	} catch (Error e) {
		out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetExcelSheetID].finishDownload(); targetWnd.Grids[targetWnd.gTargetExcelSheetID].ShowAlert('다운로드중 에러가 발생하였습니다.', 'U');}catch(e){}</script>");

		e.printStackTrace();
	}
//fos.close();
%>
<%!

// 함수	추가

String getPropValue(String Header, String prop) throws Exception
{
	int findS = 0;
	int findE = 0;

	findS = Header.indexOf("<"+prop+">");
	findE = Header.indexOf("</"+prop+">");

	if(findS != -1 && findE != -1)
		return Header.substring(findS+prop.length()+2, findE);		// 시작	태그를 제외하고	데이타만 리턴해줌
	else
		return "";
}

%>