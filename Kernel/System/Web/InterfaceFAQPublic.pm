# --
# Kernel/System/Web/InterfaceFAQPublic.pm - the public faq interface file
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: InterfaceFAQPublic.pm,v 1.2 2005-02-15 12:00:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Web::InterfaceFAQPublic;

use strict;

use vars qw($VERSION @INC);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
# all framework needed  modules
# --
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::Web::Request;
use Kernel::System::DB;
use Kernel::System::Auth;
use Kernel::System::AuthSession;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::Permission;
use Kernel::Output::HTML::Generic;
use Kernel::Modules::CustomerFAQ;

=head1 NAME

Kernel::System::Web::InterfaceFAQPublic - the public faq web interface

=head1 SYNOPSIS

the global public faq web interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create public faq web interface object

  use Kernel::System::Web::InterfaceFAQPublic;

  my $Debug = 0;
  my $InterfaceFAQ = Kernel::System::Web::InterfaceFAQPublic->new(Debug => $Debug);

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # --
    # create common framework objects 1/3
    # --
    $Self->{ConfigObject} = Kernel::Config->new();
    $Self->{LogObject} = Kernel::System::Log->new(
        LogPrefix => $Self->{ConfigObject}->Get('CGILogPrefix'),
        %{$Self},
    );
    $Self->{MainObject} = Kernel::System::Main->new(%{$Self});
    $Self->{TimeObject} = Kernel::System::Time->new(%{$Self});
    $Self->{ParamObject} = Kernel::System::Web::Request->new(
        %{$Self},
        WebRequest => $Param{WebRequest} || 0,
    );
    # --
    # debug info
    # --
    if ($Self->{Debug}) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message => 'Global handle started...',
        );
    }

    return $Self;
}

=item Run()

execute the object

  $Interface->Run();

=cut

sub Run {
    my $Self = shift;
    # --
    # get common framework params
    # --
    my %Param = ();
    # get session id
    $Param{SessionName} = $Self->{ConfigObject}->Get('SessionName') || 'SessionID';
    $Param{SessionID} = $Self->{ParamObject}->GetParam(Param => $Param{SessionName}) || '';
    # drop old session id (if exists)
    my $QueryString = $ENV{"QUERY_STRING"} || '';
    $QueryString =~ s/(\?|&|)$Param{SessionName}(=&|=.+?&|=.+?$)/&/g;
    # definde frame work params
    my $FramworkPrams = {
        Lang => '',
        Action => '',
        Subaction => '',
        RequestedURL => $QueryString,
    };
    foreach my $Key (keys %{$FramworkPrams}) {
        $Param{$Key} = $Self->{ParamObject}->GetParam(Param => $Key)
          || $FramworkPrams->{$Key};
    }
    # --
    # Check if the brwoser sends the SessionID cookie and set the SessionID-cookie
    # as SessionID! GET or POST SessionID have the lowest priority.
    # --
    if ($Self->{ConfigObject}->Get('SessionUseCookie')) {
      $Param{SessionIDCookie} = $Self->{ParamObject}->GetCookie(Key => $Param{SessionName});
      if ($Param{SessionIDCookie}) {
        $Param{SessionID} = $Param{SessionIDCookie};
      }
    }
    # --
    # create common framework objects 2/3
    # --
    $Self->{LayoutObject} = Kernel::Output::HTML::Generic->new(
        %{$Self},
        Lang => $Param{Lang},
    );
    # --
    # check common objects
    # --
    $Self->{DBObject} = Kernel::System::DB->new(%{$Self});
    if (!$Self->{DBObject}) {
        print $Self->{LayoutObject}->Header(Area => 'Core', Title => 'Error!');
        print $Self->{LayoutObject}->Error(
            Message => $DBI::errstr,
            Comment => 'Please contact your admin'
        );
        print $Self->{LayoutObject}->Footer();
        exit (1);
    }
    if ($Self->{ParamObject}->Error()) {
        print $Self->{LayoutObject}->Header(Area => 'Core', Title => 'Error!');
        print $Self->{LayoutObject}->Error(
            Message => $Self->{ParamObject}->Error(),
            Comment => 'Please contact your admin'
        );
         print $Self->{LayoutObject}->Footer();
        exit (1);
    }
    # --
    # create common framework objects 3/3
    # --
    $Self->{UserObject} = Kernel::System::User->new(%{$Self});
    $Self->{GroupObject} = Kernel::System::Group->new(%{$Self});
    $Self->{PermissionObject} = Kernel::System::Permission->new(%{$Self});
    $Self->{SessionObject} = Kernel::System::AuthSession->new(%{$Self});

    # --
    # prove of concept! - create $GenericObject
    # --
    my $GenericObject = ('Kernel::Modules::CustomerFAQ')->new(
        UserID => 1,
        %{$Self},
        %Param,
    );
    # --
    # ->Run $Action with $GenericObject
    # --
    print $GenericObject->Run(States => ['public (all)']);
    # --
    # debug info
    # --
    if ($Self->{Debug}) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message => 'Global handle stopped.',
        );
    }
    # --
    # db disconnect && undef %Param
    # --
    $Self->{DBObject}->Disconnect();
    undef %Param;
}
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2005-02-15 12:00:33 $

=cut
