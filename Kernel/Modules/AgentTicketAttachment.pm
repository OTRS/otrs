# --
# Kernel/Modules/AgentTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketAttachment.pm,v 1.9 2008-01-31 06:22:12 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketAttachment;

use strict;
use warnings;

use Kernel::System::FileTemp;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );
    $Self->{FileID}    = $Self->{ParamObject}->GetParam( Param => 'FileID' );
    $Self->{Viewer}    = $Self->{ParamObject}->GetParam( Param => 'Viewer' ) || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    # check params
    if ( !$Self->{FileID} || !$Self->{ArticleID} ) {
        $Self->{LogObject}->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # check permissions
    my %ArticleData = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );
    if ( !$ArticleData{TicketID} ) {
        $Self->{LogObject}->Log(
            Message  => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }
    elsif (
        $Self->{TicketObject}->Permission(
            Type     => 'ro',
            TicketID => $ArticleData{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # geta attachment
        if (my %Data = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $Self->{ArticleID},
                FileID    => $Self->{FileID},
            )
            )
        {

            # check viewer
            my $Viewer = '';
            if ( $Self->{ConfigObject}->Get('MIME-Viewer') ) {
                for ( keys %{ $Self->{ConfigObject}->Get('MIME-Viewer') } ) {
                    if ( $Data{ContentType} =~ /^$_/i ) {
                        $Viewer = $Self->{ConfigObject}->Get('MIME-Viewer')->{$_};
                        $Viewer =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{ConfigObject}->{$1}/g;
                    }
                }
            }

            # show with viewer
            if ( $Self->{Viewer} && $Viewer ) {

                # write tmp file
                my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
                if ( open( DATA, "> $Filename" ) ) {
                    print DATA $Data{Content};
                    close(DATA);
                }
                else {

                    # log error
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "Cant write $Filename: $!",
                    );
                    return $Self->{LayoutObject}->ErrorScreen();
                }

                # use viewer
                my $Content = '';
                if ( open( DATA, "$Viewer $Filename |" ) ) {
                    while (<DATA>) {
                        $Content .= $_;
                    }
                    close(DATA);
                }
                else {
                    return $Self->{LayoutObject}
                        ->FatalError( Message => "Can't open: $Viewer $Filename: $!", );
                }

                # return new page
                return $Self->{LayoutObject}->Attachment(
                    %Data,
                    ContentType => 'text/html',
                    Content     => $Content,
                    Type        => 'inline'
                );
            }

            # download it
            else {
                return $Self->{LayoutObject}->Attachment(%Data);
            }
        }
        else {
            $Self->{LogObject}->Log(
                Message  => "No such attacment ($Self->{FileID})! May be an attack!!!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {

        # error screen
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }
}

1;
