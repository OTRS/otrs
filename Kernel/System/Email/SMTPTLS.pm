# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::SMTPTLS;

use strict;
use warnings;

use Net::SMTP;

use parent qw(Kernel::System::Email::SMTP);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

# Use Net::SSLGlue::SMTP on systems with older Net::SMTP modules that cannot handle SMTPTLS.
BEGIN {
    if ( !defined &Net::SMTP::starttls ) {
        ## nofilter(TidyAll::Plugin::OTRS::Perl::Require)
        ## nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)
        require Net::SSLGlue::SMTP;
    }
}

sub _Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(MailHost FQDN)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # Remove a possible port from the FQDN value
    my $FQDN = $Param{FQDN};
    $FQDN =~ s{:\d+}{}smx;

    # set up connection connection
    my $SMTP = Net::SMTP->new(
        $Param{MailHost},
        Hello   => $FQDN,
        Port    => $Param{SMTPPort} || 587,
        Timeout => 30,
        Debug   => $Param{SMTPDebug},
    );

    return if !$SMTP;

    $SMTP->starttls(
        SSL_verify_mode => 0,
    );

    return $SMTP;
}

1;
