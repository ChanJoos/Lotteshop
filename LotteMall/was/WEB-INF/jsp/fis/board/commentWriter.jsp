<%@ page contentType="text/html;charset=utf-8"%>

<div class="container">
	<form role="commentForm" method="post">
		<input type="hidden" id="creator" name="creator" value=${creator}> <input type="hidden" id="pageNo" name="pageNo"
			value=${pageNo}> <input type="hidden" id="num" name="num" value=${num}> <input type="hidden" id="user_name"
			name="user_name" value=${user_name}> <input type="text" id="contents" name="contents" style="width: 100%;">
	</form>
	<button class="btn btn-danger" id="btn_cmt_input" name="btn_cmt_input" style="width: 100%;"><span class="glyphicon glyphicon-comment" aria-hidden="true"></span></button>
</div>
<script language="javascript">
	$(document).ready(init);

	function init() {
		$("#btn_cmt_input").click(function() {
			if ($("#contents").val() == "")
				alert("내용을 입력 해 주세요");
			else
				fn_doCommentInsert();
		});
	}
	function fn_doCommentInsert() {
		var formObj = $("form[role='commentForm']");
		formObj.attr("action", "/fis/board/notice/noticeCommentWriter.moJson");
		formObj.attr("method", "post");
		formObj.submit();
	}
</script>
