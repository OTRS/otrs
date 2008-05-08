# --
# AuthSession.t - auth session tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AuthSession.t,v 1.8 2008-05-08 09:35:57 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use utf8;
use Kernel::System::AuthSession;

for my $Module (qw(DB FS IPC)) {

    # don't use IPC on win
    if ( $Module eq 'IPC' && $^O =~ /win/i ) {
        next;
    }

    $Self->{ConfigObject}
        ->Set( Key => 'SessionModule', Value => "Kernel::System::AuthSession::$Module" );

    $Self->{SessionObject} = Kernel::System::AuthSession->new( %{$Self} );

    my $LongString = '';
    for my $Count ( 1 .. 2 ) {
        for ( 1 .. 4 ) {
            $LongString .= $LongString . " $_ abcdefghijklmnopqrstuvwxyz1234567890äöüß\n";
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

        my $SessionID = $Self->{SessionObject}->CreateSessionID(
            UserLogin                => 'root',
            UserEmail                => 'root@example.com',
            'LongStringNew' . $Count => $LongString,
            UserTest                 => 'SomeÄÖÜß.',
        );

        # tests
        $Self->True(
            $SessionID,
            "#$Module - CreateSessionID()",
        );

        my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );

        $Self->Is(
            $Data{UserLogin} || 0,
            'root',
            "#$Module - GetSessionIDData()",
        );

        my $Update = $Self->{SessionObject}->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'LastScreenView',
            Value     => 'SomeInfo1234',
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - #1",
        );

        $Update = $Self->{SessionObject}->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'LongString',
            Value     => "Some string with dyn. content: $Count",
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Long dyn.",
        );

        $Update = $Self->{SessionObject}->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'LongString' . $Count,
            Value     => $LongString,
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - Long ($Size)",
        );

        %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );

        $Self->True(
            $Data{"UserTest"} eq 'SomeÄÖÜß.',
            "#$Module - GetSessionIDData() - utf8",
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

        $Update = $Self->{SessionObject}->UpdateSessionID(
            SessionID => $SessionID,
            Key       => 'UserTest',
            Value     => 'カスタ äüöß.',
        );

        $Self->True(
            $Update,
            "#$Module - UpdateSessionID() - utf8",
        );

        %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );

        $Self->Is(
            $Data{"UserTest"} || '',
            'カスタ äüöß.',
            "#$Module - GetSessionIDData() - utf8",
        );

        my $Remove = $Self->{SessionObject}->RemoveSessionID( SessionID => $SessionID );

        $Self->True(
            $Remove,
            "#$Module - RemoveSessionID()",
        );
    }

    my $CleanUp = $Self->{SessionObject}->CleanUp();

    $Self->True(
        $CleanUp,
        "#$Module - CleanUp()",
    );

}
1;
