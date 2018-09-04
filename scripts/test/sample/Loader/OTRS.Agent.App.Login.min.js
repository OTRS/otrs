"use strict";var OTRS=OTRS||{};OTRS.Agent=OTRS.Agent||{};OTRS.Agent.App=OTRS.Agent.App||{};OTRS.Agent.App.Login=(function(TargetNS){TargetNS.Init=function(){if(!OTRS.Debug.BrowserCheck()){$('#LoginBox').hide();$('#OldBrowser').show();return;}
OTRS.Form.EnableForm($('#LoginBox form, #PasswordBox form'));if($('#User').val()&&$('#User').val().length){$('#Password').focus();}
else{$('#User').focus();}
$('#LostPassword, #BackToLogin').click(function(){$('#LoginBox, #PasswordBox').toggle();return false;});Now=new Date();$('#TimeOffset').val(Now.getTimezoneOffset());}
return TargetNS;}(OTRS.Agent.App.Login||{}));
