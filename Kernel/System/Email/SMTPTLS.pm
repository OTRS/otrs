# --
# Kernel/System/Email/SMTPTLS.pm - the global email send module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::SMTPTLS;

use strict;
use warnings;

use Net::SMTP::TLS::ButMaintained;

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
        || die "No SendmailModule::Host found in Core::Postmaster";
    $Self->{SMTPPort} = $Self->{ConfigObject}->Get('SendmailModule::Port') || 587;
    $Self->{User} = $Self->{ConfigObject}->Get('SendmailModule::AuthUser')
        || die "No SendmailModule::AuthUser found in Core::Postmaster";
    $Self->{Password} = $Self->{ConfigObject}->Get('SendmailModule::AuthPassword')
        || die "No SendmailModule::AuthPassword found in Core::Postmaster";
    return $Self;
}

sub Check {
    my ( $Self, %Param ) = @_;

    # try it 3 times to connect with the SMTP server
    # (M$ Exchange Server 2007 have sometimes problems on port 25)
    my $SMTP;
    TRY:
    for my $Try ( 1 .. 3 ) {

        # connect to mail server
        # During construction of an <Net::SMTP::TLS::ButMaintained> instance,
        # the full login process will occur.
        $SMTP = Net::SMTP::TLS::ButMaintained->new(
            $Self->{MailHost},
            Hello   => $Self->{FQDN},
            Port    => $Self->{SMTPPort},
            Timeout => $Self->{SMTPTimeout},

            #            Debug   => $Self->{SMTPDebug},
            Debug    => 1,
            User     => $Self->{User},
            Password => $Self->{Password},
        );

        last TRY if $SMTP;

        # sleep 0,3 seconds;
        select( undef, undef, undef, 0.3 );    ## no critic
    }

    # return if no connect was possible
    if ( !$SMTP ) {
        return ( Successful => 0, Message => "Can't connect to $Self->{MailHost}: $!!" );
    }

    return ( Successful => 1, SMTPTLS => $SMTP );
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

    # connect to mail server
    my $SMTP = Net::SMTP::TLS::ButMaintained->new(
        $Self->{MailHost},
        Hello    => $Self->{FQDN},
        Port     => $Self->{SMTPPort},
        User     => $Self->{User},
        Password => $Self->{Password},
        Timeout  => $Self->{SMTPTimeout},
        Debug    => $Self->{SMTPDebug},
    );

    # return if no connect was possible
    if ( !$SMTP ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't connect to $Self->{MailHost}: $!!",
        );
        return;
    }

    # set from, return if from was not accepted
    eval { $SMTP->mail( $Param{From} ) };
    if ($@) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't use from '$Param{From}': $@!",
        );
        $SMTP->quit();
        return;
    }

    # get recipients
    my $ToString = '';
    for my $To ( @{ $Param{ToArray} } ) {
        $ToString .= $To . ',';
        eval { $SMTP->to($To) };
        if ($@) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't send to '$To': $@!",
            );
            $SMTP->quit();
            return;
        }
    }

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $Self->{EncodeObject}->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $Self->{EncodeObject}->EncodeOutput( $Param{Body} );

    # send data
    $SMTP->data();
    eval { $SMTP->datasend( ${ $Param{Header} }, "\n", ${ $Param{Body} } ) };
    if ($@) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't send message: $@!"
        );
        $SMTP->quit();
        return;
    }
    $SMTP->dataend();
    $SMTP->quit();

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
