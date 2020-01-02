# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Event;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
);

=head1 NAME

Kernel::System::Event - events management

=head1 DESCRIPTION

Global module to manage events.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $EventObject = $Kernel::OM->Get('Kernel::System::Event');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 EventList()

get a list of available events in the system.

    my %Events = $EventObject->EventList(
        ObjectTypes => ['Ticket', 'Article'],    # optional filter
    );

    returns
    (
        Ticket => ['TicketCreate', 'TicketPriorityUpdate', ...],
        Article => ['ArticleCreate', ...],
    )

=cut

sub EventList {
    my ( $Self, %Param ) = @_;

    my %ObjectTypes = map { $_ => 1 } @{ $Param{ObjectTypes} || [] };

    my %EventConfig = %{ $Kernel::OM->Get('Kernel::Config')->Get('Events') || {} };

    my %Result;
    for my $ObjectType ( sort keys %EventConfig ) {

        if ( !%ObjectTypes || $ObjectTypes{$ObjectType} ) {
            $Result{$ObjectType} = $EventConfig{$ObjectType};
        }
    }

    # get ticket df events
    if ( !%ObjectTypes || $ObjectTypes{'Ticket'} ) {

        # get dynamic field object
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
            Valid      => 1,
            ObjectType => ['Ticket'],
            ResultType => 'HASH',
        );

        my @DynamicFieldEvents = map {"TicketDynamicFieldUpdate_$_"} sort values %{$DynamicFields};

        push @{ $Result{'Ticket'} || [] }, @DynamicFieldEvents;
    }

    # there is currently only one article df event
    if ( !%ObjectTypes || $ObjectTypes{'Article'} ) {
        push @{ $Result{'Article'} || [] }, 'ArticleDynamicFieldUpdate';
    }

    return %Result;

}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
