# --
# AuthSession.t - auth session tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::AuthSession;

# use local Config object because it will be modified
my $ConfigObject = Kernel::Config->new();

# get home directory
my $HomeDir = $ConfigObject->Get('Home');

# get all avaliable backend modules
my @BackendModuleFiles = $Self->{MainObject}->DirectoryRead(
    Directory => $HomeDir . '/Kernel/System/AuthSession/',
    Filter    => '*.pm',
    Silent    => 1,
);

MODULEFILE:
for my $ModuleFile (@BackendModuleFiles) {

    next MODULEFILE if !$ModuleFile;

    # extract module name
    my ($Module) = $ModuleFile =~ m{ \/+ ([a-zA-Z0-9]+) \.pm $ }xms;

    next MODULEFILE if !$Module;

    $ConfigObject->Set(
        Key   => 'SessionModule',
        Value => "Kernel::System::AuthSession::$Module",
    );

    my $SessionObject = Kernel::System::AuthSession->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    my $LongString = '';
    for my $Count ( 1 .. 2 ) {
        for ( 1 .. 5 ) {
            $LongString .= $LongString . " $_ abcdefghijklmnopqrstuvwxy1234567890äöüß\n";
        }
        my $Length = length($LongString);
        my $Size   = $Length;
        if ( $Size > ( 1024 * 1024 ) ) {
            $Size = sprintf "%.1f MBytes", ( $Size / ( 1024 * 1024 ) );
        }
        elsif ( $Size > 1024 ) {
            $Size = sprintf "%.1f KBytes", ( ( $Size / 1024 ) );
        }
        else {
            $Size = $Size . ' Bytes';
        }

        my %NewSessionData = (
            UserLogin                => 'root',
            UserEmail                => 'root@example.com',
            'LongStringNew' . $Count => $LongString,
            UserTest                 => 'SomeÄÖÜß.',
            UserType                 => 'User',
            SomeComplexData => {    # verify that complex data can be stored too
                'CaseSensitive' => 1,
                }
        );

        my $SessionID = $SessionObject->CreateSessionID(%NewSessionData);

        # tests
        $Self->True(
            $SessionID,
            "#$Module - CreateSessionID()",
        );

        my %NewSessionDataCheck = $SessionObject->GetSessionIDData( SessionID => $SessionID );
        delete $NewSessionDataCheck{UserChallengeToken};
        delete $NewSessionDataCheck{UserRemoteAddr};
        delete $NewSessionDataCheck{UserRemoteUserAgent};
        delete $NewSessionDataCheck{UserSessionStart};

        $Self->IsDeeply(
            \%NewSessionDataCheck,
            \%NewSessionData,
            "Initial session data",
        );

        my %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );

        $Self->Is(
            $Data{UserLogin} || 0,
            'root',
            "#$Module - GetSessionIDData()",
        );

        my $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'LastScreenView',
            Value     => 'SomeInfo1234',
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - #1",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'Value0',
            Value     => 0,
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Value0",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'Value1',
            Value     => 1,
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Value1",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => "Value''",
            Value     => '',
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Value''",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => "Value-undef",
            Value     => 'SomeValue',
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Value-undef",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'LongString',
            Value     => "Some string with dyn. content: $Count",
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Long dyn.",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'LongString' . $Count,
            Value     => $LongString,
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Long ($Size)",
        );

        %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );

        $Self->Is(
            $Data{"UserTest"},
            'SomeÄÖÜß.',
            "#$Module - GetSessionIDData() - utf8",
        );

        $Self->Is(
            $Data{"Value0"},
            0,
            "#$Module - GetSessionIDData() - Value0 ($Data{ 'Value0' })",
        );

        $Self->Is(
            $Data{"Value1"},
            1,
            "#$Module - GetSessionIDData() - Value1 ($Data{ 'Value1' })",
        );

        $Self->Is(
            $Data{"Value''"},
            '',
            "#$Module - GetSessionIDData() - Value'' (" . $Data{"Value''"} . ")",
        );

        $Self->True(
            $Data{ "LongString" . $Count } eq $LongString,
            "#$Module - GetSessionIDData() - Long ($Size)",
        );

        $Self->True(
            $Data{ "LongStringNew" . $Count } eq $LongString,
            "#$Module - GetSessionIDData() - Long ($Size)",
        );

        $Self->Is(
            $Data{"LongString"},
            "Some string with dyn. content: $Count",
            "#$Module - GetSessionIDData() - Long dyn.",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'UserTest',
            Value     => 'カスタ äüöß.',
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - utf8",
        );

        %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );

        $Self->Is(
            $Data{"UserTest"} || '',
            'カスタ äüöß.',
            "#$Module - GetSessionIDData() - utf8",
        );

        # session reconnect 1
        $SessionObject = Kernel::System::AuthSession->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );

        $Self->Is(
            $Data{"UserTest"},
            'カスタ äüöß.',
            "#$Module - GetSessionIDData() - reconnect 1 - utf8",
        );

        $Self->Is(
            $Data{"Value0"},
            0,
            "#$Module - GetSessionIDData() - reconnect 1 - Value0 ($Data{ 'Value0' })",
        );

        $Self->Is(
            $Data{"Value1"},
            1,
            "#$Module - GetSessionIDData() - reconnect 1 - Value1 ($Data{ 'Value1' })",
        );

        $Self->Is(
            $Data{"Value''"},
            '',
            "#$Module - GetSessionIDData() - reconnect 1 - Value'' (" . $Data{"Value''"} . ")",
        );

        $Update = $SessionObject->UpdateSessionID(
            SessionID => $SessionID,
            Key       => "Value-undef",
            Value     => undef,
        );

        # session reconnect 2
        $SessionObject = Kernel::System::AuthSession->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );

        $Self->Is(
            $Data{"UserTest"},
            'カスタ äüöß.',
            "#$Module - GetSessionIDData() - reconnect 2 - utf8",
        );

        $Self->Is(
            $Data{"Value0"},
            0,
            "#$Module - GetSessionIDData() - reconnect 2 - Value0 ($Data{ 'Value0' })",
        );

        $Self->Is(
            $Data{"Value1"},
            1,
            "#$Module - GetSessionIDData() - reconnect 2 - Value1 ($Data{ 'Value1' })",
        );

        $Self->Is(
            $Data{"Value''"},
            '',
            "#$Module - GetSessionIDData() - reconnect 2 - Value'' (" . $Data{"Value''"} . ")",
        );

        $Self->Is(
            $Data{"Value-undef"},
            undef,
            "#$Module - GetSessionIDData() - reconnect 2 - Value-undef (undef)",
        );

        my $Remove = $SessionObject->RemoveSessionID( SessionID => $SessionID );

        $Self->True(
            $Remove,
            "#$Module - RemoveSessionID()",
        );
    }

    my $CleanUp = $SessionObject->CleanUp();

    $Self->True(
        $CleanUp,
        "#$Module - CleanUp()",
    );
}

1;
