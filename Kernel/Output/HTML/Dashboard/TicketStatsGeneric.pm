# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Dashboard::TicketStatsGeneric;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if !$Self->{$Needed};
    }

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },

        # Don't cache this globally as it contains JS that is not inside of the HTML.
        CacheTTL => undef,
        CacheKey => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Key      = $LayoutObject->{UserLanguage} . '-' . $Self->{Name};
    my $CacheKey = 'TicketStats' . '-' . $Self->{UserID} . '-' . $Key;

    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'Dashboard',
        Key  => $CacheKey,
    );

    if ( ref $Cache ) {
        return $LayoutObject->Output(
            TemplateFile   => 'AgentDashboardTicketStats',
            Data           => $Cache,
            KeepScriptTags => $Param{AJAX},
        );
    }

    my %Axis = (
        '7Day' => {
            0 => 'Sun',
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
        },
    );

    my $ClosedText     = $LayoutObject->{LanguageObject}->Translate('Closed');
    my $CreatedText    = $LayoutObject->{LanguageObject}->Translate('Created');
    my $StateText      = $LayoutObject->{LanguageObject}->Translate('State');
    my @TicketsCreated = ();
    my @TicketsClosed  = ();
    my @TicketWeekdays = ();
    my $Max            = 0;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    for my $Key ( 0 .. 6 ) {

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        my $TimeNow = $TimeObject->SystemTime();
        if ($Key) {
            $TimeNow = $TimeNow - ( 60 * 60 * 24 * $Key );
        }
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeNow,
        );

        unshift(
            @TicketWeekdays,
            $LayoutObject->{LanguageObject}->Translate( $Axis{'7Day'}->{$WeekDay} )
        );

        my $CountCreated = $TicketObject->TicketSearch(

            # cache search result 30 min
            CacheTTL => 60 * 30,

            # tickets with create time after ... (ticket newer than this date) (optional)
            TicketCreateTimeNewerDate => "$Year-$Month-$Day 00:00:00",

            # tickets with created time before ... (ticket older than this date) (optional)
            TicketCreateTimeOlderDate => "$Year-$Month-$Day 23:59:59",

            CustomerID => $Param{Data}->{UserCustomerID},
            Result     => 'COUNT',

            # search with user permissions
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID => $Self->{UserID},
        );
        if ( $CountCreated && $CountCreated > $Max ) {
            $Max = $CountCreated;
        }
        push @TicketsCreated, $CountCreated;

        my $CountClosed = $TicketObject->TicketSearch(

            # cache search result 30 min
            CacheTTL => 60 * 30,

            # tickets with create time after ... (ticket newer than this date) (optional)
            TicketCloseTimeNewerDate => "$Year-$Month-$Day 00:00:00",

            # tickets with created time before ... (ticket older than this date) (optional)
            TicketCloseTimeOlderDate => "$Year-$Month-$Day 23:59:59",

            CustomerID => $Param{Data}->{UserCustomerID},
            Result     => 'COUNT',

            # search with user permissions
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID => $Self->{UserID},
        );
        if ( $CountClosed && $CountClosed > $Max ) {
            $Max = $CountClosed;
        }
        push @TicketsClosed, $CountClosed;
    }

    unshift(
        @TicketWeekdays,
        $StateText
    );

    my @ChartData = (
        $LayoutObject->{LanguageObject}->Translate('7 Day Stats'),
        \@TicketWeekdays,
        [ $CreatedText, reverse @TicketsCreated ],
        [ $ClosedText, reverse @TicketsClosed ],
    );

    my $ChartDataJSON = $LayoutObject->JSONEncode(
        Data => \@ChartData,
    );

    my %Data = (
        %{ $Self->{Config} },
        Key            => int rand 99999,
        ChartData      => $ChartDataJSON,
    );

    if ( $Self->{Config}->{CacheTTLLocal} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey,
            Value => \%Data,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    my $Content = $LayoutObject->Output(
        TemplateFile   => 'AgentDashboardTicketStats',
        Data           => \%Data,
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
