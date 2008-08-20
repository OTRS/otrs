# --
# Kernel/Output/HTML/CustomerUserGenericTicket.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerUserGenericTicket.pm,v 1.2 2008-08-20 15:10:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::CustomerUserGenericTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject TicketObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get all attributes
    my %TicketSearch = ();
    my @Params = split /;/, $Param{Config}->{Attributes};
    for my $String (@Params) {
        next if !$String;
        my ( $Key, $Value ) = split /=/, $String;
        if ( !defined $TicketSearch{$Key} ) {
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            @{ $TicketSearch{$Key} } = ( $ValueTmp, $Value );
        }
        else {
            push @{ $TicketSearch{$Key} }, $Value;
        }
    }

    # build url
    my $Action    = $Param{Config}->{Action};
    my $Subaction = $Param{Config}->{Subaction};
    my $URL       = $Self->{LayoutObject}->{Baselink} . "Action=$Action&Subaction=$Subaction";
    $URL .= "&CustomerID=" . $Self->{LayoutObject}->LinkQuote(
        Text => $Param{Data}->{UserCustomerID},
    );
    for my $Key ( sort keys %TicketSearch ) {
        if ( ref $TicketSearch{$Key} eq 'ARRAY' ) {
            for my $Value ( @{ $TicketSearch{$Key} } ) {
                $URL .= '&' . $Key . '=' . $Self->{LayoutObject}->LinkQuote(
                    Text => $Value,
                );
            }
        }
        else {
            $URL .= '&' . $Key . '=' . $Self->{LayoutObject}->LinkQuote(
                Text => $TicketSearch{$Key},
            );
        }
    }

    my @TicketIDs = $Self->{TicketObject}->TicketSearch(

        # result (required)
        %TicketSearch,
        CustomerID => $Param{Data}->{UserCustomerID},
        Result     => 'ARRAY',
        Permission => 'ro',
        UserID     => $Self->{UserID},
    );

    my $Count = scalar @TicketIDs;

    my $Image = $Param{Config}->{ImageNoOpenTicket};
    if ($Count) {
        $Image = $Param{Config}->{ImageOpenTicket};
    }

    # generate block
    $Self->{LayoutObject}->Block(
        Name => 'CustomerItemRow',
        Data => {
            %{ $Param{Config} },
            Image     => $Image,
            Extention => " ($Count)",
            URL       => $URL,
        },
    );

    return 1;
}

1;
