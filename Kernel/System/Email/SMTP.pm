# --
# Kernel/System/Email/SMTP.pm - the global email send module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SMTP.pm,v 1.23 2008-12-04 14:52:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Email::SMTP;

use strict;
use warnings;
use Net::SMTP;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.23 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

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

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{From} ) {
        $Param{From} = '';
    }

    # try it 3 times to connect with the SMTP server
    # (M$ Exchange Server 2007 have sometimes problems on port 25)
    my $SMTP;
    TRY:
    for my $Try ( 1 .. 3 ) {

        # connect to mail server
        $SMTP = Net::SMTP->new(
            $Self->{MailHost},
            Hello   => $Self->{FQDN},
            Port    => $Self->{SMTPPort},
            Timeout => $Self->{SMTPTimeout},
            Debug   => $Self->{SMTPDebug},
        );

        last TRY if $SMTP;

        # sleep 0,3 seconds;
        select( undef, undef, undef, 0.3 );
    }

    # return if no connect was possible
    if ( !$SMTP ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't connect to $Self->{MailHost}: $!!",
        );
        return;
    }

    # use smtp auth if configured
    if ( $Self->{User} && $Self->{Password} ) {
        if ( !$SMTP->auth( $Self->{User}, $Self->{Password} ) ) {
            my $Error = $SMTP->code() . $SMTP->message();
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "SMTP authentication failed: $Error! Enable Net::SMTP debug for more info!",
            );
            $SMTP->quit();
            return;
        }
    }

    # set from, return it from was not accepted
    if ( !$SMTP->mail( $Param{From} ) ) {
        my $Error = $SMTP->code() . $SMTP->message();
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't use from '$Param{From}': $Error! Enable Net::SMTP debug for more info!",
        );
        $SMTP->quit;
        return;
    }

    # get recipients
    my $ToString = '';
    for my $To ( @{ $Param{ToArray} } ) {
        $ToString .= $To . ',';
        if ( !$SMTP->to($To) ) {
            my $Error = $SMTP->code() . $SMTP->message();
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't send to '$To': $Error! Enable Net::SMTP debug for more info!",
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
        my $Error = $SMTP->code() . $SMTP->message();
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't send message: $Error! Enable Net::SMTP debug for more info!"
        );
        $SMTP->quit;
        return;
    }
    $SMTP->quit;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent email to '$ToString' from '$Param{From}'.",
        );
    }
    return 1;
}

1;
