# --
# Kernel/System/Crypt.pm - the main crypt module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Crypt.pm,v 1.8 2007-01-20 23:11:34 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt;

use strict;
use Kernel::System::FileTemp;

use vars qw($VERSION @ISA);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

=head1 NAME

Kernel::System::Crypt - the crypt module

=head1 SYNOPSIS

All functions to encrypt/decrypt/sign and verify emails.
For backend module info see Kernel::System::Crypt::PGP and
Kernel::System::Crypt::SMIME.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create new object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Crypt;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $CryptObject = Kernel::System::Crypt->new(
        DBObject => $DBObject,
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        CryptType => 'PGP',   # PGP or SMIME
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    foreach (qw(ConfigObject LogObject DBObject CryptType MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # check if module is enabled
    if (!$Self->{ConfigObject}->Get($Param{CryptType})) {
        return;
    }

    # create file template object
    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    # load generator crypt module
    $Self->{GenericModule} = "Kernel::System::Crypt::$Param{CryptType}";
    if (!$Self->{MainObject}->Require($Self->{GenericModule})) {
        return;
    }
    # add generator crypt functions
    @ISA = ("$Self->{GenericModule}");
    # call init()
    $Self->_Init();
    return $Self;
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

$Revision: 1.8 $ $Date: 2007-01-20 23:11:34 $

=cut