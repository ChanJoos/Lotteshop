<!DOCTYPE html>
<html>
<head>
  <!-- 
  Name : index.php
  Description : Main page
  Modification Information
  1. 2016.01.14. 남현석 최초생성
  2.

  since
  version 1.0
  see
  -->
	<title>Welcome to LotteMall</title>
	<meta name ="author" Content="Web Application Project Team">
	<meta name ="keywords" Content="Lotte, mall, shopping, 롯데, 쇼핑">
	<meta name ="description" Content="GPS기반 쇼핑전용 애플리케이션입니다.">
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />

	<!-- CSS -->
  
  <link rel="stylesheet" href="style/css/bootstrap.min.css" type="text/css">

  <!-- Plugin CSS -->
  <link rel="stylesheet" href="style/css/animate.min.css" type="text/css">
  <link rel="stylesheet" href="style/css/m.v2.min.css" type="text/css">
	
	<!-- JS  -->
	<script src="prototype.js" type="text/javascript"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/scriptaculous/1.9.0/scriptaculous.js" type="text/javascript"></script>

  <!-- backward Operator -->
  <!-- jQuery -->
  <script src="style/js/jquery.js"></script>
  <!-- Bootstrap Core js -->
  <script src="style/js/bootstrap.min.js"></script>

  <!-- Plugin js -->
  <script src="style/js/jquery.easing.min.js"></script>
  <script src="style/js/jquery.fittext.js"></script>
  <script src="style/js/wow.min.js"></script>

	
	<!--IS USER LOGINED NOW? CHECK IT -->
	<?php
	/*
    <link rel="stylesheet" href="style/css/bootstrap.css" media="screen" type="text/css">
    <script src="index.js" type="text/javascript"></script>
	session_cache_expire(120);
	session_start();
	$_SESSION["S_ID"] = session_id();
	$sid = $_SESSION["S_ID"];
			$rows = $db->query("SELECT * from account WHERE sid = '$sid'");
*/
	try {

		$db = new PDO("mysql:dbname=LotteMall","root","1111");
		$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		//CHECK USER IS LOGINED. IF SOMEONE HAS ALREADY LOGINED, DATA IS ON SESSION DB TABLE
		$rows = $db->query("SELECT * from account");
		$count = $rows->rowCount();
		//LOGINED USER. REDIRECT TO MAIN
		if($count > 0)
		{
//			echo "<script> alert('hello!'); </script>";	
//			header("Location: example.php");
//			exit;
		}
		
		// IF USER REQUESTED LOGIN, AND ID PASSWOD IS WRONG, ALERT SOMETHING.
		if(isset($_SESSION['login']) && $_SESSION['login'] == FALSE)
		{
			echo "<script> alert('you got wrong password!'); </script>";	
		}
		
	} catch (PDOException $ex) {
		header("HTTP/1.1 400 wrong request");
		Die("Sorry, Server status is not good. Error : $ex->getMessage()");
	}
	
	?>
</head>
<body>
	<div class="navbar navbar-default navbar-fixed-top">
      <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Lotte Mall</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling ('in': open, '': close, 'active': click effect)-->
        <div class="navbar-collapse collapse" id="bs-example-navbar-collapse-1">
          <ul class="nav navbar-nav navbar-left">
            <li>
              <a href="myPage.php">마이정보</a>
            </li>
            <li>
              <a href="#">프로모션/쿠폰</a>
            </li>
            <li>
              <a href="#">오프라인매장</a>
            </li>
            <!--
            <li class="divider"></li>
            -->
          </ul>

          <form class="navbar-form navbar-right" role="search">
            <div class="form-group">
              <input type="text" class="form-control" placeholder="Search">
            </div>
            <button type="submit" class="btn btn-default">상품 검색</button>
          </form>
          <ul class="nav navbar-nav navbar-right">
            <li><a href="#">장바구니</a></li>
          </ul>
        </div><!-- end of navbar -->
      </div><!-- end of container -->
    </div>

    <!--  blank -->
    <div id="blank" style="height:50.5px; width:100%"></div>

    <!-- topMenu -->
    <nav id="topMenu" >
      <ul id="scroller">
        
        <li>
          <a class="top-menu0 on" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">패션의류</a>
        </li>
        
        <li>
          <a class="top-menu1" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">뷰티</a>
        </li>
        
        <li>
          <a class="top-menu2" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">출산/유아동</a>
        </li>
    
        <li>
          <a class="top-menu3" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">식품</a>
        </li>
    
        <li>
          <a class="top-menu4" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">주방/생활용품</a>
        </li>
    
        <li>
          <a class="top-menu5" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">가구/홈데코</a>
        </li>
    
        <li>
          <a class="top-menu6" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">가전/디지털</a>
        </li>
    
        <li>
          <a class="top-menu7" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">스포츠/래저</a>
        </li>
    
        <li>
          <a class="top-menu8" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">도서/문구</a>
        </li>
    
        <li>
          <a class="top-menu9" href="#" data-cclick="MOBILE_B,SCROLLER,TODAYRECOMM,0">반려/애완용품</a>
        </li>
    
      </ul>
      <span id="scroller-left" class="scroller-arr-left" data-cclick="MOBILE_B,SCROLLER,LEFT,0"></span>
      <span id="scroller-right" class="scroller-arr-right" data-cclick="MOBILE_B,SCROLLER,RIGHT,0"></span>
    </nav>

    <script src="style/js/iscroll.js" type="text/javascript"></script>

    <div class="list-group">
  	  <a href="#" class="list-group-item">
  	    <h4 class="list-group-item-heading">티셔츠</h4>
  	    <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
  	  </a>
  	  <a href="#" class="list-group-item">
  	    <h4 class="list-group-item-heading">바지</h4>
  	    <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
  	  </a>
      <a href="#" class="list-group-item">
        <h4 class="list-group-item-heading">List group item heading</h4>
        <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
      </a>
      <a href="#" class="list-group-item">
        <h4 class="list-group-item-heading">List group item heading</h4>
        <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
      </a>
      <a href="#" class="list-group-item">
        <h4 class="list-group-item-heading">List group item heading</h4>
        <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
      </a>
      <a href="#" class="list-group-item">
        <h4 class="list-group-item-heading">List group item heading</h4>
        <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
      </a>

    </div>

    <script src="style/js/topMenuScript.js" type="text/javascript"></script>
    <script src="style/js/floatingTitle.js" type="text/javascript"></script>


</body>
</html>
