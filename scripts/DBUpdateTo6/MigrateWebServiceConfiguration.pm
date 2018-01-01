# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
