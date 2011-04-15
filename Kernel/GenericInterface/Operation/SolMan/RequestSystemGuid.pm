# --
# Kernel/GenericInterface/Operation/SolMan/RequestSystemGuid.pm - GenericInterface SolMan RequestSystemGuid operation backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: RequestSystemGuid.pm,v 1.8 2011-04-15 13:16:04 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::SolMan::RequestSystemGuid;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

use Kernel::GenericInterface::Operation::SolMan::Common;

=head1 NAME

Kernel::GenericInterface::Operation::SolMan::RequestSystemGuid - GenericInterface SolMan RequestSystemGuid Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject MainObject TimeObject ConfigObject LogObject DBObject EncodeObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{SolManCommonObject}
        = Kernel::GenericInterface::Operation::SolMan::Common->new( %{$Self} );

    return $Self;
}

=item Run()

perform RequestSystemGuid Operation. This will return the SystemID as a MD5 sum in upper case
to match SolMan style.

    my $Result = $OperationObject->Run(
        Data => { },
    );

    $Result = {
        Success         => 1,
        Data            => {
            SystemGuid => '123ABC123ABC123ABC123ABC123ABC12', # MD5 applied to SystemID (32 chars long)
            Errors     => '',                                 # should not return errors
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return {
        Success => 1,
        Data    => {
            SystemGuid => $Self->{SolManCommonObject}->LocalSystemGuid(),
            Errors     => '',
        },
    };
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

$Revision: 1.8 $ $Date: 2011-04-15 13:16:04 $

=cut
