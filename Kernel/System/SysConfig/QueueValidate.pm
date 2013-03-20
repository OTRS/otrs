# --
# Kernel/System/SysConfig/QueueValidate.pm - all QueueValidate functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SysConfig::QueueValidate;

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::Queue;

use vars qw(@ISA);

=head1 NAME

Kernel::System::SysConfig::QueueValidate - QueueValidate lib

=head1 SYNOPSIS

All functions for the QueueValidate checks.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::SysConfig::QueueValidate;

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
    my $QueueValidateObject = Kernel::System::SysConfig::QueueValidate->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{QueueObject} = Kernel::System::Queue->new( %{$Self} );

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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Data!",
        );
        return;
    }

    # data is a not a scalar
    if ( ref $Param{Data} ) {

        # get the reference type
        my $RefType = ref $Param{Data};

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Data must be a scalar, but it is a $RefType!",
        );
        return;
    }

    # get list of all valid queues
    my %Queues = $Self->{QueueObject}->QueueList(
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
    my %Queues = $Self->{QueueObject}->QueueList(
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
