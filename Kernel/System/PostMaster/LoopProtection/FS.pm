# --
# Kernel/System/PostMaster/LoopProtection/FS.pm - backend module of LoopProtection
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FS.pm,v 1.3.2.1 2003-06-01 19:19:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::LoopProtection::FS;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # --
    # get needed  objects
    # --
    foreach (qw(DBObject LogObject ConfigObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # --
    # get config options
    # --
    $Self->{LoopProtectionLog} = $Self->{ConfigObject}->Get('LoopProtectionLog') 
        || die 'No Config option "LoopProtectionLog"!';

    $Self->{PostmasterMaxEmails} = $Self->{ConfigObject}->Get('PostmasterMaxEmails')
        || 40;
    # --
    # create logfile name
    # --
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

    # --
    # write log
    # --
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

    # --
    # check existing logfile
    # --
    if (! open (DATA, "< $Self->{LoopProtectionLog}")) {
      # --
      # create new log file
      # --
      open (DATA, "> $Self->{LoopProtectionLog}") || 
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "LoopProtection!!! Can't create '$Self->{LoopProtectionLog}': $!! ",
        );
      close (DATA);
    }
    else {
      # --
      # open old log file
      # --
      while (<DATA>) {
        my @Data = split(/;/, $_);
        if ($Data[0] eq "$To") {
            $Count++;
        }
      }
      close (DATA);
    }

    # --
    # check possible loop
    # --
    if ($Count >= $Self->{PostmasterMaxEmails}) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "LoopProtection!!! Send no more emails to '$To'! Max. count of $Count has been reached!",
        );
        return;
    }
    else {
#        $Self->{LogObject}->Log(
#          Priority => 'notice',
#          Message => "Sent email to '$To'! The count is '$Count' today!",
#        );
        return 1;
    }
}
# --

1;
