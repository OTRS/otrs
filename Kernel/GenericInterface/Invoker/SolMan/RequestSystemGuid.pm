# --
# Kernel/GenericInterface/Invoker/SolMan/RequestSystemGuid.pm - GenericInterface SolMan RequestSystemGuid Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: RequestSystemGuid.pm,v 1.8 2011-03-31 18:25:21 cr Exp $
# $OldId: RequestSystemGuid.pm,v 1.3 2011/03/19 15:58:03 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::RequestSystemGuid;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Invoker::SolMan::SolManCommon;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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
    for my $Needed (
        qw(
        DebuggerObject MainObject TimeObject ConfigObject EncodeObject
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
    $Self->{SolManCommonObject} = Kernel::GenericInterface::Invoker::SolMan::SolManCommon->new(
        %{$Self}
    );

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.
RequestSystemGuid will return the GUID of the remote solman system.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {}
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => undef,               # can't generate errors
        Data            => {},                  # no data needed for this invoker
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    return {
        Success => 1,
        Data    => {},
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
        ErrorMessage    => '...',               # in case of error or undef
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

    if ( !defined $Data->{Errors} ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Invoker RequestSystemGuid: Response failure!'
                . ' An Error parameter was expected',
        );
    }

    # if there was an error in the response, forward it
    if ( IsHashRefWithData( $Data->{Errors} ) ) {

        my $HandleErrorsResult = $Self->{SolManCommonObject}->HandleErrors(
            Invoker => 'RequestSystemGuid',
            Errors  => $Data->{Errors},
        );

        return {
            Success         => $HandleErrorsResult->{Success},
            ErrorMessage    => $HandleErrorsResult->{ErrorMessage},
        };
    }

    # we need a SystemGuid
    if ( !IsStringWithData( $Data->{SystemGuid} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no SystemGuid!' );
    }

    # prepare SystemGuid
    my %ReturnData = (
        SystemGuid => $Data->{SystemGuid},
    );

    # write in debug log
    $Self->{DebuggerObject}->Info(
        Summary => 'RequestSystemGuid return success',
        Data    => \%ReturnData,
    );

    # set the Remote SystemGuid to the webservice configuration
    $Self->{SolManCommonObject}->SetRemoteSystemGuid(
        WebserviceID => $Self->{WebserviceID},
        SystemGuid   => $Data->{SystemGuid},
        AllInvokers  => 1,
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

$Revision: 1.8 $ $Date: 2011-03-31 18:25:21 $

=cut
