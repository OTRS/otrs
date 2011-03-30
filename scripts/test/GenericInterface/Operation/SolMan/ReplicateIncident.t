# --
# ReplicateIncident.t - RequestSystemGuid Operation tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.t,v 1.18 2011-03-30 09:49:51 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

return 1;

use MIME::Base64 ();

use Kernel::System::Ticket;

my $TicketObject = Kernel::System::Ticket->new( %{$Self} );

my %PrioritySolMan2OTRS = (
    1 => '1 very high',
    2 => '2 high',
    3 => '3 normal',
    4 => '4 low',
);

my @Tests = (
    [
        {
            Name      => 'ReplicateIncident without data',
            Operation => 'SolMan::ReplicateIncident',
            Success   => 0,
        },
    ],
    [
        {
            Name      => 'ReplicateIncident with wrong data (arrayref)',
            Operation => 'SolMan::ReplicateIncident',
            Success   => 0,
            Data      => [],
        },
    ],
    [
        {
            Name      => 'ReplicateIncident with correct structure, no data',
            Operation => 'SolMan::ReplicateIncident',
            Success   => 0,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {},
                IctHead            => {},
                IctId              => '',
                IctPersons         => {},
                IctSapNotes        => {},
                IctSolutions       => {},
                IctStatements      => {},
                IctTimestamp       => '',
                IctUrls            => {},
            },
        },
    ],
    [
        {
            Name      => 'ReplicateIncident',
            Operation => 'SolMan::ReplicateIncident',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {
                    item => [
                        {
                            AttachmentGuid => '2011032510000001-1-1',
                            Filename       => 'test.txt',
                            MimeType       => 'text/plain',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => '',
                        },
                    ],
                },
                IctHead => {
                    IncidentGuid     => 'Solman-3476084274',
                    RequesterGuid    => 'D3D9446802A44259755D38E6D163E820',
                    ProviderGuid     => 'DE86768CD3D015F181D0001438BF50C6',
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'title',
                    Priority         => 3,
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctId      => 'Solman-3476084274',
                IctPersons => {
                    Item => [
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'M',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    ],
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => [
                        {
                            TextType => 'SU99',

                            # text lines
                            Texts => {
                                item => [
                                    'a line of text',
                                    'another line',
                                    'multiline
    text
    works too',
                                ],
                            },
                            Timestamp => '20110323000000',
                            PersonId  => 1,
                            Language  => 'de',
                        },
                    ],
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
        {
            Name      => 'AddInfo',
            Operation => 'SolMan::AddInfo',
            Success   => 1,
            Data      => {
                IctAdditionalInfos => {},
                IctAttachments     => {
                    item => [
                        {
                            AttachmentGuid => '2011032510000001-2-1',
                            Filename       => 'test2.bin',
                            MimeType       => 'application/octet-stream',
                            Data           => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',
                            Timestamp      => '20110324000000',
                            PersonId       => 1,
                            Url            => 'http://localhost',
                            Language       => 'de',
                            Delete         => '',
                        },
                    ],
                },
                IctHead => {
                    IncidentGuid     => 'Solman-3476084274',
                    RequesterGuid    => 'D3D9446802A44259755D38E6D163E820',
                    ProviderGuid     => 'DE86768CD3D015F181D0001438BF50C6',
                    AgentId          => 1,
                    ReporterId       => 'stefan.bedorf@otrs.com',
                    ShortDescription => 'title update',
                    Priority         => 2,
                    Language         => 'de',
                    RequestedBegin   => '20000101000000',
                    RequestedEnd     => '20111231235959',
                },
                IctPersons => {
                    Item => [
                        PersonId    => 'stefan.bedorf@otrs.com',
                        PersonIdExt => 292,
                        Sex         => 'M',
                        FirstName   => 'Stefan',
                        LastName    => 'Bedorf',
                        Telephone   => {
                            PhoneNo          => '+49 9421 56818',
                            PhoneNoExtension => '0',
                        },
                        MobilePhone => '-',
                        Fax         => {
                            FaxNo          => '+49 9421 56818',
                            FaxNoExtension => '18',
                        },
                        Email => 'stefan.bedorf@otrs.com',
                    ],
                },
                IctSapNotes   => {},
                IctSolutions  => {},
                IctStatements => {
                    item => [
                        {
                            TextType => 'SU99',

                            # text lines
                            Texts => {
                                item => [
                                    'another',
                                    'note from SolMan',
                                ],
                            },
                            Timestamp => '20110323000000',
                            PersonId  => 1,
                            Language  => 'de',
                        },
                    ],
                },

                IctTimestamp => '20010101000000',
                IctUrls      => {},
            },
        },
    ],
);

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation;
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

TESTCHAIN:
for my $TestChain (@Tests) {

    my @TestTicketIDs;

    $Self->True(
        1,
        '------------ STARTING NEW TEST CHAIN ------------',
    );

    my $LastTicketID;

    TEST:
    for my $Test ( @{$TestChain} ) {

        # create object
        my $OperationObject = Kernel::GenericInterface::Operation->new(
            %{$Self},
            DebuggerObject => $DebuggerObject,
            WebserviceID   => 1,
            OperationType  => $Test->{Operation},
        );

        $Self->Is(
            ref $OperationObject,
            'Kernel::GenericInterface::Operation',
            'Operation::new() success',
        );

        next TEST if ref $OperationObject ne 'Kernel::GenericInterface::Operation';

        my $Result = $OperationObject->Run(
            Data => $Test->{Data},
        );

        $Self->Is(
            $Result->{Success},
            $Test->{Success},
            "$Test->{Name} success status",
        );

        next TEST if !$Test->{Success};

        $Self->False(
            $Result->{Errors},
            "$Test->{Name} did not yield errors",
        );

        # a new ticket was created, remember the data of this
        if ( $Test->{Operation} eq 'SolMan::ReplicateIncident' ) {
            $Self->True(
                $Result->{Data}->{PrdIctId},
                "$Test->{Name} returned a ProviderIncidentID",
            );

            $LastTicketID = $TicketObject->TicketIDLookup(
                TicketNumber => $Result->{Data}->{PrdIctId},
                UserID       => 1,
            );
        }

        $Self->True(
            $LastTicketID,
            "$Test->{Name} Ticket found",
        );

        if ($LastTicketID) {
            push @TestTicketIDs, $LastTicketID;
        }

        my %TicketData = $TicketObject->TicketGet(
            TicketID => $LastTicketID,
            UserID   => 1,
            Extended => 1,
        );

        $Self->Is(
            $TicketData{TicketNumber},
            $Result->{Data}->{PrdIctId},
            "$Test->{Name} Ticket data contains correct TicketNumber",
        );

        $Self->Is(
            $TicketData{Title},
            $Test->{Data}->{IctHead}->{ShortDescription},
            "$Test->{Name} Ticket data contains correct Title",
        );

        $Self->Is(
            $TicketData{Priority},
            $PrioritySolMan2OTRS{ $Test->{Data}->{IctHead}->{Priority} },
            "$Test->{Name} Ticket data contains correct Priority",
        );

        $Self->Is(
            $TicketData{CustomerUserID},
            $Test->{Data}->{IctHead}->{ReporterId},
            "$Test->{Name} Ticket data contains correct customer",
        );

        my @ArticleIDs = $TicketObject->ArticleIndex(
            TicketID => $LastTicketID,
        );

        TEST_STATEMENT_ITEM:
        for my $TestStatementItem ( @{ $Test->{Data}->{IctStatements}->{item} || [] } ) {

            my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $TestStatementItem->{Timestamp}
                =~ m/^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/smx;

            my $BodyExpected
                = "($TestStatementItem->{PersonId}) $Day.$Month.$Year $Hour:$Minute:$Second\n";
            $BodyExpected .= join( "\n", @{ $TestStatementItem->{Texts}->{item} || [] } );

            # try to find current attachment item in Ticket attachments
            ARTICLE_ID:
            for my $ArticleID (@ArticleIDs) {

                my %Article = $TicketObject->ArticleGet(
                    ArticleID => $ArticleID,
                    UserID    => 1,
                );

                if ( $Article{Body} eq $BodyExpected ) {
                    $Self->Is(
                        $Article{Body},
                        $BodyExpected,
                        "$Test->{Name} found plaintext article for IctStatemtent",
                    );

                    next TEST_STATEMENT_ITEM;
                }
            }

            # Article was not found, show error.
            $Self->Is(
                '',
                $BodyExpected,
                "$Test->{Name} found no plaintext article for IctStatemtent",
            );

        }

        TEST_ATTACHMENT_ITEM:
        for my $TestAttachmentItem ( @{ $Test->{Data}->{IctAttachments}->{item} || [] } ) {

            # try to find current attachment item in Ticket attachments
            ARTICLE_ID:
            for my $ArticleID (@ArticleIDs) {

                my %ArticleAttachmentIndex = $TicketObject->ArticleAttachmentIndex(
                    ArticleID => $ArticleID,
                    UserID    => 1,
                );

                # check if the current article has this attachment
                ATTACHMENT_INDEX_ENTRY:
                for my $AttachmentID ( sort keys %ArticleAttachmentIndex ) {
                    if (
                        $ArticleAttachmentIndex{$AttachmentID}->{Filename}
                        eq $TestAttachmentItem->{Filename}
                        )
                    {

                        # Success, attachment found

                        $Self->Is(
                            $ArticleAttachmentIndex{$AttachmentID}->{Filename},
                            $TestAttachmentItem->{Filename},
                            "$Test->{Name} found attachment",
                        );

                        my %Attachment = $TicketObject->ArticleAttachment(
                            ArticleID => $ArticleID,
                            FileID    => $AttachmentID,
                            UserID    => 1,
                        );

                        $Self->Is(
                            $Attachment{Content},
                            MIME::Base64::decode_base64( $TestAttachmentItem->{Data} ),
                            "$Test->{Name} attachment content for $TestAttachmentItem->{Filename}",
                        );

                        $Self->Is(
                            $Attachment{ContentType},
                            $TestAttachmentItem->{MimeType},
                            "$Test->{Name} attachment content type for $TestAttachmentItem->{Filename}",
                        );

                        next TEST_ATTACHMENT_ITEM;
                    }
                }
            }

            # Attachment was not found, show error
            $Self->Is(
                '',
                $TestAttachmentItem->{Filename},
                "$Test->{Name} Ticket data found attachment",
            );
        }

    }    # END TEST

    # delete tickets
    for my $TicketID (@TestTicketIDs) {
        $Self->True(
            $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            ),
            "TicketDelete()",
        );
    }

    $Self->True(
        1,
        '------------ END OF TEST CHAIN ------------',
    );

}    # END TESTCHAIN

1;
