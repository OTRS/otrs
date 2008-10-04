# --
# Kernel/Output/HTML/CustomerUserGenericTicket.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerUserGenericTicket.pm,v 1.3 2008-10-04 14:49:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::CustomerUserGenericTicket;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject TicketObject MainObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # lookup map
    my %Lookup = (
        Types => {
            Object => 'Kernel::System::Type',
            Return => 'TypeIDs',
            Input  => 'Type',
            Method => 'Lookup',
        },
        Queues => {
            Object => 'Kernel::System::Queue',
            Return => 'QueueIDs',
            Input  => 'Queue',
            Method => 'QueueLookup',
        },
        States => {
            Object => 'Kernel::System::State',
            Return => 'StateIDs',
            Input  => '',
            Method => 'Lookup',
        },
        Priorities => {
            Object => 'Kernel::System::Priority',
            Return => 'PriorityIDs',
            Input  => 'Priority',
            Method => 'Lookup',
        },
        Looks => {
            Object => 'Kernel::System::Look',
            Return => 'LookIDs',
            Input  => 'Lock',
            Method => 'Lookup',
        },
        Services => {
            Object => 'Kernel::System::Service',
            Return => 'ServiceIDs',
            Input  => 'Name',
            Method => 'Lookup',
        },
        SLAs => {
            Object => 'Kernel::System::SLA',
            Return => 'SLAIDs',
            Input  => 'Name',
            Method => 'Lookup',
        },
    );

    # get all attributes
    my %TicketSearch = ();
    my @Params = split /;/, $Param{Config}->{Attributes};
    for my $String (@Params) {
        next if !$String;
        my ( $Key, $Value ) = split /=/, $String;

        # do lookups
        if ( $Lookup{$Key} ) {
            next if !$Self->{MainObject}->Require( $Lookup{$Key}->{Object} );
            my $Object = $Lookup{$Key}->{Object}->new( %{ $Self } );
            my $Method = $Lookup{$Key}->{Method};
            $Value = $Object->$Method( $Lookup{$Key}->{Input} => $Value );
            $Key = $Lookup{$Key}->{Return};
        }

        # build link and search attributes
        if ( $Key =~ /IDs$/ ) {
            if ( !$TicketSearch{$Key} ) {
                $TicketSearch{$Key} = [ $Value ];
            }
            else {
                push @{ $TicketSearch{$Key} }, $Value;
            }
        }
        elsif ( !defined $TicketSearch{$Key} ) {
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            $TicketSearch{$Key} = [ $ValueTmp ];
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
