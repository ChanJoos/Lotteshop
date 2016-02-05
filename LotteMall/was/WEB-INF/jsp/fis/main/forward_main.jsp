<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>Start FIS Theme</title>

<!-- Bootstrap Core CSS -->
<link rel="stylesheet" href="../../resources/css/bootstrap.min.css" type="text/css">

<!-- Custom Fonts -->
<link
	href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800'
	rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="../../resources/font-awesome/css/font-awesome.min.css" type="text/css">

<!-- Plugin CSS -->
<link rel="stylesheet" href="../../resources/css/animate.min.css" type="text/css">

<!-- Custom CSS -->
<link rel="stylesheet" href="../../resources/css/creative.css" type="text/css">

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->


</head>

<body id="page-top">

	<form name="pageValues">
		<input type="hidden" name="user_name" id="user_name" value=${user_name}>
		<!-- 임시 아이디 값 나중에 수정해야됨 -->
	</form>
	<nav id="mainNav" class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="/fis/login/move/initLogin.moJson">Start FIS</a>
			</div>

			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav navbar-right">
					<li id="carte-lookup"'><a href="/fis/carte/lookup/view.moJson">식단 조회</a></li>
					<li><a href="/fis/rating/survey/viewRating.moJson">메뉴 평가</a></li>
					<li><a href=# onClick=gotoNoticeTop()>공지사항</a></li>
					<li><a href=# onClick=gotoVocTop()> 고객의 소리 </a></li>
					<li id="carte-input"'><a href="/fis/carte/input/view.moJson">식단 입력</a></li>
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</div>
		<!-- /.container-fluid -->
	</nav>
	<script language="javascript">
	function gotoNoticeTop()
	{
		var form = $("form[name = 'pageValues']");
		form.attr("action","/fis/board/notice/1/gotoNotice.moJson");
		form.attr("method","post");
		form.submit();
	}
	
	function gotoVocTop()
	{
		var form = $("form[name = 'pageValues']");
		form.attr("action","/fis/board/voc/1/gotoVoc.moJson");
		form.attr("method","post");
		form.submit();
	}
	</script>