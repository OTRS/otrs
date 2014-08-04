# --
# Kernel/System/Event.pm - the global event module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Event;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::Event - events management

=head1 SYNOPSIS

Global module to manage events.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $EventObject = $Kernel::OM->Get('Kernel::System::Event');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item EventList()

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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
