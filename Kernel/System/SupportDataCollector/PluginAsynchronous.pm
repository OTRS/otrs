# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::PluginAsynchronous;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::JSON',
    'Kernel::System::SystemData',
);

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

sub _GetAsynchronousData {
    my ( $Self, %Param ) = @_;

    my $Identifier = Scalar::Util::blessed($Self);

    my $AsynchronousDataString = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => $Identifier,
    );

    return if !defined $AsynchronousDataString;

    # get asynchronous data as array ref
    my $AsynchronousData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $AsynchronousDataString,
    ) || [];

    return $AsynchronousData;
}

sub _StoreAsynchronousData {
    my ( $Self, %Param ) = @_;

    return 1 if !$Param{Data};

    my $Identifier = Scalar::Util::blessed($Self);

    my $CurrentAsynchronousData = $Self->_GetAsynchronousData();

    my $AsynchronousDataString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Data},
    );

    # get system data object
    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    if ( !defined $CurrentAsynchronousData ) {

        $SystemDataObject->SystemDataAdd(
            Key    => $Identifier,
            Value  => $AsynchronousDataString,
            UserID => 1,
        );
    }
    else {

        $SystemDataObject->SystemDataUpdate(
            Key    => $Identifier,
            Value  => $AsynchronousDataString,
            UserID => 1,
        );
    }

    return 1;
}

1;
