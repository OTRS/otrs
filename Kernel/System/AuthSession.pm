# --
# Kernel/System/AuthSession.pm - provides session check and session data
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AuthSession.pm,v 1.20 2003-10-29 20:22:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession; 

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.20 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
 
# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # --
    # allocate new hash for object
    # --
    my $Self = {}; 
    bless ($Self, $Type);

    # --
    # check needed objects
    # --
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # --
    # load generator backend module
    # --
    my $GenericModule = $Self->{ConfigObject}->Get('SessionModule')
      || 'Kernel::System::AuthSession::DB';
    if (!eval "require $GenericModule") {
        die "Can't load session backend module $GenericModule! $@";
    }

    $Self->{Backend} = $GenericModule->new(%Param);

    return $Self;
}
# --
sub CheckSessionID {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->CheckSessionID(%Param);
}
# --
sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->GetSessionIDData(%Param);
}
# --
sub CreateSessionID {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->CreateSessionID(%Param);
}
# --
sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->RemoveSessionID(%Param);
}
# --
sub UpdateSessionID {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->UpdateSessionID(%Param);
}
# --
sub GetAllSessionIDs {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->GetAllSessionIDs(%Param);
}
# --
sub CleanUp {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->CleanUp(%Param);
}
# --

1;
