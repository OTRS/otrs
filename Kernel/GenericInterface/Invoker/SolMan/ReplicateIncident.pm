# --
# Kernel/GenericInterface/Invoker/SolMan/ReplicateIncident.pm - GenericInterface SolMan ReplicateIncident Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.pm,v 1.42 2011-04-14 01:24:15 cr Exp $
# $OldId: ReplicateIncident.pm,v 1.7 2011/03/24 06:06:29 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::ReplicateIncident;

use strict;
use warnings;

use Kernel::GenericInterface::Invoker::SolMan::Common;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.42 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::ReplicateIncident - GenericInterface SolMan
ReplicateIncident Invoker backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Invoker->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (
        qw(
        DebuggerObject MainObject ConfigObject EncodeObject
        LogObject TimeObject DBObject WebserviceID
        )
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{SolManCommonObject} = Kernel::GenericInterface::Invoker::SolMan::Common->new(
        %{$Self},
        Invoker      => 'ReplicateIncident',
        WebserviceID => $Self->{WebserviceID},
    );

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        Data     => {
            TicketID => 123                     # mandatory
        }
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '...',               # in case of error or undef
        Data            => {                    # data payload after Invoker or undef
            IctAdditionalInfos  => {},
            IctAttachments      => {},
            IctHead             => {},
            IctId               => '',  # type="n0:char32"
            IctPersons          => {},
            IctSapNotes         => {},
            IctSolutions        => {},
            IctStatements       => {},
            IctTimestamp        => '',  # type="n0:decimal15.0"
            IctUrls             => {},
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    my $Response =  $Self->{SolManCommonObject}->PrepareRequest(
        %Param,
    );

    return $Response;
}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $ReturnData = $InvokerObject->HandleResponse(
        %Param,
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            PersonMaps => [
                {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
                {
                    PersonId    => '0002',
                    PersonIdExt => '5051',
                },
            ],
            PrdIctId   => '0000000000001',
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    my $ReturnData = $Self->{SolManCommonObject}->HandleResponse(
        %Param,
    );

    return $ReturnData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.42 $ $Date: 2011-04-14 01:24:15 $

=cut
