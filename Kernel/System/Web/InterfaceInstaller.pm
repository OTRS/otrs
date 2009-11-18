# --
# Kernel/System/Web/InterfaceInstaller.pm - the installer interface file
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: InterfaceInstaller.pm,v 1.1.2.2 2009-11-18 11:58:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::InterfaceInstaller;

use strict;
use warnings;

use vars qw($VERSION @INC);
$VERSION = qw($Revision: 1.1.2.2 $) [1];

# all framework needed  modules
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Web::Request;
use Kernel::System::DB;
use Kernel::System::CustomerUser;
use Kernel::Output::HTML::Layout;

=head1 NAME

Kernel::System::Web::InterfaceInstaller - the installer web interface

=head1 SYNOPSIS

the global installer web interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create installer web interface object

    use Kernel::System::Web::InterfaceInstaller;

    my $Debug = 0;
    my $Interface = Kernel::System::Web::InterfaceInstaller->new( Debug => $Debug );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # create common framework objects 1/3
    $Self->{ConfigObject} = Kernel::Config->new();
    $Self->{LogObject}    = Kernel::System::Log->new(
        LogPrefix => $Self->{ConfigObject}->Get('CGILogPrefix') || 'Installer',
        %{$Self},
    );
    $Self->{EncodeObject} = Kernel::System::Encode->new( %{$Self} );
    $Self->{MainObject}   = Kernel::System::Main->new( %{$Self} );
    $Self->{TimeObject}   = Kernel::System::Time->new( %{$Self} );
    $Self->{ParamObject}  = Kernel::System::Web::Request->new(
        %{$Self},
        WebRequest => $Param{WebRequest} || 0,
    );
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self} );

    # debug info
    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global handle started...',
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

    # get common framework params
    my %Param;

    $Param{Action}     = $Self->{ParamObject}->GetParam( Param => 'Action' )     || 'Installer';
    $Param{Subaction}  = $Self->{ParamObject}->GetParam( Param => 'Subaction' )  || '';
    $Param{NextScreen} = $Self->{ParamObject}->GetParam( Param => 'NextScreen' ) || '';

    # check secure mode
    if ( $Self->{ConfigObject}->Get('SecureMode') ) {
        print $Self->{LayoutObject}->Header();
        print $Self->{LayoutObject}->Error(
            Message => 'SecureMode active!',
            Comment => 'If you want to run the Installler, disable SecureMode in Config.pm!',
        );
        print $Self->{LayoutObject}->Footer();
    }

    # run modules if exists a version value
    elsif ( $Self->{MainObject}->Require("Kernel::Modules::$Param{Action}") ) {
        $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new( %{$Self}, %Param, );

        # prove of concept! - create $GenericObject
        my $GenericObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
            %{$Self},
            %Param,
        );

        print $GenericObject->Run();
    }

    # else print an error screen
    else {

        # create new LayoutObject with '%Param'
        print $Self->{LayoutObject}->Header();
        print $Self->{LayoutObject}->Error(
            Message => "Action '$Param{Action}' not found!",
            Comment => 'Contact your admin!',
        );
        print $Self->{LayoutObject}->Footer();
    }

}

sub DESTROY {
    my $Self = shift;

    # debug info
    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global handle stopped.',
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1.2.2 $ $Date: 2009-11-18 11:58:37 $

=cut
