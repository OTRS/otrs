# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSession;

use strict;
use warnings;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject TimeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $WantSessionID = $Self->{ParamObject}->GetParam( Param => 'WantSessionID' ) || '';

    # ------------------------------------------------------------ #
    # kill session id
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Kill' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{SessionObject}->RemoveSessionID( SessionID => $WantSessionID );
        return $Self->{LayoutObject}->Redirect( OP => "Action=AdminSession" );
    }

    # ------------------------------------------------------------ #
    # kill all session id
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'KillAll' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{SessionObject}->CleanUp();
        return $Self->{LayoutObject}->Redirect( OP => "Action=AdminSession" );
    }

    # ------------------------------------------------------------ #
    # Detail View
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Detail' ) {

        # Get data for session ID
        my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $WantSessionID );

        if ( !%Data ) {
            $Self->{LogObject}->Log(
                Message  => "No Session Data for Session ID $WantSessionID",
                Priority => 'error',
            );
        }

        $Data{SessionID} = $WantSessionID;

        # create blocks
        $Self->{LayoutObject}->Block( Name => 'ActionList', );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview', );
        $Self->{LayoutObject}->Block(
            Name => 'ActionKillSession',
            Data => {%Data},
        );

        $Self->{LayoutObject}->Block(
            Name => 'DetailView',
            Data => {%Data},
        );

        for my $Key ( sort keys %Data ) {
            if ( ($Key) && ( defined( $Data{$Key} ) ) && $Key ne 'SessionID' ) {
                if ( $Key =~ /^_/ ) {
                    next;
                }
                if ( $Key =~ /Password|Pw/ ) {
                    $Data{$Key} = 'xxxxxxxx';
                }
                else {
                    $Data{$Key} = $Self->{LayoutObject}->Ascii2Html( Text => $Data{$Key} );
                }
                if ( $Key eq 'UserSessionStart' ) {
                    my $Age
                        = int(
                        ( $Self->{TimeObject}->SystemTime() - $Data{UserSessionStart} )
                        / 3600
                        );
                    my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
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
                $Self->{LayoutObject}->Block(
                    Name => 'DetailViewRow',
                    Data => {
                        Key   => $Key,
                        Value => $Data{$Key},
                    },
                );
            }
        }

        # generate output
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSession',
        );

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # else, show session list
    # ------------------------------------------------------------ #
    else {

        # get all sessions
        my @List     = $Self->{SessionObject}->GetAllSessionIDs();
        my $Table    = '';
        my $Counter  = @List;
        my %MetaData = ();
        $MetaData{UserSession}         = 0;
        $MetaData{CustomerSession}     = 0;
        $MetaData{UserSessionUniq}     = 0;
        $MetaData{CustomerSessionUniq} = 0;

        $Self->{LayoutObject}->Block( Name => 'Overview', );

        for my $SessionID (@List) {
            my $List = '';
            my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );
            $MetaData{"$Data{UserType}Session"}++;
            if ( !$MetaData{"$Data{UserLogin}"} ) {
                $MetaData{"$Data{UserType}SessionUniq"}++;
                $MetaData{"$Data{UserLogin}"} = 1;
            }

            $Data{UserType} = 'Agent' if ( $Data{UserType} ne 'Customer' );

            # create blocks
            $Self->{LayoutObject}->Block(
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
        $Self->{LayoutObject}->Block( Name => 'ActionList', );
        $Self->{LayoutObject}->Block(
            Name => 'ActionSummary',
            Data => {
                Counter => $Counter,
                %MetaData
                }
        );

        # generate output
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSession',
            Data         => {
                Counter => $Counter,
                %MetaData
                }
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
