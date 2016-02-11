 /*
  Name : index.js
  Description : Index page on javascript
  Modification Information
  1. 2016.01.14. 남현석 최초생성
  2.

  since
  version 1.0
  see
  */

window.onload = function() {
//	$("signbtn").onclick = btnClick;
	$("").observe("mouseover", btnOver );

};

//BUTTON mouseover EVENT .
function btnOver () {

	if(this.id == "signbtn"){
		$("signwindow").appear(
		{duration: 0.25}
		);
	}

	if(this.id == "cancelBtn"){
		$("signwindow").fade(
		{duration: 0.25}
		);
	}

	if(this.id == "signinBtn"){
		signin();	
	}
		
}

//BUTTON CLICK EVENT .
function btnClick () {

	if(this.id == "signbtn"){
		$("signwindow").appear(
		{duration: 0.25}
		);
	}

	if(this.id == "cancelBtn"){
		$("signwindow").fade(
		{duration: 0.25}
		);
	}

	if(this.id == "signinBtn"){
		signin();	
	}
		
}

// IF USER FILL SIGN FORM, CHECK IT AND AJAX REQUEST.
function signin() {

	var passwd = $("userpw").value;
	var passwdconfirm = $("pwconfirm").value;

	if(passwd == passwdconfirm){
		var uname = $("username").value;
		var uid = $("userid").value;


		new Ajax.Request("login.php", {
			method: "post",
			parameters: {signin: "on", name: uname, id: uid, pw: passwd },
			onSuccess: signed,
			onFailure: ajaxfail,
			onException: ajaxfail 
		});
	}else {
		alert("패스워드가 일치하지 않습니다.");
	}

}

function ajaxfail() {
	alert("OK");
	$("signwinddow").fade();
}

function signed(ajax) {

$("signwinddow").fade();
}
