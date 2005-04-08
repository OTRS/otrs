# --
# Kernel/System/Config.pm - all system config tool functions
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.1 2005-04-08 07:03:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Config;

use strict;
use Kernel::System::XML;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Config - to manage config settings

=head1 SYNOPSIS

All functions to manage config settings.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::Config;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $ConfigToolObject = Kernel::System::Config->new(
      LogObject => $LogObject,
      ConfigObject => $ConfigObject,
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

    # create xml object
    $Self->{XMLObject} = Kernel::System::XML->new(%Param);

    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # read all config files
    $Self->_Init();

    return $Self;
}

sub _Init {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # load xml config files
    if (-e "$Self->{Home}/Kernel/Config/Files/") {
        my %Data = ();
        my @Files = glob("$Self->{Home}/Kernel/Config/Files/*.xml");
        foreach my $File (@Files) {
            my $ConfigFile = '';
            if (open (IN, "< $File")) {
                while (<IN>) {
                    $ConfigFile .= $_;
                }
                close (IN);
            }
            else {
                print STDERR "ERROR: $!: $File\n";
            }
            if ($ConfigFile) {
                my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $ConfigFile);
                $Data{$File} = \@XMLHash;
            }
        }
        $Self->{XMLConfig} = [];
        # load framework, application, changes
        foreach my $Init (qw(Framework Application Changes)) {
            foreach my $Set (sort keys %Data) {
                if ($Data{$Set}->[1]->{otrs_config}->[1]->{init} eq $Init) {
#$Self->{LogObject}->Dumper($Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem});
                    push (@{$Self->{XMLConfig}}, @{$Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem}});
                    delete $Data{$Set};
                }
            }
        }
        # load misc
        foreach my $Set (sort keys %Data) {
#$Self->{LogObject}->Dumper($Data{$Set}->[1]->{otrs_config}->[1]->{init});
            push (@{$Self->{XMLConfig}}, @{$Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem}});
            delete $Data{$Set};
        }
#$Self->{LogObject}->Dumper($Self->{XMLConfig});
    }
}

=item ConfigItemGet()

get a config setting

    my %Config = $ConfigToolObject->ConfigItemGet(
        Name => 'Ticket::NumberGenerator',
    );
    
=cut

sub ConfigItemGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
        if (!$Param{$_}) { 
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Name} && $ConfigItem->{Name} eq $Param{Name}) {
#$Self->{LogObject}->Dumper($ConfigItem);
            return %{$ConfigItem};
        }
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

$Revision: 1.1 $ $Date: 2005-04-08 07:03:36 $

=cut
