# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::Test;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{CacheKey}  = 'Emails';
    $Self->{CacheType} = 'EmailTest';

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    # get already stored emails from cache
    my $Emails = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Key  => $Self->{CacheKey},
        Type => $Self->{CacheType},
    );
    $Emails //= [];

    push @{$Emails}, \%Param;

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Key   => $Self->{CacheKey},
        Type  => $Self->{CacheType},
        Value => $Emails,
        TTL   => 60 * 60 * 24,
    );

    return 1;
}

sub EmailsGet {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Key  => $Self->{CacheKey},
        Type => $Self->{CacheType},
    ) // [];
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );
}

1;
