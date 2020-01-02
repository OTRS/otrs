# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set user options
my ( $UserLogin, $UserID ) = $Helper->TestUserCreate(
    Groups => ['admin'],
);

my $ExecuteTests = sub {
    my %Param = @_;
    my @Tests = @{ $Param{Tests} };

    for my $Test (@Tests) {

        # clean previous data
        $TicketObject->{TicketAclData} = {};

        $ConfigObject->Set(
            Key   => 'TicketAcl',
            Value => $Test->{ACLs},
        );

        my $GotACLs = $ConfigObject->Get('TicketAcl');

        # sanity check
        $Self->IsDeeply(
            $GotACLs,
            $Test->{ACLs},
            "$Test->{Name} ACLs Set and Get from sysconfig",
        );

        my $Config     = $Test->{Config};
        my $ACLSuccess = $TicketObject->TicketAcl( %{ $Test->{Config} } );

        # get the data from ACL
        my %ACLData = $TicketObject->TicketAclActionData();

        if ( !$Test->{SuccessMatch} ) {
            $Self->False(
                $ACLSuccess,
                "$Test->{Name} Executed with False",
            );

            $Self->IsDeeply(
                \%ACLData,
                {},
                "$Test->{Name} ACL data must be empty",
            );
        }
        else {
            $Self->True(
                $ACLSuccess,
                "$Test->{Name} Executed with True",
            );

            $Self->IsDeeply(
                \%ACLData,
                $Test->{ReturnActionData},
                "$Test->{Name} ACL data",
            );
        }

        # clean ACLs
        $ConfigObject->Set(
            Key   => 'TicketAcl',
            Value => {},
        );

        $GotACLs = $ConfigObject->Get('TicketAcl');

        # sanity check
        $Self->IsDeeply(
            $GotACLs,
            {},
            "$Test->{Name} ACLs are clean",
        );
    }
};

# Action tests
my @Tests = (
    {
        Name => 'ACL Action - Data as a Correct Hash:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL Action - Data as a Correct Scalar:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data          => 'AgentTicketClose',
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL Action - Data as a Correct Scalar 2:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketBounce', ],
                },
            },
        },
        Config => {
            Data          => 'AgentTicketClose',
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {},
    },
    {
        Name => 'ACL Action - Data as a Correct Hash using [Not]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ '[Not]AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
        },
    },
    {
        Name => 'ACL Action - Data as a Correct Hash using [RegExp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ '[RegExp]Close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL Action - Data as a Correct Hash using [regexp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ '[regexp]close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL Action - Data as a Correct Hash using [NotRegExp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ '[NotRegExp]Close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
        },
    },
    {
        Name => 'ACL Action - Data as a Correct Hash using [Notregexp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ '[Notregexp]close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
        },
    },

    # PossibleAdd tests
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Hash:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ 'AgentTicketBounce', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketForward',
                3 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
            3 => 'AgentTicketBounce',
        },
    },
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Scalar:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ 'AgentTicketBounce', ],
                },
            },
        },
        Config => {
            Data          => 'AgentTicketBounce',
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketBounce',
        },
    },
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Scalar 2:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ 'AgentTicketBounce', ],
                },
            },
        },
        Config => {
            Data          => 'AgentTicketForward',
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {},
    },
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Hash using [Not]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketForward', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ '[Not]AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketForward',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
            3 => 'AgentTicketForward'
        },
    },
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Hash using [RegExp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketForward', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ '[RegExp]Close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketForward',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
            3 => 'AgentTicketForward',
        },
    },
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Hash using [regexp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketForward', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ '[regexp]close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketForward',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
            3 => 'AgentTicketForward',
        },
    },
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Hash using [NotRegExp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketForward', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ '[NotRegExp]Close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketForward',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
            3 => 'AgentTicketForward',
        },
    },
    {
        Name => 'ACL Action - PossibleAdd Data as a Correct Hash using [Notregexp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketForward', ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ '[Notregexp]close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketForward',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
            3 => 'AgentTicketForward',
        },
    },

    # PossibleNot tests
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Hash:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',

        },
    },
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Scalar:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data          => 'AgentTicketClose',
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {},
    },
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Scalar 2:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ 'AgentTicketBounce', ],
                },
            },
        },
        Config => {
            Data          => '-',
            Action        => 'AgentTicketClose',
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Hash using [Not]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ '[Not]AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Hash using [RegExp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ '[RegExp]Close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
        },
    },
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Hash using [regexp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ '[regexp]close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
        },
    },
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Hash using [NotRegExp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ '[NotRegExp]Close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },
    {
        Name => 'ACL Action - PossibleNot Data as a Correct Hash using [Notregexp]:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ '[Notregexp]close', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },

    # Possible/PossibleNot tests
    {
        Name => 'ACL Action - Possible/PossibleNot Data as a Correct Hash:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', 'AgentTicketBounce' ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ 'AgentTicketBounce', ],
                },
            },

        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTikcetForward',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
        },
    },

    # Possible/PossibleAdd tests
    {
        Name => 'ACL Action - Possible/PossibleAdd Data as a Correct Hash:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', 'AgentTicketBounce' ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ 'AgentTicketForward', ],
                },
            },

        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketForward',
                4 => 'AgentTicketCompose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            1 => 'AgentTicketClose',
            2 => 'AgentTicketBounce',
            3 => 'AgentTicketForward',
        },
    },

    # Possible/PossibleAdd/PossibleNot tests
    {
        Name => 'ACL Action - Possible/PossibleAdd/PossibleNot Data as a Correct Hash:',
        ACLs => {
            'Action1' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                Possible => {
                    Action => [ 'AgentTicketClose', 'AgentTicketBounce' ],
                },
            },
            'Action2' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleAdd => {
                    Action => [ 'AgentTicketForward', ],
                },
            },
            'Action3' => {
                Properties => {
                    Queue => {
                        Name => ['Raw'],
                    },
                },
                PossibleNot => {
                    Action => [ 'AgentTicketClose', ],
                },
            },
        },
        Config => {
            Data => {
                1 => 'AgentTicketClose',
                2 => 'AgentTicketBounce',
                3 => 'AgentTicketForward',
                4 => 'AgentTicketCompose',
            },
            ReturnType    => 'Action',
            ReturnSubType => '-',
            Queue         => 'Raw',
            UserID        => $UserID,
        },
        SuccessMatch     => 1,
        ReturnActionData => {
            2 => 'AgentTicketBounce',
            3 => 'AgentTicketForward',
        },
    },
);

$ExecuteTests->( Tests => \@Tests );

# cleanup is done by RestoreDatabase.

1;
