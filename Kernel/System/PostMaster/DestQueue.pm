# --
# Kernel/System/PostMaster/DestQueue.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::DestQueue;

use strict;
use warnings;

use Kernel::System::SystemAddress;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    for (qw(ConfigObject LogObject DBObject ParserObject QueueObject EncodeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SystemAddressObject} = Kernel::System::SystemAddress->new(%Param);

    return $Self;
}

# GetQueueID
sub GetQueueID {
    my ( $Self, %Param ) = @_;

    # get email headers
    my %GetParam = %{ $Param{Params} };

    # check possible to, cc and resent-to emailaddresses
    my $Recipient = '';
    for my $Key (qw(Resent-To Envelope-To To Cc Delivered-To X-Original-To)) {
        next if !$GetParam{$Key};
        if ($Recipient) {
            $Recipient .= ', ';
        }
        $Recipient .= $GetParam{$Key};
    }

    # get addresses
    my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine( Line => $Recipient );

    # check addresses
    my $QueueID;
    for my $Email (@EmailAddresses) {
        next if !$Email;
        my $Address = $Self->{ParserObject}->GetEmailAddress( Email => $Email );
        next if !$Address;

        # lookup queue id if recipiend address
        $QueueID = $Self->{SystemAddressObject}->SystemAddressQueueID(
            Address => $Address,
        );

        # debug
        if ( $Self->{Debug} > 1 ) {
            if ($QueueID) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message =>
                        "Match email: $Email to QueueID $QueueID (MessageID:$GetParam{'Message-ID'})!",
                );
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Does not match email: $Email (MessageID:$GetParam{'Message-ID'})!",
                );
            }
        }
        last if $QueueID;
    }

    # if no queue id got found, lookup postmaster queue id
    if ( !$QueueID ) {
        my $Queue = $Self->{ConfigObject}->Get('PostmasterDefaultQueue');
        return $Self->{QueueObject}->QueueLookup( Queue => $Queue ) || 1;
    }
    return $QueueID;
}

# GetTrustedQueueID
sub GetTrustedQueueID {
    my ( $Self, %Param ) = @_;

    # get email headers
    my %GetParam = %{ $Param{Params} };

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
