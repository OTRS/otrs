# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateWebServiceConfiguration;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::GenericInterface::Webservice',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateWebServiceConfiguration -  Migrate web service configuration (parameter change for REST/SOAP).

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $WebserviceList = $WebserviceObject->WebserviceList(
        Valid => 0,
    );
    return 1 if !IsHashRefWithData($WebserviceList);

    WEBSERVICEID:
    for my $WebserviceID ( sort keys %{$WebserviceList} ) {

        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );
        next WEBSERVICEID if !IsHashRefWithData($WebserviceData);

        # Check if web service is using an old configuration type and upgrade if necessary.
        $WebserviceObject->_WebserviceConfigUpgrade( %{$WebserviceData} );

        # set and write updated config
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => 1,
        );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
