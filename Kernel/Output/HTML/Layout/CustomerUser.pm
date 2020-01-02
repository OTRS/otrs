# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Layout::CustomerUser;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::CustomerUser - all CustomerUser related HTML functions

=head1 PUBLIC INTERFACE

=head2 CustomerUserAddressBookListShow()

Returns a list of customer user as sort-able list with pagination.

This function is similar to L<Kernel::Output::HTML::Layout::CustomerUser::CustomerUserAddressBookListShow()>
in F<Kernel/Output/HTML/Layout/CustomerUser.pm>.

    my $Output = $LayoutObject->CustomerUserAddressBookListShow(
        CustomerUserIDs => $CustomerUserIDsRef,                      # total list of customer user ids, that can be listed
        Total           => scalar @{ $CustomerUserIDsRef },          # total number of customer user ids
        View            => $Self->{View},                            # optional, the default value is 'AddressBook'
        Filter          => 'All',
        Filters         => \%NavBarFilter,
        LinkFilter      => $LinkFilter,
        TitleName       => 'Overview: CustomerUsers',
        TitleValue      => $Self->{Filter},
        Env             => $Self,
        LinkPage        => $LinkPage,
        LinkSort        => $LinkSort,
        Frontend        => 'Agent',                                  # optional (Agent|Customer), default: Agent, indicates from which frontend this function was called
    );

=cut

sub CustomerUserAddressBookListShow {
    my ( $Self, %Param ) = @_;

    # Take object ref to local, remove it from %Param (prevent memory leak).
    my $Env = delete $Param{Env};

    my $Frontend = $Param{Frontend} || 'Agent';

    # Set defaut view mode to 'AddressBook'.
    my $View = $Param{View} || 'AddressBook';

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get backend from config
    my $Backends = $ConfigObject->Get('CustomerUser::Frontend::Overview');
    if ( !$Backends ) {
        return $Self->FatalError(
            Message => 'Need config option CustomerUser::Frontend::Overview',
        );
    }

    # check for hash-ref
    if ( ref $Backends ne 'HASH' ) {
        return $Self->FatalError(
            Message => 'Config option CustomerUser::Frontend::Overview needs to be a HASH ref!',
        );
    }

    # check for config key
    if ( !$Backends->{$View} ) {
        return $Self->FatalError(
            Message => "No config option found for the view '$View'!",
        );
    }

    # nav bar
    my $StartHit = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
        Param => 'StartHit',
    ) || 1;

    # get personal page shown count
    my $PageShown = $ConfigObject->Get("CustomerUser::Frontend::$Self->{Action}")->{PageShown} || 100;

    # check start option, if higher then elements available, set
    # it to the last overview page (Thanks to Stefan Schmidt!)
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # set page limit and build page nav
    my $Limit   = $Param{Limit} || 20_000;
    my %PageNav = $Self->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Self->{Action},
        Link      => $Param{LinkPage},
    );

    # build navbar content
    $Self->Block(
        Name => 'OverviewNavBar',
        Data => \%Param,
    );

    # back link
    if ( $Param{LinkBack} ) {
        $Self->Block(
            Name => 'OverviewNavBarPageBack',
            Data => \%Param,
        );
    }

    # check if page nav is available
    if (%PageNav) {
        $Self->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        # don't show context settings in AJAX case (e. g. in customer ticket history),
        #   because the submit with page reload will not work there
        if ( !$Param{AJAX} ) {
            $Self->Block(
                Name => 'ContextSettings',
                Data => {
                    %PageNav,
                    %Param,
                },
            );
        }
    }

    # build html content
    my $OutputNavBar = $Self->Output(
        TemplateFile => 'AgentCustomerUserAddressBookOverviewNavBar',
        Data         => {%Param},
    );

    # create output
    my $OutputRaw = '';
    if ( !$Param{Output} ) {
        $Self->Print(
            Output => \$OutputNavBar,
        );
    }
    else {
        $OutputRaw .= $OutputNavBar;
    }

    # load module
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Backends->{$View}->{Module} ) ) {
        return $Self->FatalError();
    }

    # check for backend object
    my $Object = $Backends->{$View}->{Module}->new( %{$Env} );
    return if !$Object;

    # run module
    my $Output = $Object->Run(
        %Param,
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Frontend  => $Frontend,
    );

    # create output
    if ( !$Param{Output} ) {
        $Self->Print(
            Output => \$Output,
        );
    }
    else {
        $OutputRaw .= $Output;
    }

    # create overview nav bar
    $Self->Block(
        Name => 'OverviewNavBar',
        Data => {%Param},
    );

    # return content if available
    return $OutputRaw;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
