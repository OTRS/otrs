# --
# Kernel/System/SysConfig/PriorityValidate.pm - all PriorityValidate functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SysConfig::PriorityValidate;

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::Priority;

use vars qw(@ISA);

=head1 NAME

Kernel::System::SysConfig::PriorityValidate - PriorityValidate lib

=head1 SYNOPSIS

All functions for the PriorityValidate checks.

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
    use Kernel::System::SysConfig::PriorityValidate;

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
    my $PriorityValidateObject = Kernel::System::SysConfig::PriorityValidate->new(
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
    $Self->{PriorityObject} = Kernel::System::Priority->new( %{$Self} );

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

=item Validate()

Validates the given data, checks if the given priority exists and if it is valid.

    my $Success = $PriorityValidateObject->Validate(
        Data => '3 normal',
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

    # get list of all valid priorities
    my %Priorities = $Self->{PriorityObject}->PriorityList(
        Valid => 1,
    );

    # build lookup hash for priority names
    my %Priority2ID = reverse %Priorities;

    # priority does not exist or is invalid
    return if !$Priority2ID{ $Param{Data} };

    return 1;
}

=item GetAutoCorrectValue()

Returns a valid priority name which can be used to auto-correct
a sysconfig option with an invalid priority name.

    my $Value = $PriorityValidateObject->GetAutoCorrectValue();

=cut

sub GetAutoCorrectValue {
    my ( $Self, %Param ) = @_;

    # get list of all valid priorities
    my %Priorities = $Self->{PriorityObject}->PriorityList(
        Valid => 1,
    );

    # build lookup hash for priority names
    my %Priority2ID = reverse %Priorities;

    # try to find the priority '3 normal'
    if ( $Priority2ID{'3 normal'} ) {
        return '3 normal';
    }

    # try to find the first priority containing 'normal'
    elsif ( my ($Priority) = grep { $_ =~ m{ normal }xms } sort keys %Priority2ID ) {
        return $Priority;
    }

    # try to find the first priority starting with '3 '
    elsif ( ($Priority) = grep { $_ =~ m{ \A 3 [ ] }xms } sort keys %Priority2ID ) {
        return $Priority;
    }

    # return the first valid priority in the list
    else {
        my @SortedPriorities = sort keys %Priority2ID;
        return $SortedPriorities[0];
    }

    # return undef if no priority could be found
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
