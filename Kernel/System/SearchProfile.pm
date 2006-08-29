# --
# Kernel/System/SearchProfile.pm - module to manage search profiles
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: SearchProfile.pm,v 1.4 2006-08-29 17:30:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::SearchProfile;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::SearchProfile - module to manage search profiles

=head1 SYNOPSIS

module with all functions to manage search profiles

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::SearchProfile;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $SearchProfileObject = Kernel::System::SearchProfile->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item SearchProfileAdd()

to add a search profile item

  $SearchProfileObject->SearchProfileAdd(
      Base => 'TicketSearch',
      Name => 'last-search',
      Key => 'Body',
      Value => $String,    # SCALAR|ARRAYREF
      UserLogin => 123,
  );

=cut

sub SearchProfileAdd {
    my $Self  = shift;
    my %Param = @_;
    my @Data  = ();
    # check needed stuff
    foreach (qw(Base Name Key UserLogin)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check value
    if (!defined($Param{Value})) {
        return 1;
    }
    if (ref($Param{Value}) eq 'ARRAY') {
        @Data = @{$Param{Value}};
        $Param{Type} = 'ARRAY';
    }
    else {
        @Data = ($Param{Value});
        $Param{Type} = 'SCALAR';
    }
    # qoute params
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach my $Value (@Data) {
        my $Value = $Self->{DBObject}->Quote($Value);
        my $SQL = "INSERT INTO search_profile (login, profile_name, ".
            " profile_type, profile_key, profile_value)".
            " VALUES ".
            " ('$Param{Base}::$Param{UserLogin}', '$Param{Name}', ".
            " '$Param{Type}', '$Param{Key}', '$Value') ";
        if (!$Self->{DBObject}->Do(SQL => $SQL)) {
            return;
        }
    }
    return 1;
}

=item SearchProfileGet()

returns a hash with search profile

  my %SearchProfileData = $SearchProfileObject->SearchProfileGet(
      Base => 'TicketSearch',
      Name => 'last-search',
      UserLogin => 'me',
  );

=cut

sub SearchProfileGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Base Name UserLogin)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = "SELECT profile_type, profile_key, profile_value".
        " FROM ".
        " search_profile ".
        " WHERE ".
        " profile_name = '$Param{Name}' ".
        " AND ".
        " login = '$Param{Base}::$Param{UserLogin}'";
    my %Result = ();
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            if ($Data[0] eq 'ARRAY') {
                push (@{$Result{$Data[1]}}, $Data[2]);
            }
            else {
                $Result{$Data[1]} = $Data[2];
            }
        }
        return %Result;
    }
    else {
        return;
    }
}

=item SearchProfileDelete()

deletes an profile

  $SearchProfileObject->SearchProfileDelete(
      Base => 'TicketSearch',
      Name => 'last-search',
      UserLogin => 'me',
  );

=cut

sub SearchProfileDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Base Name UserLogin)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = "DELETE FROM search_profile WHERE ".
          " profile_name = '$Param{Name}' AND login = '$Param{Base}::$Param{UserLogin}'";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item SearchProfileList()

returns a hash of all proviles

  my %SearchProfiles = $SearchProfileObject->SearchProfileList(
      Base => 'TicketSearch',
      UserLogin => 'me',
  );

=cut

sub SearchProfileList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Base UserLogin)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = "SELECT profile_name ".
        " FROM ".
        " search_profile ".
        " WHERE ".
        " login = '$Param{Base}::$Param{UserLogin}'";
    my %Result = ();
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            $Result{$Data[0]} = $Data[0];
        }
        return %Result;
    }
    else {
        return;
    }
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.4 $ $Date: 2006-08-29 17:30:36 $

=cut
