# --
# HTML::Safe.pm - remove activ html stuff from html strings
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Safe.pm,v 1.8 2009-02-26 10:06:42 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package HTML::Safe;

use strict;

use vars qw($VERSION);
$VERSION = "1.0";

=head1 NAME

HTML::Safe - remove activ html stuff from html strings

=head1 SYNOPSIS

A module to remove/strip active html tags/addons (javascript, applets, embeds and objects) from html strings.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

  use HTML::Safe;

  my $HTMLSafe = HTML::Safe->new();


  Or if you want do define own filter params

  my $HTMLSafe = HTML::Safe->new(
      NoApplet => 1,
      NoObject => 1,
      NoEmbed => 1,
      NoIntSrcLoad => 0,
      NoExtSrcLoad => 1,
      NoJavaScript => 1,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    for (qw(NoApplet NoObject NoEmbed NoExtSrcLoad NoIntSrcLoad NoJavaScript)) {
        $Self->{$_} = defined($Param{$_}) ? $Param{$_} : 1;
    }

    return $Self;
}

=item Filter()

To filter html strings.

  # get html
  my $Data = 'Some HTML with active alements!';

  # filter active elements
  $HTMLSafe->Filter(Data => \$Data);

  # print clean html
  print $Data;

=cut

sub Filter {
    my $Self = shift;
    my %Param = @_;
    
    # check needed stuff
    if (!$Param{Data}) {
        print STDERR 'Need Data!';
        return;
    }

    # remove script tags
    if ($Self->{NoJavaScript}) {
        ${$Param{Data}} =~ s{
            <scrip.+?>(.+?)</script>
        }
        {
            if ($Self->{Debug} > 0) {
                print STDERR "Found <script> tags!\n";
            }
            if ($Self->{Debug} > 1) {
                "### removed script tags ###";
            }
            else {
                '';
            }
        }segxim;
    }

    # remove <applet> tags
    if ($Self->{NoApplet}) {
        ${$Param{Data}} =~ s{
            <apple.+?>(.+?)</applet>
        }
        {
            if ($Self->{Debug} > 0) {
                print STDERR "Found <applet> tags!\n";
            }
            if ($Self->{Debug} > 1) {
                "### removed applet tags ###";
            }
            else {
                '';
            }
        }segxim;
    }

    # remove <Object> tags
    if ($Self->{NoObject}) {
        ${$Param{Data}} =~ s{
            <objec.+?>(.+?)</object>
        }
        {
            if ($Self->{Debug} > 0) {
                print STDERR "Found <object> tags!\n";
            }
            if ($Self->{Debug} > 1) {
                "### removed object tags ###";
            }
            else {
                '';
            }
        }segxim;
    }

    # remove style/javascript parts
    if ($Self->{NoJavaScript}) {
        ${$Param{Data}} =~ s{
            <style.+?javascript(.+?|)>(.*)</style>
        }
        {
            if ($Self->{Debug} > 0) {
                print STDERR "Found <style script> tags!\n";
            }
            if ($Self->{Debug} > 1) {
                "### removed javascript style tag ###";
            }
            else {
                '';
            }
        }segxim;
    }

    # check each html tag
    ${$Param{Data}} =~ s{
        (<.+?>)
    }
    {
        my $Tag = $1;
        if ($Self->{NoJavaScript}) {
            # remove on action sub tags
            $Tag =~ s{
                \s(on.{4,10}=(".+?"|'.+?'|.+?))
            }
            {
                print STDERR "Found <on action> tags ($1)!\n" if ($Self->{Debug});
                '';
            }segxim;

            # remove entities sub tags
            $Tag =~ s{
                (&\{.+?\})
            }
            {
                print STDERR "Found js entities tags($1)!\n" if ($Self->{Debug});
                '';
            }segxim;

            # remove javascript in a href links or src links
            $Tag =~ s{
                (<(a\shref|src)=)("javascript.+?"|'javascript.+?'|javascript.+?)(\s>|>|.+?>)
            }
            {
                if ($Self->{Debug} > 0) {
                    print STDERR "Found <a href|src/javascript> tags ($3)!\n";
                }
                if ($Self->{Debug} > 1) {
                    "$1'-no js-'$4";
                }
                else {
                    "$1$4";
                }
            }segxim;

            # remove link javascript tags
            $Tag =~ s{
                (<link.+?javascript(.+?|)>)
            }
            {
                print STDERR "Found <link/javascript> ($1) tags!\n" if ($Self->{Debug});
                "### removed javascript link tag ###";
            }segxim;
        }

        # remove <embed> tags
        if ($Self->{NoEmbed}) {
            $Tag =~ s{
                (<embed\s(.+?)>)
            }
            {
                if ($Self->{Debug} > 0) {
                    print STDERR "Found <embed> ($1) tags!\n";
                }
                if ($Self->{Debug} > 1) {
                    "### removed embed tag ($1) ###";
                }
                else {
                    '';
                }
            }segxim;
        }

        # remove load tags
        if ($Self->{NoIntSrcLoad} || $Self->{NoExtSrcLoad}) {
            $Tag =~ s{
                (<(.+?)\s(src=.+?)(\s.+?|)>)
            }
            {
                if ($Self->{NoIntSrcLoad} || ($Self->{NoExtSrcLoad} && $3 =~ /(http|ftp|https)::/i)) {
                    if ($Self->{Debug} > 0) {
                        print STDERR "Found load tags ($1)!\n";
                    }
                    if ($Self->{Debug} > 1) {
                        "### can't load '$3' ###";
                    }
                    else {
                       '';
                    }
                }
                else {
                    $1;
                }
            }segxim;
        }

        # replace original tag with clean tag
        $Tag;
    }segxim;

}
1;

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=head1 VERSION

$Revision: 1.8 $ $Date: 2009-02-26 10:06:42 $

=cut
