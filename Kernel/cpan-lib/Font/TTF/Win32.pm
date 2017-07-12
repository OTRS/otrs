package Font::TTF::Win32;

# use strict;
# use vars qw($HKEY_LOCAL_MACHINE);

use Win32::Registry;
use Win32;
use File::Spec;
use Font::TTF::Font;


sub findfonts
{
    my ($sub) = @_;
    my ($font_key) = 'SOFTWARE\Microsoft\Windows' . (Win32::IsWinNT() ? ' NT' : '') . '\CurrentVersion\Fonts';
    my ($regFont, $list, $l, $font, $file);
    
# get entry from registry for a font of this name
    $::HKEY_LOCAL_MACHINE->Open($font_key, $regFont);
    $regFont->GetValues($list);

    foreach $l (sort keys %{$list})
    {
        my ($fname) = $list->{$l}[0];
        next unless ($fname =~ s/\(TrueType\)$//o);
        $file = File::Spec->rel2abs($list->{$l}[2], "$ENV{'windir'}/fonts");
        $font = Font::TTF::Font->open($file) || next;
        &{$sub}($font, $fname);
        $font->release;
    }
}

1;

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>. 


=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.



=cut