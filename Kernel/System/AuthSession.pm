# --
# AuthSession.pm - provides session check and session data
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AuthSession.pm,v 1.1 2001-12-02 18:24:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession; 

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;
 
# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    $Self->{LogObject} = $Param{LogObject};

    # get config data
    my $ConfigObject = $Param{ConfigObject} || 
       $Self->{LogObject}->Log(Priority => 'error', MSG => 'No ConfigObject!');

    $Self->{SessionSpool} = $ConfigObject->Get('SessionDir');
    $Self->{SystemID} = $ConfigObject->Get('SystemID');
 
    # debug
    $Self->{debug} = 1;    

    return $Self;
}
# --
sub CheckSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    open (SESSION, "< $Self->{SessionSpool}/$SessionID") || return;
    close (SESSION); 

    # FIXME!
    # IP CHECK and TIME CHECK!!!
  
    return 1;
}
# --
sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    my $Strg = '';
    my %Data;

    # FIXME!
    open (SESSION, "< $Self->{SessionSpool}/$SessionID") or return;
    while (<SESSION>) {
        $Strg = $_;
    }
    close (SESSION);
    my @StrgData = split(/;/, $Strg); 
    foreach (@StrgData) {
         my @PaarData = split(/=/, $_);
         $Data{$PaarData[0]} = $PaarData[1];
         # debug
         if ($Self->{debug}) {
             print STDERR "$PaarData[0]=$PaarData[1]\n";
         } 
    }

    return %Data;
}
# --
sub CreateSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = 10 . time() . int(rand(999999999)) . $Self->{SystemID};
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # FIXME!
    open (SESSION, ">> $Self->{SessionSpool}/$SessionID") or return;
    foreach (keys %Param) {
        print SESSION "$_=$Param{$_};";
    }
    print SESSION "UserSessionStart=" . time() . ";";
    print SESSION "UserRemoteAddr=" . $RemoteAddr . ";\n";
    close (SESSION);

    return $SessionID;
}
# --
sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};

    # FIXME!
    system ("rm $Self->{SessionSpool}/$SessionID");

    return 1;
}
# --

1;


