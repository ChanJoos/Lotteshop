package com.vo;

public class WishListVO extends PagingVO {
	public int product_idx;
	public int market_idx;
	public int account_idx;
	public int qty;
	public String create_date;
	public String update_date;
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
	public int getAccount_idx() {
		return account_idx;
	}
	public void setAccount_idx(int account_idx) {
		this.account_idx = account_idx;
	}
	public int getQty() {
		return qty;
	}
	public void setQty(int qty) {
		this.qty = qty;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getUpdate_date() {
		return update_date;
	}
	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
	}
	
}
