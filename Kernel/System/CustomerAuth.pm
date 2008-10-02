# --
# Kernel/System/CustomerAuth.pm - provides the authentification
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerAuth.pm,v 1.19 2008-10-02 14:08:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::CustomerAuth;

use strict;
use warnings;
use Kernel::System::CustomerUser;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

=head1 NAME

Kernel::System::CustomerAuth - customer autentification module.

=head1 SYNOPSIS

The autentification module for the customer interface.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::CustomerAuth;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $AuthObject = Kernel::System::CustomerAuth->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get customer user object to validate customers
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    # load generator auth module
    for my $Count ( '', 1 .. 10 ) {
        my $GenericModule = $Self->{ConfigObject}->Get("Customer::AuthModule$Count");
        next if !$GenericModule;

        if ( !$Self->{MainObject}->Require($GenericModule) ) {
            $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
        }
        $Self->{"Backend$Count"} = $GenericModule->new( %Param, Count => $Count );
    }

    return $Self;
}

=item GetOption()

Get module options. Currently exists just one option, "PreAuth".

    if ($AuthObject->GetOption(What => 'PreAuth')) {
        print "No login screen is needed. Autentificaion is based on some other options. E. g. $ENV{REMOTE_USER}\n";
    }

=cut

sub GetOption {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->GetOption(%Param);
}

=item Auth()

The autentificaion function.

    if ($AuthObject->Auth(User => $User, Pw => $Pw)) {
        print "Auth ok!\n";
    }
    else {
        print "Auth invalid!\n";
    }

=cut

sub Auth {
    my ( $Self, %Param ) = @_;

    # use all 11 backends and return on first auth
    my $User;
    for ( '', 1 .. 10 ) {

        # return on no config setting
        next if !$Self->{"Backend$_"};

        # check auth backend
        $User = $Self->{"Backend$_"}->Auth(%Param);

        # remember auth backend
        if ($User) {
            $Self->{CustomerUserObject}->SetPreferences(
                Key    => 'UserAuthBackend',
                Value  => $_,
                UserID => $User,
            );
            last;
        }
    }

    # check if recorde exists
    return if !$User;

    # check if user is vaild
    my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $User );
    if ( defined( $CustomerData{ValidID} ) && $CustomerData{ValidID} ne 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$User' is set to invalid, can't login!",
        );
        return;
    }

    # return user
    return $User;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.19 $ $Date: 2008-10-02 14:08:49 $

=cut
