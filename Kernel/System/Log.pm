# --
# Kernel/System/Log.pm - log wapper 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Log.pm,v 1.8 2002-12-15 12:39:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log;
use IPC::SysV qw(IPC_PRIVATE IPC_RMID S_IRWXU);

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # --
    # check log prefix 
    # --
    $Self->{LogPrefix} = $Param{LogPrefix} || '?LogPrefix?';
    # --
    # get config object 
    # --
    if (!$Param{ConfigObject}) {
        die "Got no ConfigObject!"; 
    }
    # --
    # load log backend
    # --
    my $GeneratorModule = $Param{ConfigObject}->Get('LogModule')
      || 'Kernel::System::Log::SysLog';
    eval "require $GeneratorModule";
    # --
    # create backend handle
    # --
    $Self->{Backend} = $GeneratorModule->new(%Param);
    # --
    # ipc stuff
    # --
    $Self->{SystemID} = $Param{ConfigObject}->Get('SystemID');
    $Self->{IPCKey} = "444423$Self->{SystemID}";
    $Self->{IPCSize} = 8*1024;
    # init session data mem
    $Self->{Key} = shmget($Self->{IPCKey}, $Self->{IPCSize}, 0777 | 0001000) || die $!;

    return $Self;
}
# --
sub Log { 
    my $Self = shift;
    my %Param = @_;
    my $Priority = $Param{Priority} || 'debug';
    my $Message = $Param{MSG} || $Param{Message} || '???';
    my $Caller = $Param{Caller} || 0;
    # --
    # returns the context of the current subroutine and sub-subroutine!
    # --
    my ($Package1, $Filename1, $Line1, $Subroutine1) = caller($Caller+0);
    my ($Package2, $Filename2, $Line2, $Subroutine2) = caller($Caller+1);
    if (!$Subroutine2) {
      $Subroutine2 = $0;
    }
    # --
    # log backend
    # --
    $Self->{Backend}->Log(
        Priority => $Priority,
        Caller => $Caller,
        Message => $Message,
        LogPrefix => $Self->{LogPrefix},
        Module => $Subroutine2,
        Line => $Line1,
    );
    # --
    # if error, write it to STDERR
    # --
    if ($Priority =~ /error/i) {
        printf STDERR "ERROR: $Self->{LogPrefix} Perl: %vd OS: $^O Time: ".localtime()."\n\n", $^V;

        print STDERR "  Message: $Message\n\n";
        print STDERR "  Traceback ($$): \n";
        foreach (0...8) {
            my ($Package1, $Filename1, $Line1, $Subroutine1) = caller($Caller+$_);
            my ($Package2, $Filename2, $Line2, $Subroutine2) = caller($Caller+1+$_);
            if (!$Subroutine2) {
                $Subroutine2 = $0;
            }
            print STDERR "    Module: $Subroutine2 Line: $Line1\n" if ($Line1);
        }
        print STDERR "\n";
    }
    # --
    # write shm cache log
    # --
    if ($Priority !~ /debug/i) {
        my $Data = localtime().";;$Priority;;$Self->{LogPrefix};;$Subroutine2;;$Line1;;$Message;;\n";
        my $String = $Self->GetLog();
        shmwrite($Self->{Key}, $Data.$String, 0, $Self->{IPCSize}) || die $!;
    }
    return 1;
}
# --
sub Error {
    my $Self = shift;
    my $What = shift;
    return $Self->{Backend}->{Error}->{$What} || ''; 
}
# --
sub GetLog {
    my $Self = shift;
    my $String = '';
    shmread($Self->{Key}, $String, 0, $Self->{IPCSize}) || die "$!";
    return $String;
}
# --

1;
