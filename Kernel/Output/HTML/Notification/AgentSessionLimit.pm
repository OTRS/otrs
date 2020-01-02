# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::AgentSessionLimit;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # Check if the agent session limit for the prior warning is reached
    #   and save the message for the translation and the output.
    my $AgentSessionLimitPriorWarningMessage
        = $Kernel::OM->Get('Kernel::System::AuthSession')->CheckAgentSessionLimitPriorWarning();

    return '' if !$AgentSessionLimitPriorWarningMessage;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Notify(
        Data     => $LayoutObject->{LanguageObject}->Translate($AgentSessionLimitPriorWarningMessage),
        Priority => 'Warning',
    );

    return $Output;
}

1;
