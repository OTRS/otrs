# --
# Kernel/GenericInterface/Operation/SolMan/ReplicateIncident.pm - GenericInterface SolMan ReplicateIncident operation backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.pm,v 1.1 2011-03-24 09:33:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::SolMan::ReplicateIncident;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::SolMan - GenericInterface SolMan ReplicateIncident Operation backend

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
    for my $Needed (qw(DebuggerObject ConfigObject MainObject)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item Run()

perform ReplicateIncident Operation. This will return ???.

    my $Result = $OperationObject->Run(
        Data => { },
    );

    $Result = {
        Success         => 1,                              # 0 or 1
        ErrorMessage    => '',                             # in case of error
        Data            => {                               # result data payload after Operation
            Errors     => ''                               # should not return errors
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # copy data
    my $ReturnData = {
        Errors => '',
    };

    # return result
    return {
        Success => 1,
        Data    => $ReturnData,
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

$Revision: 1.1 $ $Date: 2011-03-24 09:33:13 $

=cut
