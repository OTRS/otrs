# --
# Kernel/System/Log.pm - log wapper 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Log.pm,v 1.14 2003-02-08 15:09:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log;
use IPC::SysV qw(IPC_PRIVATE IPC_RMID S_IRWXU);

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # --
    # get config object 
    # --
    if (!$Param{ConfigObject}) {
        die "Got no ConfigObject!"; 
    }
    # --
    # check log prefix 
    # --
    $Self->{LogPrefix} = $Param{LogPrefix} || '?LogPrefix?';
    $Self->{LogPrefix} .= '-'.$Param{ConfigObject}->Get('SystemID');
    # --
    # load log backend
    # --
    my $GenericModule = $Param{ConfigObject}->Get('LogModule')
      || 'Kernel::System::Log::SysLog';
    if (!eval "require $GenericModule") {
        die "Can't load log backend module $GenericModule! $@";
    }
    # --
    # create backend handle
    # --
    $Self->{Backend} = $GenericModule->new(%Param);
    # --
    # ipc stuff
    # --
    $Self->{SystemID} = $Param{ConfigObject}->Get('SystemID');
    $Self->{IPCKey} = "444423$Self->{SystemID}";
    $Self->{IPCSize} = 4*1024;
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
        for (my $i = 0; $i < 12; $i++) {
            my ($Package1, $Filename1, $Line1, $Subroutine1) = caller($Caller+$i);
            my ($Package2, $Filename2, $Line2, $Subroutine2) = caller($Caller+1+$i);
            # if there is no caller module use the file name
            if (!$Subroutine2) {
                $Subroutine2 = $0;
            }
            # print line if upper caller module exists
            if ($Line1) {
                print STDERR "    Module: $Subroutine2 Line: $Line1\n";
            }
            # return if there is no upper caller module
            if (!$Line2) {
                $i = 12;
            }
        }
        print STDERR "\n";
        # --
        # store data (for the frontend)
        # --
        $Self->{Error}->{Message} = $Message;
        $Self->{Error}->{Subroutine} = $Subroutine2;
        $Self->{Error}->{Line} = $Line1;
        $Self->{Error}->{Version} = eval("\$$Package1". '::VERSION');
    }
    # --
    # write shm cache log
    # --
    if ($Priority !~ /debug/i) {
        $Priority = lc($Priority);
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
    return $Self->{Error}->{$What} || ''; 
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
