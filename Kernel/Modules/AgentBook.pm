# --
# Kernel/Modules/AgentBook.pm - spelling module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentBook.pm,v 1.15 2009-02-16 11:20:52 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentBook;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(TicketObject ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    for (qw(To Cc Bcc)) {
        $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # get list of users
    my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' );
    my %CustomerUserList = ();
    if ($Search) {
        %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch( Search => $Search, );
    }
    my %List = ();
    for ( keys %CustomerUserList ) {
        my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $_, );
        if ( $CustomerUserData{UserEmail} ) {
            $List{ $CustomerUserData{UserEmail} } = $CustomerUserList{$_};
        }
    }
    for ( reverse sort { $List{$b} cmp $List{$a} } keys %List ) {
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {
                Name  => $List{$_},
                Email => $_,
            },
        );
    }

    # start with page ...
    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AgentBook', Data => \%Param );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    return $Output;
}

1;
