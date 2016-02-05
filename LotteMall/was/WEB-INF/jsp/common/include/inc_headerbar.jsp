<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/include/inc_tablib.jsp"%>
<script>
	function setHeaderInfo(title, link) {
		$("#headerTitle").text(title);
		$("#headerPrev").click(function() {
			location.href = link;
		});
	}
</script>
 <div id="header" >
	<div class="nav">
		<h1>
			<a id="headerPrev" href="javascript:void()" class="prev"><span
				class="hide">이전페이지</span></a> <span id="headerTitle"></span>
		</h1>
	</div>
</div>