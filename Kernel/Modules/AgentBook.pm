# --
# Kernel/Modules/AgentBook.pm - spelling module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentBook.pm,v 1.1 2004-01-08 22:10:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentBook;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(TicketObject ParamObject DBObject QueueObject LayoutObject 
      ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # get params
    foreach (qw(To Cc Bcc)) {
        $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    } 
    # ger listed users
    my $Search = $Self->{ParamObject}->GetParam(Param => 'Search');
    my %CustomerUserList = ();
    if ($Search) {
        %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
            Search => $Search.'*',
        );
    }
    my %AddressList = ();
    foreach (keys %CustomerUserList) {
        my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $_, 
        );
        $AddressList{$CustomerUserData{UserEmail}} = $CustomerUserList{$_};
    }
    # start with page ...
    $Output .= $Self->{LayoutObject}->Header(Title => 'Addressbook');
    $Output .= $Self->_Mask(
        List => \%AddressList,
        %Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # do html quoteing
    foreach (qw(To Cc Bcc)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_});
    }
    my %List = %{$Param{List}};
    foreach (keys %List) {
        $Param{AddressList} .= '<tr><td>'.$Self->{LayoutObject}->Ascii2Html(Text => $List{$_}).
            "</td><td><a href=\"\" onclick=\"AddToAddress('$_'); return false;\">\$Text{\"To\"}</a></td>".
            "<td><a href=\"\" onclick=\"AddCcAddress('$_'); return false;\">\$Text{\"Cc\"}</a></td></tr>";
    }
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentBook', Data => \%Param);
}
# --
1;
