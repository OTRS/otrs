# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::PublicCalendar;

use strict;
use warnings;

use MIME::Base64 qw();
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # check needed parameters
    for my $Needed (qw(CalendarID User Token)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->CustomerErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'No %s!', $Needed ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
    }

    # get user
    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        User  => $GetParam{User},
        Valid => 1,
    );
    if ( !%User ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No such user!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

    # get calendar
    my %Calendar = $CalendarObject->CalendarGet(
        CalendarID => $GetParam{CalendarID},
        UserID     => $User{UserID},
    );

    if ( !%Calendar ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No permission!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    if ( $Calendar{ValidID} != 1 ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Invalid calendar!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # check access token
    my $AccessToken = $CalendarObject->GetAccessToken(
        CalendarID => $GetParam{CalendarID},
        UserLogin  => $GetParam{User},
    );

    if ( $AccessToken ne $GetParam{Token} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Invalid URL!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get iCalendar string
    my $ICalString = $Kernel::OM->Get('Kernel::System::Calendar::Export::ICal')->Export(
        CalendarID => $Calendar{CalendarID},
        UserID     => $User{UserID},
    );

    if ( !$ICalString ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('There was an error exporting the calendar!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # prepare the file name
    my $Filename = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
        Filename => "$Calendar{CalendarName}.ics",
        Type     => 'Attachment',
    );

    # send iCal response
    return $LayoutObject->Attachment(
        ContentType => 'text/calendar',
        Charset     => $LayoutObject->{Charset},
        Content     => $ICalString,
        Filename    => $Filename,
        NoCache     => 1,
    );
}

1;
