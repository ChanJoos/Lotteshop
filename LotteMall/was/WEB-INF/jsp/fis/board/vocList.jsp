<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>


<form role="pageInfoForm" method="post">
	<input type="hidden" id="pageNo" name="pageNo" value=${pageNo}> <input type="hidden" id="user_name" name="user_name"
		value=${user_name}> <input type="hidden" id="searchWord" name="searchWord" value=${searchWord}>
</form>

<body onload="chk_writeAuth()">
	<div class="container">
		<div>
			<h2 class="text-center">고객의 소리</h2>
		</div>
		<table class="table table-hover table-bordered" border="1" style="text-align: center">
			<colgroup>
				<col width="5%">
				<col width="95%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No.</th>
					<th scope="col" style="text-align: center"><span class="glyphicon glyphicon-list-alt"></span></th>
				</tr>
			</thead>
			<tbody>
				<!-- 목록이 반복될 영역 -->
				<c:forEach var="col" items="${list}" begin="${pStart}" end="${pEnd}" step="1">
					<tr>
						<td style="text-align: center">${col.ROW_NUM}</td>
						<td style="text-align: left"><a href=# onClick=showContents(${col.NUM})><h4>${col.TITLE}</h4></a>
						<h6><span class="glyphicon glyphicon-user"></span>${col.CREATOR}&nbsp&nbsp<span class="glyphicon glyphicon-calendar"></span>${col.DATE}</h6></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div>
			<div class="row" style="text-align: right">
				<input type="text" id="searchWordInput" name="searchWordInput" style="width: 25%;" value=${searchWord} >
				<button type="button" class="btn btn-primary" id="btn_search" name="btn_search">
					<span class="glyphicon glyphicon-search"></span>
				</button>

				<button type="button" class="btn btn-primary" name="btn_vocWrite" id="btn_vocWrite" style="width: 15%;">
					<span class="glyphicon glyphicon-pencil"></span>
				</button>
			</div>
			<div class="paging" style="text-align: center">
				<c:forEach var="i" begin="1" end="${listLen}" step="1">
					<a href=# onClick=gotoVoc(${i})><font size=5>&nbsp${i}&nbsp</font></a>
				</c:forEach>
			</div>
		</div>
	</div>
	<!--//container-->
</body>

<script language="javascript">
	function gotoVoc(n)
	{
		var form = $("form[role = 'pageInfoForm']");
		
		$("#searchWord").val($("#searchWordInput").val());
		form.attr("action","/fis/board/voc/" + n + "/gotoVoc.moJson");
		form.attr("method","post");
		form.submit();
	}
	
	function showContents(n){
		var obj = $("form[role='pageInfoForm']");
		var num = $('<input></input>');
		
		num.attr("type", "hidden");
		num.attr("name", "num");
		num.attr("id", "num");
		num.attr("value", n);
		
		obj.append(num);
		obj.attr("action", "/fis/board/voc/showVocContents.moJson");
		obj.attr("method", "post");
		obj.submit();
	}
	
	function fn_doSearch(){
		var obj = $("form[role='pageInfoForm']");
		
		$("#searchWord").val($("#searchWordInput").val());
		obj.attr("action","/fis/board/voc/1/gotoVoc.moJson");
		obj.attr("method","post");
		obj.submit();
	}
		
	$("#btn_vocWrite").click(function() {
			var obj = $("form[role='pageInfoForm']");
			obj.attr("action", "/fis/board/voc/gotoVocWriter.moJson");
			obj.attr("method", "post");
			obj.submit();
		});
	$("#btn_search").click(function(){
		fn_doSearch();
		});
	
	$('#searchWordInput').keypress(function(event) {if (event.keyCode == 13) {
						fn_doSearch();
					}
				});
	</script>