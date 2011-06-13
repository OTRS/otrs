# --
# Kernel/Output/HTML/PostOutputNFonAutoTimeAccounting.pm
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: PostOutputNFonAutoTimeAccounting.pm,v 1.5 2011/06/13 06:12:59 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PostOutputNFonAutoTimeAccounting;

use strict;
use warnings;

use Kernel::System::NFonAutoTimeAccountingTrafficLights;
use Kernel::System::Ticket;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (qw(ConfigObject MainObject LogObject LayoutObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{RefreshTimeSeconds} = int(
        $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPost')
            ->{PostOutputNFonAutoTimeAccounting}->{RefreshTimeSeconds} || 10
    );

    # traffic light stuff
    $Self->{TrafficLightsObject} = Kernel::System::NFonAutoTimeAccountingTrafficLights->new(%Param);
    $Self->{TicketObject}        = Kernel::System::Ticket->new( %{$Self} );

    $Self->{DefaultYellowTime}
        = $Self->{ConfigObject}->Get('NFon::AutoTimeAccounting::TrafficLight::YellowTimeDefault')
        || 2;
    $Self->{DefaultRedTime}
        = $Self->{ConfigObject}->Get('NFon::AutoTimeAccounting::TrafficLight::RedTimeDefault') || 6;

    $Self->{Action} = $Self->{ParamObject}->GetParam( Param => 'Action' );
    $Self->{TicketID} = $Self->{ParamObject}->GetParam( Param => 'TicketID' ) || '';
    $Self->{ArticleTypes}
        = $Self->{ConfigObject}->Get('NFon::AutoTimeAccounting::TrafficLight::ArticleTypes');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Data} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Data!' );
        $Self->{LayoutObject}->FatalDie();
    }

    $Self->InjectAutoTimeUnits(%Param);
    $Self->InjectAutoLogonTime(%Param);
    $Self->InjectAutoTrafficLight(%Param);

    return;
}

sub InjectAutoTimeUnits {
    my ( $Self, %Param ) = @_;

    # Only work on pages which have the TimeUnits field.
    return 1 if ${ $Param{Data} } !~ m{ [ ] id="TimeUnitsServerError"}smx;

    # Only work if the injection was not yet made.
    return 1 if ${ $Param{Data} } =~ m{[ ] id="NFonAutoTimeAccountingTimeUnitsPause"}smx;

    my $PauseInformationText
        = $Self->{LayoutObject}->{LanguageObject}->Get('You are currently in "pause" mode.');

    my $PauseText  = $Self->{LayoutObject}->{LanguageObject}->Get('Pause');
    my $ResumeText = $Self->{LayoutObject}->{LanguageObject}->Get('Resume');

    my $Injection = <<"EOF";
<span class="FieldExplanation" id="NFonAutoTimeAccountingTimeUnitsStatus"></span>
<button type="button" id="NFonAutoTimeAccountingTimeUnitsPause" value="Pause">$PauseText</button>
<span class="Error Hidden NFonAutoTimeAccountingPauseInformation">$PauseInformationText</span>

<!-- dtl:js_on_document_complete -->
Core.Config.Set('NFonAutoTimeAccounting.Localization', {
    PauseText:  '$PauseText',
    ResumeText: '$ResumeText'
});
Core.Agent.NFonAutoTimeAccounting.Init($Self->{RefreshTimeSeconds});
<!-- dtl:js_on_document_complete -->
EOF

    ${ $Param{Data} } =~ s{
        (<div [ ] id="TimeUnitsServerError".*?</div>)
    }{$1$Injection}smx;

    return;
}

sub InjectAutoLogonTime {
    my ( $Self, %Param ) = @_;

    # Only work on pages which have the TimeUnits field.
    return 1 if ${ $Param{Data} } !~ m{ [ ] id="UserInfo"}smx;

    # Only work if the injection was not yet made.
    return 1 if ${ $Param{Data} } =~ m{[ ] id="NFonAutoTimeAccountingLogonTimeStatus"}smx;

    my $LogonText
        = $Self->{LayoutObject}->{LanguageObject}->Get('Logon time');

    my $PauseInformationText
        = $Self->{LayoutObject}->{LanguageObject}->Get('You are currently in "pause" mode.');

    my $PauseText  = $Self->{LayoutObject}->{LanguageObject}->Get('Pause');
    my $ResumeText = $Self->{LayoutObject}->{LanguageObject}->Get('Resume');

    my $Injection = <<"EOF";
<div class="SpacingTop">
    $LogonText: <span id="NFonAutoTimeAccountingLogonTimeStatus">00:00:00</span>
    <button type="button" id="NFonAutoTimeAccountingLogonTimePause" value="Pause">$PauseText</button>
</div>
<div class="Error Hidden NFonAutoTimeAccountingPauseInformation">$PauseInformationText</div>

<!-- dtl:js_on_document_complete -->
Core.Config.Set('NFonAutoTimeAccounting.Localization', {
    PauseText:  '$PauseText',
    ResumeText: '$ResumeText'
});
Core.Agent.NFonAutoTimeAccounting.Init($Self->{RefreshTimeSeconds});
<!-- dtl:js_on_document_complete -->
EOF

    ${ $Param{Data} } =~ s{
        (<div [ ] id="UserInfo".*?)</div>
    }{$1$Injection</div>}smx;

    return;
}

sub InjectAutoTrafficLight {
    my ( $Self, %Param ) = @_;

    # Only work on pages which have the TimeUnits field.
    return 1 if ${ $Param{Data} } !~ m{ [ ] id="TimeUnitsServerError"}smx;

    # Only work if the injection was not yet made.
    return 1 if ${ $Param{Data} } =~ m{[ ] id="CurrentTrafficLight"}smx;

    # only work if a TicketID is present
    return 1 if !$Self->{TicketID};

    my $MatchedAction = '';
    for my $ArticleType ( keys %{ $Self->{ArticleTypes} } ) {
        my @Actions = split( ',', $Self->{ArticleTypes}{$ArticleType} );
        for my $Key (@Actions) {
            $MatchedAction = $ArticleType
                if ( $Self->{Action} eq $Key );
        }
    }

    # only work with registered screens
    return 1 if !$MatchedAction;

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # get traffic light information
    my %TrafficLight = $Self->{TrafficLightsObject}->Get(
        SystemComponent => $Ticket{TicketFreeText1},
        TicketTypeID    => $Ticket{TypeID},
        ArticleType     => $MatchedAction,
    );

    my $PauseInformationText
        = $Self->{LayoutObject}->{LanguageObject}->Get('You are currently in "pause" mode.');
    my $ImgPath    = $Self->{ConfigObject}->Get('Frontend::ImagePath');
    my $YellowTime = $TrafficLight{YellowTime} || $Self->{DefaultYellowTime};
    my $RedTime    = $TrafficLight{RedTime} || $Self->{DefaultRedTime};

    my $GreenImage  = $ImgPath . "traffic_light_green.png";
    my $RedImage    = $ImgPath . "traffic_light_red.png";
    my $YellowImage = $ImgPath . "traffic_light_yellow.png";
    my $GrayImage   = $ImgPath . "traffic_light_gray.png";

    my $Injection = <<"EOF";
<span class="TrafficLightsContent">
<img src="$GreenImage" class="Traffic GreenLight"/>
<img src="$RedImage" class="Traffic RedLight Hidden"/>
<img src="$YellowImage" class="Traffic YellowLight Hidden"/>
<img src="$GrayImage" class="Traffic GrayLight Hidden"/>
<input type="hidden" id="CurrentTrafficLight" value="GreenLight">
</span>
<!-- dtl:js_on_document_complete -->
Core.Config.Set('YellowTime', '$YellowTime');
Core.Config.Set('RedTime', '$RedTime');
<!-- dtl:js_on_document_complete -->
EOF

    ${ $Param{Data} } =~ s{
        (<div [ ] id="TimeUnitsServerError".*?</div>)
    }{$1$Injection}smx;

    return;
}

1;
