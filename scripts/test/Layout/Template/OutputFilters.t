# --
# scripts/test/Layout/Template/OutputFilters.t - layout testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self %Param));

use File::Basename qw();

use Kernel::System::AuthSession;
use Kernel::System::Web::Request;
use Kernel::System::Group;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::Output::HTML::Layout;

# create local objects
my $SessionObject = Kernel::System::AuthSession->new( %{$Self} );
my $GroupObject   = Kernel::System::Group->new( %{$Self} );
my $TicketObject  = Kernel::System::Ticket->new( %{$Self} );
my $UserObject    = Kernel::System::User->new( %{$Self} );
my $ParamObject   = Kernel::System::Web::Request->new(
    %{$Self},
    WebRequest => $Param{WebRequest} || 0,
);

my @Tests = (
    {
        Name   => 'Ouptput filter post',
        Config => {
            "Frontend::Output::FilterElementPre"  => {},
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPostPrefix:\n",
                },
            },
        },
        Data => {
            Title => 'B&B'
        },
        Result => 'OutputFilterPostPrefix:
Test: B&B
',
    },
    {
        Name   => 'Ouptput filter post, cache test',
        Config => {
            "Frontend::Output::FilterElementPre"  => {},
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPostPrefix2:\n",
                },
            },
        },
        Data => {
            Title => 'B&B'
        },
        Result => 'OutputFilterPostPrefix2:
Test: B&B
',
    },
    {
        Name   => 'Output filter pre',
        Config => {
            "Frontend::Output::FilterElementPre" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPrePrefix:\n",
                },
            },
            "Frontend::Output::FilterElementPost" => {},
        },
        Data => {
            Title => 'B&B'
        },
        Result => 'OutputFilterPrePrefix:
Test: B&B
',
    },
    {
        Name   => 'Output filter pre, cache test',
        Config => {
            "Frontend::Output::FilterElementPre" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPrePrefix2:\n",
                },
            },
            "Frontend::Output::FilterElementPost" => {},
        },
        Data => {
            Title => 'B&B 2'
        },
        Result => 'OutputFilterPrePrefix2:
Test: B&B 2
',
    },
);

for my $Test (@Tests) {

    my $ConfigObject = $Kernel::OM->Get('ConfigObject');

    for my $Key ( sort keys %{ $Test->{Config} || {} } ) {
        $ConfigObject->Set( Key => $Key, Value => $Test->{Config}->{$Key} );
    }

    my $LayoutObject = Kernel::Output::HTML::Layout->new(
        ConfigObject  => $ConfigObject,
        LogObject     => $Self->{LogObject},
        TimeObject    => $Self->{TimeObject},
        MainObject    => $Self->{MainObject},
        EncodeObject  => $Self->{EncodeObject},
        SessionObject => $SessionObject,
        DBObject      => $Self->{DBObject},
        ParamObject   => $ParamObject,
        TicketObject  => $TicketObject,
        UserObject    => $UserObject,
        GroupObject   => $GroupObject,
        UserID        => 1,
        Lang          => 'de',
    );

    # Call Output() once so that the TT objects are created.
    $LayoutObject->Output( Template => '' );

    # Now add this directory as include path to be able to use the test templates
    my $IncludePaths = $LayoutObject->{TemplateProviderObject}->include_path();
    unshift @{$IncludePaths}, $ConfigObject->Get('Home') . '/scripts/test/Layout/Template';
    $LayoutObject->{TemplateProviderObject}->include_path($IncludePaths);

    for my $Block ( @{ $Test->{BlockData} || [] } ) {
        $LayoutObject->Block( %{$Block} );
    }

    my $Result = $LayoutObject->Output(
        TemplateFile => 'OutputFilters',
        Data => $Test->{Data} // {},
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
