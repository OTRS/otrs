# --
# Kernel/GenericInterface/Invoker/SolMan/ReplicateIncident.pm - GenericInterface SolMan ReplicateIncident Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.pm,v 1.1 2011-03-18 19:50:34 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::ReplicateIncident;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
        LogObject TimeObject DBObject
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

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        Data => { }
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # we need a ID
    if ( !IsStringWithData( $Param{Data}->{TicketID} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no TicketID' );
    }
    my $TicketID = $Param{Data}->{TicketID};

    use Kernel::System::Ticket;
    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
    );

    # get ticket data
    my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID );

    #print STDERR $Ticket{TicketID} . " ti \n";
    # compare TicketNumber from Param and from DB
    if ( $TicketID ne $Ticket{'TicketID'} ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Error getting Ticket Data' );
    }

    #    # check all needed stuff about ticket
    #    # ( permissions, locked, etc . . . )

    #    # request SystemGuid
    #    my $RequesterSystemGuid  = Kernel::GenericInterface::Requester->new( %{$Self} );
    #    my RequestSolManSystemGuid = $RequesterSystemGuid->Run(
    #        WebserviceID => $Self->{WebserviceID},
    #        Invoker      => 'RequestSystemGuid',
    #        Data         => {},
    #    );

    my %DataForReturn;
    return {
        Success => 1,
        Data    => \%DataForReturn,
    };
}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            SystemGuid => 123ABC123ABC123ABC123ABC123ABC12
            Errors     => {
                item => {
                    ErrorCode => '01'
                    Val1      =>  'Error Description',
                    Val2      =>  'Error Detail 1',
                    Val3      =>  'Error Detail 2',
                    Val4      =>  'Error Detail 3',

                }
            }
        },
    );

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            SystemGuid => 123ABC123ABC123ABC123ABC123ABC12
            Errors     => {
                item => [
                    {
                        ErrorCode => '01'
                        Val1      =>  'Error Description',
                        Val2      =>  'Error Detail 1',
                        Val3      =>  'Error Detail 2',
                        Val4      =>  'Error Detail 3',
                    },
                    {
                        ErrorCode => '04'
                        Val1      =>  'Error Description',
                        Val2      =>  'Error Detail 1',
                        Val3      =>  'Error Detail 2',
                        Val4      =>  'Error Detail 3',
                    },
                ],
            }
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            SystemGuid => 123ABC123ABC123ABC123ABC123ABC12
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # break early if response was not successfull
    if ( !$Param{ResponseSuccess} ) {
        return {
            Success      => 0,
            ErrorMessage => 'Invoker ReplicateIncident: Response failure!',
        };
    }

    # to store data
    my $Data = $Param{Data};

    # if there was an error in the response, forward it
    if ( IsHashRefWithData( $Data->{Errors} ) ) {

        # to store the error message(s)
        my $ErrorMessage;

        # to store each error item
        my @ErrorItems;

        # check for multimple errors
        if ( IsArrayRefWithData( $Data->{Errors}->{item} ) ) {

            # get all errors
            for my $Item ( @{ $Param{Errors}->{Item} } ) {
                if ( IsHashRefWithData($Item) ) {
                    push @ErrorItems, $Item;
                }
            }
        }

        # only one error
        elsif ( IsHashRefWithData( $Data->{Errors}->{item} ) ) {
            push @ErrorItems, $Data->{Errors}->{item};
        }

        if ( scalar @ErrorItems gt 0 ) {

            # cicle trough all error items
            for my $Item (@ErrorItems) {

                # check error code
                if ( IsStringWithData( $Item->{ErrorCode} ) ) {
                    $ErrorMessage .= "Error Code $Item->{ErrorCode} ";
                }
                else {
                    $ErrorMessage .= 'An error message was received but no Error Code found! ';
                }

                # set the erros description
                if ( IsStringWithData( $Item->{Val1} ) ) {
                    $ErrorMessage .= "$Item->{Val1} ";
                }
                $ErrorMessage .= 'Details: ';

                # cicle trough all details
                for my $Val qw(Val2 Val2 Val3) {
                    if ( IsStringWithData( $Item->{"$Val"} ) ) {
                        $ErrorMessage .= "$Item->{$Val}  ";
                    }
                }

                $ErrorMessage .= " | ";
            }
        }

        # write in debug log
        $Self->{DebuggerObject}->Error(
            Summary => 'ReplicateIncident return error',
            Data    => $ErrorMessage,
        );

        return {
            Success => 1,
            Data    => \$ErrorMessage,
        };
    }

    # we need a SystemGuid
    if ( !IsStringWithData( $Param{Data}->{SystemGuid} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no Guid!' );
    }

    # prepare SystemGuid
    my %ReturnData = (
        SystemGuid => $Param{Data}->{SystemGuid},
    );

    # write in debug log
    $Self->{DebuggerObject}->Info(
        Summary => 'ReplicateIncident return success',
        Data    => \%ReturnData,
    );

    return {
        Success => 1,
        Data    => \%ReturnData,
    };
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

$Revision: 1.1 $ $Date: 2011-03-18 19:50:34 $

=cut
