# --
# Kernel/System/Encode.pm - character encodings
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Encode.pm,v 1.2 2004-01-09 16:41:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Encode;

use strict;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
  use Kernel::System::Log;
  use Kernel::Encode;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );

  my $EncodeObject = Kernel::System::Encode->new( 
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common objects 
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_!" if (!$Self->{$_});
    } 
    # 0=off; 1=on; 
    $Self->{Debug} = 0;

    # check if Perl 5.8.0 encode is available
    if (eval "require Encode") {
        $Self->{CharsetEncodeSupported} = 1;
    }
    else {
        if ($Self->{Debug}) {
          $Self->{LogObject}->Log(
            Priority => 'debug',
            Message => "Charset encode not supported withyour perl version!",
          );
        }
    }
    return $Self;
}   
# --

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
# --

=item EncodeInternalUsed()
    
Returns the internal used charset if possible. E. g. if "EncodeSupported()" 
is true and Kernel/Config.pm "DefaultCharset" is "utf-8", then utf-8 is
the internal charset. It returns false if no internal charset (utf-8) is
used.

  my $Charset = $EncodeObject->EncodeInternalUsed();

=cut

sub EncodeInternalUsed {
    my $Self = shift;
    if ($Self->{CharsetEncodeSupported} && $Self->{ConfigObject}->Get('DefaultCharset') eq 'utf-8') {
        return 'utf-8';
    }
    else {
        return;
    }
}
# --

=item EncodeFrontendUsed()
    
Returns the used frontend charset if possible. E. g. if "EncodeSupported()" 
is true and Kernel/Config.pm "DefaultCharset" is "utf-8", then utf-8 is
the frontend charset. It returns false if no frontend charset (utf-8) is
used (then the translation charset (from translation file) will be used).

  my $Charset = $EncodeObject->EncodeFrontendUsed();

=cut

sub EncodeFrontendUsed {
    my $Self = shift;
    if ($Self->{CharsetEncodeSupported} && $Self->{ConfigObject}->Get('DefaultCharset') eq 'utf-8') {
        return 'utf-8';
    }
    else {
        return;
    }
}
# --

=item Convert()
    
Convert one charset to an other charset.

  my $utf8 = $EncodeObject->Convert(
      Text => $iso_8859_1_string,
      From => 'iso-8859-1',
      To => 'utf-8',
  );

  my $iso_8859_1 = $EncodeObject->Convert(
      Text => $utf-8_string,
      From => 'utf-8',
      To => 'iso-8859-1',
  );

=cut

sub Convert {
    my $Self = shift;
    my %Param = @_;
    my $Text = defined $Param{Text} ? $Param{Text} : return;
    # check needed stuff
    foreach (qw(From To)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # if there is no charset encode supported (min. Perl 5.8.0)
    if (!$Self->{CharsetEncodeSupported}) {
        return $Text;
    }
    # if no encode is needed
    if ($Param{From} =~ /^$Param{To}$/i) {
        return $Text;
    }
    # encode is needed
    else {
        if ($Text ne '' && !eval{Encode::from_to($Text, $Param{From}, $Param{To})}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Charset encode '$Param{From}' -=> '$Param{To}' ($Text) not supported",
            );
        }
        else {
          if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              Message => "Charset encode '$Param{From}' -=> '$Param{To}' ($Text)",
            );
          }
        }
        return $Text;
    }
}
# --

=item Decode()
    
Convert given charset into the internal used charset (utf-8), if 
"EncodeInternalUsed()" returns one. Should be used on all I/O interfaces.

  my $String = $EncodeObject->Decode(
      Text => $String,
      From => $SourceCharset,
  ); 

=cut

sub Decode {
    my $Self = shift;
    my %Param = @_;
    my $Text = defined $Param{Text} ? $Param{Text} : return;
    # check needed stuff
    foreach (qw(From)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # internel charset
    if ($Self->EncodeInternalUsed()) {
        return $Self->Convert(%Param, To => $Self->EncodeInternalUsed());
    }
    else {
        return $Text;
    }
}
# --
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).  

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2004-01-09 16:41:34 $

=cut
