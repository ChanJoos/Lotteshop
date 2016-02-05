<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>

<meta http-equiv="X-UA-Compatible" content="IE=edge">

<script src="/fis/common/js/jquery/jquery-1.10.2.min.js"></script>
<script src="/fis/common/js/jquery/jquery.blockUI.js"></script>
<script src="/fis/common/js/common/common.js"></script>
<script src="/fis/common/js/common/datetime.js"></script>
<script src="/fis/common/js/common/ajax_common.js"></script>
<script src="/fis/common/js/common/json2.js"></script>

<mvc:resources mapping="/resource/**" location="/WEB-INF/" />
<%
	String cp = request.getContextPath();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<!-- 허용준 -->
<%-- <link href="<%=cp%>/fis/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet"> --%>
<!-- 
	<link href="../../resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 -->

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
		<input type="hidden" name="user_name" id="user_name" value="${user_name}">
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
				<li><a href="/fis/carte/lookup/view.moJson">식단 조회</a></li>
				<li><a href="/fis/rating/survey/viewRating.moJson">메뉴 평가</a></li>
				<li><a href=# onClick=gotoNotice()>공지사항</a></li>
				<li><a href=# onClick=gotoVoc()> 고객의 소리 </a></li>
				<li><a href="/fis/carte/input/view.moJson">식단 입력</a></li>
			</ul>
		</div>
		<!-- /.navbar-collapse -->
	</div>
	<!-- /.container-fluid --> </nav>

	<div id="blank" style="height: 50.5px; width: 100%"></div>

	<section class="no-padding div-centered" id="portfolio">
	<div class="menu-selection">
		<a href="/fis/carte/lookup/view.moJson" class="portfolio-box">
			<img src="../../resources/img/main/1_y.jpg" class="img-responsive" alt="">
			<div class="portfolio-box-caption">
				<div class="portfolio-box-caption-content">
					<div class="project-category text-faded"></div>
					<div class="project-name"></div>
				</div>
			</div>
		</a>
		<a href="/fis/rating/survey/viewRating.moJson" id="div_rating" class="portfolio-box"> 
			<img	src="../../resources/img/main/2_y.jpg" class="img-responsive" alt="">
			<div class="portfolio-box-caption">
				<div class="portfolio-box-caption-content">
					<div class="project-category text-faded"></div>
					<div class="project-name"></div>
				</div>
			</div>
		</a> 
		<br/>
		<a href=# onClick=gotoNotice() class="portfolio-box">
			<img src="../../resources/img/main/3_y.jpg" class="img-responsive" alt="">
			<div class="portfolio-box-caption">
				<div class="portfolio-box-caption-content">
					<div class="project-category text-faded"></div>
					<div class="project-name"></div>
				</div>
			</div>
		</a>
		<a href=# onClick=gotoVoc() class="portfolio-box page-scroll">
			<img src="../../resources/img/main/4_y.jpg" class="img-responsive" alt="">
			<div class="portfolio-box-caption">
				<div class="portfolio-box-caption-content">
					<div class="project-category text-faded"></div>
					<div class="project-name"></div>
				</div>
			</div>
		</a>
	</div>
	</section>

	<div id="divLoginTodayDate">
		<span id="yearSpan"></span>년 <span id="monthSpan"></span>월 <span id="dateSpan"></span>일 메뉴
	</div>

	<section id="carteSection">
	<table class="table table-hover">
		<tbody>
			<tr class='BF'>
				<td width="15%">아침</td>
				<td width="50%" id='BF'><span id='spanBF' class='carte'> </span></td>
				<td id="bf_rt" width="15%"></td>
				<td width="20%"></td>
			</tr>
			<tr class='LC'>
				<td>점심</td>
				<td id='LC'><span id='spanLC' class='carte'> </span></td>
				<td id="lc_rt"></td>
				<td></td>
			</tr>
			<tr class='DN'>
				<td>저녁</td>
				<td id='DN'><span id='spanDN' class='carte'> </span></td>
				<td id="dn_rt"></td>
				<td>
					<form role="form" method="post" accept-charset="utf-8">
						<input type="hidden" name="date" value="0"> <input type="hidden" name="carte_type" value="0"> <input
							type="hidden" name="reserve_yn" value="0">
					</form> 예약 인원<br /> <span id="reserveNumDN">0</span>명 <br />
					<button type="submit" class="btn btn-primary reserve" id="reserveDN">예약하기</button>
				</td>
			</tr>
		</tbody>
	</table>
	</section>
	

	<!-- jQuery -->
	<script src="../../resources/js/jquery.js"></script>

	<!-- Bootstrap Core JavaScript -->
	<script src="../../resources/js/bootstrap.min.js"></script>

	<!-- Plugin JavaScript -->
	<script src="../../resources/js/jquery.easing.min.js"></script>
	<script src="../../resources/js/jquery.fittext.js"></script>
	<script src="../../resources/js/wow.min.js"></script>

	<!-- Custom Theme JavaScript -->
	<script src="../../resources/js/creative.js"></script>

	<%@include file="fn_login.jsp"%>
	
	<script language="javascript">
		//$(document).ready(init);

		function init() {
		}

		function gotoNotice()
		{
			var form = $("form[name = 'pageValues']");
			form.attr("action","/fis/board/notice/1/gotoNotice.moJson");
			form.attr("method","post");
			form.submit();
		}
		
		function gotoVoc()
		{
			var form = $("form[name = 'pageValues']");
			form.attr("action","/fis/board/voc/1/gotoVoc.moJson");
			form.attr("method","post");
			form.submit();
		}
	</script>
	
</body>
</html>