# --
# Kernel/System/XML.pm - lib xml
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: XML.pm,v 1.1 2005-01-12 17:34:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::XML;

use strict;
use MIME::Base64;
use XML::Parser::Lite;

use vars qw($VERSION $S);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::XML - xml lib

=head1 SYNOPSIS

All xml related finctions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::XML;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $XMLObject = Kernel::System::XML->new(
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

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $S = $Self;

    return $Self;
}

=item XMLParse()

parse a xml file

    my @XMLStructur = $XMLObject->XMLParse(String => $FileString);

=cut

sub XMLParse {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(String)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "$_ not defined!");
        return;
      }
    }
    # cleanup global vars
    undef $Self->{XMLARRAY};
    # parse package
    my $Parser = new XML::Parser::Lite(Handlers => {Start => \&HS, End => \&ES, Char => \&CS});
    $Parser->parse($Param{String});
    return @{$Self->{XMLARRAY}};
}

sub HS {
    my ($Expat, $Element, %Attr) = @_;
#    print "s:'$Element'\n";
#    push (@{$S->{XMLARRAY}}, {Type => 'Start', Tag => $Element, Attr => \%Attr});
    if ($S->{LastTag}) {
#        push (@{$S->{XMLARRAY}}, {%{$S->{LastTag}}, Content => undef});
        push (@{$S->{XMLARRAY}}, {%{$S->{LastTag}}, Content => $S->{C}});
    }
    undef $S->{LastTag};
    undef $S->{C};
    $S->{LastTag} = {TagType => 'Start', Tag => $Element, %Attr};
}

sub CS {
    my ($Expat, $Element, $I, $II) = @_;
#    $Element = $Expat->recognized_string();
#    print "v:'$Element'\n";
    if ($S->{LastTag}) {
        # base64 encode
        if ($S->{LastTag}->{Encode} && $S->{LastTag}->{Encode} eq 'Base64') {
            $S->{C} .= decode_base64($Element);
        }
        else {
            $S->{C} .= $Element;
        }
    }
}

sub ES {
    my ($Expat, $Element) = @_;
#    print "e:'$Element'\n";
    if ($S->{LastTag}) {
        push (@{$S->{XMLARRAY}}, {%{$S->{LastTag}}, Content => $S->{C}});
    }
    undef $S->{LastTag};
    undef $S->{C};
    push (@{$S->{XMLARRAY}}, {TagType => 'End', Tag => $Element});
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2005-01-12 17:34:37 $

=cut
