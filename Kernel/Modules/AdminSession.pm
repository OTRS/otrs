# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminSession.pm,v 1.30 2008-01-31 06:22:12 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminSession;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.30 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
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
        $Self->{SessionObject}->RemoveSessionID( SessionID => $WantSessionID );
        return $Self->{LayoutObject}->Redirect( OP => "Action=AdminSession" );
    }

    # ------------------------------------------------------------ #
    # kill all session id
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'KillAll' ) {
        my @List = $Self->{SessionObject}->GetAllSessionIDs();
        for my $SessionID (@List) {

            # killall sessions but not the own one!
            if ( $WantSessionID ne $SessionID ) {
                $Self->{SessionObject}->RemoveSessionID( SessionID => $SessionID );
            }
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=AdminSession" );
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
        for my $SessionID (@List) {
            my $List = '';
            my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );
            $MetaData{"$Data{UserType}Session"}++;
            if ( !$MetaData{"$Data{UserLogin}"} ) {
                $MetaData{"$Data{UserType}SessionUniq"}++;
                $MetaData{"$Data{UserLogin}"} = 1;
            }
            for ( sort keys %Data ) {
                if ( ($_) && ( defined( $Data{$_} ) ) && $_ ne 'SessionID' ) {
                    if ( $_ =~ /^_/ ) {
                        next;
                    }
                    if ( $_ =~ /Password|Pw/ ) {
                        $Data{$_} = 'xxxxxxxx';
                    }
                    else {
                        $Data{$_} = $Self->{LayoutObject}->Ascii2Html( Text => $Data{$_} );
                    }
                    if ( $_ eq 'UserSessionStart' ) {
                        my $Age
                            = int( ( $Self->{TimeObject}->SystemTime() - $Data{UserSessionStart} )
                            / 3600 );
                        my $TimeStamp = $Self->{TimeObject}
                            ->SystemTime2TimeStamp( SystemTime => $Data{UserSessionStart}, );
                        $List .= "" . $_ . "=$TimeStamp / $Age h; ";
                    }
                    else {
                        $List .= "" . $_ . "=$Data{$_}; ";
                    }
                }
            }

            # create blocks
            $Self->{LayoutObject}->Block(
                Name => 'Session',
                Data => {
                    SessionID => $SessionID,
                    Output    => $List,
                    %Data,
                },
            );
        }

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
