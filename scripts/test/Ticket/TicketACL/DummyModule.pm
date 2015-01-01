# --
# scripts/test/Ticket/TicketACL/DummyModule.pm - dummy Acl module for testing
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use Kernel::System::ObjectManager;

package scripts::test::Ticket::TicketACL::DummyModule;    ## no critic

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config Acl)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    $Param{Acl}->{DummyModule} = {

        # match properties
        Properties => {

            # current ticket match properties
            Ticket => {
                TicketID => [ $Param{TicketID} ],
            },
        },
        PossibleNot => {
            Ticket => {
                State => ['open'],
                }
        },
    };

    return 1;
}

1;
