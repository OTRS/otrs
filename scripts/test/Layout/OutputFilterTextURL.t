# --
# OutputFilterTextURL.t - tests to check correct transformations of URLs
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self %Param));
use utf8;

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
my $LayoutObject = Kernel::Output::HTML::Layout->new(
    ConfigObject       => $Self->{ConfigObject},
    LogObject          => $Self->{LogObject},
    TimeObject         => $Self->{TimeObject},
    MainObject         => $Self->{MainObject},
    EncodeObject       => $Self->{EncodeObject},
    SessionObject      => $SessionObject,
    DBObject           => $Self->{DBObject},
    ParamObject        => $ParamObject,
    TicketObject       => $TicketObject,
    UserObject         => $UserObject,
    GroupObject        => $GroupObject,
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);

my @Tests = (
    {
        Name  => 'Simple URL',
        Input => 'http://www.url.com',
    },
    {
        Name  => 'URL with parameters',
        Input => 'http://www.url.com?parameter=test;parameter2=test2',
    },
    {
        Name  => 'URL with round brackets',
        Input => 'http://www.url.com/file(1)name/file(2)name',
    },

    # {
    #     Name     => 'URL with square brackets',
    #     Input    => 'http://www.url.com?host[0]=hostname;[1]',
    # },
);

for my $Test (@Tests) {

    my $Output = $LayoutObject->Ascii2Html(
        Text        => $Test->{Input},
        LinkFeature => 1,
    );

    $Self->Is(
        $Output,
        '<a href="'
            . $Test->{Input}
            . '" target="_blank" title="'
            . $Test->{Input} . '">'
            . $Test->{Input} . '</a>',
        $Test->{Name},
    );
}

1;
