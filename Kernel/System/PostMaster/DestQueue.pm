# --
# Kernel/System/PostMaster/DestQueue.pm - sub part of PostMaster.pm
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DestQueue.pm,v 1.3 2002-07-13 12:25:45 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::DestQueue;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
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

    # get parse object
    $Self->{ParseObject} = $Param{ParseObject} || die 'Got no ParseObject!';

    # get config object
    $Self->{ConfigObject} = $Param{ConfigObject} || die 'Got no ConfigObject!';

    return $Self;
}
# --
# GetQueueID
sub GetQueueID {
    my $Self = shift;
    my %Param = @_;
    my $ParseObject = $Self->{ParseObject};
    my $DBObject = $Self->{DBObject};
    my $Queue = $Self->{ConfigObject}->Get('DefaultQueue');
    my $GetParamTmp = $Param{Params};
    my %GetParam = %$GetParamTmp;
    my $QueueID;
# get all addresses
    my %SystemAddresses = $DBObject->GetTableData(
        Table => 'system_address',
        What => 'value0, queue_id',
        Valid => 1
    );
# check possible to and cc emailaddresses
    my @EmailAddresses = $ParseObject->SplitAddressLine(Line => $GetParam{To} .",". $GetParam{Cc});
    foreach (@EmailAddresses) {
        my $Address = $ParseObject->GetEmailAddress(Email => $_);
        foreach (keys %SystemAddresses) {
            if ($_ =~ /$Address/i) {
                if ($Self->{Debug} > 0) {
                    print STDERR "* matched email: $_ (QueueID=$SystemAddresses{$_})\n";
                }
                $QueueID = $SystemAddresses{$_};
            }
            else {
                if ($Self->{Debug} > 0) {
                    print STDERR "doesn't matched: '$_' != '$Address'\n";
                }
            }
        }
    }

# if there exists a X-OTRS-Queue header
    if ($GetParam{'X-OTRS-Queue'}) {
        if ($Self->{Debug} > 0) {
            print STDERR "* there exists a X-OTRS-Queue header: $GetParam{'X-OTRS-Queue'} " .
            "(QueueID $QueueID now undef)\n";
        }
        $Queue = $GetParam{'X-OTRS-Queue'};
        $QueueID = undef;
    }

# get dest queue
    if (!$QueueID) {
        my $QueueObject = Kernel::System::Queue->new(DBObject => $DBObject);
        $QueueID = $QueueObject->QueueLookup(Queue => $Queue) || 1;
        if ($Self->{Debug} > 0) {
            print STDERR "* make QueueLookup (Queue=$Queue, QueueID=$QueueID)\n";
        }
    }
    return $QueueID;
}
# --

1;
