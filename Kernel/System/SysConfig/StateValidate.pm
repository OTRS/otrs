# --
# Kernel/System/SysConfig/StateValidate.pm - all StateValidate functions
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: StateValidate.pm,v 1.2 2010-07-23 16:48:15 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SysConfig::StateValidate;

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::State;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::SysConfig::StateValidate - StateValidate lib

=head1 SYNOPSIS

All functions for the StateValidate checks.

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
    use Kernel::System::SysConfig::StateValidate;

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
    my $StateValidateObject = Kernel::System::SysConfig::StateValidate->new(
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
    $Self->{StateObject} = Kernel::System::State->new( %{$Self} );

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

=item Validate()

Validates the given data, checks if the given state exists and if it is valid.

    my $Success = $StateValidateObject->Validate(
        Data => 'open',
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

    # get list of all valid states
    my %States = $Self->{StateObject}->StateList(
        UserID => 1,
        Valid  => 1,
    );

    # build lookup hash for state names
    my %State2StateID = reverse %States;

    # state does not exist or is invalid
    return if !$State2StateID{ $Param{Data} };

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2010-07-23 16:48:15 $

=cut
