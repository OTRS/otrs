# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSession;

use strict;
use warnings;

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

    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $WantSessionID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'WantSessionID' ) || '';

    # ------------------------------------------------------------ #
    # kill session id
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Kill' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $SessionObject->RemoveSessionID( SessionID => $WantSessionID );
        return $LayoutObject->Redirect( OP => "Action=AdminSession" );
    }

    # ------------------------------------------------------------ #
    # kill all session id
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'KillAll' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $SessionObject->CleanUp();
        return $LayoutObject->Redirect( OP => "Action=AdminSession" );
    }

    # ------------------------------------------------------------ #
    # Detail View
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Detail' ) {

        # Get data for session ID
        my %Data = $SessionObject->GetSessionIDData( SessionID => $WantSessionID );

        if ( !%Data ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "No Session Data for Session ID $WantSessionID",
                Priority => 'error',
            );
        }

        $Data{SessionID} = $WantSessionID;

        # create blocks
        $LayoutObject->Block(
            Name => 'ActionList',
        );
        $LayoutObject->Block(
            Name => 'ActionOverview',
        );
        $LayoutObject->Block(
            Name => 'ActionKillSession',
            Data => {%Data},
        );

        $LayoutObject->Block(
            Name => 'DetailView',
            Data => {%Data},
        );

        KEY:
        for my $Key ( sort keys %Data ) {
            if ( ($Key) && ( defined( $Data{$Key} ) ) && $Key ne 'SessionID' ) {
                if ( $Key =~ /^_/ ) {
                    next KEY;
                }
                if ( $Key =~ /Password|Pw/ ) {
                    $Data{$Key} = 'xxxxxxxx';
                }
                else {
                    $Data{$Key} = $LayoutObject->Ascii2Html( Text => $Data{$Key} );
                }
                if ( $Key eq 'UserSessionStart' ) {

                    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
                    my $Age        = int(
                        ( $TimeObject->SystemTime() - $Data{UserSessionStart} )
                        / 3600
                    );
                    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
                        SystemTime => $Data{UserSessionStart},
                    );
                    $Data{$Key} = "$TimeStamp / $Age h ";
                }
                if ( $Key eq 'Config' || $Key eq 'CompanyConfig' ) {
                    $Data{$Key} = 'HASH of data';
                }
                if ( $Data{$Key} eq ';' ) {
                    $Data{$Key} = '';
                }
            }

            if ( $Data{$Key} ) {

                # create blocks
                $LayoutObject->Block(
                    Name => 'DetailViewRow',
                    Data => {
                        Key   => $Key,
                        Value => $Data{$Key},
                    },
                );
            }
        }

        # generate output
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSession',
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # else, show session list
    # ------------------------------------------------------------ #
    else {

        # get all sessions
        my @List     = $SessionObject->GetAllSessionIDs();
        my $Table    = '';
        my $Counter  = @List;
        my %MetaData = ();
        $MetaData{UserSession}         = 0;
        $MetaData{CustomerSession}     = 0;
        $MetaData{UserSessionUniq}     = 0;
        $MetaData{CustomerSessionUniq} = 0;

        $LayoutObject->Block(
            Name => 'Overview',
        );

        for my $SessionID (@List) {
            my $List = '';
            my %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );
            $MetaData{"$Data{UserType}Session"}++;
            if ( !$MetaData{"$Data{UserLogin}"} ) {
                $MetaData{"$Data{UserType}SessionUniq"}++;
                $MetaData{"$Data{UserLogin}"} = 1;
            }

            $Data{UserType} = 'Agent' if ( $Data{UserType} ne 'Customer' );

            # create blocks
            $LayoutObject->Block(
                Name => 'Session',
                Data => {
                    SessionID     => $SessionID,
                    UserFirstname => $Data{UserFirstname},
                    UserLastname  => $Data{UserLastname},
                    UserType      => $Data{UserType},
                },
            );
        }

        # create blocks
        $LayoutObject->Block(
            Name => 'ActionList',
        );
        $LayoutObject->Block(
            Name => 'ActionSummary',
            Data => {
                Counter => $Counter,
                %MetaData
                }
        );

        # generate output
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSession',
            Data         => {
                Counter => $Counter,
                %MetaData
                }
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

1;
