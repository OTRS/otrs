# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Package::Event::LinkObjectEventTypes;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::LinkObject::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    return if !$Param{Data}->{Name};
    return if !$Param{Data}->{Version};

    # Loop protection: only execute this handler once for same package and action.
    if (
        $Kernel::OM->Get('Kernel::System::LinkObject::Ticket')
        ->{'_EventTypeConfigUpdate::AlreadyProcessed'}
        ->{ $Param{Data}->{Name} . $Param{Data}->{Version} . $Param{Event} }++
        )
    {
        return;
    }

    return $Kernel::OM->Get('Kernel::System::LinkObject::Ticket')->EventTypeConfigUpdate();
}

1;
