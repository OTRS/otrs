# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::System::PostMaster::LoopProtectionCommon;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;
use utf8;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config options
    $Self->{PostmasterMaxEmails} = $Kernel::OM->Get('Kernel::Config')->Get('PostmasterMaxEmails') || 40;
    $Self->{PostmasterMaxEmailsPerAddress} =
        $Kernel::OM->Get('Kernel::Config')->Get('PostmasterMaxEmailsPerAddress') || {};

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $Self->{LoopProtectionDate} = $DateTimeObject->Format( Format => '%Y-%m-%d' );

    return $Self;
}

1;
