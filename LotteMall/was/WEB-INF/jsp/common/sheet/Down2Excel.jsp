<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="org.apache.poi.hssf.record.*" %>
<%@ page import="org.apache.poi.hssf.model.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="org.dom4j.*" %>
<%@ page import="org.dom4j.io.*" %>
<%
/*
   Copyright 2012 IBLeaders

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/


	//====================================================================================================
	// [ 사용자 환경 설정 #1 ]
	//====================================================================================================
	// Html 페이지의 엔코딩이 utf-8 로 구성되어 있으면 "isUTF8 = true;" 로 설정하십시오.
	// 엑셀 문서의 한글이 깨지면 이 값을 바꿔 보십시오.
	// LoadExcel.jsp 도 동일한 값으로 바꿔 주십시오.
	//====================================================================================================
	//boolean isUTF8 = false;
	boolean isUTF8 = true;

	//====================================================================================================
	// [ 사용자 환경 설정 #2 ]
	//====================================================================================================
	// 엑셀에 포함될 이미지의 URL 에 가상폴더를 사용할 경우가 조금이라도 있다면 웹루트를 아래 변수에 직접 지정해 주십시오.
	// 엑셀에 포함될 이미지에 가상폴더를 사용하지 않으면 그냥 널로 두십시오.
	//====================================================================================================
	//String sWebRoot = "C:/apache-tomcat-6.0.16/webapps";
	String sWebRoot = "D:/Eclipse_workspace/IBSheetHtml4/bin";


	//====================================================================================================
	// [ 사용자 환경 설정 #3 ]
	//====================================================================================================
	// 트리 컬럼에서 레벨별로 … 를 덧붙여서 레벨별로 보기 좋게 만듭니다.
	// 만약 … 대신 다른 문자를 사용하기를 원하시면 아래 유니코드 \u2026 (16진수형태) 대신 다른 문자를 입력하십시오.
	//====================================================================================================
	//String sTreeChar = "";		// 레벨별 들여쓰기처리 대신 트리글자들을 다닥다닥 붙임.
	//String sTreeChar = "\u119E";	// ㆍ
	//String sTreeChar = "\u2500";	// ─
	String sTreeChar = "\u2026";	// …


	//====================================================================================================
	// [ 사용자 환경 설정 #4 ]
	//====================================================================================================
	// 기본 폰트 이름과 폰트 크기를 설정합니다.
	//====================================================================================================
	String defaultFontName = "Dotum";
	short defaultFontSize = 11;

// isDebug = true; // 디버그전용
//FileOutputStream fos = new FileOutputStream("D:/receive_debug.txt");

	if(sWebRoot.equals(""))
	{
		sWebRoot = application.getRealPath("");
	}

	request.setCharacterEncoding("euc-kr");

	String downloadTokenValue = "";

	try
	{
		//====================================================================================================
		// 수신자료를 수집합니다.
		//====================================================================================================
		BufferedReader br = null;
		if(isUTF8)
		{
			br = new BufferedReader(new InputStreamReader(request.getInputStream(),"UTF-8"));
		}
		else
		{
			br = new BufferedReader(new InputStreamReader(request.getInputStream()));
		}

		int NewSheetNo = 0;
		String SheetNames = "";
		String str;
		String sHeader = "";
		String sData = "";
		String CellType = "";
		StringBuffer sbData = new StringBuffer();

		boolean isHeaderParse = true;

		while((str = br.readLine()) != null)
		{
			str += "\r\n";
			if(isHeaderParse) // 헤더를 분석함
			{
				if(str.indexOf("\u007F")>=0 && str.indexOf("\u0005")>=0)
				{
					isHeaderParse = false;	// 이제부터는 데이타 분석하기
					sHeader += str.substring(0,str.indexOf("\u0005"));
					sbData.append(str.substring(str.indexOf("\u0005")));
				}
				else
				{
					sHeader += str;
				}
			}
			else // 데이타를 모음
			{
				sbData.append(str);
			}
		}
		br.close();
		sData = sbData+"";

		//====================================================================================================
		// 엑셀 자료의 헤더부분만 정리합니다.
		//====================================================================================================
		sHeader = sHeader.substring(sHeader.indexOf("\u0004")+1);

		//====================================================================================================
		// 엑셀 자료의 데이터 부분을 정리합니다.(버퍼링대비)
		//====================================================================================================
		sData = sData.substring(0,sData.lastIndexOf("\u0005")+1);

		String LastBufferPack = "";
		LastBufferPack = sHeader +  sData;
//System.out.println(sHeader +  sData);
//System.out.println(sHeader);
//System.out.println(sData);
//System.out.println(LastBufferPack);


		//====================================================================================================
		// 워크북을 생성합니다.
		//====================================================================================================
		HSSFWorkbook workbook = new HSSFWorkbook();

		String[] SheetDatas = LastBufferPack.split("\u0003");

		int kLoop = 1;
		if(LastBufferPack.indexOf("\u0003")!=-1)
		{
			kLoop = SheetDatas.length-0;
		}

		// report
		sHeader = SheetDatas[0].substring(0, SheetDatas[0].indexOf("\u0005"));
		String reportXMLURL = getPropValue(sHeader, "ReportXMLURL");
		ReportData reportData_ = null;
		if(!"".equals(reportXMLURL))
		{
			reportData_ = getReportData(reportXMLURL);
		}

		for(int k=0 ; k<kLoop ; k++) //최대 n개의 시트를 모아받기 가능.
		{

			sHeader = SheetDatas[k].substring(0,SheetDatas[k].indexOf("\u0005"));
			sData = SheetDatas[k].substring(SheetDatas[k].indexOf("\u0005"));
			SheetDatas[k] = "";

			//====================================================================================================
			// 전달받은 Down2Excel 인자를 준비합니다.
			//====================================================================================================
			int columnCount = 0;
			String sPalette= getPropValue(sHeader, "Palette");
			String sRowHeights = getPropValue(sHeader, "RowHeights");
			String sColVisibles = getPropValue(sHeader, "ColVisibles");
			String arrRowHeights[] = sRowHeights.split("\\|");
			String TheDownloadFileName = getPropValue(sHeader, "FileName");
			String TheSheetName = getPropValue(sHeader, "SheetName");
			String Merge = getPropValue(sHeader, "Merge");
			String ImageNoSeed = " "+getPropValue(sHeader, "ImageNoSeed");
			String RecordTypes = getPropValue(sHeader, "RecordTypes");
			String RecordFormats = getPropValue(sHeader, "RecordFormats");
			String ColWidths = getPropValue(sHeader, "ColWidths");
			String arrColVisibles[] = sColVisibles.split("\\|");
			String RecordOrgFormats = getPropValue(sHeader, "RecordOrgFormats");
			String arrColWidths[] = ColWidths.split("\\|");
			String BaseDir = getPropValue(sHeader,"BaseDir");

			String TitleText = getPropValue(sHeader, "TitleText");//"위글\u007F위글2\u007F위글3\u0005밑글\u007F밑글2\u007F밑글3";
			String UserMerge = getPropValue(sHeader, "UserMerge");
			String ColAlign = getPropValue(sHeader, "ColAlign");
			downloadTokenValue = getPropValue(sHeader, "downloadTokenValue");
			String TextToGeneral = getPropValue(sHeader, "TextToGeneral");
			String WordWrap = getPropValue(sHeader, "WordWrap");



			String[] temp = RecordTypes.split("\\^");
			String arrRecordType[][]		= new String[temp.length][];
			String arrRecordFormat[][]		= new String[temp.length][];
			String arrRecordOrgFormat[][]	= new String[temp.length][];
			String arrRecordTypeNumeric[][]	= new String[temp.length][];

			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				arrRecordType[r]			= temp2.split("\\|");
				arrRecordFormat[r]			= temp2.split("\\|");
				arrRecordOrgFormat[r]		= temp2.split("\\|");
				arrRecordTypeNumeric[r]	= temp2.split("\\|");
			}

			temp = RecordFormats.split("\\^");
			String arrRecordFormat2[][] = new String[temp.length][];
			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				arrRecordFormat2[r] = temp2.split("\\|", arrRecordType[0].length);
			}

			temp = RecordOrgFormats.split("\\^");
			String arrRecordOrgFormat2[][] = new String[temp.length][];
			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				arrRecordOrgFormat2[r] = temp2.split("\\|", arrRecordType[0].length);
			}

			temp = ColAlign.split("\\^");
			String arrColAlign[][] = new String[temp.length][];
			for (int r=0 ; r<temp.length ; r++) {
				String temp2 = temp[r];
				arrColAlign[r] = temp2.split("\\|", arrRecordType[0].length);
			}

			for(int r=0 ; r<arrRecordType.length ; r++)
			{
				for(int s=0 ; s<arrRecordType[0].length ; s++)
				{
					if(arrRecordType[r][s].equals("Seq"))
					{
						arrRecordFormat2[r][s] = "#,###";
						arrRecordOrgFormat2[r][s] = "Integer";
					}
				}
			}
//System.out.println(Arrays.deepToString(arrRecordType));

			TitleText = replace(TitleText, "\u0002", "\u0005");

			BaseDir = replace(sWebRoot, "\\", "/")+BaseDir;

			int HeaderRows  = Integer.parseInt("0" + getPropValue(sHeader, "HeaderRows"));
			int DownHeader  = Integer.parseInt("0" + getPropValue(sHeader, "DownHeader"));
			int SheetDesign = Integer.parseInt("0" + getPropValue(sHeader, "SheetDesign"));

			String SheetFontName = getPropValue(sHeader,"SheetFontName");
			int ExcelFontSize = 0;
			int ExcelRowHeight = 0;
			int SheetFontSize = 0;
			int HeaderBackColor = 0;
			int DataBackColor = 0;
	//			int SumBackColor = 0;

	//			int SumStartRow = Integer.parseInt(getPropValue(sHeader,"SumStartRow"));
	//			int SumEndRow = Integer.parseInt(getPropValue(sHeader,"SumEndRow"));

			if(SheetDesign==1 || SheetDesign==2)
			{
				SheetFontName = getPropValue(sHeader,"SheetFontName");
				ExcelFontSize = Integer.parseInt("0"+getPropValue(sHeader,"ExcelFontSize"));
				ExcelRowHeight = getPropValue(sHeader,"ExcelRowHeight").equals("") ? 0 : Integer.parseInt(getPropValue(sHeader,"ExcelRowHeight"));
				SheetFontSize = Integer.parseInt("0"+getPropValue(sHeader,"SheetFontSize"));
				if(ExcelFontSize>0)
				{
					SheetFontSize = ExcelFontSize;
				}
				HeaderBackColor = Integer.parseInt("0"+getPropValue(sHeader,"HeaderBackColor"));
				DataBackColor = Integer.parseInt("0"+getPropValue(sHeader,"DataBackColor"));
	//				SumBackColor = Integer.parseInt("0"+getPropValue(sHeader,"SumBackColor"));
			}
			else
			{
				SheetFontName = defaultFontName;
				SheetFontSize = defaultFontSize;
			}

			int hSheetFontSize = SheetFontSize;
			if(hSheetFontSize<3)
			{
				hSheetFontSize = 10;
			}


			//====================================================================================================
			// 다운로드 파일명을 설정합니다.
			//====================================================================================================
			if(TheDownloadFileName.indexOf(".xls")==-1)
			{
				TheDownloadFileName +=".xls";
				//TheDownloadFileName = java.net.URLEncoder.encode(TheDownloadFileName); //한글파일명깨짐방지
			}
			if(k==0)
			{
//				String sEncodingFileName = java.net.URLEncoder.encode(TheDownloadFileName, "utf-8").replaceAll("\\+", " ");
//
//				response.setHeader("Content-Disposition", "attachment;filename=" + sEncodingFileName + ";");
//				response.setHeader("Content-Description", "JSP Generated Data");

				String browserName = getBrowser(request);
				String sEncodingFileName = getEncodedFilename(TheDownloadFileName, browserName);
				if ("Opera".equals(browserName)){
					response.setHeader("Content-Type", "application/octet-stream;charset=UTF-8");
				} else {
					response.setHeader("Content-Type", "application/octet-stream");
				}
				response.setHeader("Content-Disposition", "attachment;filename=\"" + sEncodingFileName + "\";");
			}

			//====================================================================================================
			// 워크시트명을 설정합니다.
			//====================================================================================================
			if(TheSheetName=="")
			{
				TheSheetName ="sheet";
			}

			//====================================================================================================
			// 워크시트를 준비합니다.
			//====================================================================================================
			HSSFSheet sheet = null;

			//====================================================================================================
			// 기본 셀 스타일을 정의합니다.
			//====================================================================================================
			HSSFCellStyle styleTitle = (HSSFCellStyle)workbook.createCellStyle();
			HSSFCellStyle styleHead = (HSSFCellStyle)workbook.createCellStyle();
			HSSFCellStyle styleCol[] = new HSSFCellStyle[arrRecordType.length * arrRecordType[0].length];

			HSSFCellStyle style[] = new HSSFCellStyle[arrRecordType.length * arrRecordType[0].length];
			HSSFCellStyle styleHeadColor[] = new HSSFCellStyle[arrRecordType.length * arrRecordType[0].length];

			for(int j=0;j<arrRecordType.length * arrRecordType[0].length;j++)
			{
				style[j] = (HSSFCellStyle)workbook.createCellStyle();
				styleHeadColor[j] = (HSSFCellStyle)workbook.createCellStyle();
			}

			HSSFDataFormat df[] = new HSSFDataFormat[arrRecordType.length * arrRecordType[0].length];
			for(int i=0;i<arrRecordType.length * arrRecordType[0].length;i++)
			{
				int dataRowIdx = i / arrRecordType[0].length;
				int dataRowIdx2 = i % arrRecordType[0].length;
				styleCol[i] = (HSSFCellStyle)workbook.createCellStyle();
				df[i] = (HSSFDataFormat)workbook.createDataFormat();

				if("|Seq|AutoSum|AutoAvg|Int|Float|".indexOf("|"+arrRecordTypeNumeric[dataRowIdx][dataRowIdx2]+"|")>-1)
				{
					arrRecordTypeNumeric[dataRowIdx][dataRowIdx2] = "N"; //N 이면 숫자 계산임..
				}
				else if(arrRecordTypeNumeric[dataRowIdx][dataRowIdx2].equals("Date"))
				{
					arrRecordTypeNumeric[dataRowIdx][dataRowIdx2] = "D"; //널이면 숫자,계산 아님
				}
				else
				{
					arrRecordTypeNumeric[dataRowIdx][dataRowIdx2] = ""; //널이면 숫자,계산 아님
				}

				arrRecordFormat[dataRowIdx][dataRowIdx2] = "";
				if (i<arrRecordFormat2.length * arrRecordFormat2[0].length)
				{
					arrRecordFormat[dataRowIdx][dataRowIdx2] = arrRecordFormat2[dataRowIdx][dataRowIdx2];
				}

				arrRecordOrgFormat[dataRowIdx][dataRowIdx2] = "";
				if (i<arrRecordOrgFormat2.length * arrRecordOrgFormat2[0].length)
				{
					//arrRecordOrgFormat[dataRowIdx][dataRowIdx2] = arrRecordOrgFormat2[dataRowIdx][dataRowIdx2];
				}
			}

			HSSFFont font = (HSSFFont)workbook.createFont();
			HSSFPalette palette = workbook.getCustomPalette();

			if(SheetDesign==1 || SheetDesign==2)
			{
				if(!sPalette.trim().equals(""))
				{
					sPalette = " "+sPalette.trim();
					String pal[] = sPalette.split(" ");
					for(int i=1;i<pal.length && i<=0x30;i++)
					{
						palette.setColorAtIndex((short)(0x0F+i),(byte)Integer.parseInt(pal[i].substring(0,2),16),(byte)Integer.parseInt(pal[i].substring(2,4),16),(byte)Integer.parseInt(pal[i].substring(4,6),16)); //데이터
					}
				}
			}

			// 헤더 기본스타일
			SetDefaultStyle("TITLE", "","","",styleTitle, "", df[0], font, SheetDesign, SheetFontSize, SheetFontName, getColorIndex(palette,255,255,255), defaultFontName, defaultFontSize, reportData_, palette, "", WordWrap);
			SetDefaultStyle("HEAD", "","","",styleHead, "",df[0], font, SheetDesign, SheetFontSize, SheetFontName, getColorIndex(palette,((HeaderBackColor/256/256)%256),  ((HeaderBackColor/256)%256), (HeaderBackColor%256)), defaultFontName, defaultFontSize, reportData_, palette, "", WordWrap);

			// 컬럼별 포맷 설정
			for(int i=0;i<arrRecordType.length * arrRecordType[0].length;i++)
			{
				int dataRowIdx = i / arrRecordType[0].length;
				int dataRowIdx2 = i % arrRecordType[0].length;

				String colAlignInfo = "";
				if(arrColAlign.length > 0)
					colAlignInfo = arrColAlign[dataRowIdx][dataRowIdx2];

				SetDefaultStyle("DATA", arrRecordType[dataRowIdx][dataRowIdx2],arrRecordOrgFormat[dataRowIdx][dataRowIdx2],arrRecordFormat[dataRowIdx][dataRowIdx2], styleCol[i], colAlignInfo, df[i], font, SheetDesign, SheetFontSize, SheetFontName, getColorIndex(palette,255,255,255), defaultFontName, defaultFontSize, reportData_, palette, TextToGeneral, WordWrap);
			}

			int sTitleRow = 0;

			if (!TitleText.equals(""))
			{
				sTitleRow = TitleText.split("\u0005").length;
				TitleText = "\u0005"+TitleText;
			}

			sData = TitleText+sData;
			String[] lines = (sData+"").split("\u0005");
			HSSFRow row = null;

			int rowNumber = 0;
			long SheetNo = 0;

			//====================================================================================================
			// 데이타 를 표현합니다.
			//====================================================================================================
			for (int iR = 1; iR < lines.length; iR++)
			{

				if(iR == 1) // for Report
				{
					// Sheet의 데이터를 표시할 엑셀의 시작 행 위치
					if(reportData_ != null && !"".equals(reportData_.StartRow))
						rowNumber = Integer.parseInt(reportData_.StartRow) - 1;
					rowNumber += iR;
				}

				// 첫항목과 끝항목은 무시함
				if(iR == 1 || rowNumber % 65536 == 1)
				{
					//====================================================================================================
					// 워크시트를 생성합니다.
					//====================================================================================================
					sheet = (HSSFSheet)workbook.createSheet();
					SheetNo = ((rowNumber-1)/65536)+1;
					if(SheetNo!=1)TheSheetName += SheetNo;

					if(SheetNames.indexOf(TheSheetName)==-1) // 새로운 시트명(정상적인 경우)
					{
						workbook.setSheetName(NewSheetNo, TheSheetName);
					}
					else // 시트명 중복시
					{
						workbook.setSheetName(NewSheetNo, TheSheetName+"("+k+")");
					}

					SheetNames += TheSheetName+"//"; //사용했던 시트명들
					NewSheetNo = NewSheetNo + 1;
				}

				if(lines[iR].indexOf("\u0002")!=-1) // 널자료시의 대응
				{
					lines[iR] = " ";
				}

				String [] cells = lines[iR].split("\u007F");
				row = (HSSFRow)sheet.getRow((rowNumber-1)%65536);
				if(row == null)
					row = (HSSFRow)sheet.createRow((rowNumber-1)%65536);

				columnCount = arrRecordType[0].length;
				if(iR<=sTitleRow)
				{
					columnCount = cells.length;
				}

				CellType = "TITLE";

				if(iR == 1) // set Report
				{
					setReportData(reportData_, columnCount, palette, workbook, sheet, rowNumber);
				}

				for (int iC = 0; iC < columnCount; iC++)
				{
					int recordTypeIndex = (iR - 1 - HeaderRows + sTitleRow) % arrRecordType.length;

					HSSFCell cell = (HSSFCell)row.createCell((short) iC);

					// 헤더만 강제로 가운데 정렬
					if(iR <= sTitleRow)
					{
						cell.setCellStyle(styleTitle);
					}
					else if(sTitleRow < iR && iR<=HeaderRows+sTitleRow && DownHeader==1)
					{
						cell.setCellStyle(styleHead);
						CellType = "HEAD";
					}
					else
					{
						cell.setCellStyle(styleCol[recordTypeIndex * arrRecordType[0].length + iC]);
						CellType = "";
					}
					if (iC<cells.length)
					{
						if(CellType.equals("TITLE") || CellType.equals("HEAD") || arrRecordTypeNumeric[recordTypeIndex][iC].equals("")) //널은 숫자,날짜가 아님.
						{
							// 숫자, 날짜를 제외한 일반 값들
							cell.setCellType(HSSFCell.CELL_TYPE_STRING);
							if(CellType.equals("HEAD"))
							{
								cellWriteValueText(workbook, palette, SheetDesign==1,cell,0, cells[iC], sTreeChar, "", "");
							}
							else
							{
								cellWriteValueText(workbook, palette, SheetDesign==1,cell,iC, cells[iC], sTreeChar, "", "");
							}
						}
						else
						{
							if(arrRecordTypeNumeric[recordTypeIndex][iC].equals("D"))
							{
									cell.setCellType(HSSFCell.CELL_TYPE_STRING);
//									cells[iC] = replace(cells[iC], "\\/","-");
//									cells[iC] = replace(cells[iC], "\\.","-");
									cellWriteValueDate(workbook, palette, SheetDesign==1,cell,iC, cells[iC]);
							}
							else
							{
								if(arrRecordTypeNumeric[recordTypeIndex][iC].equals("N"))
								{
									try
									{
										cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
										cellWriteValueNumeric(workbook, palette, SheetDesign==1,cell,iC, cells[iC]);
									}
									catch(NumberFormatException e)
									{
										try
										{
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											cellWriteValue(workbook, palette, SheetDesign==1, cell, iC, cells[iC]);
										}
										catch(NumberFormatException e2)
										{
											cellWriteValue(workbook, palette, SheetDesign==1, cell, iC, "0");
										}
									}
								}
							}
						}

						if(CellType.equals("")) // 이미지는 헤더와 합계에서 제외
						{

							if(arrRecordType[recordTypeIndex][iC].equals("Image") || arrRecordType[recordTypeIndex][iC].equals("ImageText"))
							{
								if(ImageNoSeed.indexOf(" "+(iR-1-sTitleRow)+","+iC+" ")==-1)
								{
									drawImage(sheet, workbook,sWebRoot, rowNumber, iC, BaseDir, cells[iC] );
								}

								if(arrRecordType[recordTypeIndex][iC].equals("Image"))
								{
									cellWriteValue(workbook, palette, SheetDesign==1,cell,iC, "");
								}
							}
						}
					}
					else
					{
						cellWriteValue(workbook, palette, SheetDesign==1,cell,iC, "");
					}

				} //for

				if(reportData_ != null && !"".equals(reportData_.DefaultRowHeight))
				{
					//row.setHeightInPoints(Float.parseFloat(reportData_.DefaultRowHeight));
				} else {

					if(ExcelRowHeight == -1)
					{
						row.setHeight((short)-1); // 자동 높이
					} else if(ExcelRowHeight > 0)
					{
						row.setHeight((short)(15*ExcelRowHeight)); // 15 트윕 단위*1픽셀
					} else if(iR>sTitleRow)
					{
						if((iR-sTitleRow)<arrRowHeights.length)
						{
							row.setHeight((short)(40+20*Short.parseShort(arrRowHeights[iR-sTitleRow]))); // 20단위 1픽셀씩 위아래 1픽셀씩 여백에 높이만큼 높이 잡음
						}
					} else {
						row.setHeight((short)(40+20*32)); // 20 포인트 단위에 1픽셀씩 위아래 1픽셀씩 여백에 높이만큼 높이 잡음
					}

				}

				if(rowNumber == 65536 || iR == lines.length-1)
				{
					int startRow = 0;
					if(reportData_ != null && !"".equals(reportData_.StartRow))
						startRow = Integer.parseInt(reportData_.StartRow) - 1;
//Merge = "0,0,2,0 0,2,2,2 0,3,1,8 0,9,0,15 0,16,2,16 0,17,1,20 0,21,1,28 0,29,2,29 0,30,2,31 0,32,1,35 0,36,2,36 0,37,2,37 0,38,2,38 0,39,2,39 1,9,1,10";
//Merge = "0,0,2,1 0,2,2,2 0,3,0,8 1,3,2,3 1,4,1,7 1,8,2,8";

					if(!Merge.equals(""))
					{
						String[] Merges = Merge.split(" ");
						for (int iM = 0; iM < Merges.length; iM++)
						{
							String[] mergeData = Merges[iM].split(",");

							int mStartRow = Integer.parseInt(mergeData[0]);
							short mStartCol = (short)Integer.parseInt(mergeData[1]);
							int mEndRow = Integer.parseInt(mergeData[2]);
							short mEndCol = (short)Integer.parseInt(mergeData[3]);
							if(mStartCol <= mEndCol)
							{
								Region region = new Region(mStartRow+sTitleRow + startRow, mStartCol, mEndRow + sTitleRow + startRow,(short)Integer.parseInt(mergeData[3]));
								sheet.addMergedRegion(region); //영역 머지하기
							}
						}
					}

					if(!UserMerge.equals(""))
					{
						String[] Merges = UserMerge.split(" ");
						for (int iM = 0; iM < Merges.length; iM++)
						{
							String[] mergeData = Merges[iM].split(",");

							int mStartRow = Integer.parseInt(mergeData[0]);
							short mStartCol = (short)Integer.parseInt(mergeData[1]);
							int mEndRow = Integer.parseInt(mergeData[2]);
							short mEndCol = (short)Integer.parseInt(mergeData[3]);
							if(mStartCol <= mEndCol)
							{
								Region region = new Region(mStartRow, mStartCol, mStartRow + mEndRow - 1, (short)(mStartCol + mEndCol - 1));
								sheet.addMergedRegion(region); //영역 머지하기
							}
						}
					}

					// 컬럼폭 반영
					double cWidthRatio = 36.5764447695684;
					for (int iC = 0; iC < arrRecordType[0].length; iC++)
					{
						if(arrColVisibles[iC].equals("0"))
						{
							sheet.setColumnWidth(iC,0);
						}
						else
						{
							int width = (int)(cWidthRatio * Integer.parseInt("0"+arrColWidths[iC]) * SheetFontSize / 10 * 1.2); // 그리드 픽실과 엑셀픽셀을 맞춘 상태에서 폰트의 크기에 비례함
							if(width > 65280)
								width = 65280;
							sheet.setColumnWidth(iC, width);
						}
					}

					// set Report
					setReportColumnRowSize(reportData_, columnCount, sheet, rowNumber);

				}


				// report Label & BorderSet
				setReportLabelBorderSet(reportData_, palette, workbook, sheet);

				// report datapattern
				setReportDataDataPattern(reportData_, palette, workbook, row, cells, columnCount);

				rowNumber++;
			}

		} // sheet

		// 파일 다운로드 체크 쿠키 심기
		Cookie cookie = new Cookie("fileDownloadToken", downloadTokenValue);
		cookie.setPath("/");
		response.addCookie(cookie);

		//====================================================================================================
		// Client 로 전송합니다.
		//====================================================================================================
		out.clear();
		out = pageContext.pushBody();

		ServletOutputStream out2 = response.getOutputStream();
		workbook.write(out2);
		out2.flush();
	/*
	} catch(FileNotFoundException ex){
		System.out.println("FileNotFoundException : " + ex);
	} catch(IOException ioe){
		ioe.printStackTrace();
	} catch (Exception e) {
		e.printStackTrace();
	*/
	} catch (Error e) {
		out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetExcelSheetID].finishDownload(); targetWnd.Grids[targetWnd.gTargetExcelSheetID].ShowAlert('엑셀 다운로드중 에러가 발생하였습니다.', 'U');}catch(e){}</script>");

		e.printStackTrace();
	} finally {
	}
//fos.close();
%>

<%!

// 함수 추가
void cellWriteValue(HSSFWorkbook workbook, HSSFPalette palette, boolean SheetDesign, HSSFCell cell, int iC, String iData) throws Exception
{
	String iColor = "";
	if(iData.indexOf("\u0006")>-1)
	{
		iColor = iData.substring(iData.indexOf("\u0006")+1);
		iData = iData.substring(0,iData.indexOf("\u0006"));
		if(iColor.length()>=6)
		{
			HSSFCellStyle style = (HSSFCellStyle)workbook.createCellStyle(); 
			style.cloneStyleFrom(cell.getCellStyle()); 

			style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(iColor.substring(0,2),16), Integer.parseInt(iColor.substring(2,4),16), Integer.parseInt(iColor.substring(4,6),16)));

			cell.setCellStyle(style);
		}
	}

	cell.setCellValue(iData);
}

void cellWriteValueDate(HSSFWorkbook workbook, HSSFPalette palette, boolean SheetDesign, HSSFCell cell, int iC, String iData) throws Exception
{
	String iColor = "";
	if(iData.indexOf("\u0006")>-1)
	{
		iColor = iData.substring(iData.indexOf("\u0006")+1);
		iData = iData.substring(0,iData.indexOf("\u0006"));
		if(iColor.length()>=6)
		{
			HSSFCellStyle style = (HSSFCellStyle)workbook.createCellStyle(); 
			style.cloneStyleFrom(cell.getCellStyle()); 

			style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(iColor.substring(0,2),16), Integer.parseInt(iColor.substring(2,4),16), Integer.parseInt(iColor.substring(4,6),16)));

			cell.setCellStyle(style);
		}
	}

/*
	HSSFCellStyle cs = cell.getCellStyle();

	CreationHelper createHelper = workbook.getCreationHelper();

	cs.setDataFormat( createHelper.createDataFormat().getFormat(cs.getDataFormatString()) );
	cell.setCellStyle(cs);

	SimpleDateFormat df = new SimpleDateFormat(cs.getDataFormatString());
	
	HSSFCellStyle cs = workbook.createCellStyle(); 
*/

	HSSFCellStyle csori = (HSSFCellStyle)cell.getCellStyle();
	SimpleDateFormat df = new SimpleDateFormat(csori.getDataFormatString());

		
	if(!"".equals(iData)) {
		Date date;
		try {
			date = df.parse(iData);
			cell.setCellValue(date);
		} catch(Exception e) {
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);	// 2012-12-14 소계, 누계 때문에 ㅠㅠ
			cell.setCellValue(iData);
		}
	} else {
		cell.setCellValue("");
	}
}

void cellWriteValueNumeric(HSSFWorkbook workbook, HSSFPalette palette, boolean SheetDesign, HSSFCell cell, int iC, String iData) throws Exception
{
	String iColor = "";
	if(iData.indexOf("\u0006")>-1)
	{
		iColor = iData.substring(iData.indexOf("\u0006")+1);
		iData = iData.substring(0,iData.indexOf("\u0006"));
		if(iColor.length()>=6)
		{
			HSSFCellStyle style = (HSSFCellStyle)workbook.createCellStyle(); 
			style.cloneStyleFrom(cell.getCellStyle()); 

			style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(iColor.substring(0,2),16), Integer.parseInt(iColor.substring(2,4),16), Integer.parseInt(iColor.substring(4,6),16)));

			cell.setCellStyle(style);
		}
	}

	if(!"".equals(iData))
		cell.setCellValue(Double.parseDouble(replace(iData,",","")));
	else
		cell.setCellValue("");
}

void cellWriteValueText(HSSFWorkbook workbook, HSSFPalette palette, boolean SheetDesign,HSSFCell cell, int iC, String iData, String sTreeChar, String recordType, String recordOrgFormat) throws Exception
{

	String iColor = "";
	if(iData.indexOf("\u0006")>-1)
	{
		iColor = iData.substring(iData.indexOf("\u0006")+1);
		iData = iData.substring(0,iData.indexOf("\u0006"));

		if(iColor.length()>=6)
		{
			HSSFCellStyle style = (HSSFCellStyle)workbook.createCellStyle(); 
			style.cloneStyleFrom(cell.getCellStyle()); 

			style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(iColor.substring(0,2),16), Integer.parseInt(iColor.substring(2,4),16), Integer.parseInt(iColor.substring(4,6),16)));

			cell.setCellStyle(style);
		}
	}
/*
	if(recordType.equals("Text") && "Ym".indexOf(recordOrgFormat)>-1)
	{
		iData = iData.replaceAll("\\.","-");
	}
*/
	iData = replace(iData, "\r\n", "\n");
	iData = replace(iData, "\u0001", sTreeChar);

	cell.setCellValue(iData);
}

short getColorIndex(HSSFPalette pallete, int R, int G, int B) throws Exception
{
	HSSFColor color = pallete.findSimilarColor((byte)R, (byte)G, (byte)B);
	if(color==null)
	{
		return HSSFColor.WHITE.index;
	}
	else
	{
		return color.getIndex();
	}
}


void drawImage(HSSFSheet sheet, HSSFWorkbook wb, String sWebRoot, int R, int C, String BaseDir, String url ) throws IOException
{
	File f = null;
	int result = 0;

	String ImageFilePath = "";

	if(url.indexOf("\u0006")>-1)
	{
		url = url.substring(0,url.indexOf("\u0006"));
	}


	if("http".equals((url+"    ").substring(0,4)))
	{
		url = url.substring(url.indexOf("://")+3);
		url = url.substring(url.indexOf("/"));
	}

	if("/".equals((url+" ").substring(0,1)))
	{
		url = sWebRoot + url;
	    ImageFilePath = url;
	}
	else
	{
	    ImageFilePath = BaseDir+url;
	}

	f = new File(ImageFilePath);

	if(f!=null)
	{
		if(f.length()>0)
		{

			HSSFPatriarch patriarch = (HSSFPatriarch)sheet.createDrawingPatriarch();
			HSSFClientAnchor anchor;
			anchor = new HSSFClientAnchor(15,15,0,200,(short)C,(R-1),(short)(C+1),(R-1)); // 이미지 크기조절은 여기서..
			anchor.setAnchorType( 2 );
			try{
				patriarch.createPicture(anchor, loadPicture(ImageFilePath, wb )); // 삽입 할 이미지
			}catch(FileNotFoundException e){}
		}
	}


}


static int loadPicture( String path, HSSFWorkbook wb ) throws IOException
{
	int pictureIndex=-1;
	FileInputStream fis = null;
	ByteArrayOutputStream bos = null;

	try {
		fis = new FileInputStream(path);
		bos = new ByteArrayOutputStream( );
		int c;
		while ( (c = fis.read()) != -1) {
			bos.write( c );
		}
		pictureIndex = wb.addPicture( bos.toByteArray(), HSSFWorkbook.PICTURE_TYPE_JPEG  );
	} finally {
		if (fis != null) fis.close();
		if (bos != null) bos.close();
	}
	return pictureIndex;
}

String getPropValue(String Header, String prop) throws Exception
{
	int findS = 0;
	int findE = 0;

	findS = Header.indexOf("<"+prop+">");
	findE = Header.indexOf("</"+prop+">");

	if(findS != -1 && findE != -1) return Header.substring(findS+prop.length()+2,findE);		// 시작 태그를 제외하고 데이타만 리턴해줌
	else return "";
}

void SetDefaultStyle(String RowType, String DataType, String DataOrgFormat, String DataFormat, HSSFCellStyle istyle, String align, HSSFDataFormat df, HSSFFont font, int SheetDesign, int SheetFontSize, String SheetFontName, int BgColorIndex, String defaultFontName, short defaultFontSize, ReportData reportData, HSSFPalette palette, String TextToGeneral, String WordWrap)
{
	// 외곽선
	if(!(RowType.equals("TITLE") || SheetDesign == 2))
	{
		istyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		istyle.setBottomBorderColor(HSSFColor.BLACK.index);
		istyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		istyle.setLeftBorderColor(HSSFColor.BLACK.index);
		istyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		istyle.setRightBorderColor(HSSFColor.BLACK.index);
		istyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		istyle.setTopBorderColor(HSSFColor.BLACK.index);
	}

	// 워드랩
	if(WordWrap.equals("1") || WordWrap.equals(""))
		istyle.setWrapText(true);

	// 세로정렬
	istyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

	if(SheetDesign==1 || SheetDesign==2)
	{
		if(SheetFontSize>0)
		{
			font.setFontHeightInPoints((short)SheetFontSize);
		}
		if(!SheetFontName.equals(""))
		{
			font.setFontName(SheetFontName);
		}

		if(!RowType.equals("TITLE"))
		{
			istyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			istyle.setFillForegroundColor((short)BgColorIndex);
		}
		istyle.setFont(font);
	}
	else
	{
		font.setFontHeightInPoints(defaultFontSize);
		font.setFontName(defaultFontName);
		istyle.setFont(font);
	}

	if(reportData != null)
	{
		setFont(palette, font, reportData.DefaultFont);
	}

	// 기본 정렬, 기본 서식
	if(RowType.equals("HEAD") || RowType.equals("TITLE"))
	{
		istyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		istyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("@"));
	}
	else
	{
		if("left".equals(align.toLowerCase()))
			istyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		else if("center".equals(align.toLowerCase()))
			istyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		else if("right".equals(align.toLowerCase()))
			istyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		else
			istyle.setAlignment(HSSFCellStyle.ALIGN_JUSTIFY);
		//styleSum.setDataFormat(HSSFDataFormat.getBuiltinFormat("@"));
	}

	// 컬럼별 서식
	if(!RowType.equals("HEAD"))
	{
		// 숫자 계산만 오른쪽 정렬하기 (AutoSum|AutoAvg|Int|Float)
		if("|AutoSum|AutoAvg|Int|Float|Integer|".indexOf("|"+DataType+"|")>-1 || "|Integer|Int|NullInteger|Float|NullFloat|".indexOf("|"+DataOrgFormat+"|")>-1)
		{
			istyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		}

		// Integer 등의 포맷이 지원타입이 아닌 곳에서 선언된 경우 무시
		if("|Integer|NullInteger|Float|NullFloat|Int|".indexOf("|"+DataOrgFormat+"|")>-1)
		{
			if("|AutoSum|AutoAvg|Int|Float|Integer|".indexOf("|"+DataType+"|")==-1)
			{
				DataFormat = "";
			}
		}

		// 2013-01-10 전화번호, Number 포맷은 포맷을 적용하지 말자
		if(DataType.equals("Text") && ("PhoneNo".equals(DataFormat) || "Number".equals(DataFormat)))
		{
			DataFormat = "";
		}

		// 컬럼별 서식 설정하기
		if(DataType.equals("Date"))
		{
			istyle.setDataFormat(df.getFormat(replace(DataFormat, "h", "H")));
//			istyle.setDataFormat(df.getFormat(DataFormat.replaceAll("\\/","-").replaceAll("\\.","-")));
//			istyle.setDataFormat(df.getFormat("yyyy-mm-dd"));
		}
		else if(DataFormat.equals("")) //포맷 없으면 모두 텍스트 서식
		{
			/*if("|Text|ImageText|".indexOf("|"+DataType+"|")>-1)
			{
				istyle.setDataFormat(df.getBuiltinFormat("text")); // @ 또는 text
			} else {
				istyle.setDataFormat(df.getBuiltinFormat("")); // @ 또는 text
			}*/
			//istyle.setDataFormat(df.getBuiltinFormat("@")); // @ 또는 textDataType

			if(DataType.equals("Text") && TextToGeneral.equals("1"))
			{
				istyle.setDataFormat(df.getBuiltinFormat("")); // 일반
			} else if(DataType.equals("Text")) {
				istyle.setDataFormat(df.getBuiltinFormat("text")); // 일반
			} else {
				istyle.setDataFormat(df.getBuiltinFormat("")); // 일반
			}
		}
		else if(!DataFormat.equals("")) //포맷 적용
		{
			DataFormat = replace(DataFormat,"*","#");
			DataFormat = replace(DataFormat,"#.","0.");
			DataFormat = replace(DataFormat,"0.#","0.0");
			if("#".equals(DataFormat.substring(DataFormat.length()-1)))
			{
				if(DataFormat.indexOf(".")==-1)
				{
					DataFormat = DataFormat.substring(0,DataFormat.length()-1)+"0";
				}
			}
			istyle.setDataFormat(df.getFormat(DataFormat)); //편집후포맷
		}


	}
}

String replace(String sStrString, String sStrOld, String sStrNew)
{
	if (sStrString == null)return null;

	for (int iIndex = 0 ; (iIndex = sStrString.indexOf(sStrOld, iIndex)) >= 0 ; iIndex += sStrNew.length())
	sStrString = sStrString.substring(0, iIndex) + sStrNew + sStrString.substring(iIndex + sStrOld.length());
	return sStrString;
}

///////// Report

class ReportData
{
	String StartRow = "";
	String ViewCols = "";
	String Data = "";
	String PaperSize = "";
	String Orientation = "";
	String Margins_Top = "";
	String Margins_Header = "";
	String Margins_Left = "";
	String Margins_Right = "";
	String Margins_Bottom = "";
	String Margins_Footer = "";
	String Adjust = "";
	String Adjust_value = "";
	String Fit = "";
	String Fit_Height = "";
	String Fit_Width = "";
	String CenterOnPage_Horizontal = "";
	String CenterOnPage_Vertical = "";
	String RowsRepeat_Row1 = "";
	String RowsRepeat_Row2 = "";
	String ColsRepeat_Col1 = "";
	String ColsRepeat_Col2 = "";
	String DefaultRowHeight = "";

	Font DefaultFont = new Font();

	String Header_Left_Text = "";
	String Header_Center_Text = "";
	String Header_Right_Text = "";

	String Footer_Left_Text = "";
	String Footer_Center_Text = "";
	String Footer_Right_Text = "";

	Font Header_Left_Font = new Font();
	Font Header_Center_Font = new Font();
	Font Header_Right_Font = new Font();
	Font Footer_Left_Font = new Font();
	Font Footer_Center_Font = new Font();
	Font Footer_Right_Font = new Font();

	ArrayList reportColumnWidth = new ArrayList();
	ArrayList reportRowHeight = new ArrayList();
	ArrayList labels = new ArrayList();
}


class ColumnWidth
{
	String col1 = "";
	String col2 = "";
	String size = "";
}
class RowHeight
{
	String row1 = "";
	String row2 = "";
	String size = "";
}
class Font
{
	String Name = "";
	String Bold = "";
	String Size = "";
	String Color = "";
	String Italic = "";
	String UnderLine = "";
	String Strikethrough = "";
	String Superscript = "";
	String Subscript = "";
}

class Label
{
	String type = "";
	String SheetCol = "";
	String Word = "";
	String Range_row1 = "";
	String Range_row2 = "";
	String Range_col1 = "";
	String Range_col2 = "";
	String RowHeight = "";
	String Merge = "";
	String Alignment_Horizontal = "";
	String Alignment_Vertical = "";
	String BackColor = "";
	String Pattern = "";
	String PatternColor = "";
	String IndentLevel = "";
	String Orientation = "";
	String WrapText = "";
	String NumberFormatLocal = "";
	String InputText = "";
	String TopEdge_Style = "";
	String BottomEdge_Style = "";
	String LeftEdge_Style = "";
	String RightEdge_Style = "";
	String InVertical_Style = "";
	String InHorizontal_Style = "";
	String TopEdge_Weight = "";
	String BottomEdge_Weight = "";
	String LeftEdge_Weight = "";
	String RightEdge_Weight = "";
	String InVertical_Weight = "";
	String InHorizontal_Weight = "";
	String TopEdge_Color = "";
	String BottomEdge_Color = "";
	String LeftEdge_Color = "";
	String RightEdge_Color = "";
	String InVertical_Color = "";
	String InHorizontal_Color = "";
	Font font = new Font();
}


short getBorderStyle(String style, String weight)
{
	short retval = 0;

	if(style != null)
		style = style.toLowerCase();

	if(weight != null)
		weight = weight.toLowerCase();

	if("none".equals(style) && "".equals(weight))
		retval = HSSFCellStyle.BORDER_NONE;
	else if("continuous".equals(style) && "hairline".equals(weight))
		retval = HSSFCellStyle.BORDER_DOTTED;
	else if("dot".equals(style) && "thin".equals(weight))
		retval = HSSFCellStyle.BORDER_HAIR;
	else if("dashdotdot".equals(style) && "thin".equals(weight))
		retval = HSSFCellStyle.BORDER_DASH_DOT_DOT;
	else if("dashdot".equals(style) && "thin".equals(weight))
		retval = HSSFCellStyle.BORDER_DASH_DOT;
	else if("dash".equals(style) && "thin".equals(weight))
		retval = HSSFCellStyle.BORDER_DASHED;
	else if("continuous".equals(style) && "thin".equals(weight))
		retval = HSSFCellStyle.BORDER_THIN;
	else if("dashdotdot".equals(style) && "xlmedium".equals(weight))
		retval = HSSFCellStyle.BORDER_MEDIUM_DASH_DOT_DOT;
	else if("slantdashdot".equals(style) && "xlmedium".equals(weight))
		retval = HSSFCellStyle.BORDER_SLANTED_DASH_DOT;
	else if("dashdot".equals(style) && "xlmedium".equals(weight))
		retval = HSSFCellStyle.BORDER_MEDIUM_DASH_DOT;
	else if("dash".equals(style) && "xlmedium".equals(weight))
		retval = HSSFCellStyle.BORDER_MEDIUM_DASHED;
	else if("continuous".equals(style) && "xlmedium".equals(weight))
		retval = HSSFCellStyle.BORDER_MEDIUM;
	else if("continuous".equals(style) && "thick".equals(weight))
		retval = HSSFCellStyle.BORDER_THICK;
	else if("double".equals(style) && "thick".equals(weight))
		retval = HSSFCellStyle.BORDER_DOUBLE;

	return retval;
}

short getFillPattern(String pattern)
{
	short retval = 0;

	if(pattern != null)
		pattern = pattern.toLowerCase();

	if("xlsolid".equals(pattern))
		retval = 1;
	else if("xlgray75".equals(pattern))
		retval = 3;
	else if("xlgray50".equals(pattern))
		retval = 2;
	else if("xlgray25".equals(pattern))
		retval = 4;
	else if("xlgray16".equals(pattern))
		retval = 17;
	else if("xlgray8".equals(pattern))
		retval = 18;
	else if("xlhorizontal".equals(pattern))
		retval = 5;
	else if("xlvertical".equals(pattern))
		retval = 6;
	else if("xldown".equals(pattern))
		retval = 7;
	else if("xlup".equals(pattern))
		retval = 8;
	else if("xlchecker".equals(pattern))
		retval = 9;
	else if("xlsemigray75".equals(pattern))
		retval = 10;
	else if("xllighthorizontal".equals(pattern))
		retval = 11;
	else if("xllightvertical".equals(pattern))
		retval = 12;
	else if("xllightdown".equals(pattern))
		retval = 13;
	else if("xllightup".equals(pattern))
		retval = 14;
	else if("xlgrid".equals(pattern))
		retval = 15;
	else if("xlcrisscross".equals(pattern))
		retval = 16;

	return retval;
}

String getHeaderFooterStr(String text, Font font)
{
	String pre = "";
	String suf = "";

	if("".equals(text))
		return "";

	if(!"".equals(font.Name))
	{
		if("true".equals(font.Italic.toLowerCase()))
			pre += HSSFHeader.font(font.Name, "italic");
		else
			pre += HSSFHeader.font(font.Name, "");
	} else if("true".equals(font.Italic.toLowerCase())) {
		pre += HSSFHeader.font("", "italic");
	}
	if(!"".equals(font.Size))
	{
		pre += HSSFHeader.fontSize((short) Integer.parseInt(font.Size));
	}
	if("true".equals(font.Bold.toLowerCase()))
	{
		pre += HSSFHeader.startBold();
		suf += HSSFHeader.endBold();
	}
	if("single".equals(font.UnderLine.toLowerCase()))
	{
		pre += HSSFHeader.startUnderline();
		suf += HSSFHeader.endUnderline();
	} else if("double".equals(font.UnderLine.toLowerCase()))
	{
		pre += HSSFHeader.startDoubleUnderline();
		suf += HSSFHeader.endDoubleUnderline();
	}

	return pre + text + suf;
}

short paletteIndex_ = 65;

void setFont(HSSFPalette palette, HSSFFont font, Font fontdata)
{
//	System.out.println("paletteIndex_ : " + paletteIndex_);
	if(!"".equals(fontdata.Name.toLowerCase()))
		font.setFontName(fontdata.Name);
	if(!"".equals(fontdata.Size))
		font.setFontHeightInPoints((short)Integer.parseInt(fontdata.Size)); //폰트 크기
	if("true".equals(fontdata.Bold.toLowerCase()))
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD); //폰트 굵게
	if(!"".equals(fontdata.Color))
	{
		String color[] = fontdata.Color.split(",");
		palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(color[0]), (byte)Integer.parseInt(color[1]), (byte)Integer.parseInt(color[2]));
		try {
			font.setColor( getColorIndex(palette, Integer.parseInt(color[0]), Integer.parseInt(color[1]), Integer.parseInt(color[2])) );
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	if("true".equals(fontdata.Italic.toLowerCase()))
		font.setItalic(true);
	if("true".equals(fontdata.Strikethrough.toLowerCase()))
		font.setStrikeout(true);
	if("single".equals(fontdata.UnderLine.toLowerCase()))
		font.setUnderline(HSSFFont.U_SINGLE);
	else if("double".equals(fontdata.UnderLine.toLowerCase()))
		font.setUnderline(HSSFFont.U_DOUBLE);
	if("true".equals(fontdata.Superscript.toLowerCase()))
		font.setTypeOffset(HSSFFont.SS_SUPER);
	if("true".equals(fontdata.Subscript.toLowerCase()))
		font.setTypeOffset(HSSFFont.SS_SUB);
}

String getAttrValue(Element ele, String name)
{
	String retVal = "";
	retVal = ele.attributeValue(name);
	return retVal == null ? "" : retVal;
}

String getElementText(Element ele, String name)
{
	String retVal = "";
	retVal = ele.elementText(name);
	return retVal == null ? "" : retVal;
}

ReportData getReportData(String reportURL)
{
	ReportData reportData = new ReportData();

	try {
		URL url = new URL(reportURL);
		SAXReader reader = new SAXReader();
		Document document = reader.read(url);
		//Document document = DocumentHelper.parseText(ReportXML);

		Element RootElement = document.getRootElement();

		for (Iterator i1 = RootElement.elementIterator("IBSheetSet"); i1.hasNext();)
		{
			Element PageSet = (Element) i1.next();
			reportData.StartRow  = getElementText(PageSet, "StartRow");
			reportData.ViewCols  = getElementText(PageSet, "ViewCols");
			reportData.Data  = getElementText(PageSet, "Data");
		}

		for (Iterator i1 = RootElement.elementIterator("PageSet"); i1.hasNext();)
		{
			Element PageSet = (Element) i1.next();
			reportData.PaperSize  = getElementText(PageSet, "PaperSize");
			reportData.Orientation  = getElementText(PageSet, "Orientation");
			reportData.DefaultRowHeight  = getElementText(PageSet, "DefaultRowHeight");

			for (Iterator i2 = PageSet.elementIterator("Margins"); i2.hasNext();)
			{
				Element ele = (Element) i2.next();
				reportData.Margins_Header	= getAttrValue(ele, "Header");
				reportData.Margins_Footer	= getAttrValue(ele, "Footer");
				reportData.Margins_Top		= getAttrValue(ele, "Top");
				reportData.Margins_Bottom	= getAttrValue(ele, "Bottom");
				reportData.Margins_Left		= getAttrValue(ele, "Left");
				reportData.Margins_Right	= getAttrValue(ele, "Right");
			}

			for (Iterator i2 = PageSet.elementIterator("Scaling"); i2.hasNext();)
			{
				Element Scaling = (Element) i2.next();
				reportData.Adjust  = getElementText(Scaling, "Adjust");
				reportData.Fit  = getElementText(Scaling, "Fit");
				for (Iterator i3 = Scaling.elementIterator("Adjust"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Adjust_value	= getAttrValue(ele, "Value");
				}
				for (Iterator i3 = Scaling.elementIterator("Fit"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Fit_Height	= getAttrValue(ele, "Height");
					reportData.Fit_Width	= getAttrValue(ele, "Width");
				}
			}
			for (Iterator i2 = PageSet.elementIterator("CenterOnPage"); i2.hasNext();)
			{
				Element ele = (Element) i2.next();
				reportData.CenterOnPage_Horizontal	= getAttrValue(ele, "Horizontal");
				reportData.CenterOnPage_Vertical	= getAttrValue(ele, "Vertical");
			}
			for (Iterator i2 = PageSet.elementIterator("RowsRepeat"); i2.hasNext();)
			{
				Element ele = (Element) i2.next();
				reportData.RowsRepeat_Row1 = getAttrValue(ele, "Row1");
				reportData.RowsRepeat_Row2 = getAttrValue(ele, "Row2");
			}
			for (Iterator i2 = PageSet.elementIterator("ColsRepeat"); i2.hasNext();)
			{
				Element ele = (Element) i2.next();
				reportData.ColsRepeat_Col1 = getAttrValue(ele, "Col1");
				reportData.ColsRepeat_Col2 = getAttrValue(ele, "Col2");
			}
			for (Iterator i2 = PageSet.elementIterator("DefaultFont"); i2.hasNext();)
			{
				Element ele = (Element) i2.next();
				reportData.DefaultFont.Name	= getAttrValue(ele, "Name");
				reportData.DefaultFont.Bold	= getAttrValue(ele, "Bold");
				reportData.DefaultFont.Italic	= getAttrValue(ele, "Italic");
				reportData.DefaultFont.Size	= getAttrValue(ele, "size");
				reportData.DefaultFont.UnderLine	= getAttrValue(ele, "UnderLine");
				reportData.DefaultFont.Strikethrough	= getAttrValue(ele, "Strikethrough");
				reportData.DefaultFont.Superscript	= getAttrValue(ele, "Superscript");
				reportData.DefaultFont.Subscript	= getAttrValue(ele, "Subscript");
				reportData.DefaultFont.Color	= getAttrValue(ele, "Color");
			}
		}
		if("".equals(reportData.RowsRepeat_Row1))
			reportData.RowsRepeat_Row1 = "-1";
		if("".equals(reportData.RowsRepeat_Row2))
			reportData.RowsRepeat_Row2 = "-1";
		if("".equals(reportData.ColsRepeat_Col1))
			reportData.ColsRepeat_Col1 = "-1";
		if("".equals(reportData.ColsRepeat_Col2))
			reportData.ColsRepeat_Col2 = "-1";

		int idx = 0;
		for (Iterator i1 = RootElement.elementIterator("ColumnWidth"); i1.hasNext();)
		{
			ColumnWidth cw = new ColumnWidth();

			Element ColumnWidth = (Element) i1.next();
			cw.size = ColumnWidth.getText();
			cw.col1 = getAttrValue(ColumnWidth, "Col1");
			cw.col2 = getAttrValue(ColumnWidth, "Col2");
			reportData.reportColumnWidth.add(idx++, cw);
			ColumnWidth cws = (ColumnWidth)reportData.reportColumnWidth.get(idx-1);
		}

		for (Iterator i1 = RootElement.elementIterator("RowHeight"); i1.hasNext();)
		{
			RowHeight rh = new RowHeight();

			Element RowHeight = (Element) i1.next();
			rh.size = RowHeight.getText();
			rh.row1 = getAttrValue(RowHeight, "Row1");
			rh.row2 = getAttrValue(RowHeight, "Row2");
			reportData.reportRowHeight.add(rh);
		}

		for (Iterator i1 = RootElement.elementIterator("CustomHeader"); i1.hasNext();)
		{
			Element CustomHeader = (Element) i1.next();
			for (Iterator i2 = CustomHeader.elementIterator("LeftSection"); i2.hasNext();)
			{
				Element Section = (Element) i2.next();
				for (Iterator i3 = Section.elementIterator("Font"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Header_Left_Font.Name = getAttrValue(ele, "Name");
					reportData.Header_Left_Font.Size = getAttrValue(ele, "Size");
					reportData.Header_Left_Font.Bold = getAttrValue(ele, "Bold");
					reportData.Header_Left_Font.Italic = getAttrValue(ele, "Italic");
					reportData.Header_Left_Font.UnderLine = getAttrValue(ele, "UnderLine");
				}
				for (Iterator i3 = Section.elementIterator("InputText"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Header_Left_Text = ele.getText();
				}
			}
			for (Iterator i2 = CustomHeader.elementIterator("CenterSection"); i2.hasNext();)
			{
				Element Section = (Element) i2.next();
				for (Iterator i3 = Section.elementIterator("Font"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Header_Center_Font.Name = getAttrValue(ele, "Name");
					reportData.Header_Center_Font.Size = getAttrValue(ele, "Size");
					reportData.Header_Center_Font.Bold = getAttrValue(ele, "Bold");
					reportData.Header_Center_Font.Italic = getAttrValue(ele, "Italic");
					reportData.Header_Center_Font.UnderLine = getAttrValue(ele, "UnderLine");
				}
				for (Iterator i3 = Section.elementIterator("InputText"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Header_Center_Text = ele.getText();
				}
			}
			for (Iterator i2 = CustomHeader.elementIterator("RightSection"); i2.hasNext();)
			{
				Element Section = (Element) i2.next();
				for (Iterator i3 = Section.elementIterator("Font"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Header_Right_Font.Name = getAttrValue(ele, "Name");
					reportData.Header_Right_Font.Size = getAttrValue(ele, "Size");
					reportData.Header_Right_Font.Bold = getAttrValue(ele, "Bold");
					reportData.Header_Right_Font.Italic = getAttrValue(ele, "Italic");
					reportData.Header_Right_Font.UnderLine = getAttrValue(ele, "UnderLine");
				}
				for (Iterator i3 = Section.elementIterator("InputText"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Header_Right_Text = ele.getText();
				}
			}
		}

		for (Iterator i1 = RootElement.elementIterator("CustomFooter"); i1.hasNext();)
		{
			Element CustomFooter = (Element) i1.next();
			for (Iterator i2 = CustomFooter.elementIterator("LeftSection"); i2.hasNext();)
			{
				Element Section = (Element) i2.next();
				for (Iterator i3 = Section.elementIterator("Font"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Footer_Left_Font.Name = getAttrValue(ele, "Name");
					reportData.Footer_Left_Font.Size = getAttrValue(ele, "Size");
					reportData.Footer_Left_Font.Bold = getAttrValue(ele, "Bold");
					reportData.Footer_Left_Font.Italic = getAttrValue(ele, "Italic");
					reportData.Footer_Left_Font.UnderLine = getAttrValue(ele, "UnderLine");
				}
				for (Iterator i3 = Section.elementIterator("InputText"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Footer_Left_Text = ele.getText();
				}
			}
			for (Iterator i2 = CustomFooter.elementIterator("CenterSection"); i2.hasNext();)
			{
				Element Section = (Element) i2.next();
				for (Iterator i3 = Section.elementIterator("Font"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Footer_Center_Font.Name = getAttrValue(ele, "Name");
					reportData.Footer_Center_Font.Size = getAttrValue(ele, "Size");
					reportData.Footer_Center_Font.Bold = getAttrValue(ele, "Bold");
					reportData.Footer_Center_Font.Italic = getAttrValue(ele, "Italic");
					reportData.Footer_Center_Font.UnderLine = getAttrValue(ele, "UnderLine");
				}
				for (Iterator i3 = Section.elementIterator("InputText"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Footer_Center_Text = ele.getText();
				}
			}
			for (Iterator i2 = CustomFooter.elementIterator("RightSection"); i2.hasNext();)
			{
				Element Section = (Element) i2.next();
				for (Iterator i3 = Section.elementIterator("Font"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Footer_Right_Font.Name = getAttrValue(ele, "Name");
					reportData.Footer_Right_Font.Size = getAttrValue(ele, "Size");
					reportData.Footer_Right_Font.Bold = getAttrValue(ele, "Bold");
					reportData.Footer_Right_Font.Italic = getAttrValue(ele, "Italic");
					reportData.Footer_Right_Font.UnderLine = getAttrValue(ele, "UnderLine");
				}
				for (Iterator i3 = Section.elementIterator("InputText"); i3.hasNext();)
				{
					Element ele = (Element) i3.next();
					reportData.Footer_Right_Text = ele.getText();
				}
			}
		}

		for (Iterator i1 = RootElement.elementIterator("Label"); i1.hasNext();)
		{
			Element Ranges = (Element) i1.next();
			for (Iterator i2 = Ranges.elementIterator("Range"); i2.hasNext();)
			{
				Label label = new Label();
				label.type = "Label";

				Element Range = (Element) i2.next();

				label.Range_row1 = getAttrValue(Range, "Row1");
				label.Range_row2 = getAttrValue(Range, "Row2");
				label.Range_col1 = getAttrValue(Range, "Col1");
				label.Range_col2 = getAttrValue(Range, "Col2");
				label.RowHeight  = getAttrValue(Range, "RowHeight");
				label.InputText  = getElementText(Range, "InputText");

				for (Iterator i3 = Range.elementIterator("CellFormat"); i3.hasNext();)
				{
					Element CellFormat = (Element) i3.next();
					label.Merge = getElementText(CellFormat, "Merge");
					for (Iterator i4 = CellFormat.elementIterator("Alignment"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.Alignment_Horizontal	= getAttrValue(ele, "Horizontal");
						label.Alignment_Vertical	= getAttrValue(ele, "Vertical");
					}
					for (Iterator i4 = CellFormat.elementIterator("Interior"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.BackColor		= getAttrValue(ele, "BackColor");
						label.Pattern		= getAttrValue(ele, "Pattern");
						label.PatternColor	= getAttrValue(ele, "PatternColor");
					}
					for (Iterator i4 = CellFormat.elementIterator("Font"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.font.Name			 = getAttrValue(ele, "Name");
						label.font.Bold			 = getAttrValue(ele, "Bold");
						label.font.Size			 = getAttrValue(ele, "Size");
						label.font.Color		 = getAttrValue(ele, "Color");
						label.font.Italic		 = getAttrValue(ele, "Italic");
						label.font.UnderLine	 = getAttrValue(ele, "UnderLine");
						label.font.Strikethrough = getAttrValue(ele, "Strikethrough");
						label.font.Superscript	 = getAttrValue(ele, "Superscript");
						label.font.Subscript	 = getAttrValue(ele, "Subscript");
					}
					for (Iterator i4 = CellFormat.elementIterator("Format"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.IndentLevel		= getAttrValue(ele, "IndentLevel");
						label.Orientation		= getAttrValue(ele, "Orientation");
						label.WrapText			= getAttrValue(ele, "WrapText");
						label.NumberFormatLocal = getAttrValue(ele, "NumberFormatLocal");
					}
				}

				for (Iterator i3 = Range.elementIterator("BorderStyle"); i3.hasNext();)
				{
					Element CellFormat = (Element) i3.next();
					for (Iterator i4 = CellFormat.elementIterator("TopEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.TopEdge_Style  = getAttrValue(ele, "Style");
						label.TopEdge_Color  = getAttrValue(ele, "Color");
						label.TopEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("BottomEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.BottomEdge_Style  = getAttrValue(ele, "Style");
						label.BottomEdge_Color  = getAttrValue(ele, "Color");
						label.BottomEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("LeftEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.LeftEdge_Style  = getAttrValue(ele, "Style");
						label.LeftEdge_Color  = getAttrValue(ele, "Color");
						label.LeftEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("RightEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.RightEdge_Style  = getAttrValue(ele, "Style");
						label.RightEdge_Color  = getAttrValue(ele, "Color");
						label.RightEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("InVertical"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.InVertical_Style  = getAttrValue(ele, "Style");
						label.InVertical_Color  = getAttrValue(ele, "Color");
						label.InVertical_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("InHorizontal"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.InHorizontal_Style  = getAttrValue(ele, "Style");
						label.InHorizontal_Color  = getAttrValue(ele, "Color");
						label.InHorizontal_Weight = getAttrValue(ele, "Weight");
					}
				}

				reportData.labels.add(label);
			}
		}
		for (Iterator i1 = RootElement.elementIterator("BorderSet"); i1.hasNext();)
		{
			Element Ranges = (Element) i1.next();
			for (Iterator i2 = Ranges.elementIterator("Range"); i2.hasNext();)
			{
				Label label = new Label();
				label.type = "BorderSet";

				Element Range = (Element) i2.next();

				label.Range_row1 = getAttrValue(Range, "Row1");
				label.Range_row2 = getAttrValue(Range, "Row2");
				label.Range_col1 = getAttrValue(Range, "Col1");
				label.Range_col2 = getAttrValue(Range, "Col2");
				label.RowHeight  = getAttrValue(Range, "RowHeight");
				label.InputText  = getElementText(Range, "InputText");

				for (Iterator i3 = Range.elementIterator("CellFormat"); i3.hasNext();)
				{
					Element CellFormat = (Element) i3.next();
					label.Merge = getElementText(CellFormat, "Merge");
					for (Iterator i4 = CellFormat.elementIterator("Alignment"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.Alignment_Horizontal	= getAttrValue(ele, "Horizontal");
						label.Alignment_Vertical	= getAttrValue(ele, "Vertical");
					}
					for (Iterator i4 = CellFormat.elementIterator("Interior"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.BackColor		= getAttrValue(ele, "BackColor");
						label.Pattern		= getAttrValue(ele, "Pattern");
						label.PatternColor	= getAttrValue(ele, "PatternColor");
					}
					for (Iterator i4 = CellFormat.elementIterator("Font"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.font.Name			 = getAttrValue(ele, "Name");
						label.font.Bold			 = getAttrValue(ele, "Bold");
						label.font.Size			 = getAttrValue(ele, "Size");
						label.font.Color		 = getAttrValue(ele, "Color");
						label.font.Italic		 = getAttrValue(ele, "Italic");
						label.font.UnderLine	 = getAttrValue(ele, "UnderLine");
						label.font.Strikethrough = getAttrValue(ele, "Strikethrough");
						label.font.Superscript	 = getAttrValue(ele, "Superscript");
						label.font.Subscript	 = getAttrValue(ele, "Subscript");
					}
					for (Iterator i4 = CellFormat.elementIterator("Format"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.IndentLevel		= getAttrValue(ele, "IndentLevel");
						label.Orientation		= getAttrValue(ele, "Orientation");
						label.WrapText			= getAttrValue(ele, "WrapText");
						label.NumberFormatLocal = getAttrValue(ele, "NumberFormatLocal");
					}
				}

				for (Iterator i3 = Range.elementIterator("BorderStyle"); i3.hasNext();)
				{
					Element CellFormat = (Element) i3.next();
					for (Iterator i4 = CellFormat.elementIterator("TopEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.TopEdge_Style  = getAttrValue(ele, "Style");
						label.TopEdge_Color  = getAttrValue(ele, "Color");
						label.TopEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("BottomEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.BottomEdge_Style  = getAttrValue(ele, "Style");
						label.BottomEdge_Color  = getAttrValue(ele, "Color");
						label.BottomEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("LeftEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.LeftEdge_Style  = getAttrValue(ele, "Style");
						label.LeftEdge_Color  = getAttrValue(ele, "Color");
						label.LeftEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("RightEdge"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.RightEdge_Style  = getAttrValue(ele, "Style");
						label.RightEdge_Color  = getAttrValue(ele, "Color");
						label.RightEdge_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("InVertical"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.InVertical_Style  = getAttrValue(ele, "Style");
						label.InVertical_Color  = getAttrValue(ele, "Color");
						label.InVertical_Weight = getAttrValue(ele, "Weight");
					}
					for (Iterator i4 = CellFormat.elementIterator("InHorizontal"); i4.hasNext();)
					{
						Element ele = (Element) i4.next();
						label.InHorizontal_Style  = getAttrValue(ele, "Style");
						label.InHorizontal_Color  = getAttrValue(ele, "Color");
						label.InHorizontal_Weight = getAttrValue(ele, "Weight");
					}
				}

				reportData.labels.add(label);
			}
		}

		for (Iterator i0 = RootElement.elementIterator("DataPattern"); i0.hasNext();)
		{
			Element DataPattern = (Element) i0.next();
			for (Iterator i1 = DataPattern.elementIterator("Standard"); i1.hasNext();)
			{
				Element Standard = (Element) i1.next();

				Label label = new Label();
				label.type = "DataPattern";
				label.SheetCol = getAttrValue(Standard, "SheetCol");
				label.Word = getAttrValue(Standard, "Word");

				for (Iterator i2 = Standard.elementIterator("Range"); i2.hasNext();)
				{
					Element Range = (Element) i2.next();

					label.Range_row1 = getAttrValue(Range, "Row1");
					label.Range_row2 = getAttrValue(Range, "Row2");
					label.Range_col1 = getAttrValue(Range, "Col1");
					label.Range_col2 = getAttrValue(Range, "Col2");
					label.RowHeight  = getAttrValue(Range, "RowHeight");
					label.InputText  = getElementText(Range, "InputText");

					for (Iterator i3 = Range.elementIterator("CellFormat"); i3.hasNext();)
					{
						Element CellFormat = (Element) i3.next();
						label.Merge = getElementText(CellFormat, "Merge");
						for (Iterator i4 = CellFormat.elementIterator("Alignment"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.Alignment_Horizontal	= getAttrValue(ele, "Horizontal");
							label.Alignment_Vertical	= getAttrValue(ele, "Vertical");
						}
						for (Iterator i4 = CellFormat.elementIterator("Interior"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.BackColor		= getAttrValue(ele, "BackColor");
							label.Pattern		= getAttrValue(ele, "Pattern");
							label.PatternColor	= getAttrValue(ele, "PatternColor");
						}
						for (Iterator i4 = CellFormat.elementIterator("Font"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.font.Name			 = getAttrValue(ele, "Name");
							label.font.Bold			 = getAttrValue(ele, "Bold");
							label.font.Size			 = getAttrValue(ele, "Size");
							label.font.Color		 = getAttrValue(ele, "Color");
							label.font.Italic		 = getAttrValue(ele, "Italic");
							label.font.UnderLine	 = getAttrValue(ele, "UnderLine");
							label.font.Strikethrough = getAttrValue(ele, "Strikethrough");
							label.font.Superscript	 = getAttrValue(ele, "Superscript");
							label.font.Subscript	 = getAttrValue(ele, "Subscript");
						}
						for (Iterator i4 = CellFormat.elementIterator("Format"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.IndentLevel		= getAttrValue(ele, "IndentLevel");
							label.Orientation		= getAttrValue(ele, "Orientation");
							label.WrapText			= getAttrValue(ele, "WrapText");
							label.NumberFormatLocal = getAttrValue(ele, "NumberFormatLocal");
						}
					}

					for (Iterator i3 = Range.elementIterator("BorderStyle"); i3.hasNext();)
					{
						Element CellFormat = (Element) i3.next();
						for (Iterator i4 = CellFormat.elementIterator("TopEdge"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.TopEdge_Style  = getAttrValue(ele, "Style");
							label.TopEdge_Color  = getAttrValue(ele, "Color");
							label.TopEdge_Weight = getAttrValue(ele, "Weight");
						}
						for (Iterator i4 = CellFormat.elementIterator("BottomEdge"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.BottomEdge_Style  = getAttrValue(ele, "Style");
							label.BottomEdge_Color  = getAttrValue(ele, "Color");
							label.BottomEdge_Weight = getAttrValue(ele, "Weight");
						}
						for (Iterator i4 = CellFormat.elementIterator("LeftEdge"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.LeftEdge_Style  = getAttrValue(ele, "Style");
							label.LeftEdge_Color  = getAttrValue(ele, "Color");
							label.LeftEdge_Weight = getAttrValue(ele, "Weight");
						}
						for (Iterator i4 = CellFormat.elementIterator("RightEdge"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.RightEdge_Style  = getAttrValue(ele, "Style");
							label.RightEdge_Color  = getAttrValue(ele, "Color");
							label.RightEdge_Weight = getAttrValue(ele, "Weight");
						}
						for (Iterator i4 = CellFormat.elementIterator("InVertical"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.InVertical_Style  = getAttrValue(ele, "Style");
							label.InVertical_Color  = getAttrValue(ele, "Color");
							label.InVertical_Weight = getAttrValue(ele, "Weight");
						}
						for (Iterator i4 = CellFormat.elementIterator("InHorizontal"); i4.hasNext();)
						{
							Element ele = (Element) i4.next();
							label.InHorizontal_Style  = getAttrValue(ele, "Style");
							label.InHorizontal_Color  = getAttrValue(ele, "Color");
							label.InHorizontal_Weight = getAttrValue(ele, "Weight");
						}
					}

					reportData.labels.add(label);
				}
			}
		}
	} catch(Exception e) {
		e.printStackTrace();
		reportData = null;
	}

	return reportData;
}

void setReportData(ReportData reportData_, int columnCnt, HSSFPalette palette, HSSFWorkbook workbook, HSSFSheet sheet, int rowNumber)
{
	if(reportData_ == null)
		return;

	try {
		HSSFPrintSetup printsetup = (HSSFPrintSetup)sheet.getPrintSetup(); // get print setup

		// 용지 크기 설정
		/*
		if("A3".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize(printsetup.A3_PAPERSIZE);
		else if("A4".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize(printsetup.A4_PAPERSIZE);
		else if("B4".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize(printsetup.B4_PAPERSIZE);
		else if("B5".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize(printsetup.B5_PAPERSIZE);
		*/

		if("A3".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize((short)8);
		else if("A4".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize((short)9);
		else if("B4".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize((short)12);
		else if("B5".equals(reportData_.PaperSize.toUpperCase()))
			printsetup.setPaperSize((short)13);

		// 용지 방향 설정
		if("landscape".equals(reportData_.Orientation.toLowerCase()))
			printsetup.setLandscape(true);

		// 헤더/푸터 여백 설정
		if(!"".equals(reportData_.Margins_Header))
			printsetup.setHeaderMargin(Double.parseDouble(reportData_.Margins_Header) / 2.54);
		if(!"".equals(reportData_.Margins_Footer))
			printsetup.setFooterMargin(Double.parseDouble(reportData_.Margins_Footer) / 2.54);

		// 용지 여백 설정
		if(!"".equals(reportData_.Margins_Left))
			sheet.setMargin(HSSFSheet.LeftMargin, Double.parseDouble(reportData_.Margins_Left) / 2.54);
		if(!"".equals(reportData_.Margins_Right))
			sheet.setMargin(HSSFSheet.RightMargin, Double.parseDouble(reportData_.Margins_Right) / 2.54);
		if(!"".equals(reportData_.Margins_Top))
			sheet.setMargin(HSSFSheet.TopMargin, Double.parseDouble(reportData_.Margins_Top) / 2.54);
		if(!"".equals(reportData_.Margins_Bottom))
			sheet.setMargin(HSSFSheet.BottomMargin, Double.parseDouble(reportData_.Margins_Bottom) / 2.54);

		// 배율 설정
		if("true".equals(reportData_.Adjust.toLowerCase()))
		{
			printsetup.setScale((short) Integer.parseInt(reportData_.Adjust_value));
		}
		if("true".equals(reportData_.Fit.toLowerCase()))
		{
			sheet.setAutobreaks(true);
			printsetup.setFitWidth((short)Integer.parseInt(reportData_.Fit_Width));
			printsetup.setFitHeight((short)Integer.parseInt(reportData_.Fit_Height));
		}

		// center on page
		if("true".equals(reportData_.CenterOnPage_Horizontal.toLowerCase()))
			sheet.setHorizontallyCenter(true);
		if("true".equals(reportData_.CenterOnPage_Vertical.toLowerCase()))
			sheet.setVerticallyCenter(true);

		// 행/열 반복 설정
		workbook.setRepeatingRowsAndColumns(0, Integer.parseInt(reportData_.ColsRepeat_Col1)-1, Integer.parseInt(reportData_.ColsRepeat_Col2)-1, Integer.parseInt(reportData_.RowsRepeat_Row1)-1, Integer.parseInt(reportData_.RowsRepeat_Row2)-1);

		// 기본 로우 높이 설정
		if(!"".equals(reportData_.DefaultRowHeight))
			sheet.setDefaultRowHeightInPoints(Float.parseFloat(reportData_.DefaultRowHeight));
//			sheet.setDefaultRowHeight((short)(40+20*Integer.parseInt(reportData_.DefaultRowHeight)));

		// 머리글 설정
		HSSFHeader header = (HSSFHeader)sheet.getHeader();
		header.setLeft(getHeaderFooterStr(reportData_.Header_Left_Text,   reportData_.Header_Left_Font));
		header.setCenter(getHeaderFooterStr(reportData_.Header_Center_Text, reportData_.Header_Center_Font));
		header.setRight(getHeaderFooterStr(reportData_.Header_Right_Text,  reportData_.Header_Right_Font));
		// 바닥글 설정
		HSSFFooter footer = (HSSFFooter)sheet.getFooter();
		footer.setLeft(getHeaderFooterStr(reportData_.Footer_Left_Text,   reportData_.Footer_Left_Font));
		footer.setCenter(getHeaderFooterStr(reportData_.Footer_Center_Text, reportData_.Footer_Center_Font));
		footer.setRight(getHeaderFooterStr(reportData_.Footer_Right_Text,  reportData_.Footer_Right_Font));
	} catch(Exception e) {
		e.printStackTrace();
	}
}

void setReportLabelBorderSet(ReportData reportData_, HSSFPalette palette, HSSFWorkbook workbook, HSSFSheet sheet)
{
	if(reportData_ == null)
		return;

	try {
		for(int cnt=0 ; cnt<reportData_.labels.size() ; cnt++)
		{
			Label label = (Label)reportData_.labels.get(cnt);
			if(label.type.equals("Label") || label.type.equals("BorderSet"))
			{
				HSSFCellStyle label_style = (HSSFCellStyle)workbook.createCellStyle();

				// 보더 설정
				String TopEdge_Color[] = label.TopEdge_Color.split(",");
				String BottomEdge_Color[] = label.BottomEdge_Color.split(",");
				String LeftEdge_Color[] = label.LeftEdge_Color.split(",");
				String RightEdge_Color[] = label.RightEdge_Color.split(",");

				if(!label.TopEdge_Style.equals("") || !label.TopEdge_Weight.equals(""))
					label_style.setBorderTop(getBorderStyle(label.TopEdge_Style, label.TopEdge_Weight));

				if(!label.BottomEdge_Style.equals("") || !label.BottomEdge_Weight.equals(""))
					label_style.setBorderBottom( getBorderStyle(label.BottomEdge_Style, label.BottomEdge_Weight) );

				if(!label.LeftEdge_Style.equals("") || !label.LeftEdge_Weight.equals(""))
					label_style.setBorderLeft(getBorderStyle(label.LeftEdge_Style, label.LeftEdge_Weight));

				if(!label.RightEdge_Style.equals("") || !label.RightEdge_Weight.equals(""))
					label_style.setBorderRight(getBorderStyle(label.RightEdge_Style, label.RightEdge_Weight));

				if(TopEdge_Color.length == 3)
					label_style.setTopBorderColor(getColorIndex(palette, Integer.parseInt(TopEdge_Color[0]), Integer.parseInt(TopEdge_Color[1]), Integer.parseInt(TopEdge_Color[2])));

				if(BottomEdge_Color.length == 3)
					label_style.setBottomBorderColor(getColorIndex(palette, Integer.parseInt(BottomEdge_Color[0]), Integer.parseInt(BottomEdge_Color[1]), Integer.parseInt(BottomEdge_Color[2])));

				if(LeftEdge_Color.length == 3)
					label_style.setLeftBorderColor(getColorIndex(palette, Integer.parseInt(LeftEdge_Color[0]), Integer.parseInt(LeftEdge_Color[1]), Integer.parseInt(LeftEdge_Color[2])));

				if(RightEdge_Color.length == 3)
					label_style.setRightBorderColor(getColorIndex(palette, Integer.parseInt(RightEdge_Color[0]), Integer.parseInt(RightEdge_Color[1]), Integer.parseInt(RightEdge_Color[2])));

				// 가로 정렬 설정
				if("left".equals(label.Alignment_Horizontal.toLowerCase()))
					label_style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
				else if("center".equals(label.Alignment_Horizontal.toLowerCase()))
					label_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
				else if("right".equals(label.Alignment_Horizontal.toLowerCase()))
					label_style.setAlignment(HSSFCellStyle.ALIGN_RIGHT);

				// 세로 정렬 설정
				if("top".equals(label.Alignment_Vertical.toLowerCase()))
					label_style.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);
				else if("center".equals(label.Alignment_Vertical.toLowerCase()))
					label_style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
				else if("bottom".equals(label.Alignment_Vertical.toLowerCase()))
					label_style.setVerticalAlignment(HSSFCellStyle.VERTICAL_BOTTOM);

				//폰트 설정
				HSSFFont font2 = (HSSFFont)workbook.createFont();
				setFont(palette, font2, label.font);
				label_style.setFont(font2); //폰트 스타일 적용

				// 패턴 색상 설정
				if(!"".equals(label.PatternColor))
				{
					String color[] = label.PatternColor.split(",");
					palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(color[0]), (byte)Integer.parseInt(color[1]), (byte)Integer.parseInt(color[2]));
					label_style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(color[0]), Integer.parseInt(color[1]), Integer.parseInt(color[2])));
				}
				// 배경색 설정
				if(!"".equals(label.BackColor))
				{
					String color[] = label.BackColor.split(",");
					palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(color[0]), (byte)Integer.parseInt(color[1]), (byte)Integer.parseInt(color[2]));
					if("".equals(label.Pattern))
					{
						label_style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
						label_style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(color[0]), Integer.parseInt(color[1]), Integer.parseInt(color[2])));
					} else {
						label_style.setFillBackgroundColor(getColorIndex(palette, Integer.parseInt(color[0]), Integer.parseInt(color[1]), Integer.parseInt(color[2])));
					}
				} else {
					label_style.setFillBackgroundColor((short) HSSFColor.WHITE.index);
				}
				// 패턴 설정
				if(!"".equals(label.Pattern))
				{
					label_style.setFillPattern(getFillPattern(label.Pattern));
				}

				if(!"".equals(label.IndentLevel.toLowerCase()))
					label_style.setIndention((short)Integer.parseInt(label.IndentLevel));
				if(!"".equals(label.Orientation.toLowerCase()))
					label_style.setRotation((short)Integer.parseInt(label.Orientation));
				if("true".equals(label.WrapText.toLowerCase()))
					label_style.setWrapText(true);
				if(!"".equals(label.NumberFormatLocal))
					label_style.setDataFormat(HSSFDataFormat.getBuiltinFormat(label.NumberFormatLocal));

				for(int label_row=Integer.parseInt(label.Range_row1) ; label_row<=Integer.parseInt(label.Range_row2) ; label_row++)
				{
					HSSFRow row2 = (HSSFRow)sheet.getRow(label_row - 1);
					if(row2 == null)
						row2 = (HSSFRow)sheet.createRow(label_row - 1);

					if(!"".equals(label.RowHeight))
						row2.setHeightInPoints(Float.parseFloat(label.RowHeight));

					for(short label_col=((short)Integer.parseInt(label.Range_col1)) ; label_col<=(short)Integer.parseInt(label.Range_col2) ; label_col++)
					{
						HSSFCell cell;
						cell = (HSSFCell)row2.getCell((short) label_col - 1);
						if(cell == null)
							cell = (HSSFCell)row2.createCell((short) label_col - 1);
						cell.setCellStyle(label_style);
						if(label_row==Integer.parseInt(label.Range_row1) && label_col==(short)Integer.parseInt(label.Range_col1) && !"".equals(label.InputText))
						{
							cell.setCellValue(label.InputText);
						}
					}
				}

				// 머지 설정
				if("true".equals(label.Merge.toLowerCase()))
					sheet.addMergedRegion(new Region(Integer.parseInt(label.Range_row1)-1, (short)(Integer.parseInt(label.Range_col1)-1), Integer.parseInt(label.Range_row2)-1, (short)(Integer.parseInt(label.Range_col2)-1))); //병합
			}
		}
	} catch(Exception e) {
		e.printStackTrace();
	}
}

int calculateColWidth(double width)
{
	if(width > 254)
		return 65280;
	if(width > 1)
	{
		double floor = Math.floor(((double)width)/5);
		double factor = 30 * floor;
		double value = 450 + factor + (width-1) * 250;
		return (int)(Math.ceil(value));
	}
	else
		return 450;
 }

void setReportColumnRowSize(ReportData reportData_, int columnCnt, HSSFSheet sheet, int rowNumber)
{
	if(reportData_ == null)
		return;

	for(int l=0 ; l<reportData_.reportColumnWidth.size() ; l++)
	{
		ColumnWidth cw = (ColumnWidth)reportData_.reportColumnWidth.get(l);
		int startCol = Integer.parseInt(cw.col1);
		int endCol = 0;
		if("end".equals(cw.col2.toLowerCase()))
			endCol = columnCnt;
		else
			endCol = cw.col2.equals("") ? startCol : Integer.parseInt(cw.col2);

		for(int colNo=startCol ; colNo<=endCol ; colNo++)
		{
			sheet.setColumnWidth(colNo - 1, calculateColWidth(Double.parseDouble(cw.size)));
		}
	}

	for(int l=0 ; l<reportData_.reportRowHeight.size() ; l++)
	{
		RowHeight rw = (RowHeight)reportData_.reportRowHeight.get(l);
		int startRow = Integer.parseInt(rw.row1);
		int endRow = 0;
		if("end".equals(rw.row2.toLowerCase()))
			endRow = rowNumber - 1;
		else
			endRow = rw.row2.equals("") ? startRow : Integer.parseInt(rw.row2);
		for(int rowNo=startRow ; rowNo<=endRow ; rowNo++)
		{
			HSSFRow row = (HSSFRow)sheet.getRow(rowNo - 1);
			if(row == null)
				row = (HSSFRow)sheet.createRow(rowNo - 1);

			row.setHeightInPoints(Float.parseFloat("0"+rw.size));
		}
	}
}

void setReportDataDataPattern(ReportData reportData_, HSSFPalette palette, HSSFWorkbook workbook, HSSFRow row, String[] cells, int columnCount_)
{
	if(reportData_ == null)
		return;

	try {
		for(int cnt=0 ; cnt<reportData_.labels.size() ; cnt++)
		{
			Label label = (Label)reportData_.labels.get(cnt);

			if(label.type.equals("DataPattern"))
			{
				short cellIndex = (short) Integer.parseInt(label.SheetCol);
//System.out.println("label.Word : " + label.Word + " " + cells[cellIndex] + " :  " + label.Word.equals(cells[cellIndex]) + " " + label.Word.length() + " " + cells[cellIndex].length());
				boolean bingo = false;
				if(label.Word.startsWith("*") && label.Word.endsWith("*"))
				{
					if(cells[cellIndex].indexOf(replace(label.Word, "*", "")) > -1)
					{
						bingo = true;
					}
				} else if(label.Word.endsWith("*")) {
					if(cells[cellIndex].startsWith(replace(label.Word, "*", "")))
					{
						bingo = true;
					}
				} else if(label.Word.startsWith("*")) {
					if(cells[cellIndex].endsWith(replace(label.Word, "*", "")))
					{
						bingo = true;
					}
				} else if(label.Word.equals(cells[cellIndex])) {
					bingo = true;
				}
				if(bingo)
				{
					for(short label_col=(short)(Integer.parseInt(label.Range_col1)-1) ; label_col<(short)Integer.parseInt(label.Range_col2) ; label_col++)
					{
						HSSFCellStyle label_style = (HSSFCellStyle)workbook.createCellStyle();

						// 보더 설정
						String TopEdge_Color[] = label.TopEdge_Color.split(",");
						String BottomEdge_Color[] = label.BottomEdge_Color.split(",");
						String LeftEdge_Color[] = label.LeftEdge_Color.split(",");
						String RightEdge_Color[] = label.RightEdge_Color.split(",");


						if(!label.TopEdge_Style.equals("") || !label.TopEdge_Weight.equals(""))
							label_style.setBorderTop(getBorderStyle(label.TopEdge_Style, label.TopEdge_Weight));

						if(!label.BottomEdge_Style.equals("") || !label.BottomEdge_Weight.equals(""))
							label_style.setBorderBottom( getBorderStyle(label.BottomEdge_Style, label.BottomEdge_Weight) );

						if(!label.LeftEdge_Style.equals("") || !label.LeftEdge_Weight.equals(""))
							label_style.setBorderLeft(getBorderStyle(label.LeftEdge_Style, label.LeftEdge_Weight));

						if(!label.RightEdge_Style.equals("") || !label.RightEdge_Weight.equals(""))
							label_style.setBorderRight(getBorderStyle(label.RightEdge_Style, label.RightEdge_Weight));

						if(TopEdge_Color.length == 3)
						{
							palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(TopEdge_Color[0]), (byte)Integer.parseInt(TopEdge_Color[1]), (byte)Integer.parseInt(TopEdge_Color[2]));
							label_style.setTopBorderColor(getColorIndex(palette, Integer.parseInt(TopEdge_Color[0]), Integer.parseInt(TopEdge_Color[1]), Integer.parseInt(TopEdge_Color[2])));
						}
						if(BottomEdge_Color.length == 3)
						{
							palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(BottomEdge_Color[0]), (byte)Integer.parseInt(BottomEdge_Color[1]), (byte)Integer.parseInt(BottomEdge_Color[2]));
							label_style.setBottomBorderColor(getColorIndex(palette, Integer.parseInt(BottomEdge_Color[0]), Integer.parseInt(BottomEdge_Color[1]), Integer.parseInt(BottomEdge_Color[2])));
						}
						if(LeftEdge_Color.length == 3)
						{
							palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(LeftEdge_Color[0]), (byte)Integer.parseInt(LeftEdge_Color[1]), (byte)Integer.parseInt(LeftEdge_Color[2]));
							label_style.setLeftBorderColor(getColorIndex(palette, Integer.parseInt(LeftEdge_Color[0]), Integer.parseInt(LeftEdge_Color[1]), Integer.parseInt(LeftEdge_Color[2])));
						}
						if(RightEdge_Color.length == 3)
						{
							palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(RightEdge_Color[0]), (byte)Integer.parseInt(RightEdge_Color[1]), (byte)Integer.parseInt(RightEdge_Color[2]));
							label_style.setRightBorderColor(getColorIndex(palette, Integer.parseInt(RightEdge_Color[0]), Integer.parseInt(RightEdge_Color[1]), Integer.parseInt(RightEdge_Color[2])));
						}

						// 가로 정렬 설정
						if("left".equals(label.Alignment_Horizontal.toLowerCase()))
							label_style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
						else if("center".equals(label.Alignment_Horizontal.toLowerCase()))
							label_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
						else if("right".equals(label.Alignment_Horizontal.toLowerCase()))
							label_style.setAlignment(HSSFCellStyle.ALIGN_RIGHT);

						// 세로 정렬 설정
						if("top".equals(label.Alignment_Vertical.toLowerCase()))
							label_style.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);
						else if("center".equals(label.Alignment_Vertical.toLowerCase()))
							label_style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
						else if("bottom".equals(label.Alignment_Vertical.toLowerCase()))
							label_style.setVerticalAlignment(HSSFCellStyle.VERTICAL_BOTTOM);

						//폰트 설정
						HSSFFont font2 = (HSSFFont)workbook.createFont();
						setFont(palette, font2, label.font);
						label_style.setFont(font2); //폰트 스타일 적용

						// 패턴 색상 설정
						if(!"".equals(label.PatternColor))
						{
							String color[] = label.PatternColor.split(",");
							palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(color[0]), (byte)Integer.parseInt(color[1]), (byte)Integer.parseInt(color[2]));
							label_style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(color[0]), Integer.parseInt(color[1]), Integer.parseInt(color[2])));
						}
						// 배경색 설정
						if(!"".equals(label.BackColor))
						{
							String color[] = label.BackColor.split(",");
							palette.setColorAtIndex(paletteIndex_++, (byte)Integer.parseInt(color[0]), (byte)Integer.parseInt(color[1]), (byte)Integer.parseInt(color[2]));
							if("".equals(label.Pattern))
							{
								label_style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
								label_style.setFillForegroundColor(getColorIndex(palette, Integer.parseInt(color[0]), Integer.parseInt(color[1]), Integer.parseInt(color[2])));
							} else {
								label_style.setFillBackgroundColor(getColorIndex(palette, Integer.parseInt(color[0]), Integer.parseInt(color[1]), Integer.parseInt(color[2])));
							}
						} else {
							label_style.setFillBackgroundColor((short) HSSFColor.WHITE.index);
						}
						// 패턴 설정
						if(!"".equals(label.Pattern))
						{
							label_style.setFillPattern(getFillPattern(label.Pattern));
						}

						if(!"".equals(label.IndentLevel.toLowerCase()))
							label_style.setIndention((short)Integer.parseInt(label.IndentLevel));
						if(!"".equals(label.Orientation.toLowerCase()))
							label_style.setRotation((short)Integer.parseInt(label.Orientation));
						if("true".equals(label.WrapText.toLowerCase()))
							label_style.setWrapText(true);
						if(!"".equals(label.NumberFormatLocal))
							label_style.setDataFormat(HSSFDataFormat.getBuiltinFormat(label.NumberFormatLocal));

						if("".equals(label.Range_col2))
							label.Range_col2 = label.Range_col1;
						else if("end".equals(label.Range_col2.toLowerCase()))
							label.Range_col2 = String.valueOf(columnCount_);

						HSSFCell cell = (HSSFCell)row.getCell(label_col);

						int cellType = cell.getCellType();
						cell.setCellType(cellType);

						HSSFCellStyle style = (HSSFCellStyle)cell.getCellStyle();

						HSSFDataFormat format = (HSSFDataFormat)workbook.createDataFormat();
						label_style.setDataFormat(style.getDataFormat());

						cell.setCellStyle(label_style);
					}
					
					if(!"".equals(label.RowHeight))
						row.setHeightInPoints(Float.parseFloat(label.RowHeight));
				}
			}
		}	// end of DataPattern
	} catch (Exception e) {
		e.printStackTrace();
	}
}

private String getBrowser(HttpServletRequest request) {
	String header = request.getHeader("User-Agent");
	if (header.indexOf("MSIE") > -1) {
		return "MSIE";
	} else if (header.indexOf("Chrome") > -1) {
		return "Chrome";
	} else if (header.indexOf("Opera") > -1) {
		return "Opera";
	} else if (header.indexOf("Safari") > -1) {
		return "Safari";
	}
	return "Firefox";
}

private String getEncodedFilename(String filename, String browser) throws Exception {
	String encodedFilename = "";

	if (browser.equals("MSIE")) {
		encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
	} else if (browser.equals("Firefox") || browser.equals("Safari") || browser.equals("Opera")) {
		encodedFilename = new String(filename.getBytes("UTF-8"), "8859_1");
	} else if (browser.equals("Chrome")) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < filename.length(); i++) {
			char c = filename.charAt(i);
			if (c > '~') {
				sb.append(URLEncoder.encode("" + c, "UTF-8"));
			} else {
				sb.append(c);
			}
		}
		encodedFilename = sb.toString();
	} else {
		encodedFilename = new String(filename.getBytes("UTF-8"), "8859_1");
	}

	return encodedFilename;
}

%>
