# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::test::sample::GenericAgent::CustomCode::DeleteTmp;

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $FileName = $Param{FileName} || $Param{New}->{ParamValue1} || '';

    return   if !$FileName;
    return 1 if !-e $FileName;

    return if !unlink $FileName;

    return 1;
}

1;
