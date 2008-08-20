# --
# Email.t - email parser tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Email.t,v 1.3 2008-08-20 15:10:38 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use utf8;
use Kernel::System::Email;
use Kernel::System::EmailParser;

# do not really send emails
$Self->{ConfigObject}->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# test scenarios
my @Tests = (
    {
        Name => 'ascii',
        Data => {
            From    => 'john.smith@example.com',
            To      => 'john.smith2@example.com',
            Subject => 'some subject',
            Body    => 'Some Body',
            Type    => 'text/plain',
            Charset => 'utf8',
        },
    },
    {
        Name => 'utf8 - de',
        Data => {
            From => '"Fritz Müller" <fritz@example.com>',
            To   => 'Hans Kölner (friend@example.com)',
            Subject =>
                'This is a text with öäüßöäüß to check for problems äöüÄÖüßüöä!',
            Body    => "Some Body\nwith\n\nöäüßüüäöäüß1öää?ÖÄPÜ",
            Type    => 'text/plain',
            Charset => 'utf8',
        },
    },
    {
        Name => 'utf8 - ru',
        Data => {
            From => '"Служба поддержки (support)" <me@example.com>',
            To   => 'friend@example.com',
            Subject =>
                'это специальныйсабжект для теста системы тикетов',
            Body    => "Some Body\nlala",
            Type    => 'text/plain',
            Charset => 'utf8',
        },
    },
);

my $Count = 0;
for my $Encoding ( '', qw(base64 quoted-printable 8bit) ) {
    $Count++;
    my $CountSub = 0;
    for my $Test (@Tests) {
        $CountSub++;
        my $Name = "#$Count.$CountSub $Encoding $Test->{Name}";

        # set forcing of encoding
        $Self->{ConfigObject}->Set(
            Key   => 'SendmailEncodingForce',
            Value => $Encoding,
        );

        # gererate email
        my $EmailObject = Kernel::System::Email->new( %{$Self} );
        my ( $Header, $Body ) = $EmailObject->Send(
            %{ $Test->{Data} },
        );

        # start MIME::Tools workaround
        ${$Body} =~ s/\n/\r/g;

        # end MIME::Tools workaround
        my $Email = ${$Header} . "\n" . ${$Body};
        my @Array = split /\n/, $Email;

        # parse email
        my $ParserObject = Kernel::System::EmailParser->new(
            %{$Self},
            Email => \@Array,
        );

        # check header
        for my $Key (qw(From To Cc Subject)) {
            next if !$Test->{Data}->{$Key};
            $Self->Is(
                $ParserObject->GetParam( WHAT => $Key ),
                $Test->{Data}->{$Key},
                "$Name GetParam(WHAT => '$Key')",
            );
        }

        # check body
        if ( $Test->{Data}->{Body} ) {
            my $Body = $ParserObject->GetMessageBody();

            # start MIME::Tools workaround
            $Body =~ s/\r/\n/g;
            $Body =~ s/=\n//;
            $Body =~ s/\n$//;
            $Body =~ s/=$//;

            # end MIME::Tools workaround
            $Self->Is(
                $Body,
                $Test->{Data}->{Body},
                "$Name GetMessageBody()",
            );
        }

        # check charset
        if ( $Test->{Data}->{Charset} ) {
            $Self->Is(
                $ParserObject->GetCharset(),
                $Test->{Data}->{Charset},
                "$Name GetCharset()",
            );
        }
    }
}

# reset email encoding
$Self->{ConfigObject}->Set(
    Key   => 'SendmailEncodingForce',
    Value => '',
);

1;
