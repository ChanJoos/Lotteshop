<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>


<script language="javascript">
	$(document).ready(init);

	function init() {
		fn_setEvent();
		fn_chkUser();
	}

	function fn_chkUser() {
		if ("${user_name}" != "${creator}") {
			document.getElementById("btn_edit").disabled = true;
			document.getElementById("btn_delete").disabled = true;
		}
	}

	function fn_doInsertList() {
		var formObj = $("form[role='contentsForm']");
		formObj.attr("action", "/fis/board/notice/1/insert.moJson");
		formObj.attr("method", "post");
		formObj.submit();
	}

	function fn_setEvent() {
		$("#btn_write").click(function() {

			if ($("#title").val() == "" && $("#contents").val() == "")
				alert("제목과 내용을 입력 해 주세요");
			else if ($("#title").val() == "")
				alert("제목을 입력 해 주세요");
			else if ($("#contents").val() == "")
				alert("내용을 입력 해 주세요");
			else
				fn_doInsertList();

		});
		
		$("#btn_back").click(
				function() {
					var formObj = $("form[role='contentsForm']");
					formObj.attr("action",
							"/fis/board/notice/${pageNo}/gotoNotice.moJson");
					formObj.attr("method", "post");
					formObj.submit();
				});

		$("#btn_edit").click(
				function() {
					var formObj = $("form[role='contentsForm']");
					formObj.attr("action",
							"/fis/board/notice/gotoNoticeEditor.moJson");
					formObj.submit();
				});

		$("#btn_edit_done").click(
				function() {
					if (confirm('수정 하시겠습니까?')) {
						var formObj = $("form[role='contentsForm']");
						formObj.attr("action",
								"/fis/board/notice/doUpdateContents.moJson");
						formObj.submit();
					}
				});
		$("#btn_delete").click(
				function() {
					if (confirm('정말 삭제 하시겠습니까?')) {
						var formObj = $("form[role='contentsForm']");
						formObj.attr("action",
								"/fis/board/notice/doDeleteContents.moJson");
						formObj.submit();
					}
				});

	}
</script>