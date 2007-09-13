# --
# Kernel/System/Auth.pm - provides the authentification
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Auth.pm,v 1.24 2007-09-13 01:01:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Auth;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.24 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Auth - agent autentification module.

=head1 SYNOPSIS

The autentification module for the agent interface.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Auth;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $AuthObject = Kernel::System::Auth->new(
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
    foreach (qw(LogObject ConfigObject DBObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # load generator auth module
    foreach my $Count ('', 1..10) {
        my $GenericModule = $Self->{ConfigObject}->Get("AuthModule$Count");
        if ($GenericModule) {
            if (!$Self->{MainObject}->Require($GenericModule)) {
                $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
            }
            $Self->{"Backend$Count"} = $GenericModule->new(%Param, Count => $Count);
        }
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
    my $Self = shift;
    my %Param = @_;
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
    my $Self = shift;
    my %Param = @_;
    foreach ('', 1..10) {
        if ($Self->{"Backend$_"}) {
            my $Return = $Self->{"Backend$_"}->Auth(%Param);
            if ($Return) {
                return $Return;
            }
        }
    }
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.24 $ $Date: 2007-09-13 01:01:27 $

=cut
