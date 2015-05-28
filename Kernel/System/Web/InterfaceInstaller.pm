# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::InterfaceInstaller;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Main',
    'Kernel::System::Web::Request',
);

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

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => $Kernel::OM->Get('Kernel::Config')->Get('CGILogPrefix') || 'Installer',
        },
        'Kernel::Output::HTML::Layout' => {
            InstallerOnly => 1,
        },
        'Kernel::System::Web::Request' => {
            WebRequest => $Param{WebRequest} || 0,
        },
    );

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    $Param{Action}     = $ParamObject->GetParam( Param => 'Action' )     || 'Installer';
    $Param{Subaction}  = $ParamObject->GetParam( Param => 'Subaction' )  || '';
    $Param{NextScreen} = $ParamObject->GetParam( Param => 'NextScreen' ) || '';

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            %Param,
        },
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check secure mode
    if ( $Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        print $LayoutObject->Header();
        print $LayoutObject->Error(
            Message => 'SecureMode active!',
            Comment =>
                'If you want to re-run the Installer, disable the SecureMode in the SysConfig',
        );
        print $LayoutObject->Footer();
    }

    # run modules if a version value exists
    elsif ( $Kernel::OM->Get('Kernel::System::Main')->Require("Kernel::Modules::$Param{Action}") ) {

        # proof of concept! - create $GenericObject
        my $GenericObject = ( 'Kernel::Modules::' . $Param{Action} )->new(
            %Param,
        );

        print $GenericObject->Run();
    }

    # else print an error screen
    else {

        # create new LayoutObject with '%Param'
        print $LayoutObject->Header();
        print $LayoutObject->Error(
            Message => "Action '$Param{Action}' not found!",
            Comment => 'Contact your admin!',
        );
        print $LayoutObject->Footer();
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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
