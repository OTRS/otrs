<?php
//
// otrs location
//
$starthost='http://otrs.example.com/otrs/index.pl';

// 
// logout messages
//
$reason = $GLOBALS['HTTP_GET_VARS']['Reason'];
$reasons = array(
    ''   => '',
    'InvalidSessionID' => _("Your session has expired. Please login again."),
    'Logout'  => _("You have been logged out.<br />Thank you for using the system."),
    'LoginFailed'  => _("Login failed for some reason. Most likely your username or password was entered incorrectly."),
    'SystemError' => _("System error! Contact your admin!")
    );

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">

<title>Welcome</title>
</head>

<body onload="setFocus()" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<script language="JavaScript" type="text/javascript">

<!--

function setFocus()
{
    document.login.User.focus();
}

function submit_login()
{
    if (document.login.User.value == "") {
        alert("Please provide your username and password");
        document.login.User.focus();
        return false;
    } else if (document.login.Password.value == "") {
        alert("Please provide your username and password");
        document.login.Password.focus();
        return false;
    } else {
        return true;
    }
}
//-->

</script>

<center>
<form action="<?= $starthost ?>" method="post" name="login">
<input type="hidden" name="Action" value="Login" />
<input type="hidden" name="RequestedURL" value="<?= $GLOBALS['HTTP_GET_VARS']['RequestedURL'] ?>" />

<table align="center" border="0" width="260" cellspacing="4" cellpadding="2">
<tr>
  <td align="center" colspan="2">Welcome to OpenTRS</td>
</tr>
<?
    //
    // print reason if needed
    //
    if ($reasons[$reason] != '') {
        echo '<tr>';
        echo '<td align="center" colspan="2">'. $reasons[$reason] .'</td>';
        echo '</tr>';
    }
?>
<tr>
  <td align="right"><b>Username</b></td>
  <td align="left"><input type="text" tabindex="1" name="User" value="" /></td>
</tr>
<tr>
  <td align="right"><b>Password</b></td>
  <td align="left"><input type="password" tabindex="2" name="Password" /></td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td align="left"><input type="submit" name="button" tabindex="4" value="Log in" onclick="return submit_login();" /></td>
</tr>
</table>

</form>
</center>

</body>
</html>


