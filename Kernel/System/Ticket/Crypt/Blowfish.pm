# --
# Kernel/System/Ticket/Crypt/Blowfish.pm - article crypt Blowfish backend
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Blowfish.pm,v 1.1 2002-12-08 20:46:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Crypt::Blowfish;

use strict;
use Crypt::CBC;
use MIME::Base64;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub CryptInit {
    my $Self = shift;
    my %Param = @_;
    $Self->{Cipher} = Crypt::CBC->new( 
        {
            'key'             => $Self->{ConfigObject}->Get('TicketCryptModule::Key') || die 'Need TicketCryptModule::Key!',
            'cipher'          => 'Blowfish',
            'iv'              => '$KJh#(}q',
            'regenerate_key'  => 0,   # default true
            'padding'         => 'space',
            'prepend_iv'      => 0
         }
    );
    return 1;
} 
# --
sub Encrypt {
    my $Self = shift;
    my $What = shift || ''; 
    my $ciphertext = $Self->{Cipher}->encrypt($What);
    return encode_base64($ciphertext);
}
# --
sub Decrypt {
    my $Self = shift;
    my $What = shift || ''; 
    $What = decode_base64($What);
    my $plaintext = $Self->{Cipher}->decrypt($What);
    return $plaintext;
}
# --
1;
