<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.poi.poifs.dev.*" %>
<%@ page import="org.apache.poi.hssf.record.*" %>
<%@ page import="org.apache.poi.hssf.record.formula.*" %>
<%@ page import="org.apache.poi.hssf.model.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%
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
	String sWebRoot = "C:/apache-tomcat-6.0.16/webapps"; 
	//String sWebRoot = "";	


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
	
    //====================================================================================================
    // 대용량 서버전용 List 구조체인 SHEETDATA 를 전달 받기
    //====================================================================================================
	List li = (List)request.getAttribute("SHEETDATA");

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

//fos.write(LastBufferPack.getBytes());

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

//fos.write(("[2]\n").getBytes());
		for(int k=0;k<kLoop;k++) //최대 n개의 시트를 모아받기 가능.
		{
			sHeader = SheetDatas[k].substring(0,SheetDatas[k].indexOf("\u0005"));
			sData = SheetDatas[k].substring(SheetDatas[k].indexOf("\u0005"));
			SheetDatas[k] = "";

	        //====================================================================================================
	        // 전달받은 Down2Excel 인자를 준비합니다.
	        //====================================================================================================
			String CellData = "";
			int arrSize = 0;
			String sPalette= getPropValue(sHeader,"Palette");
//fos.write(sPalette.getBytes());
			String sRowHeights = getPropValue(sHeader,"RowHeights");
			String arrRowHeights[] = sRowHeights.split("\\|");
			String TheDownloadFileName = getPropValue(sHeader,"FileName");
			String TheSheetName = getPropValue(sHeader,"SheetName");
			String Merge = getPropValue(sHeader,"Merge");
			String ImageNoSeed = " "+getPropValue(sHeader,"ImageNoSeed");
			String RecordTypes = getPropValue(sHeader,"RecordTypes");
			String SaveNames = getPropValue(sHeader,"SaveNames");
			String RecordFormats = getPropValue(sHeader,"RecordFormats");
			String ColWidths = getPropValue(sHeader,"ColWidths");
			String RecordOrgFormats = getPropValue(sHeader,"RecordOrgFormats");
			String arrSaveNames[] = SaveNames.split("\\|");
			String arrColWidths[] = ColWidths.split("\\|");
			String arrRecordType[] = RecordTypes.split("\\|");
			String arrRecordFormat[] = RecordTypes.split("\\|");
			String arrRecordOrgFormat[] = RecordTypes.split("\\|");
			String arrRecordFormat2[] = RecordFormats.split("\\|");
			String arrRecordOrgFormat2[] = RecordOrgFormats.split("\\|");
			String arrRecordTypeNumeric[] = RecordTypes.split("\\|");
			String BaseDir = getPropValue(sHeader,"BaseDir");

			String downCombo = getPropValue(sHeader,"DownCombo");
			String arrComboCode[][] = new String[arrRecordType.length][];
			String arrComboText[][] = new String[arrRecordType.length][];
			for(int i=0 ; i<arrRecordType.length ; i++)
			{
				arrComboCode[i] = getPropValue(sHeader, i+"_IBCC").split("\\|");
				arrComboText[i] = getPropValue(sHeader, i+"_IBCT").split("\\|");
			}

			String TitleText = getPropValue(sHeader,"TitleText");//"위글\u007F위글2\u007F위글3\u0005밑글\u007F밑글2\u007F밑글3";
			String UserMerge = getPropValue(sHeader,"UserMerge");
			String ColAlign = getPropValue(sHeader, "ColAlign");
			String arrColAlign[] = ColAlign.split("\\|", arrRecordType.length);
			downloadTokenValue = getPropValue(sHeader, "downloadTokenValue");

			TitleText = TitleText.replace("\u0002","\u0005");
			BaseDir = sWebRoot.replace("\\","/")+BaseDir;

			int HeaderRows = Integer.parseInt("0"+getPropValue(sHeader,"HeaderRows"));
			int DownHeader = Integer.parseInt("0"+getPropValue(sHeader,"DownHeader"));
			int SheetDesign = Integer.parseInt("0"+getPropValue(sHeader,"SheetDesign"));

			String SheetFontName = getPropValue(sHeader,"SheetFontName");
			int ExcelFontSize = 0;
			int ExcelRowHeight = 0;
			int SheetFontSize = 0;
			int HeaderBackColor = 0;
			int DataBackColor = 0;
			int SumBackColor = 0;

			int SumStartRow = Integer.parseInt(getPropValue(sHeader,"SumStartRow"));
			int SumEndRow = Integer.parseInt(getPropValue(sHeader,"SumEndRow"));

			if(SheetDesign==1 || SheetDesign==2)
			{
				SheetFontName = getPropValue(sHeader,"SheetFontName");
				ExcelFontSize = Integer.parseInt("0"+getPropValue(sHeader,"ExcelFontSize"));
				ExcelRowHeight = Integer.parseInt("0"+getPropValue(sHeader,"ExcelRowHeight"));
				SheetFontSize = Integer.parseInt("0"+getPropValue(sHeader,"SheetFontSize"));
				if(ExcelFontSize>0) 
				{
					SheetFontSize = ExcelFontSize;
				}
				HeaderBackColor = Integer.parseInt("0"+getPropValue(sHeader,"HeaderBackColor"));
				DataBackColor = Integer.parseInt("0"+getPropValue(sHeader,"DataBackColor"));
				SumBackColor = Integer.parseInt("0"+getPropValue(sHeader,"SumBackColor"));
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
				response.setHeader("Content-Type", "application/octet-stream");

				//String sEncodingFileName = new String(TheDownloadFileName.getBytes("euc-kr"), "8859_1");
				//String sEncodingFileName = java.net.URLEncoder.encode(TheDownloadFileName, "utf-8").replaceAll("\\+", " ");
				//response.setHeader("Content-Disposition", "attachment;filename=" + sEncodingFileName + ";");
				//response.setHeader("Content-Description", "JSP Generated Data");

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
			HSSFCellStyle styleTitle = workbook.createCellStyle();
			HSSFCellStyle styleHead = workbook.createCellStyle();
			HSSFCellStyle styleCol[] = new HSSFCellStyle[arrRecordType.length];
			
			HSSFCellStyle style[] = new HSSFCellStyle[arrRecordType.length*64];
			HSSFCellStyle styleHeadColor[] = new HSSFCellStyle[arrRecordType.length*64];

			for(int j=0;j<arrRecordType.length*64;j++)
			{
				style[j] = workbook.createCellStyle();
				styleHeadColor[j] = workbook.createCellStyle();
			}
						
			HSSFDataFormat df[] = new HSSFDataFormat[arrRecordType.length];
			for(int i=0;i<arrRecordType.length;i++)
			{
				styleCol[i] = workbook.createCellStyle();
				df[i] = workbook.createDataFormat();
				
				if("|AutoSum|AutoAvg|Int|Float|".indexOf("|"+arrRecordTypeNumeric[i]+"|")>-1)
				{
					arrRecordTypeNumeric[i] = "N"; //N 이면 숫자 계산임..
				}
				else if(arrRecordTypeNumeric[i].equals("Date"))
				{
					arrRecordTypeNumeric[i] = "D"; //널이면 숫자,계산 아님
				}
				else
				{
					arrRecordTypeNumeric[i] = ""; //널이면 숫자,계산 아님
				}
				
				arrRecordFormat[i] = "";
				if (i<arrRecordFormat2.length)
				{
					arrRecordFormat[i] = arrRecordFormat2[i];
				}

				arrRecordOrgFormat[i] = "";
				if (i<arrRecordOrgFormat2.length)
				{
					arrRecordOrgFormat[i] = arrRecordOrgFormat2[i];
				}
			}
			HSSFFont font = workbook.createFont();
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
			SetDefaultStyle("TITLE", "","","",styleTitle, "", df[0], font, SheetDesign, SheetFontSize, SheetFontName, getColorIndex(palette,255,255,255), defaultFontName, defaultFontSize);
			SetDefaultStyle("HEAD", "","","",styleHead, "", df[0], font, SheetDesign, SheetFontSize, SheetFontName, getColorIndex(palette,((HeaderBackColor/256/256)%256),  ((HeaderBackColor/256)%256), (HeaderBackColor%256)), defaultFontName, defaultFontSize);

			// 컬럼별 포맷 설정
			for(int i=0;i<arrRecordType.length;i++)
			{
				for(int j=0;j<64;j++)
				{
					SetDefaultStyle("HEAD", arrRecordType[i],arrRecordOrgFormat[i],arrRecordFormat[i], styleHeadColor[j], "", df[i], font, SheetDesign, SheetFontSize, SheetFontName, j, defaultFontName, defaultFontSize);
				}

				SetDefaultStyle("DATA", arrRecordType[i],arrRecordOrgFormat[i],arrRecordFormat[i], styleCol[i], arrColAlign[i], df[i], font, SheetDesign, SheetFontSize, SheetFontName, getColorIndex(palette,255,255,255), defaultFontName, defaultFontSize);
				for(int j=0;j<64;j++)
				{
					SetDefaultStyle("DATA", arrRecordType[i],arrRecordOrgFormat[i],arrRecordFormat[i], style[i*64+j], "", df[i], font, SheetDesign, SheetFontSize, SheetFontName, j, defaultFontName, defaultFontSize);
				}
				
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

	        //====================================================================================================
	        // 브라우저 시트에서 제공한 헤더 자료(또는 타이틀 자료 포함) 들을 li 구조의 앞부분에 추가 합니다. 헤더가 2줄이면 2개가 추가됨.
	        //====================================================================================================
	        for (int iR = 1; iR < lines.length; iR++)
	        {
				if(lines[iR].indexOf("\u0002")!=-1) // 널자료시의 대응
				{
					lines[iR] = " ";
				}
				String [] cells = lines[iR].split("\u007F");
				Map mp = new HashMap();
//fos.write(("Row:"+iR+" "+lines[iR]+" Size:"+arrSaveNames.length+"/"+cells.length+"\n").getBytes());
				for(int c=0;c<arrSaveNames.length;c++)
				{
					if(c<cells.length)
					{
						mp.put(arrSaveNames[c],cells[c]);
					}
					else
					{
						mp.put(arrSaveNames[c],"");
					}
				}
				li.add(iR-1,mp);
	        }

	        //====================================================================================================
	        // 데이타 를 표현합니다.
	        //====================================================================================================
	        //for (int iR = 1; iR < lines.length; iR++)
	        for (int iR = 1; iR <= li.size(); iR++)
	        {
//fos.write((iR+" Row :"+li.size()+"\n").getBytes());
	        
	        	// 첫항목과 끝항목은 무시함
				if(iR % 65536 == 1)
				{
			        //====================================================================================================
			        // 워크시트를 생성합니다.
			        //====================================================================================================
			        sheet = workbook.createSheet();
			        long SheetNo = ((iR-1)/65536)+1;
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

				Map mp = (Map)li.get((iR-1));
				row = sheet.createRow((iR-1)%65536);
				CellType = "TITLE";
				arrSize = arrSaveNames.length;

/*				if(iR<=sTitleRow) 
				{
					//arrSize = cells.length;
				}
*/		

		        CellData = "";
		        for (int iC = 0; iC < arrSize; iC++)
		        {
		        	try
		        	{
				        CellData = "";
		        		CellData = mp.get(arrSaveNames[iC]).toString();
		        	}
		        	catch(NullPointerException en)
		        	{
		        	
		        	}

					HSSFCell cell = row.createCell((short) iC);
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
						if(SumStartRow+sTitleRow < iR && iR <= SumEndRow+sTitleRow)
						{
							cell.setCellStyle(styleCol[iC]);
							CellType = "SUM";
						}
						else
						{
							cell.setCellStyle(styleCol[iC]);
							CellType = "";
						}
					}

		        	if (iC<arrSize)
		        	{
						try {
		        		// 2012.05.07 starworld DownCombo:'TEXT' 인 경우 코드를 텍스트로 변경
						if("TEXT".equals(downCombo) && arrRecordType[iC].indexOf("Combo") > -1)
						{
							for(int m=0 ; m<arrComboCode[iC].length ; m++)
							{
								if(arrComboCode[iC][m].equals(CellData))
								{
									CellData = arrComboText[iC][m];
									break;
								}
							}
							
						}
						} catch(Exception e) {e.printStackTrace(); return;}
						if(CellType.equals("TITLE") || CellType.equals("HEAD") || arrRecordTypeNumeric[iC].equals("")) //널은 숫자,날짜가 아님.
						{
							// 숫자, 날짜를 제외한 일반 값들
							cell.setCellType(HSSFCell.CELL_TYPE_STRING);
							if(CellType.equals("HEAD"))
							{
								cellWriteValueText(palette, styleHeadColor, SheetDesign==1,cell,0, CellData, sTreeChar);
							}
							else
							{
								cellWriteValueText(palette, style, SheetDesign==1,cell,iC, CellData, sTreeChar);
							}
						}
						else
						{
						    if(arrRecordTypeNumeric[iC].equals("D"))
						    {
									cell.setCellType(HSSFCell.CELL_TYPE_STRING);
									CellData=CellData.replaceAll("\\/","-").replaceAll("\\.","-");
									cellWriteValue(palette, style,SheetDesign==1,cell,iC, CellData);
						    }
							else
							{
								if(arrRecordTypeNumeric[iC].equals("N"))
								{
									try
									{
										cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
										cellWriteValueNumeric(palette, style,SheetDesign==1,cell,iC, CellData);
									}
									catch(NumberFormatException e)
									{
										try
										{
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											cellWriteValue(palette, style,SheetDesign==1,cell,iC,CellData);
										}
										catch(NumberFormatException e2)
										{
											cellWriteValue(palette, style,SheetDesign==1,cell,iC,"0");
										}
									}
								}
							}
						}
						
					    if(CellType.equals("")) // 이미지는 헤더와 합계에서 제외
					    {
						    if(arrRecordType[iC].equals("Image") || arrRecordType[iC].equals("ImageText"))
						    {
							    if(ImageNoSeed.indexOf(" "+(iR-1-sTitleRow)+","+iC+" ")==-1)
							    {
								    drawImage(sheet, workbook,sWebRoot, iR, iC, BaseDir, CellData);
	  							}
	
								if(arrRecordType[iC].equals("Image"))
								{
									cellWriteValue(palette, style,SheetDesign==1,cell,iC, "");
							    }
						    }
					    }
					}
					else
					{
						cellWriteValue(palette, style, SheetDesign==1,cell,iC, "");
					}

					
		    	} // end of cell
		    	
/*	            if(iR>sTitleRow)
	            {
		            if((iR-sTitleRow)<arrRowHeights.length)
		            {
		            	row.setHeight((short)(40+20*Short.parseShort(arrRowHeights[iR-sTitleRow]))); // 20단위 1픽셀씩 위아래 1픽셀씩 여백에 높이만큼 높이 잡음
		            }
		        }
		    	else
		    	{
	            	row.setHeight((short)(40+20*32)); // 20 포인트 단위에 1픽셀씩 위아래 1픽셀씩 여백에 높이만큼 높이 잡음
		    	}
		    	
		    	if(ExcelRowHeight>0)
		    	{
	            	row.setHeight((short)(15*ExcelRowHeight)); // 15 트윕 단위*1픽셀
		    	}
*/

	        } // end of row


			if(!Merge.equals(""))
			{
				int startRow = 0;
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
		    //int cWidthRatio = 5; // 8 권장인데, 폭이 좁아서 문제라고 판단된다면 숫자를 줄이자.
		    for (int iC = 0; iC < arrRecordType.length; iC++)
		    {
		    	//sheet.setColumnWidth(iC,(255/cWidthRatio*Integer.parseInt("0"+arrColWidths[iC])));
				sheet.autoSizeColumn(iC,true);
		    }
	
		} // sheet

		// 파일 다운로드 체크 쿠키 심기
		Cookie cookie = new Cookie("fileDownloadToken", downloadTokenValue);
		cookie.setPath("/");
		response.addCookie(cookie);
		//System.out.println("fileDownloadToken : " + downloadTokenValue);

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
		System.out.println("IOException : " + ioe);
		//fos.write(ioe.toString().getBytes());
	*/
	} catch (Exception e) {
		//fos.write(e.toString().getBytes());
		out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetExcelSheetID].finishDownload(); targetWnd.Grids[targetWnd.gTargetExcelSheetID].ShowAlert('엑셀 다운로드중 에러가 발생하였습니다.', 'U');}catch(e){}</script>");
		e.printStackTrace();
	} catch (Error e) {
		out.println("<script>try{var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[targetWnd.gTargetExcelSheetID].finishDownload(); targetWnd.Grids[targetWnd.gTargetExcelSheetID].ShowAlert('엑셀 다운로드중 에러가 발생하였습니다.', 'U');}catch(e){}</script>");

		e.printStackTrace();
	}
//fos.close();
%>

<%!

// 함수 추가
private void cellWriteValue(HSSFPalette palette, HSSFCellStyle[] style , boolean SheetDesign,HSSFCell cell, int iC, String iData) throws Exception
{
	String iColor = "";
	if(iData.indexOf("\u0006")>-1)
	{
		iColor = iData.substring(iData.indexOf("\u0006")+1);
		iData = iData.substring(0,iData.indexOf("\u0006"));
		if(iColor.length()>=6)
		{
			cell.setCellStyle(style[iC*64+getColorIndex(palette,Integer.parseInt(iColor.substring(0,2),16),Integer.parseInt(iColor.substring(2,4),16),Integer.parseInt(iColor.substring(4,6),16))]);
		}
	}

	cell.setCellValue(iData);
}
private void cellWriteValueNumeric(HSSFPalette palette, HSSFCellStyle[] style, boolean SheetDesign, HSSFCell cell, int iC, String iData) throws Exception
{
	String iColor = "";
	if(iData.indexOf("\u0006")>-1)
	{
		iColor = iData.substring(iData.indexOf("\u0006")+1);
		iData = iData.substring(0,iData.indexOf("\u0006"));
		if(iColor.length()>=6)
		{
			cell.setCellStyle(style[iC*64+getColorIndex(palette,Integer.parseInt(iColor.substring(0,2),16),Integer.parseInt(iColor.substring(2,4),16),Integer.parseInt(iColor.substring(4,6),16))]);
		}
	}
	cell.setCellValue(Double.parseDouble(iData.replace(",","")));
}
private void cellWriteValueText(HSSFPalette palette, HSSFCellStyle[] style,  boolean SheetDesign,HSSFCell cell, int iC, String iData, String sTreeChar) throws Exception
{

	String iColor = "";
	if(iData.indexOf("\u0006")>-1)
	{
		iColor = iData.substring(iData.indexOf("\u0006")+1);
		iData = iData.substring(0,iData.indexOf("\u0006"));
		if(iColor.length()>=6)
		{
			cell.setCellStyle(style[iC*64+getColorIndex(palette,Integer.parseInt(iColor.substring(0,2),16),Integer.parseInt(iColor.substring(2,4),16),Integer.parseInt(iColor.substring(4,6),16))]);
		}
	}


	cell.setCellValue(iData.replaceAll("\r\n","\n").replaceAll("\u0001",sTreeChar));
}

private Short getColorIndex(HSSFPalette pallete, int R, int G, int B) throws Exception
{
	HSSFColor color = pallete.findSimilarColor(R,G,B);
	if(color==null)
	{
		return HSSFColor.WHITE.index;
	}
	else
	{
		return color.getIndex();
	}
}

private void drawImage(HSSFSheet sheet, HSSFWorkbook wb, String sWebRoot, int R, int C, String BaseDir, String url ) throws IOException
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
	    
		    HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
		    HSSFClientAnchor anchor;
		    anchor = new HSSFClientAnchor(15,15,0,200,(short)C,(R-1),(short)(C+1),(R-1)); // 이미지 크기조절은 여기서..
		    anchor.setAnchorType( 2 );
		    patriarch.createPicture(anchor, loadPicture(ImageFilePath, wb )); // 삽입 할 이미지
		}
	}
	
	
}


private static int loadPicture( String path, HSSFWorkbook wb ) throws IOException
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

void SetDefaultStyle(String RowType, String DataType, String DataOrgFormat, String DataFormat, HSSFCellStyle istyle, String align, HSSFDataFormat df, HSSFFont font, int SheetDesign, int SheetFontSize, String SheetFontName, int BgColorIndex, String defaultFontName, short defaultFontSize)
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
	
	// 워드랩 세로정렬
	istyle.setWrapText(true);
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
		if("|AutoSum|AutoAvg|Int|Float|".indexOf("|"+DataType+"|")>-1 || "|Integer|NullInteger|Float|NullFloat|".indexOf("|"+DataOrgFormat+"|")>-1)
		{
			istyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		}
		
		// 컬럼별 서식 설정하기
		if(DataType.equals("Date"))
		{
			istyle.setDataFormat(df.getFormat(DataFormat.replace("h", "H").replaceAll("\\/","-").replaceAll("\\.","-")));
//			istyle.setDataFormat(df.getFormat("yyyy-mm-dd"));
		}
		else if(DataFormat.equals("")) //포맷 없으면 모두 텍스트 서식
		{
			//istyle.setDataFormat(df.getBuiltinFormat("@")); // @ 또는 text
			istyle.setDataFormat(df.getBuiltinFormat("")); // @ 또는 text
		}
		else if(!DataFormat.equals("")) //포맷 적용
		{
			DataFormat = DataFormat.replace("*","#").replace("#.","0.").replace("0.#","0.0");
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
