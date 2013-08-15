# --
# Kernel/System/Email/SMTPTLS.pm - email send backend for SMTP/TLS
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::SMTPTLS;

use strict;
use warnings;

use Net::SSLGlue::SMTP;

use base qw(Kernel::System::Email::SMTP);

sub _Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(MailHost FQDN)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # set up connection connection
    my $SMTP = Net::SMTP->new(
        $Param{MailHost},
        Hello   => $Param{FQDN},
        Port    => $Param{SMTPPort} || 587,
        Timeout => 30,
        Debug   => $Param{SMTPDebug},
    );
    $SMTP->starttls(
        SSL_verify_mode => 0,
    );
    return $SMTP;
}

1;
