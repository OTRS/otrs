# --
# Kernel/System/Crypt.pm - the main crypt module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Crypt;

use strict;
use warnings;

use Kernel::System::FileTemp;
use Kernel::System::Time;

use vars qw(@ISA);

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

create new object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        CryptObject => {
            CryptType   => 'PGP',   # PGP or SMIME
        },
    );
    my $CryptObject = $Kernel::OM->Get('CryptObject');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    for (qw( ConfigObject EncodeObject LogObject MainObject DBObject CryptType )) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # check if module is enabled
    return if !$Self->{ConfigObject}->Get( $Param{CryptType} );

    # create file template object
    $Self->{FileTempObject} = Kernel::System::FileTemp->new( %{$Self} );

    # reset ISA for testability and peristent environments
    @ISA = ();

    # load generator crypt module
    $Self->{GenericModule} = "Kernel::System::Crypt::$Param{CryptType}";
    return if !$Self->{MainObject}->RequireBaseClass( $Self->{GenericModule} );

    # time object
    $Self->{TimeObject} = Kernel::System::Time->new( %{$Self} );

    # call init()
    $Self->_Init();

    # check working env
    return if $Self->Check();

    return $Self;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
