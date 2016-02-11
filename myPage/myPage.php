<!DOCTYPE html>
<html>
<head>
	<!-- 
	Name : myPage.php
	Description : Page for login 
	Modification Information
	1. 2016.01.14. 남현석 최초생성
	2.

	since
	version 1.0
	see
	-->
	<title>accounts for LotteMall customer</title>
	<meta name ="author" Content="Web Application Project Team">
	<meta name ="keywords" Content="Lotte, mall, shopping, 롯데, 쇼핑">
	<meta name ="description" Content="GPS기반 쇼핑전용 애플리케이션입니다.">
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

	<!-- CSS -->
    <link rel="stylesheet" href="style/css/bootstrap.css" media="screen">
    <link rel="stylesheet" href="style/css/custom.min.css">
	
	<!-- JS  -->
	<script src="prototype.js" type="text/javascript"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/scriptaculous/1.9.0/scriptaculous.js" type="text/javascript"></script>
	<script src="index.js" type="text/javascript"></script>	

</head>
<body>
	<div id="body_wrapper">
		<footer>
		</footer>
		<div id="a">
			<div id="loginwindow" class="window">
				<div>
					<h1> MEMBER LOGIN </h1>
				</div>
				<div id="inputwindow">
					<form action="login.php" method="post">
						<div>
						<label for="id"> ID </label>
						<input type="text" name="id" />
						</div>
						<div>
						<input id="submit" type="image" src="power43.png" alt="submit" value="Login" />
						</div>
						<div>
						<label for="pw"> PW </label>
						<input type="password" name="pw" />
						</div>
						<div>
						<input type="checkbox" name="remember" > Remember Me </input>
						<button type="button" id="signbtn"> Sign In </button>
						</div>			
					</form>
				</div>

			</div>
		</div>
		<div id="b">
			<div id="signwindow" class="window" style="display:none">
				<div>
					<h1> SIGN IN </h1>
				</div>
				<form>
					<div>
					<label for="uname"><span>name</span></label>
					<input id="username" type="text" name="uname" />
					</div>
					<div>
					<label for="id"><span>ID</span></label>
					<input id="userid" type="text" name="id" />
					</div>
					<div>
					<label for="pw"><span>PW</span></label>
					<input id="userpw" type="password" name="pw" />
					</div>
					<div>
					<label for="pwconfirm"><span>PW again</span></label>
					<input id="pwconfirm" type="password" name="pwconfirm" />
					</div>
					<div>
					<button type="button" id="signinBtn"> Sign In </button>		
					<button type="button" id="cancelBtn"> Cancel </button>		
				</form>
			</div>
		</div>
	</div>	

</body>
</html>