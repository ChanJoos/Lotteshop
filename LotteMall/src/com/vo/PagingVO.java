package com.vo;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;

public class PagingVO implements Serializable {
	private static final long serialVersionUID = 2676894245717960187L;
	
	private String menu_cd;
	private String win_cd;
	private String menu_nm;
	private String win_nm;

	private String emp_id;

	/** 검색조건 */
	private String searchCondition = "";

	/** 검색Keyword */
	private String searchKeyword = "";

	/** 검색사용여부 */
	private String searchUseYn = "";

	/** 입력쪽에 년도 */
	private String msearchYear = "";

	/** 입력쪽에 사업장 */
	private String msearchWkpl = "";

	private String searchFirst = "";
	private String searchSecond = "";
	private String searchThird = "";
	private String searchFourth = "";
	private String searchFifth = "";
	/** 현재페이지 */
	private int pageIndex = 1;

	/** 페이지갯수 */
	private int pageUnit = 10;

	/** 페이지사이즈 */
	private int pageSize = 10;

	/** firstIndex */
	private int firstIndex = 1;

	/** lastIndex */
	private int lastIndex = 1;

	/** recordCountPerPage */
	private int recordCountPerPage = 10;

	public String getSearchCondition() {
		return searchCondition;
	}

	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

	public String getSearchUseYn() {
		return searchUseYn;
	}

	public void setSearchUseYn(String searchUseYn) {
		this.searchUseYn = searchUseYn;
	}

	public String getMsearchYear() {
		return msearchYear;
	}

	public void setMsearchYear(String msearchYear) {
		this.msearchYear = msearchYear;
	}

	public String getMsearchWkpl() {
		return msearchWkpl;
	}

	public void setMsearchWkpl(String msearchWkpl) {
		this.msearchWkpl = msearchWkpl;
	}

	public String getSearchFirst() {
		return searchFirst;
	}

	public void setSearchFirst(String searchFirst) {
		this.searchFirst = searchFirst;
	}

	public String getSearchSecond() {
		return searchSecond;
	}

	public void setSearchSecond(String searchSecond) {
		this.searchSecond = searchSecond;
	}

	public String getSearchThird() {
		return searchThird;
	}

	public void setSearchThird(String searchThird) {
		this.searchThird = searchThird;
	}

	public String getSearchFourth() {
		return searchFourth;
	}

	public void setSearchFourth(String searchFourth) {
		this.searchFourth = searchFourth;
	}

	public String getSearchFifth() {
		return searchFifth;
	}

	public void setSearchFifth(String searchFifth) {
		this.searchFifth = searchFifth;
	}

	public int getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}

	public int getPageUnit() {
		return pageUnit;
	}

	public void setPageUnit(int pageUnit) {
		this.pageUnit = pageUnit;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getFirstIndex() {
		return firstIndex;
	}

	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}

	public int getLastIndex() {
		return lastIndex;
	}

	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}

	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}

	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

	public String getMenu_cd() {
		return menu_cd;
	}

	public void setMenu_cd(String menu_cd) {
		this.menu_cd = menu_cd;
	}

	public String getEmp_id() {
		return emp_id;
	}

	public void setEmp_id(String emp_id) {
		this.emp_id = emp_id;
	}

	public String getWin_cd() {
		return win_cd;
	}

	public void setWin_cd(String win_cd) {
		this.win_cd = win_cd;
	}

	public String getMenu_nm() {
		return menu_nm;
	}

	public void setMenu_nm(String menu_nm) {
		this.menu_nm = menu_nm;
	}

	public String getWin_nm() {
		return win_nm;
	}

	public void setWin_nm(String win_nm) {
		this.win_nm = win_nm;
	}
}
