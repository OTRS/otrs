# --
# Kernel/GenericInterface/Operation/SolMan/ReplicateIncident.pm - GenericInterface SolMan ReplicateIncident operation backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.pm,v 1.5 2011-03-29 12:37:23 martin Exp $
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
use Kernel::System::Ticket;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

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

    # create ticket
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        Title        => $Param{Data}->{IctHead}->{ShortDescription},
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => $Param{Data}->{IctHead}->{ReporterId},
        CustomerUser => $Param{Data}->{IctHead}->{ReporterId},
        OwnerID      => 1,
        UserID       => 1,
    );
    if ( !$TicketID ) {
        return $Self->{DebuggerObject}->Error(
            Summary => $Self->{LogObject}->GetLogEntry(
                Type => 'error',
                What => 'message',
            ),
        );
    }

    # create article
    if ( $Param{Data}->{IctStatements} && $Param{Data}->{IctStatements}->{item} ) {
        my $ArticleID;
        for my $Items ( @{ $Param{Data}->{IctStatements}->{item} } ) {
            next if !$Items;
            next if ref $Items ne 'HASH';
            next if !$Items->{Texts};
            next if ref $Items->{Texts} ne 'HASH';
            next if !$Items->{Texts}->{item};
            next if ref $Items->{Texts}->{item} ne 'ARRAY';
            my $Body = '';
            $Body .= join @{ $Items->{Texts}->{item} };
            my $ArticleIDLocal = $Self->{TicketObject}->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Subject        => 'some short description',
                Body           => $Body,
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                HistoryType    => 'AddNote',
                HistoryComment => 'Update from SolMan!',
                UserID         => 1,
            );
            if ( !$ArticleIDLocal ) {
                return $Self->{DebuggerObject}->Error(
                    Summary => $Self->{LogObject}->GetLogEntry(
                        Type => 'error',
                        What => 'message',
                    ),
                );
            }
            $ArticleID = $ArticleIDLocal;
        }

        # create attachments
        if ( $Param{Data}->{IctAttachments} && $Param{Data}->{IctAttachments}->{item} ) {
            for my $Attachment ( @{ $Param{Data}->{IctAttachments}->{item} } ) {
                my $Success = $Self->{TicketObject}->ArticleWriteAttachment(
                    Content     => MIME::Base64::decode_base64( $Attachment->{Data} ),
                    Filename    => $Attachment->{Filename},
                    ContentType => $Attachment->{MimeType},
                    ArticleID   => $ArticleID,
                    UserID      => 1,
                );
            }
        }
    }

    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # copy data
    my $ReturnData = {
        Errors   => '',
        PrdIctId => $Ticket{TicketNumber},
    };

    # return result
    return {
        Success => 1,
        Data    => $ReturnData,
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

$Revision: 1.5 $ $Date: 2011-03-29 12:37:23 $

=cut
