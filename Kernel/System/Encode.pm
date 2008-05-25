# --
# Kernel/System/Encode.pm - character encodings
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Encode.pm,v 1.33 2008-05-25 12:26:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Encode;

use strict;
use warnings;

use vars qw(@ISA $VERSION);

$VERSION = qw($Revision: 1.33 $) [1];

=head1 NAME

Kernel::System::Encode - character encodings

=head1 SYNOPSIS

This module will use Perl's Encode module (Perl 5.8.0 or higher required).
If the Perl version is lower then 5.8.0, no encoding will be possible. The
return string is still the same charset.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a language object

    use Kernel::Config;
    use Kernel::System::Encode;

    my $ConfigObject = Kernel::Config->new();

    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed object
    $Self->{ConfigObject} = $Param{ConfigObject} || die 'Got no ConfigObject!';

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    # check if Perl 5.8.0 encode is available
    if ( eval "require Encode" ) {
        $Self->{CharsetEncodeSupported} = 1;
    }
    elsif ( $Self->{Debug} ) {
        print STDERR "Charset encode not supported with your perl version!\n";
    }

    # get internal charset
    if (
        $Self->{CharsetEncodeSupported}
        && $Self->{ConfigObject}->Get('DefaultCharset') =~ /^utf(-8|8)$/i
        )
    {
        $Self->{UTF8Support} = 1;
    }

    # get frontend charset
    $Self->{CharsetEncodeFrontendUsed} = $Self->EncodeFrontendUsed();

    # encode STDOUT and STDERR
    $Self->SetIO( \*STDOUT, \*STDERR );

    return $Self;
}

=item EncodeSupported()

Returns true or false if charset encoding is possible (depends on Perl version =< 5.8.0).

    if ($EncodeObject->EncodeSupported()) {
        print "Charset encoding is possible!\n";
    }
    else {
        print "Sorry, charset encoding is not possible!\n";
    }

=cut

sub EncodeSupported {
    my $Self = shift;

    return $Self->{CharsetEncodeSupported};
}

=item EncodeInternalUsed()

Returns the internal used charset if possible. E. g. if "EncodeSupported()"
is true and Kernel/Config.pm "DefaultCharset" is "utf-8", then utf-8 is
the internal charset. It returns false if no internal charset (utf-8) is
used.

    my $Charset = $EncodeObject->EncodeInternalUsed();

=cut

sub EncodeInternalUsed {
    my $Self = shift;

    return 'utf-8' if $Self->{UTF8Support};
    return;
}

=item EncodeFrontendUsed()

Returns the used frontend charset if possible. E. g. if "EncodeSupported()"
is true and Kernel/Config.pm "DefaultCharset" is "utf-8", then utf-8 is
the frontend charset. It returns false if no frontend charset (utf-8) is
used (then the translation charset (from translation file) will be used).

    my $Charset = $EncodeObject->EncodeFrontendUsed();

=cut

sub EncodeFrontendUsed {
    my $Self = shift;

    return 'utf-8' if $Self->{UTF8Support};
}

=item Convert()

Convert one charset to an other charset.

    my $utf8 = $EncodeObject->Convert(
        Text => $iso_8859_1_string,
        From => 'iso-8859-1',
        To   => 'utf-8',
    );

    my $iso_8859_1 = $EncodeObject->Convert(
        Text => $utf-8_string,
        From => 'utf-8',
        To   => 'iso-8859-1',
    );

There is also a Force => 1 option if you need to force the
already converted string. And Check => 1 if the sting result
should be checked if it's a valid string (e. g. valid utf8 string).

=cut

sub Convert {
    my ( $Self, %Param ) = @_;

    return if !defined $Param{Text};
    return if $Param{Text} eq '';

    # check needed stuff
    for (qw(From To)) {
        if ( !defined $Param{$_} ) {
            print STDERR "Need $_!\n";
            return;
        }
    }

    # if there is no charset encode supported (min. Perl 5.8.0)
    return $Param{Text} if !$Self->{CharsetEncodeSupported};

    # if no encode is needed
    if ( $Param{From} =~ /^$Param{To}$/i ) {

        # set utf-8 flag
        if ( $Param{To} =~ /^utf(-8|8)/i ) {
            Encode::_utf8_on( $Param{Text} );
        }

        # check if string is valid utf8
        if ( $Param{Check} && !eval { Encode::is_utf8( $Param{Text}, 1 ) } ) {
            Encode::_utf8_off( $Param{Text} );
            print STDERR "No valid '$Param{To}' string: '$Param{Text}'!\n";
            return $Param{Text};
        }

        # return text
        return $Param{Text};
    }

    # encode is needed
    if ( $Param{Force} ) {
        Encode::_utf8_off( $Param{Text} );
    }

    # convert string
    if ( !eval { Encode::from_to( $Param{Text}, $Param{From}, $Param{To}, 1 ) } ) {
        print STDERR "Charset encode '$Param{From}' -=> '$Param{To}' ($Param{Text})"
            . " not supported!\n";
        return $Param{Text};
    }

    # set utf-8 flag
    if ( $Param{To} =~ /^utf(8|-8)$/i ) {
        Encode::_utf8_on( $Param{Text} );
    }

    # output debug message
    if ( $Self->{Debug} ) {
        print STDERR "Charset encode '$Param{From}' -=> '$Param{To}' ($Param{Text})!\n";
    }

    return $Param{Text};
}

=item SetIO()

Set array of file handles to utf-8 output.

    $EncodeObject->SetIO(\*STDOUT, \*STDERR);

=cut

sub SetIO {
    my ( $Self, @Array ) = @_;

    return if !$Self->{CharsetEncodeSupported};
    return if !$Self->{CharsetEncodeFrontendUsed};
    return if !$Self->{CharsetEncodeFrontendUsed} =~ /utf(-8|8)/i;

    ROW:
    for my $Row (@Array) {
        next ROW if !defined $Row;
        next ROW if ref $Row ne 'GLOB';

        # set binmode
        binmode( $Row, ':utf8' );
    }

    return;
}

=item Encode()

Convert internal used charset (e. g. utf-8) into given charset (utf-8), if
"EncodeInternalUsed()" returns one. Should be used on all I/O interfaces
if data is already utf-8 to set the utf-8 stamp.

    $EncodeObject->Encode(\$String);

=cut

sub Encode {
    my ( $Self, $What ) = @_;

    return if !defined $What;
    return if !$Self->{CharsetEncodeSupported};
    return if !$Self->{CharsetEncodeFrontendUsed};
    return if !$Self->{CharsetEncodeFrontendUsed} =~ /utf(-8|8)/i;

    if ( ref $What eq 'SCALAR' ) {
        return $What if !defined ${$What};

        Encode::_utf8_on( ${$What} );
        return $What;
    }

    if ( ref $What eq 'ARRAY' ) {
        ROW:
        for my $Row ( @{$What} ) {
            next ROW if !defined $Row;

            Encode::_utf8_on($Row);
        }
        return $What;
    }

    Encode::_utf8_on($What);

    return $What;
}

=item Decode()

Convert given charset into the internal used charset (utf-8), if
"EncodeInternalUsed()" returns one. Should be used on all I/O interfaces.

    my $String = $EncodeObject->Decode(
        Text => $String,
        From => $SourceCharset,
    );

=cut

sub Decode {
    my ( $Self, %Param ) = @_;

    return if !defined $Param{Text};

    # check needed stuff
    if ( !defined $Param{From} ) {
        print STDERR "Need From!\n";
        return;
    }

    return $Param{Text} if !$Self->EncodeInternalUsed();
    return $Self->Convert( %Param, To => $Self->EncodeInternalUsed() );
}

=item EncodeOutput()

Convert utf8 to a sequence of octets. All possible characters have
a UTF-8 representation so this function cannot fail.

This should be used in for output of utf8 chars.

    $EncodeObject->EncodeOutput(\$String);

=cut

sub EncodeOutput {
    my ( $Self, $What ) = @_;

    return 1 if !$Self->{CharsetEncodeSupported};
    return 1 if !$Self->EncodeFrontendUsed();
    return 1 if !$Self->EncodeFrontendUsed() =~ /utf(-8|8)/i;

    return 1 if !Encode::is_utf8( ${$What} );

    ${$What} = Encode::encode_utf8( ${$What} );
    return 1;
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

$Revision: 1.33 $ $Date: 2008-05-25 12:26:40 $

=cut
