# --
# Kernel/GenericInterface/Operation/SolMan/RequestSystemGuid.pm - GenericInterface SolMan RequestSystemGuid operation backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: RequestSystemGuid.pm,v 1.3 2011-03-17 19:16:46 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::SolMan::RequestSystemGuid;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::SolMan - GenericInterface SolMan RequestGuid Operation backend

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

perform RequestSystemGuid Operation. This will return the SystemID as a MD5 sum in upper case
to martch SolMan stryle.

    my $Result = $OperationObject->Run(
        Data => { },
    );

    $Result = {
        Success         => 1,                              # 0 or 1
        ErrorMessage    => '',                             # in case of error
        Data            => {                               # result data payload after Operation
            SystemGuid => 123ABC123ABC123ABC123ABC123ABC12 # MD5 applied to SystemID (32 chars long)
            Errors     => ''                               # should not return errors
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # get SystemID
    my $SystemID = $Self->{ConfigObject}->Get('SystemID') || 10;

    # convert SystemID to MD5 string
    my $SystemIDMD5 = $Self->{MainObject}->MD5sum(
        String => $SystemID,
    );

    # conver to upper case to match SolMan style
    $SystemIDMD5 = uc $SystemIDMD5;

    # copy data
    my $ReturnData = {
        SystemGuid => $SystemIDMD5,
        Errors     => '',
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

$Revision: 1.3 $ $Date: 2011-03-17 19:16:46 $

=cut
