# --
# Kernel/System/XML.pm - lib xml
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: XML.pm,v 1.2 2005-01-22 16:10:04 martin Exp $
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
$VERSION = '$Revision: 1.2 $';
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

=item XMLHash2XML()

generate a xml string 

    my $XMLString = $XMLObject->XMLHash2XML(@XMLStructur);

=cut

sub XMLHash2XML {
    my $Self = shift;
    my @XMLStructur = @_;
    my $Output = '';
    $Self->{XMLHash2XMLLayer} = 0;
    foreach my $Key (@XMLStructur) {
        $Output .= $Self->_ElementBuild(%{$Key});
    }
    return $Output;
}
sub _ElementBuild {
    my $Self = shift;
    my %Param = @_;
    my @Tag = ();
    my @Sub = ();
    my $Output = '';
    if ($Param{Key}) {
        $Self->{XMLHash2XMLLayer}++;
        foreach (2..$Self->{XMLHash2XMLLayer}) {
            $Output .= "  ";
        }
        $Output .= "<$Param{Key}";
    }
    foreach (sort keys %Param) {
        if (ref($Param{$_}) eq 'ARRAY') {
            push (@Tag, $_);
            push (@Sub, $Param{$_});
        }
        elsif ($_ ne 'Content' && $_ ne 'Key' && $_ ne 'TagKey') {
            $Output .= " $_=\"$Param{$_}\"";
        }
    }
    if ($Param{Key}) {
        $Output .= ">";
    }
    if ($Param{Content}) {
        $Output .= "$Param{Content}";
    }
    else {
        $Output .= "\n";
    }
    foreach (0..$#Sub) {
        foreach my $K (@{$Sub[$_]}) {
            if (defined($K)) {
                $Output .= $Self->_ElementBuild(%{$K}, Key => $Tag[$_], );
            }
        }
    }
    if ($Param{Key}) {
        if (!$Param{Content}) {
            foreach (2..$Self->{XMLHash2XMLLayer}) {
                $Output .= "  ";
            }
        }
        $Output .= "</$Param{Key}>\n";
        $Self->{XMLHash2XMLLayer} = $Self->{XMLHash2XMLLayer} - 1;
    }
    return $Output;
}

=item XMLParse2Hash()

parse a xml file and return a hash/array structur

    my @XMLStructur = $XMLObject->XMLParse2Hash(String => $FileString);

    XML: 
    <Contact role="admin" type="organization">
      <Name type="long">Example Inc.</Name>
      <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
      <Email type"secundary">sales@example.com</Email>
      <Telephone country="germany">+49-999-99999</Telephone>
    </Contact>

    ARRAY:
    [
      {
        Contact => [
          {
            role => 'admin',
            type => 'organization',
            Name => [
              {
                Content => 'Example Inc.',
                type => 'long',
              },
            ]
            Email => [
              {
                Content => 'info@exampe.com',
                Domain => [
                  {
                    Content => '1234.com',
                  },
                ],
              },
            ],
          }
        ],
      }
    ]

    $XMLStructur[0]{Contact}[0]{role} = 'admin';
    $XMLStructur[0]{Contact}[0]{type} = 'organization';
    $XMLStructur[0]{Contact}[0]{Name}[0]{Content} = 'Example Inc.';
    $XMLStructur[0]{Contact}[0]{Name}[0]{type} = 'long';
    $XMLStructur[0]{Contact}[0]{Email}[1]{Content} = 'info@exampe.com';
    $XMLStructur[0]{Contact}[0]{Email}[1]{Domain}[0]{Content} = '1234.com';

=cut

sub XMLParse2Hash {
    my $Self = shift;
    my %Param = @_;
    my @NewXMLStructur;
    my @XMLStructur = $Self->XMLParse(%Param);
    foreach my $Tag (@XMLStructur) {
        # just start
        if ($Tag->{TagType} ne 'Start') {
            next;
        }
        my $Key = $Tag->{TagKey};
        my $T = '';
        foreach (sort keys %{$Tag}) {
            if ($_ ne 'Tag' && $_ ne 'TagType' && $_ ne 'TagLevel' && $_ ne 'TagCount' && $_ ne 'TagLastLevel') {
                if (defined($Tag->{$_}) && $Tag->{$_} !~ /^\s+$/) {
                    $Tag->{$_} =~ s/'/\\'/g;
                    $T .= '$NewXMLStructur[0]->'.$Key."{$_} = '$Tag->{$_}';\n";
#                    print $T;
                    if (!eval $T) {
                        print STDERR "ERROR: $@\n";
                    }
                }
            }
        }
    }

#    $NewXMLStructur[1]{'IODEF-Document'} = $NewXMLStructur[0]{'IODEF-Document'};
    $NewXMLStructur[0]{Meta}[0]{Created} = 'admin';
    
    return @NewXMLStructur;
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
    $Self->{XMLLevel} = 0;
    $Self->{XMLTagCount} = 0;
    undef $Self->{XMLHash};
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelTagCount};
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
#        $Self->{XMLHash}->{$Element}++; 
        push (@{$S->{XMLARRAY}}, {%{$S->{LastTag}}, Content => $S->{C}});
    }
    undef $S->{LastTag};
    undef $S->{C};
    $S->{XMLLevel}++;
    $S->{XMLTagCount}++;
    $S->{XMLLevelTag}->{$S->{XMLLevel}} = $Element;
    if ($S->{Tll} && $S->{Tll} > $S->{XMLLevel}) {
        foreach (($S->{XMLLevel}+1)..30) {
            undef $S->{XMLLevelCount}->{$_}; #->{$Element} = 0;
        }
    }
    $S->{XMLLevelCount}->{$S->{XMLLevel}}->{$Element}++;
    # remember old level
    $S->{Tll} = $S->{XMLLevel};

    my $Key = '';
    foreach (1..($S->{XMLLevel})) {
        if ($Key) {
#            $Key .= "->";
        }
        $Key .= "{'$S->{XMLLevelTag}->{$_}'}";
        $Key .= "[".$S->{XMLLevelCount}->{$_}->{$S->{XMLLevelTag}->{$_}}."]";
    }
    $S->{LastTag} = {
        %Attr, 
        TagType => 'Start',
        Tag => $Element,
        TagLevel => $S->{XMLLevel},
        TagCount => $S->{XMLTagCount},
        TagKey => $Key,
        TagLastLevel => $S->{XMLLevelTag}->{($S->{XMLLevel}-1)}, 
    };
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
    $S->{XMLTagCount}++;
    if ($S->{LastTag}) {
        push (@{$S->{XMLARRAY}}, {%{$S->{LastTag}}, Content => $S->{C}, });
    }
    undef $S->{LastTag};
    undef $S->{C};
    push (@{$S->{XMLARRAY}}, {
        TagType => 'End',
        TagLevel => $S->{XMLLevel},
        TagCount => $S->{XMLTagCount},
        Tag => $Element},
    );
    $S->{XMLLevel} = $S->{XMLLevel} - 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2005-01-22 16:10:04 $

=cut
