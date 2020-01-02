# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminCloudServices;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

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
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');

    # check if cloud services are disabled
    my $CloudServicesDisabled = $ConfigObject->Get('CloudServices::Disabled') || 0;

    if ($CloudServicesDisabled) {

        my $Output = $LayoutObject->Header(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'CloudServicesDisabled',
            Data         => \%Param
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # get web services list
    my %CloudServiceList = %{ $ConfigObject->Get('CloudService::Admin::Module') || {} };

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
