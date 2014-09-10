# --
# Email.t - email parser tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::EmailParser;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# do not really send emails
$ConfigObject->Set(
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
            To   => '"Hans Kölner" <friend@example.com>',
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
    {
        Name => 'utf8 - high unicode characters',
        Data => {
            From    => '"Служба поддержки (support)" <me@example.com>',
            To      => 'friend@example.com',
            Subject => 'Test related to bug#9832',
            Body    => "\x{2660}",
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
        $ConfigObject->Set(
            Key   => 'SendmailEncodingForce',
            Value => $Encoding,
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Email'] );
        my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

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
            Email => \@Array,
        );

        # check header
        KEY:
        for my $Key (qw(From To Cc Subject)) {
            next KEY if !$Test->{Data}->{$Key};
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

        # check Content-Type
        if ( $Test->{Data}->{Type} ) {
            $Self->Is(
                ( split ';', $ParserObject->GetContentType() )[0],
                $Test->{Data}->{Type},
                "$Name GetContentType()",
            );
        }
    }
}

1;
