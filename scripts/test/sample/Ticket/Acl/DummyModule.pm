# --
# scripts/test/sample/Ticket/Acl/DummyModule.pm - dummy Acl module for testing
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::test::sample::Ticket::Acl::DummyModule;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject DBObject TicketObject LogObject UserObject CustomerUserObject MainObject TimeObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config Acl)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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
                State   => ['open'],
            }
        },
    };
    return 1;
}


1;
