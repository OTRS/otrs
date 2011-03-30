# --
# Kernel/GenericInterface/Operation/SolMan/ReplicateIncident.pm - GenericInterface SolMan ReplicateIncident operation backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.pm,v 1.7 2011-03-30 09:11:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::SolMan::ReplicateIncident;

use strict;
use warnings;

use MIME::Base64();
use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);
use Kernel::GenericInterface::Operation::SolMan::SolManCommon;
use Kernel::System::Ticket;
use Kernel::System::CustomerUser;
use Kernel::System::User;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::SolMan - GenericInterface SolMan ReplicateIncident Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject)
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

    # create Ticket Object
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    # create CustomerUser Object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    # create CustomerUser Object
    $Self->{UserObject} = Kernel::System::User->new( %{$Self} );

    # create additional objects
    $Self->{SolManCommonObject}
        = Kernel::GenericInterface::Operation::SolMan::SolManCommon->new( %{$Self} );

    return $Self;
}

=item Run()

perform ReplicateIncident Operation. This will return the created ticket number.

    my $Result = $OperationObject->Run(
        Data => {
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
    );

    $Result = {
        Success         => 1,                       # 0 or 1
        ErrorMessage    => '',                      # in case of error
        Data            => {                        # result data payload after Operation
            PrdIctId   => '2011032400001',          # Incident number in the provider (help desk system) / type="n0:char32"
            PersonMaps => {                         # Mapping of person IDs / tns:IctPersonMaps
                Item => {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
            },
            Errors => {                         # should not return errors
                item => {
                    ErrorCode => '01'
                    Val1      =>  'Error Description',
                    Val2      =>  'Error Detail 1',
                    Val3      =>  'Error Detail 2',
                    Val4      =>  'Error Detail 3',

                },
            },
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # we need Data
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no Data' );
    }

    # check needed data
    for my $Key (qw(IctHead)) {
        if ( !IsHashRefWithData( $Param{Data}->{$Key} ) ) {
            return $Self->{DebuggerObject}->Error( Summary => "Got no Data->$Key" );
        }
    }
    for my $Key (qw(IctId IctTimestamp)) {
        if ( !IsStringWithData( $Param{Data}->{$Key} ) ) {
            return $Self->{DebuggerObject}->Error( Summary => "Got no Data->$Key" );
        }
    }

    return $Self->{SolManCommonObject}->TicketSync(%Param);
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

$Revision: 1.7 $ $Date: 2011-03-30 09:11:24 $

=cut
