# --
# Kernel/System/Email.pm - the global email send module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Email.pm,v 1.7 2004-09-28 17:46:52 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email;

use strict;
use MIME::Words qw(:all);
use MIME::Entity;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Email - to send email

=head1 SYNOPSIS

Global module to send email via sendmail or SMTP.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::Time;
  use Kernel::System::DB;
  use Kernel::System::Email;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $TimeObject    = Kernel::System::Time->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $SendObject = Kernel::System::Email->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
      TimeObject => $TimeObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # debug level
    $Self->{Debug} = $Param{Debug} || 0;
    # check all needed objects
    foreach (qw(ConfigObject LogObject DBObject TimeObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # load generator backend module
    my $GenericModule = $Self->{ConfigObject}->Get('SendmailModule')
      || 'Kernel::System::Email::Sendmail';
    if (!eval "require $GenericModule") {
        die "Can't load sendmail backend module $GenericModule! $@";
    }
    # create backend object
    $Self->{Backend} = $GenericModule->new(%Param);

    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');

    return $Self;
}

=item Send()

To send an email without already created header:

    if ($SendObject->Send(
      From => 'me@example.com',
      To => 'friend@example.com',
      Subject => 'Some words!',
      Type => 'text/plain',
      Charset => 'iso-8859-15',
      Body => 'Some nice text',)) {
        print "Email sent!\n";
    }
    else {
        print "Email not sent!\n";
    }

To send an email with already created header:

    if ($SendObject->Send(
      From => 'me@example.com',
      To => 'friend@example.com',
      Header => $Header,
      Body => $Body,)) {
        print "Email sent!\n";
    }
    else {
        print "Email not sent!\n";
    }

=cut

sub Send {
    my $Self = shift;
    my %Param = @_;

    # check needed stuff
    foreach (qw(Body)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{To} && !$Param{Cc} && !$Param{Bcc}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need To, Cc or Bcc!");
        return;
    }
    # check from
    if (!$Param{From}) {
        $Param{From} = $Self->{ConfigObject}->Get('AdminEmail') || 'otrs@localhost';
    }

    if (!$Param{Header}) {
        my %Header = ();
        foreach (qw(From To Cc Bcc Subject Organization Charset)) {
            if ($Param{$_}) {
                $Header{$_} = $Param{$_};
            }
        }
        # do some encode
        foreach (qw(From To Cc Bcc Subject)) {
            if ($Header{$_} && $Param{Charset}) {
                $Header{$_} = encode_mimewords($Header{$_}, Charset => $Param{Charset}) || '';
            }
        }
        $Header{'X-Mailer'} = "OTRS Mail Service ($VERSION)";
        $Header{'X-Powered-By'} = 'OTRS - Open Ticket Request System (http://otrs.org/)';
        $Header{'Type'} = $Param{Type} || 'text/plain';
        if ($Param{Charset} && $Param{Charset} =~ /utf(8|-8)/i) {
            $Header{'Encoding'} = '8bit';
#            $Header{'Encoding'} = 'base64';
        }
        else {
            $Header{'Encoding'} = '7bit';
        }
        $Header{'Message-ID'} = "Message-ID: <".time().".".rand(999999)."\@$Self->{FQDN}>";
        my $Entity = MIME::Entity->build(%Header, Data => $Param{Body});
        # get header
        my $head = $Entity->head;
        $Param{Header} = $head->as_string();

        $Param{Body} = $Entity->body_as_string();
    }
    # add date header
    $Param{Header} = "Date: ".$Self->{TimeObject}->MailTimeStamp()."\n".$Param{Header};
    # get recipients
    my $To = '';
    my @ToArray = ();
    foreach (qw(To Cc Bcc)) {
        if ($Param{$_}) {
            foreach my $Email (Mail::Address->parse($Param{$_})) {
                push (@ToArray, $Email->address());
                if ($To) {
                    $To .= ', ';
                }
                $To .= $Email->address();
            }
        }
    }
    if ($Self->{SendmailBcc}) {
        push (@ToArray, $Self->{SendmailBcc});
        $To .= ", $Self->{SendmailBcc}";
    }

    # get sender
    my @Sender = Mail::Address->parse($Param{From});
    my $RealFrom = $Sender[0]->address();

    # debug
    if ($Self->{Debug} > 1) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Sent email to '$To' from '$RealFrom'. ".
                "Subject => $Param{Subject};",
        );
    }

    return $Self->{Backend}->Send(
        From => $RealFrom,
        To => $To,
        ToArray => \@ToArray,
        Header => \$Param{Header},
        Body => \$Param{Body},
    );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.7 $ $Date: 2004-09-28 17:46:52 $

=cut

