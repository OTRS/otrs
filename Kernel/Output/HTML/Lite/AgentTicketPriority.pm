# --
# AgentTicketPriority.dtl - provides HTML for AgentTicketPriority mask
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketPriority.pm,v 1.1 2005-02-17 07:02:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
<!-- start form -->
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<tr>
  <td class="mainhead">
    $Env{"Box0"}$Text{"Change priority of ticket"}: $Data{"TicketNumber"}$Env{"Box1"}
  </td>
</tr>
<tr>
  <td class="menu">
    <a href="$Env{"Baselink"}$Env{"LastScreenView"}" onmouseover="window.status='$Text{"Back"}'; return true;" onmouseout="window.status='';" class="menuitem">$Text{"Back"}</a>
  </td>
</tr>
</table>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<tr>
  <td class="mainbody">

  <br>

  <form action="$Env{"CGIHandle"}" method="post">
  <input type="hidden" name="Action" value="$Env{"Action"}">
  <input type="hidden" name="Subaction" value="Update">
  <input type="hidden" name="TicketID" value="$Data{"TicketID"}">
  <table border="0" width="700" align="center" cellspacing="0" cellpadding="4">
  <tr>
    <td colspan="2" class="contenthead">$Text{"Options"}</td>
  </tr>
  <tr>
  <td class="contentbody">
      <table border="0">
      <tr>
        <td class="contentkey">$Text{"Priority"}:</td>
        <td class="contentvalue">$Data{"OptionStrg"}</td>
      </tr>
      </table>
  </td>
  </tr>
  <tr>
    <td class="contentfooter">
      <input class="button" type="submit" value="$Text{"update"}">
    </td>
  </tr>
  </table>
  </form>

  <br>

  </td>
</tr>
</table>
<!-- end form -->

