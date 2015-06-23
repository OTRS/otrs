# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::NotificationEvent::Transport::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
);

=head1 NAME

Kernel::System::Ticket::Event::NotificationEvent::Transport::Base - common notification event transport functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item SendNotification()

send a notification using an specified transport

    my $Success = $TransportObject->SendNotification(
        TicketID     => $Param{Data}->{TicketID},
        UserID       => $Param{UserID},
        Notification => \%Notification,
        Recipient    => {
            UserID        => 123,
            UserLogin     => 'some login',
            UserTitle     => 'some title',
            UserFirstname => 'some first name',
            UserLastname  => 'some last name'.
            # ...
        },
        Event                 => $Param{Event},
        Attachments           => \@Attachments,         # optional
    );

returns

    $Success = 1;       # or false in case of an error

=cut

=item GetTransportRecipients()

generates a list of recipients exclusive for a determined transport, the content of the list is
usually an attribute of an Agent or Customer and it depends on each transport

    my @TransportRecipients = $TransportObject->GetTransportRecipients(
        Notification => \%Notification,
    );

returns:

    @TransportRecipents = (
        {
            UserEmail    => 'some email',       # optional
            UserFisrname => 'some name',        # optional
            # ...                               # optional
        }
    );

or
    @TransportRecipients = undef;   in case of an error

=cut

=item TransportSettingsDisplayGet()

generates and returns the HTML code to display exclusive settings for each transport.

    my $HTMLOutput = $TransportObject->TransportSettingsDisplayGet(
        Data => $NotificationDataAttribute,           # as retrieved from Kernel::System::NotificationEvent::NotificationGet()
    );

returns

    $HTMLOuput = 'some HTML code';

=cut

=item TransportParamSettingsGet()

gets specific parameters from the web request and put them back in the GetParam attribute to be
saved in the notification as the standard parameters

    my $Success = $TransportObject->TransportParamSettingsGet(
        GetParam => $ParmHashRef,
    );

returns

    $Success = 1;       # or false in case of a failure

=cut

=item IsUsable();

returns if the transport can be used in the system environment,

    my $Success = $TransportObject->IsUsable();

returns

    $Success = 1;       # or false

=cut

=item GetTransportEventData()

returns the needed event information after a notification has been sent

    my $EventData = $TransportObject-> GetTransportEventData();

returns:

    $EventData = {
        Event => 'ArticleAgentNotification',    # or 'ArticleCustomerNotification'
        Data  => {
            TicketID  => 123,
            ArticleID => 123,                   # optional
        },
        UserID => 123,
    );

=cut

sub GetTransportEventData {
    my ( $Self, %Param ) = @_;

    return $Self->{EventData} // {};
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
