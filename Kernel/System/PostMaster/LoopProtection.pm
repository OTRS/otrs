# --
# LoopProtection.pm - sub module of Postmaster.pm
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LoopProtection.pm,v 1.1 2001-12-30 00:33:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::LoopProtection;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    $Self->{Debug} = 0;

    # get db object
    $Self->{DBObject} = $Param{DBObject} || die 'Got no DBObject!';

    # get LogObject
    $Self->{LogObject} = $Param{LogObject} || die 'Got no LogObject!';

    # get config object
    $Self->{ConfigObject} = $Param{ConfigObject} || die 'Got no ConfigObject!';

    $Self->{LoopProtectionLog} = $Self->{ConfigObject}->Get('LoopProtectionLog') 
        || die 'No Config option "LoopProtectionLog"!';

    $Self->{MaxPostMasterEmails} = $Self->{ConfigObject}->Get('MaxPostMasterEmails')
        || die 'No Config option "MaxPostMasterEmails"!';

    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = localtime(time);
    $Year=$Year+1900;
    $Month++;

    $Self->{LoopProtectionLog} .= '-'.$Year.'-'.$Month.'-'.$Day.'.log';    

    return $Self;
}
# --
sub SendEmail {
    my $Self = shift;
    my %Param = @_;
    my $To = $Param{To} || return;

    open (DATA, ">> $Self->{LoopProtectionLog}") || die "Can't open $Self->{LoopProtectionLog}: $!";
    print DATA "$To;".localtime().";\n";
    close (DATA);   
 
    return 1;
}
# -- 
sub Check {
    my $Self = shift;
    my %Param = @_;
    my $To = $Param{To} || return;
    my $Count = 0;
 
    # FIXME
    open (DATA, "< $Self->{LoopProtectionLog}") || 
        $Self->{LogObject}->Log(
          Priority => 'error',
          MSG => "LoopProtection!!! Can't open'$Self->{LoopProtectionLog}': $!! ",
        );

    while (<DATA>) {
        my @Data = split(/;/, $_);
        if ($Data[0] eq "$To") {
            $Count++;
        }
    }
    close (DATA);

    if ($Count >= $Self->{MaxPostMasterEmails}) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          MSG => "LoopProtection!!! Send no more emails to '$To'! Max. count of $Count has been reached! ",
        );
        return;
    }
    else {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "Sent email to '$To'! The count is '$Count' today! ",
        );
        return 1;
    }
}
# --

1;
