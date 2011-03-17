# --
# Kernel/GenericInterface/Invoker/SolMan/RequestSystemGuid.pm - GenericInterface SolMan RequestSystemGuid Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: RequestSystemGuid.pm,v 1.2 2011-03-17 19:16:24 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::RequestSystemGuid;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::RequestSystemGuid - GenericInterface SolMan
RequestSystemGuid Invoker backend

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
    for my $Needed (qw(DebuggerObject MainObject TimeObject)) {
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

    # This invoker does not need any data
    my %ReturnData;

    return {
        Success => 1,
        Data    => \%ReturnData,
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
            ErrorMessage => 'Invoker RequestSystemGuid: Response failure!',
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
            Summary => 'RequestSystemGuid return error',
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
        Summary => 'RequestSystemGuid return success',
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

$Revision: 1.2 $ $Date: 2011-03-17 19:16:24 $

=cut
