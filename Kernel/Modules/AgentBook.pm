# --
# Kernel/Modules/AgentBook.pm - addressbook module
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentBook;

use strict;
use warnings;

use Kernel::System::CustomerUser;
our $ObjectManagerDisabled = 1;

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

    # create additional objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    for (qw(ToCustomer CcCustomer BccCustomer CustomerData)) {
        $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # get list of users
    my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' );
    my %CustomerUserList;
    if ($Search) {
        %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
            Search => $Search,
        );
    }
    my %List;
    for ( sort keys %CustomerUserList ) {
        my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $_,
        );
        if ( $CustomerUserData{UserEmail} ) {
            $List{ $CustomerUserData{UserEmail} } = {
                Email       => $CustomerUserList{$_},
                CustomerKey => $_
            };
        }
    }

    # build customer search autocomplete field
    $Self->{LayoutObject}->Block(
        Name => 'CustomerSearchAutoComplete',
    );

    if (%List) {
        $Self->{LayoutObject}->Block(
            Name => 'SearchResult',
        );

        my $Count = 1;
        for ( reverse sort { $List{$b}->{Email} cmp $List{$a}->{Email} } keys %List ) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    Email => $List{$_}->{Email},
                    Count => $Count,
                    CustomerDataJSON =>
                        $Kernel::OM->Get('Kernel::System::JSON')
                        ->Encode( Data => { $List{$_}->{Email} => $List{$_}->{CustomerKey} } ),
                },
            );
            $Count++;
        }
    }

    # start with page ...
    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentBook',
        Data         => \%Param
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
