# --
# AuthSession.pm - provides session check and session data
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AuthSession.pm,v 1.4 2002-01-01 20:37:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession; 

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;
 
# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    $Self->{LogObject} = $Param{LogObject} || die 'No LogObject!';

    # get config data
    my $ConfigObject = $Param{ConfigObject} || die 'No ConfigObject!'; 

    $Self->{SessionSpool} = $ConfigObject->Get('SessionDir');
    $Self->{SystemID} = $ConfigObject->Get('SystemID');
 
    # Debug 0=off 1=on
    $Self->{Debug} = 0;    

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
    my $SessionID = $Param{SessionID} || die 'Got no SessionID!';
    my $Strg = '';
    my %Data;

    # FIXME!
    open (SESSION, "< $Self->{SessionSpool}/$SessionID") or return;
    while (<SESSION>) {
        chomp;
        $Strg = $_;
    }
    close (SESSION);
    my @StrgData = split(/;/, $Strg); 
    foreach (@StrgData) {
         my @PaarData = split(/=/, $_);
         $Data{$PaarData[0]} = $PaarData[1] || '';
         # Debug
         if ($Self->{Debug}) {
             print STDERR "GetSessionIDData: $PaarData[0]=$PaarData[1]\n";
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
    open (SESSION, ">> $Self->{SessionSpool}/$SessionID") || die "Can't create $Self->{SessionSpool}/$SessionID: $!"; 
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
sub UpdateSessionID {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || die 'No Key!';
    my $Value = $Param{Value} || die 'No Value!';
    my $SessionID = $Param{SessionID} || die 'No SessionID!';

    my %SessionData = $Self->GetSessionIDData(SessionID => $SessionID);

    # update the value 
    $SessionData{$Key} = $Value; 
    
    open (SESSION, "> $Self->{SessionSpool}/$SessionID") || die "Can't write $Self->{SessionSpool}/$SessionID: $!";
    foreach (keys %SessionData) {
        print SESSION "$_=$SessionData{$_};";
        # Debug
        if ($Self->{Debug}) {
            print STDERR "UpdateSessionID: $_=$SessionData{$_}\n";
        }

    }
    close (SESSION);

    return 1;
}
# --


1;


