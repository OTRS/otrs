# --
# Kernel/System/Email/SMTP.pm - the global email send module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: SMTP.pm,v 1.17 2007-12-04 13:12:27 ot Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email::SMTP;

use strict;
use warnings;
use Net::SMTP;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    for (qw(ConfigObject LogObject EncodeObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }

    # debug
    $Self->{Debug} = $Param{Debug} || 0;
    if ( $Self->{Debug} > 2 ) {

        # shown on STDERR
        $Self->{SMTPDebug} = 1;
    }

    # smtp timeout in sec
    $Self->{SMTPTimeout} = 30;

    # get config data
    $Self->{FQDN}     = $Self->{ConfigObject}->Get('FQDN');
    $Self->{MailHost} = $Self->{ConfigObject}->Get('SendmailModule::Host')
        || die "No SendmailModule::Host found in Kernel/Config.pm";
    $Self->{SMTPPort} = $Self->{ConfigObject}->Get('SendmailModule::Port') || 'smtp(25)';
    $Self->{User}     = $Self->{ConfigObject}->Get('SendmailModule::AuthUser');
    $Self->{Password} = $Self->{ConfigObject}->Get('SendmailModule::AuthPassword');
    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    my $ToString = '';

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{From} ) {
        $Param{From} = "";
    }

    # send mail
    my $SMTP = Net::SMTP->new(
        $Self->{MailHost},
        Hello   => $Self->{FQDN},
        Port    => $Self->{SMTPPort},
        Timeout => $Self->{SMTPTimeout},
        Debug   => $Self->{SMTPDebug}
    );
    if (!$SMTP) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't connect to $Self->{MailHost}: $!!",
        );
        return;
    }

    if ( $Self->{User} && $Self->{Password} ) {
        if ( !$SMTP->auth( $Self->{User}, $Self->{Password} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "SMTP authentication failed! Enable debug for more info!",
            );
            $SMTP->quit();
            return;
        }
    }
    if ( !$SMTP->mail( $Param{From} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't use from: $Param{From}! Enable debug for more info!",
        );
        $SMTP->quit;
        return;
    }
    for ( @{ $Param{ToArray} } ) {
        $ToString .= "$_,";
        if ( !$SMTP->to($_) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't send to: $_! Enable debug for more info!",
            );
            $SMTP->quit;
            return;
        }
    }

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $Self->{EncodeObject}->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $Self->{EncodeObject}->EncodeOutput( $Param{Body} );

    # send data
    if ( !$SMTP->data( ${ $Param{Header} }, "\n", ${ $Param{Body} } ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't send message. Server code "
                        . $Self->{SMTPObject}->code() . ", '" . $Self->{SMTPObject}->message()
                        . "' Enable debug for more info!"
        );
        $SMTP->quit;
        return;
    }
    $SMTP->quit;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log( Message => "Sent email to '$ToString' from '$Param{From}'.", );
    }
    return 1;

}

1;
