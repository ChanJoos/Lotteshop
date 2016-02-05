package com.vo;

public class DiscountVO extends PagingVO{
	public int product_idx;
	public int market_idx;
	public int rate;
	public String create_date;
	public String end_date;
	public int getProduct_idx() {
		return product_idx;
	}
	public void setProduct_idx(int product_idx) {
		this.product_idx = product_idx;
	}
	public int getMarket_idx() {
		return market_idx;
	}
	public void setMarket_idx(int market_idx) {
		this.market_idx = market_idx;
	}
	public int getRate() {
		return rate;
	}
	public void setRate(int rate) {
		this.rate = rate;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	
	
	
}
