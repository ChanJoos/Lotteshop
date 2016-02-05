package com.vo;

public class EventVO extends PagingVO{
	private int idx;
	private int market_idx;
	private String name;
	private String start_date;
	private String end_date;
	private String contents;
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public int getMarket_idx() {
		return market_idx;
	}
	public void setMarket_idx(int market_idx) {
		this.market_idx = market_idx;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	
	
	
	

}
