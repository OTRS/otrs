# --
# Kernel/System/AuthSession.pm - provides session check and session data
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AuthSession.pm,v 1.22 2004-09-27 13:37:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;


=head1 NAME

Kernel::System::AuthSeesion - global session interface

=head1 SYNOPSIS

All session functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::AuthSession;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $SesionObject = Kernel::System::AuthSession->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
  );

(The session backend (DB, FS or IPC) is configures in Kernel/Config.pm)

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # load generator backend module
    my $GenericModule = $Self->{ConfigObject}->Get('SessionModule')
      || 'Kernel::System::AuthSession::DB';
    if (!eval "require $GenericModule") {
        die "Can't load session backend module $GenericModule! $@";
    }

    $Self->{Backend} = $GenericModule->new(%Param);

    return $Self;
}

=item CheckSessionID()

checks a session, returns true (session ok) or false (session invalid)

  $SessionObject->CheckSessionID(SessionID => '1234567890123456');

=cut

sub CheckSessionID {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->CheckSessionID(%Param);
}

=item CheckSessionID()

get session data in a hash

  my %Data = $SessionObject->GetSessionIDData(SessionID => '1234567890123456');

=cut

sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->GetSessionIDData(%Param);
}

=item CreateSessionID()

create a new session with given data

  my $SessionID = $SessionObject->CreateSessionID(
      UserLogin => 'root',
      UserEmail => 'root@example.com',
  );

=cut

sub CreateSessionID {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->CreateSessionID(%Param);
}

=item RemoveSessionID()

removes a session and returns true (session deleted), false (if
session can't get deleted)

  $SessionObject->RemoveSessionID(SessionID => '1234567890123456');

=cut

sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->RemoveSessionID(%Param);
}

=item UpdateSessionID()

update session info by key and value, returns true (if ok) and
false (if can't update)

  $SessionObject->UpdateSessionID(
      SessionID => '1234567890123456',
      Key => 'LastScreenView',
      Value => 'SomeInfo',
  );

=cut

sub UpdateSessionID {
    my $Self = shift;
    my %Param = @_;
    if ($Param{Key} && $Param{Key} =~ /:/) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't Update Key: '$Param{Key}' because of ':' is not alown!",
        );
        return;
    }
    return $Self->{Backend}->UpdateSessionID(%Param);
}

=item GetAllSessionIDs()

returns a array with all session ids

  my @Sessions = $SessionObject->GetAllSessionIDs();

=cut

sub GetAllSessionIDs {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->GetAllSessionIDs(%Param);
}

=item CleanUp()

clean up of sessions in your system

  $SessionObject->CleanUp();

=cut

sub CleanUp {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->CleanUp(%Param);
}
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.22 $ $Date: 2004-09-27 13:37:24 $

=cut
