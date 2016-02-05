package ibchart;

import java.util.List;
import java.util.Map;

/**
 * @Class Name : IBChartSeries.java
 * @Description : 차트의 Series(바)
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
public class IBChartSeries {
	private String seriesName;
	private List<Map<String,String>> arrData;
	
	public String getSeriesName() {
		return seriesName;
	}
	
	public void setSeriesName(String seriesName) {
		this.seriesName = seriesName;
	}
	public List<Map<String, String>> getArrData() {
		return arrData;
	}
	public void setArrData(List<Map<String, String>> arrData) {
		this.arrData = arrData;
	}
}
