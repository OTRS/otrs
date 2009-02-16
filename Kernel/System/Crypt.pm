# --
# Kernel/System/Crypt.pm - the main crypt module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Crypt.pm,v 1.14 2009-02-16 11:58:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Crypt;

use strict;
use warnings;

use Kernel::System::FileTemp;
use Kernel::System::Encode;

use vars qw($VERSION @ISA);
$VERSION = qw($Revision: 1.14 $) [1];

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
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        MainObject   => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $CryptObject = Kernel::System::Crypt->new(
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        CryptType    => 'PGP',   # PGP or SMIME
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    for (qw(ConfigObject LogObject DBObject CryptType MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # check if module is enabled
    if ( !$Self->{ConfigObject}->Get( $Param{CryptType} ) ) {
        return;
    }

    # create file template object
    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);
    $Self->{EncodeObject}   = Kernel::System::Encode->new(%Param);

    # load generator crypt module
    $Self->{GenericModule} = "Kernel::System::Crypt::$Param{CryptType}";
    if ( !$Self->{MainObject}->Require( $Self->{GenericModule} ) ) {
        return;
    }

    # add generator crypt functions
    @ISA = ("$Self->{GenericModule}");

    # call init()
    $Self->_Init();

    # check working env
    if ( $Self->Check() ) {
        return;
    }

    return $Self;
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

$Revision: 1.14 $ $Date: 2009-02-16 11:58:56 $

=cut
