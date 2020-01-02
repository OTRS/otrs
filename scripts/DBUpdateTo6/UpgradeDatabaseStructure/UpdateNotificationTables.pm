# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::UpdateNotificationTables;    ## no critic

use strict;
use warnings;
use utf8;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::UpdateNotificationTables - perform updates for notification tables

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # Drop table no longer needed since OTRS 5.
        '<TableDrop Name="notifications"/>',
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Add new email delivery failure notification, but only if it hasn't been added already.
    #   This check is done via search for an existing notification for ArticleEmailSendingError event. If a notification
    #   is found, following insert will be skipped.
    $DBObject->Prepare(
        SQL   => "SELECT notification_id FROM notification_event_item WHERE event_value = ?",
        Bind  => [ \'ArticleEmailSendingError' ],
        Limit => 1,
    );

    my $Exists;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Exists = $Row[0];
    }

    if ( !$Exists ) {
        push @XMLStrings,
            '<Insert Table="notification_event">
                <Data Key="name" Type="Quote" Translatable="1">Ticket email delivery failure notification</Data>
                <Data Key="valid_id">1</Data>
                <Data Key="comments" Type="Quote"></Data>
                <Data Key="create_by">1</Data>
                <Data Key="create_time">current_timestamp</Data>
                <Data Key="change_by">1</Data>
                <Data Key="change_time">current_timestamp</Data>
            </Insert>';
    }

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    # Get the ID of just inserted email delivery notification, so additional entries can reference it correctly.
    #   It's safe to use the name here, since there was no chance to change it yet (it has just been inserted).
    #   Using the ID '15' is unsafe, since system might already have additional notifications.
    if ( !$Exists ) {
        $DBObject->Prepare(
            SQL   => "SELECT id FROM notification_event WHERE name = ? AND change_by = 1",
            Bind  => [ \'Ticket email delivery failure notification' ],
            Limit => 1,
        );

        my $NotificationID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $NotificationID = $Row[0];
        }
        return if !$NotificationID;

        @XMLStrings = (
            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">AgentEnabledByDefault</Data>
                <Data Key="event_value" Type="Quote">Email</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">ArticleAttachmentInclude</Data>
                <Data Key="event_value" Type="Quote">0</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">ArticleCommunicationChannelID</Data>
                <Data Key="event_value" Type="Quote">1</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">Events</Data>
                <Data Key="event_value" Type="Quote">ArticleEmailSendingError</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">LanguageID</Data>
                <Data Key="event_value" Type="Quote">en</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">RecipientGroups</Data>
                <Data Key="event_value" Type="Quote">2</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">Recipients</Data>
                <Data Key="event_value" Type="Quote">AgentResponsible</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">Recipients</Data>
                <Data Key="event_value" Type="Quote">AgentOwner</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">TransportEmailTemplate</Data>
                <Data Key="event_value" Type="Quote">Default</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">Transports</Data>
                <Data Key="event_value" Type="Quote">Email</Data>
            </Insert>',

            '<Insert Table="notification_event_item">
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="event_key" Type="Quote">VisibleForAgent</Data>
                <Data Key="event_value" Type="Quote">0</Data>
            </Insert>',

            '<Insert Table="notification_event_message">
                <Data Key="id" Type="AutoIncrement">110</Data>
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="content_type" Type="Quote">text/plain</Data>
                <Data Key="language" Type="Quote">en</Data>
                <Data Key="subject" Type="Quote"><![CDATA[Email Delivery Failure]]></Data>
                <Data Key="text" Type="Quote"><![CDATA[Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

Please note, that the delivery of an email article of [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has failed. Please check the email address of your recipient for mistakes and try again. You can manually resend the article from the ticket if required.

Error Message:
<OTRS_AGENT_TransmissionStatusMessage>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>;ArticleID=<OTRS_AGENT_ArticleID>

-- <OTRS_CONFIG_NotificationSenderName>]]></Data>
            </Insert>',

            '<Insert Table="notification_event_message">
                <Data Key="id" Type="AutoIncrement">111</Data>
                <Data Key="notification_id">' . $NotificationID . '</Data>
                <Data Key="content_type" Type="Quote">text/plain</Data>
                <Data Key="language" Type="Quote">hu</Data>
                <Data Key="subject" Type="Quote"><![CDATA[E-mail kézbesítési hiba]]></Data>
                <Data Key="text" Type="Quote"><![CDATA[Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

Felhívjuk a figyelmét, hogy a(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy e-mail bejegyzésének kézbesítése nem sikerült. Ellenőrizze, hogy nincs-e a címzett e-mail címében hiba, és próbálja meg újra. Kézileg is újraküldheti a bejegyzést a jegyből, ha szükséges.

Hibaüzenet:
<OTRS_AGENT_TransmissionStatusMessage>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>;ArticleID=<OTRS_AGENT_ArticleID>

-- <OTRS_CONFIG_NotificationSenderName>]]></Data>
            </Insert>',
        );

        return if !$Self->ExecuteXMLDBArray(
            XMLArray => \@XMLStrings,
        );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
