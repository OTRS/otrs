# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
                if ( ref $Data{$Key} ) {
                    $Data{$Key} = '[...]';
                }
                elsif ( $Key =~ /^_/ ) {
                    next KEY;
                }
                elsif ( $Key =~ /Password|Pw/ ) {
                    $Data{$Key} = '[xxx]';
                }
                else {
                    $Data{$Key} = $LayoutObject->Ascii2Html( Text => $Data{$Key} );
                }
                if ( $Key eq 'UserSessionStart' ) {

                    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
                    my $Age            = int(
                        ( $DateTimeObject->ToEpoch() - $Data{UserSessionStart} )
                        / 3600
                    );
                    my $TimeStamp = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            Epoch => $Data{UserSessionStart},
                        }
                    )->ToString();
                    $Data{$Key} = "$TimeStamp / $Age h ";
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
            Data         => {
                Action => $Self->{Subaction},
                %Data,
            },
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

        $LayoutObject->Block(
            Name => 'Filter'
        );

        for my $SessionID (@List) {
            my $List = '';
            my %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );
            if ( $Data{UserType} && $Data{UserLogin} ) {
                $MetaData{"$Data{UserType}Session"}++;
                if ( !$MetaData{"$Data{UserLogin}"} ) {
                    $MetaData{"$Data{UserType}SessionUniq"}++;
                    $MetaData{"$Data{UserLogin}"} = 1;
                }
            }

            $Data{UserType} = 'Agent' if ( !$Data{UserType} || $Data{UserType} ne 'Customer' );

            # create blocks
            $LayoutObject->Block(
                Name => 'Session',
                Data => {
                    SessionID     => $SessionID,
                    UserFirstname => $Data{UserFirstname},
                    UserLastname  => $Data{UserLastname},
                    UserFullname  => $Data{UserFullname},
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
