# --
# Kernel/System/PostMaster/Filter/NewTicketReject.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NewTicketReject.pm,v 1.7 2007-09-29 10:54:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::Filter::NewTicketReject;

use strict;
use warnings;

use Kernel::System::Ticket;
use Kernel::System::Email;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    for (qw(ConfigObject LogObject DBObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    $Self->{EmailObject}  = Kernel::System::Email->new(%Param);

    return $Self;
}

sub Run {
    my $Self  = shift;
    my %Param = @_;

    # get config options
    my %Config = ();
    my %Match  = ();
    my %Set    = ();
    if ( $Param{JobConfig} && ref( $Param{JobConfig} ) eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };
        if ( $Config{Match} ) {
            %Match = %{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            %Set = %{ $Config{Set} };
        }
    }

    # match 'Match => ???' stuff
    my $Matched    = '';
    my $MatchedNot = 0;
    for ( sort keys %Match ) {
        if ( $Param{GetParam}->{$_} && $Param{GetParam}->{$_} =~ /$Match{$_}/i ) {
            $Matched = $1 || '1';
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
                );
            }
        }
        else {
            $MatchedNot = 1;
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched NOT!",
                );
            }
        }
    }
    if ( $Matched && !$MatchedNot ) {

        # check if new ticket
        my $Tn = $Self->{TicketObject}->GetTNByString( $Param{GetParam}->{'Subject'} );
        if ( $Tn && $Self->{TicketObject}->TicketCheckNumber( Tn => $Tn ) ) {
            return 1;
        }
        else {

            # set attributes if ticket is created
            for ( keys %Set ) {
                $Param{GetParam}->{$_} = $Set{$_};
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message =>
                        "Set param '$_' to '$Set{$_}' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
            }

            # send bounce mail
            $Self->{EmailObject}->Send(
                To      => $Param{GetParam}->{'From'},
                Subject => $Self->{ConfigObject}
                    ->Get('PostMaster::PreFilterModule::NewTicketReject::Subject'),
                Body => $Self->{ConfigObject}
                    ->Get('PostMaster::PreFilterModule::NewTicketReject::Body'),
                Charset    => $Self->{ConfigObject}->Get('DefaultCharset'),
                Loop       => 1,
                Attachment => [
                    {   Filename    => "email.txt",
                        Content     => $Param{GetParam}->{'Body'},
                        ContentType => "application/octet-stream",
                    }
                ],
            );
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Send reject mail to '$Param{GetParam}->{From}'!",
            );
        }
    }
    return 1;
}

1;
