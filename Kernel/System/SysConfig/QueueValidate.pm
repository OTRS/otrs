# --
# Kernel/System/SysConfig/QueueValidate.pm - all QueueValidate functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SysConfig::QueueValidate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Queue',
);

=head1 NAME

Kernel::System::SysConfig::QueueValidate - QueueValidate lib

=head1 SYNOPSIS

All functions for the QueueValidate checks.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $QueueValidateObject = $Kernel::OM->Get('Kernel::System::SysConfig::QueueValidate');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

=item Validate()

Validates the given data, checks if the given queue exists and if it is valid.

    my $Success = $QueueValidateObject->Validate(
        Data => 'Postmaster',
    );

=cut

sub Validate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data!",
        );
        return;
    }

    # data is a not a scalar
    if ( ref $Param{Data} ) {

        # get the reference type
        my $RefType = ref $Param{Data};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data must be a scalar, but it is a $RefType!",
        );
        return;
    }

    # get list of all valid queues
    my %Queues = $Kernel::OM->Get('Kernel::System::Queue')->QueueList(
        Valid => 1,
    );

    # build lookup hash for queue names
    my %Queue2ID = reverse %Queues;

    # queue does not exist or is invalid
    return if !$Queue2ID{ $Param{Data} };

    return 1;
}

=item GetAutoCorrectValue()

Returns a valid queue name which can be used to auto-correct
a sysconfig option with an invalid queue name.

    my $Value = $QueueValidateObject->GetAutoCorrectValue();

=cut

sub GetAutoCorrectValue {
    my ( $Self, %Param ) = @_;

    # get list of all valid queues
    my %Queues = $Kernel::OM->Get('Kernel::System::Queue')->QueueList(
        Valid => 1,
    );

    # build lookup hash for queue names
    my %Queue2ID = reverse %Queues;

    # try to find the queue 'Raw'
    if ( $Queue2ID{Raw} ) {
        return 'Raw';
    }

    # try to find the queue 'Postmaster'
    elsif ( $Queue2ID{Postmaster} ) {
        return 'Postmaster';
    }

    # return the first valid queue in the list
    else {
        my @SortedQueues = sort keys %Queue2ID;
        return $SortedQueues[0];
    }

    # return undef if no queue could be found
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
