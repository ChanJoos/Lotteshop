package ibchart;

import java.util.List;
 
/**
 * @Class Name : IBChartConfig.java
 * @Description :  ibchart 환경
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
public class IBChartConfig {
	List<String> xAxisLabels; /* 라벨표기 */

	public List<String> getxAxisLabels() {
		return xAxisLabels;
	}

	public void setxAxisLabels(List<String> xAxisLabels) {
		this.xAxisLabels = xAxisLabels;
	}
}
