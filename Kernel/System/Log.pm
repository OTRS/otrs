# --
# Kernel/System/Log.pm - log wapper 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Log.pm,v 1.7 2002-08-13 15:01:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $ ';
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
    if (!$Param{LogPrefix}) {
        $Param{LogPrefix} = '?LogPrefix?';
    }
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

    return $Self;
}
# --
sub Log { 
    my $Self = shift;
    my %Param = @_;
    $Self->{Backend}->Log(%Param);
    return 1;
}
# --
sub Error {
    my $Self = shift;
    my $What = shift;
    return $Self->{Backend}->{Error}->{$What} || ''; 
}
# --
1;

