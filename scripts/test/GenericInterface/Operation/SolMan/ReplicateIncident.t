# --
# ReplicateIncident.t - RequestSystemGuid Operation tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.t,v 1.7 2011-03-29 08:52:35 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use MIME::Base64 ();

return 1;

use Kernel::System::Ticket;

my $TicketObject = Kernel::System::Ticket->new( %{$Self} );

my %PrioritySolMan2OTRS = (
    1 => '1: very high',
    2 => '2: high',
    3 => '3: normal',
    4 => '4: low',
);

my @Tests = (
    {
        Name    => 'No data',
        Success => 0,
    },
    {
        Name    => 'Wrong data (arrayref)',
        Success => 0,
        Data    => [],
    },
    {
        Name    => 'Correct structure, no data',
        Success => 0,
        Data    => {
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
    {
        Name    => 'Correct structure',
        Success => 1,
        Data    => {
            IctAdditionalInfos => {},
            IctAttachments     => {
                item => [
                    {

                        # Unique ID of attachment suggestion: TicketID-ArticleID-AttachmentID),
                        #   max. 32 characters
                        AttachmentGuid => '2011032510000001-1-1',

                        # attachment name - optional when deleting the attachment
                        Filename => 'test.txt',

                        # optional: attachment mime type without charset information
                        MimeType => 'text/plain',

                        # base64 encoded content - optional when deleting the attachment
                        Data => 'ZWluIHRlc3Qgw6TDtsO8w5/DhMOWw5zigqw=',

                        # optional: timestamp of attachment creation - Format YYYYMMDDhhmmss
                        Timestamp => '20110324000000',

                        # person who added/removed the attachment
                        PersonId => 1,

                        # optional: url that allows to display the attachment
                        # FIXME not sure what this actually does
                        Url => 'http://localhost',

                        # optional: Language of attachment FIXME not sure if this affects anything
                        Language => 'de',

                        # empty value or a single space indicates an addition, everything else
                        #   (single character allowed) indicates an attachment deletion
                        Delete => '',
                    },
                ],
            },
            IctHead => {

                # required: OTRS ticket number
                IncidentGuid => '',

                # required: OTRS-system GUID
                RequesterGuid => 'D3D9446802A44259755D38E6D163E820',

                # required: SolMan-system GUID
                ProviderGuid => 'DE86768CD3D015F181D0001438BF50C6',

                # optional: id of OTRS ticket owner
                AgentId => 1,

                # optional: id of OTRS ticket customer, max. 32 characters
                ReporterId => 'stefan.bedorf@otrs.com',

                # optional: OTRS ticket title, max. 40 characters
                ShortDescription => 'title',

                # optional: SolMan priority id - available id's:
                # 1, 2, 3, 4 (representing '1: very high', '2: high', '3: normal', '4: low')
                Priority => 3,

            # required: communication language of ticket - Format 2 character string e.g. 'de', 'en'
                Language => 'de',

                # required: FIXME - Format YYYYMMDDhhmmss
                RequestedBegin => '20000101000000',

                # required: FIXME - Format YYYYMMDDhhmmss
                RequestedEnd => '20111231235959',
            },
            IctId      => '',
            IctPersons => {
                Item => [

                    # required: id of OTRS agent/customer, max. 32 characters
                    PersonId => 'stefan.bedorf@otrs.com',

         # optional: id of SolMan agent/customer
         # If no SolMan id is provided and the PersonId has not been used in the interface
         # before, a new contact is automatically added in SolMan, using the provided details below.
         # The SolMan id of the new contact will be returned for reference.
         # If the OTRS id has been used, the same SolMan contact will be used,
         # but no further changes of the contact are possible.
                    PersonIdExt => 292,

                    # optional: gender of OTRS agent/custome, consisting of 1 character,
                    #   maybe 'm', 'f' - appears to be unused
                    Sex => 'M',

                    # optional: first name of OTRS agent/customer, max. 40 characters
                    FirstName => 'Stefan',

                    # optional: last name of OTRS agent/customer, max. 40 characters
                    LastName => 'Bedorf',

                    # optional: phone number of OTRS agent/customer
                    Telephone => {

                        # optional: phone number of OTRS agent/customer, max. 30 characters
                        PhoneNo => '+49 9421 56818',

                       # optional: phone number extension of OTRS agent/customer, max. 10 characters
                        PhoneNoExtension => '0',
                    },

                    # optional: mobile phone number of OTRS agent/customer, max. 30 characters
                    MobilePhone => '-',

                    # optional: fax number of OTRS agent/customer
                    Fax => {

                        # optional: fax number of OTRS agent/customer, max. 30 characters
                        FaxNo => '+49 9421 56818',

                        # optional: fax number extension of OTRS agent/customer, max. 10 characters
                        FaxNoExtension => '18',
                    },

                    # optional: email address of OTRS agent/customer, max. 240 characters
                    Email => 'stefan.bedorf@otrs.com',
                ],
            },
            IctSapNotes  => {},
            IctSolutions => {},

            # additional plaintext articles
            IctStatements => {
                item => [
                    {

                        # text type (see list of possible types)
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

                        # optional: create timestamp of article - Format YYYYMMDDhhmmss
                        Timestamp => '20110323000000',

                        # person who added the article
                        PersonId => 1,

                        # optional: Language of article
                        Language => 'de',
                    },
                ],
            },

            # required: FIXME - Format YYYYMMDDhhmmss
            IctTimestamp => '20010101000000',
            IctUrls      => {},
        },
    },
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

# create object
my $OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    OperationType  => 'SolMan::ReplicateIncident',
);

$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() success',
);

TEST:
for my $Test (@Tests) {
    my $Result = $OperationObject->Run(
        Data => $Test->{Data},
    );

    $Self->Is(
        $Result->{Success},
        $Test->{Success},
        "$Test->{Name} success status",
    );

    if ( $Test->{Success} ) {

        # TODO clarify return value correctness
        $Self->True(
            $Result->{PrdIctId},
            "$Test->{Name} returned a ProviderIncidentID",
        );

        $Self->False(
            $Result->{Errors},
            "$Test->{Name} did not yield errors",
        );

        my $TicketID = $TicketObject->TicketIDLookup(
            TicketNumber => $Result->{PrdIctId},
            UserID       => 1,
        );

        $Self->True(
            $TicketID,
            "$Test->{Name} Ticket found",
        );

        my %TicketData = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
            Extended => 1,
        );

        $Self->Is(
            $TicketData{TicketNumber},
            $Result->{PrdIctId},
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

        my @ArticleIDs = $TicketObject->ArticleIndex(
            TicketID => $TicketID,
        );

        TEST_STATEMENT_ITEM:
        for my $TestStatementItem ( @{ $Test->{Data}->{IctStatements}->{item} || [] } ) {

            my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = '20110323000000'
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

            # article was not found.
            $Self->Is(
                '',
                $BodyExpected,
                "$Test->{Name} found plaintext article for IctStatemtent",
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

                        next TEST_ATTACHMENT_ITEM;
                    }
                }
            }

            $Self->Is(
                '',
                $TestAttachmentItem->{Filename},
                "$Test->{Name} Ticket data found attachment",
            );
        }
    }
}
1;
