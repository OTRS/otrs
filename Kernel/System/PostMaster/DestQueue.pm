# --
# Kernel/System/PostMaster/DestQueue.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: DestQueue.pm,v 1.22 2008-04-24 21:48:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PostMaster::DestQueue;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    for (qw(ConfigObject LogObject DBObject ParseObject QueueObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

# GetQueueID
sub GetQueueID {
    my ( $Self, %Param ) = @_;

    my $Queue    = $Self->{ConfigObject}->Get('PostmasterDefaultQueue');
    my %GetParam = %{ $Param{Params} };
    my $QueueID;

    # get all system addresses
    my %SystemAddresses = $Self->{DBObject}->GetTableData(
        Table => 'system_address',
        What  => 'value0, queue_id',
        Valid => 1
    );

    # check possible to, cc and resent-to emailaddresses
    my $Recipient = '';
    for (qw(Cc To Resent-To)) {
        if ( $GetParam{$_} ) {
            if ($Recipient) {
                $Recipient .= ', ';
            }
            $Recipient .= $GetParam{$_};
        }
    }

    # get addresses
    my @EmailAddresses = $Self->{ParseObject}->SplitAddressLine( Line => $Recipient, );

    # check addresses
    for (@EmailAddresses) {
        my $Address = $Self->{ParseObject}->GetEmailAddress( Email => $_ );
        for ( keys %SystemAddresses ) {
            if ( $_ =~ /^\Q$Address\E$/i ) {
                if ( $Self->{Debug} > 1 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "Match email: $_ (QueueID=$SystemAddresses{$_}/MessageID:$GetParam{'Message-ID'})!",
                    );
                }
                $QueueID = $SystemAddresses{$_};
            }
            else {
                if ( $Self->{Debug} > 1 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "Does not match email: $_ (QueueID=$SystemAddresses{$_}/MessageID:$GetParam{'Message-ID'})!",
                    );
                }
            }
        }
    }
    if ( !$QueueID ) {
        return $Self->{QueueObject}->QueueLookup( Queue => $Queue ) || 1;
    }
    return $QueueID;
}

# GetTrustedQueueID
sub GetTrustedQueueID {
    my ( $Self, %Param ) = @_;

    my %GetParam = %{ $Param{Params} };
    my $QueueID;
    my $Queue;

    # if there exists a X-OTRS-Queue header
    if ( $GetParam{'X-OTRS-Queue'} ) {
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message =>
                    "There exists a X-OTRS-Queue header: $GetParam{'X-OTRS-Queue'} (MessageID:$GetParam{'Message-ID'})!",
            );
        }

        # get dest queue
        return $Self->{QueueObject}->QueueLookup( Queue => $GetParam{'X-OTRS-Queue'} );
    }
    return;
}

1;
