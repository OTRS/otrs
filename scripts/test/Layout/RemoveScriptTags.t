# --
# scripts/test/Layout/_RemoveScriptTags.t - layout module testscript
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

# Tests for _RemoveScriptTags method
my @Tests = (
    {
        Input  => '',
        Result => '',
        Name   => '_RemoveScriptTags - empty test',
    },
    {
        Input  => '<script type="text/javascript"></script>',
        Result => '',
        Name   => '_RemoveScriptTags - just tags test',
    },
    {
        Input => '
<script type="text/javascript">
    123
    // 456
    789
</script>',
        Result => '

    123
    // 456
    789
',
        Name => '_RemoveScriptTags - some content test',
    },
    {
        Input => '
<script type="text/javascript">//<![CDATA[
    OTRS.UI.Tables.InitTableFilter($(\'#FilterCustomers\'), $(\'#Customers\'));
    OTRS.UI.Tables.InitTableFilter($(\'#FilterGroups\'), $(\'#Groups\'));
//]]></script>
        ',
        Result => '

    OTRS.UI.Tables.InitTableFilter($(\'#FilterCustomers\'), $(\'#Customers\'));
    OTRS.UI.Tables.InitTableFilter($(\'#FilterGroups\'), $(\'#Groups\'));

        ',
        Name => '_RemoveScriptTags - complete content test',
    },
    {
        Input => <<'EOF',
<!--DocumentReadyActionRowAdd-->
<script type="text/javascript">  //<![CDATA[
   alert();
//]]></script>
<!--/DocumentReadyActionRowAdd-->
<!--DocumentReadyStart-->
<script type="text/javascript">//  <![CDATA[
   alert();
//]]></script>
<!--/DocumentReadyStart-->
EOF
        Result => <<"EOF",

   alert();
\n
   alert();

EOF
        Name => '_RemoveScriptTags - complete content test with block comments',
    },
    {
        Input => <<'EOF',
<script type="text/javascript">  //<![CDATA[
<!--DocumentReadyActionRowAdd-->
   alert();
<!--/DocumentReadyActionRowAdd-->
//]]></script>
EOF
        Result => <<"EOF",

   alert();

EOF
        Name =>
            '_RemoveScriptTags - complete content test with block comments inside the script tags',
    },
);

for my $Test (@Tests) {
    my $LRST = $LayoutObject->_RemoveScriptTags(
        Code => $Test->{Input},
    );
    $Self->Is(
        $LRST,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
