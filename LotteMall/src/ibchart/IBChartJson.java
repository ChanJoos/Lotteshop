package ibchart;

import java.util.List;

/**
 * @Class Name : IBChartJson.java
 * @Description : ibchart Json객채 클래스
 * @Modification Information
 * @
 * @  수정일          수정자                  수정내용
 * @ ---------        ---------   -------------------------------
 * @ 2013. 8. 9.  NP007                   최초생성
 *
 * @author NP007
 * @since
 * @version 1.0
 * @see
 */
public class IBChartJson {
	private IBChartConfig config;
	private List<IBChartSeries> data;
	
	public IBChartConfig getConfig() {
		return config;
	}
	public void setConfig(IBChartConfig config) {
		this.config = config;
	}
	public List<IBChartSeries> getData() {
		return data;
	}
	public void setData(List<IBChartSeries> data) {
		this.data = data;
	}	
}
