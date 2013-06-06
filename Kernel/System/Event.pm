# --
# Kernel/System/Event.pm - the global event module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Event;

use strict;
use warnings;

=head1 NAME

Kernel::System::Event - events management

=head1 SYNOPSIS

Global module to manage events.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::Event;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DynamicFieldObject = Kernel::System::DynamicField->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $EventObject = Kernel::System::Event->new(
        ConfigObject        => $ConfigObject,
        LogObject           => $LogObject,
        DBObject            => $DBObject,
        MainObject          => $MainObject,
        TimeObject          => $TimeObject,
        EncodeObject        => $EncodeObject,
        DynamicFieldObject  => $DynamicFieldObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(ConfigObject LogObject DBObject TimeObject MainObject EncodeObject DynamicFieldObject))
    {
        die "Got no $_" if !$Self->{$_};
    }

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

    my %Result;

    my %EventConfig = %{ $Self->{ConfigObject}->Get('Events') || {} };

    for my $ObjectType ( sort keys %EventConfig ) {
        if ( !%ObjectTypes || $ObjectTypes{$ObjectType} ) {
            $Result{$ObjectType} = $EventConfig{$ObjectType};
        }
    }

    # get ticket df events
    if ( !%ObjectTypes || $ObjectTypes{'Ticket'} ) {
        my $DynamicFields = $Self->{DynamicFieldObject}->DynamicFieldList(
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
