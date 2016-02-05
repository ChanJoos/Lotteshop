<%@ page contentType="text/html;charset=utf-8"%>

<form role="commentInfoForm">
	<input type="hidden" name="contents_num" id="contents_num" value=${num}> <input type="hidden" name="pageNo" id="pageNo"
		value=${pageNo}> <input type="hidden" name="user_name" id="user_name" value=${user_name}>
</form>

<div class="container">
	<table border="1" class="table table-hover table-bordered">
		<colgroup>
			<col width="10%">
			<col width="75%">
			<col width="10%">
			<col width="5%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><center>
						<span class="glyphicon glyphicon-user" aria-hidden="true" />
					</center></th>
				<th scope="col"><center>
						<span class="glyphicon glyphicon-list-alt" aria-hidden="true" />
					</center></th>
				<th scope="col"><center>
						<span class="glyphicon glyphicon-calendar" aria-hidden="true" />
					</center></th>
				<th scope="col"><center>
						<span class="glyphicon glyphicon-trash" aria-hidden="true">
					</center></th>
			</tr>
		</thead>
		<c:forEach var="col" items="${commentList}" begin="0" end="${commentSize}" step="1">
			<tr name="commentTR" id="commentTR">
				<td>${col.CREATOR}</td>
				<td>${col.CONTENTS}</td>
				<td>${col.DATE}</td>
				<td><a href=# onClick=deleteComment(${col.NUM})>X</a></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
<script language="javascript">

function deleteComment(num){
	var obj = $("form[role='commentInfoForm']");
	var num = $('<input></input>');
	
	num.attr("type", "hidden");
	num.attr("name", "num");
	num.attr("id", "num");
	num.attr("value", num);
	
	obj.append(num);
	obj.attr("action", "/fis/board/notice/doDeleteComment.moJson");
	obj.attr("method", "post");
	obj.submit();
}

</script>
<br>