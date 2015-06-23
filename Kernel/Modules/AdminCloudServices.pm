# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCloudServices;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    return $Self->_ShowOverview(
        %Param,
        Action => 'Overview',
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # get web services list
    my %CloudServiceList = %{ $Kernel::OM->Get('Kernel::Config')->Get('CloudService::Admin::Module') || {} };

    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    my $SystemIsRegistered = $RegistrationState eq 'registered';

    CLOUDSERVICE:
    for my $CloudService ( sort keys %CloudServiceList ) {

        next CLOUDSERVICE if !$CloudService;
        next CLOUDSERVICE if !IsHashRefWithData( $CloudServiceList{$CloudService} );

        if ( !$CloudServiceList{$CloudService}->{Name} || !$CloudServiceList{$CloudService}->{ConfigDialog} ) {

            # write an error message to the OTRS log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Configuration of CloudService $CloudService is invalid!",
            );

            # notify the user of problems loading this web service
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
            );

            # continue loading the list of cloud services
            next CLOUDSERVICE;
        }

        # add result row container
        $LayoutObject->Block(
            Name => 'OverviewResultRow',
            Data => {
                CloudService            => $CloudServiceList{$CloudService},
                OTRSBusinessIsInstalled => $OTRSBusinessObject->OTRSBusinessIsInstalled(),
                SystemIsRegistered      => $SystemIsRegistered,
            },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminCloudServices',
        Data         => {
            %Param,
            SystemIsRegistered => $SystemIsRegistered,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

1;
