# --
# Kernel/GenericInterface/Operation/Test/PerformTest.pm - GenericInterface test operation interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: PerformTest.pm,v 1.5 2011-02-10 15:34:31 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Test::PerformTest;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation

=head1 SYNOPSIS

GenericInterface Operation interface.

Operations are called by web service requests from remote
systems.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Operation::Test::PerformTest;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
    );
    my $OperationObject = Kernel::GenericInterface::Operation::Test::PerformTest->new(
        ConfigObject   => $ConfigObject,
        EncodeObject   => $EncodeObject,
        LogObject      => $LogObject,
        MainObject     => $MainObject,
        DBObject       => $DBObject,
        TimeObject     => $TimeObject,
        DebuggerObject => $DebuggerObject,

        Operation => 'Ticket::TicketCreate',    # the local operation to use
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
                }
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item Run()

perform the selected Operation.

    my $Result = $OperationObject->Run(
        Data => {                               # data payload before Operation
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # result data payload after Operation
            ...
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref with at least one entry
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no Data hash ref with content!' );
    }

    my $ReturnData = $Self->_Test( Data => $Param{Data} );

    # return result
    return {
        Success => 1,
        Data    => $ReturnData,
    };
}

=item _Test()

returns Data

    my $ReturnData => $OperationObject->_Test(
        Data => { # data payload before mapping
            'abc' => 'Def,
            'ghi' => 'jkl',
        },
    );

    $ReturnData = { # data payload after mapping
            'abc' => 'Def,
            'ghi' => 'jkl',
    };

=cut

sub _Test {
    my ( $Self, %Param ) = @_;

    my $ReturnData = {};
    for my $Key ( keys %{ $Param{Data} } ) {
        $ReturnData->{$Key} = $Param{Data}->{$Key};
    }

    return $ReturnData;
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

$Revision: 1.5 $ $Date: 2011-02-10 15:34:31 $

=cut
