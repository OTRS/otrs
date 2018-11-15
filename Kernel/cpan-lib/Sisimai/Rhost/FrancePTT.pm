package Sisimai::Rhost::FrancePTT;
use feature ':5.10';
use strict;
use warnings;

my $ErrorCodes = {
    '103' => 'blocked',       # Service refuse. Veuillez essayer plus tard.
    '104' => 'toomanyconn',   # Too many connections, slow down. LPN105_104
    '105' => undef,           # Veuillez essayer plus tard.
    '109' => undef,           # Veuillez essayer plus tard. LPN003_109
    '201' => undef,           # Veuillez essayer plus tard. OFR004_201
    '305' => 'securityerror', # 550 5.7.0 Code d'authentification invalide OFR_305
    '401' => 'blocked',       # 550 5.5.0 SPF: *** is not allowed to send mail. LPN004_401
    '402' => 'securityerror', # 550 5.5.0 Authentification requise. Authentication Required. LPN105_402
    '403' => 'rejected',      # 5.0.1 Emetteur invalide. Invalid Sender.
    '405' => 'rejected',      # 5.0.1 Emetteur invalide. Invalid Sender. LPN105_405
    '415' => 'rejected',      # Emetteur invalide. Invalid Sender. OFR_415
    '416' => 'userunknown',   # 550 5.1.1 Adresse d au moins un destinataire invalide. Invalid recipient. LPN416
    '417' => 'mailboxfull',   # 552 5.1.1 Boite du destinataire pleine. Recipient overquota.
    '418' => 'userunknown',   # Adresse d au moins un destinataire invalide
    '420' => 'suspend',       # Boite du destinataire archivee. Archived recipient.
    '421' => 'rejected',      # 5.5.3 Mail from not owned by user. LPN105_421.
    '423' => undef,           # Service refused, please try later. LPN105_423
    '424' => undef,           # Veuillez essayer plus tard. LPN105_424
    '506' => 'spamdetected',  # Mail rejete. Mail rejected. OFR_506 [506]
    '510' => 'blocked',       # Veuillez essayer plus tard. service refused, please try later. LPN004_510 
    '513' => undef,           # Mail rejete. Mail rejected. OUK_513
    '514' => 'mesgtoobig',    # Taille limite du message atteinte
};

sub get {
    # Detect bounce reason from Orange and La Poste
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String]                The bounce reason for Orange, La Poste
    my $class = shift;
    my $argvs = shift // return undef;
    return $argvs->reason if $argvs->reason;

    my $statusmesg = $argvs->diagnosticcode;
    my $reasontext = '';

    if( $statusmesg =~ /\b(LPN|OFR|OUK)(_[0-9]{3}|[0-9]{3}[-_][0-9]{3})\b/ ) {
        # OUK_513, LPN105-104, OFR102-104
        my $v = sprintf("%03d", substr($1.$2, -3, 3));
        $reasontext = $ErrorCodes->{ $v } || 'undefined';
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::FrancePTT - Detect the bounce reason returned from Orange and
La Poste.

=head1 SYNOPSIS

    use Sisimai::Rhost;

=head1 DESCRIPTION

Sisimai::Rhost detects the bounce reason from the content of Sisimai::Data
object as an argument of get() method when the value of C<rhost> of the object
end with "laposte.net" or "orange.fr".
This class is called only Sisimai::Data class.

=head1 CLASS METHODS

=head2 C<B<get(I<Sisimai::Data Object>)>>

C<get()> detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

