# --
# Kernel/Modules/AdminNFonAutoTimeAccountingTrafficLights.pm - provides a log view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminNFonAutoTimeAccountingTrafficLights.pm,v 1.7 2011/05/19 09:52:03 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminNFonAutoTimeAccountingTrafficLights;

use strict;
use warnings;

use Kernel::System::NFonAutoTimeAccountingTrafficLights;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for (qw(ParamObject EncodeObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{TrafficLightsObject} = Kernel::System::NFonAutoTimeAccountingTrafficLights->new(%Param);

    $Self->{DefaultYellowTime}
        = $Self->{ConfigObject}->Get('NFon::AutoTimeAccounting::TrafficLight::YellowTimeDefault')
        || 2;
    $Self->{DefaultRedTime}
        = $Self->{ConfigObject}->Get('NFon::AutoTimeAccounting::TrafficLight::RedTimeDefault') || 6;

    $Self->{ArticleTypes} = [ 'PhoneIn', 'PhoneOut', 'Email', 'Note' ];

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get parameter from web browser
    my $GetParam = $Self->_GetParams;

    if ( $Self->{Subaction} eq 'ChangeAction' ) {
        return $Self->_UpdateRow(
            GetParam => $GetParam,
            %Param,
        );
    }

    # default: show start screen
    return $Self->_ShowScreen(
        %Param,
    );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # get components
    my %Components = %{ $Self->{ConfigObject}->Get('TicketFreeText1') };

    # get ticket types
    my %TicketTypes = $Self->{TicketObject}->TicketTypeList(
        UserID => $Self->{UserID},
    );

    # get saved values
    my %List    = $Self->{TrafficLightsObject}->GetList();
    my $Counter = 1;
    for my $Component ( keys %Components ) {
        for my $TicketType ( keys %TicketTypes ) {
            my %TimeValues;
            for my $ArticleType ( @{ $Self->{ArticleTypes} } ) {
                my $YellowTime
                    = $List{ $Component . '_' . $TicketType . '_' . $ArticleType }
                    ->{YellowTime} || '';
                my $RedTime
                    = $List{ $Component . '_' . $TicketType . '_' . $ArticleType }
                    ->{RedTime} || '';

                $TimeValues{ $ArticleType . 'YellowTime' } = $YellowTime
                    || $Self->{DefaultYellowTime};
                $TimeValues{ $ArticleType . 'RedTime' } = $RedTime || $Self->{DefaultRedTime};
                $TimeValues{ $ArticleType . 'Time' } = "$YellowTime;$RedTime";
            }
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => {
                    SystemComponent => $Components{$Component},
                    Component       => $Component,
                    TicketTypeID    => $TicketType,
                    TicketType      => $TicketTypes{$TicketType},
                    Counter         => $Counter++,
                    %TimeValues,
                },
            );
        }

    }

    # get ticket
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminNFonAutoTimeAccountingTrafficLights',
        Data         => {
            %Param,
            DefaultYellowTime => $Self->{DefaultYellowTime},
            DefaultRedTime    => $Self->{DefaultRedTime},
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _UpdateRow {
    my ( $Self, %Param ) = @_;

    my $Error        = 0;
    my $ErrorMessage = '';
    my %ReturnValues;
    for my $Type ( @{ $Self->{ArticleTypes} } ) {
        my $YellowTime = $Param{GetParam}->{ $Type . 'YellowTime' };
        my $RedTime    = $Param{GetParam}->{ $Type . 'RedTime' };
        if (
            ( $YellowTime ne '' ) ||
            ( $RedTime ne '' )
            )
        {
            my $Success = $Self->{TrafficLightsObject}->Update(
                SystemComponent => $Param{GetParam}->{Component},
                TicketTypeID    => $Param{GetParam}->{TicketTypeID},
                ArticleType     => $Type,
                YellowTime      => $YellowTime,
                RedTime         => $RedTime,
            );
            if ( !$Success ) {
                $Error = 1;
                $ErrorMessage .= "Error updating " .
                    $Param{GetParam}->{SystemComponent} . ' ' .
                    $Param{GetParam}->{TicketTypeID} . ' ' .
                    $Type . ' ' .
                    $YellowTime . ' ' .
                    $RedTime;
            }
        }
        $ReturnValues{ $Type . 'YellowTime' } = $YellowTime;
        $ReturnValues{ $Type . 'RedTime' }    = $RedTime;
    }

    my $LogData;
    if ( !$Error ) {
        $LogData = {
            Data => {
                Success => 1,
                %ReturnValues,
            },
        };
    }
    else {
        $LogData = {
            Data => {
                Message => $ErrorMessage,
            },
        };
    }

    # build JSON output
    my $JSON = $Self->{LayoutObject}->JSONEncode(
        Data => $LogData,
    );

    # send JSON response
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw(
        SystemComponent Component TicketTypeID TicketType
        PhoneInYellowTime PhoneInRedTime PhoneOutYellowTime PhoneOutRedTime
        EmailYellowTime EmailRedTime NoteYellowTime NoteRedTime
        )
        )
    {
        $GetParam->{$ParamName} =
            $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }
    return $GetParam;
}

1;
