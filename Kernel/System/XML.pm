# --
# Kernel/System/XML.pm - lib xml
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: XML.pm,v 1.3 2005-01-24 15:47:25 martin Exp $
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
$VERSION = '$Revision: 1.3 $';
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
  use Kernel::System::DB;
  use Kernel::System::XML;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $XMLObject = Kernel::System::XML->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
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
    foreach (qw(ConfigObject LogObject DBObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $S = $Self;

    return $Self;
}

=item XMLHashAdd()

add a xml hash to storage

    $XMLObject->XMLHashAdd(
        Type => 'SomeType',
        Key => '123',
        Hash => \@XMLStructur,
    );

=cut

sub XMLHashAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Type Key Hash)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %ValueHASH = $Self->XMLHashValue(XMLStructur => $Param{Hash});
    if (%ValueHASH) {
        $Self->XMLHashDelete(%Param);
        # db quote
        foreach (keys %Param) {
            $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
        }
        foreach my $Key (sort keys %ValueHASH) {
            my $Value = $Self->{DBObject}->Quote($ValueHASH{$Key});
            $Key = $Self->{DBObject}->Quote($Key);
            $Self->{DBObject}->Do(
                SQL => "INSERT INTO xml_storage (xml_type, xml_key, xml_content_key, xml_content_value) VALUES ('$Param{Type}', '$Param{Key}', '$Key', '$Value')",
            );
        }
    }
    return 1;
}

=item XMLHashGet()

get a xml hash from database

    my @XMLStructur = $XMLObject->XMLHashGet(
        Type => 'SomeType',
        Key => '123',
    );

=cut

sub XMLHashGet {
    my $Self = shift;
    my %Param = @_;
    my $Content = '';
    my @XMLStructur = ();
    # check needed stuff
    foreach (qw(Type Key)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote 
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = "SELECT xml_content_key, xml_content_value " .
        " FROM " .
        " xml_storage " .
        " WHERE " .
        " xml_type = '$Param{Type}' AND xml_key = '$Param{Key}'";

    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        $Data[1] =~ s/'/\\'/g;
        $Content .= '$XMLStructur[0]'.$Data[0]." = '$Data[1]';\n";
    }
#    print $Content;
    if (!eval $Content) {
        print STDERR "ERROR: $@\n";
    }
    return @XMLStructur; 
}

=item XMLHashDelete()

delete a xml hash from database

    $XMLObject->XMLHashDelete(
        Type => 'SomeType',
        Key => '123',
    );

=cut

sub XMLHashDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Type Key)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) { 
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM xml_storage WHERE xml_type = '$Param{Type}' AND xml_key = '$Param{Key}'",
    );
}

=item XMLHashSearch()

search  elete a xml hash from database

    my @Keys = $XMLObject->XMLHashSearch(K
        Type => 'SomeType',
        What => {
            "{'ElementA'}[%]{'ElementB'}[%]{'Content'}" => '%content%',
        }
    );

=cut

sub XMLHashSearch {
    my $Self = shift;
    my %Param = @_;
    my $SQL = '';
    my @Keys = ();
    # check needed stuff
    foreach (qw(Type What)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    foreach my $Key (sort keys %{$Param{What}}) {
        if ($SQL) {
            $SQL .= " AND ";
        }
        my $Value = $Self->{DBObject}->Quote($Param{What}->{$Key});
        $SQL .= " (xml_content_key LIKE '$Key' AND xml_content_value LIKE '$Value')";
    }
    # db quote
    foreach (keys %Param) { 
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    $SQL = 'SELECT xml_key FROM xml_storage WHERE '.$SQL." AND xml_type = '$Param{Type}'";
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        push (@Keys, $Data[0]);
    }
    return @Keys;
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

=item XMLParse2XMLHash()

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

sub XMLParse2XMLHash {
    my $Self = shift;
    my %Param = @_;
    my @XMLStructur = $Self->XMLParse(%Param);
    my @NewXMLStructur = $Self->XMLHashUpdate(XMLStructur => \@XMLStructur);

#    $NewXMLStructur[1]{'IODEF-Document'} = $NewXMLStructur[0]{'IODEF-Document'};
#    $NewXMLStructur[0]{Meta}[0]{Created} = 'admin';
    
    return @NewXMLStructur;
}

=item XMLHashValue()

return a hash with long hash key and content 

    my %Hash = $XMLObject->XMLHashSearch(XMLStructur => \@XMLStructur);

    for example:

    $Hash{'{Planet}[0]{Content}'} = 'Sun';

=cut

sub XMLHashValue {
    my $Self = shift;
    my %Param = @_;
    my @NewXMLStructur;
    # check needed stuff
    foreach (qw(XMLStructur)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "$_ not defined!");
        return;
      }
    }

    $Self->{XMLLevel} = 0;
    $Self->{XMLTagCount} = 0;
    $Self->{XMLHash} = {};
    $Self->{XMLHashReturn} = 1;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};
    foreach my $Item (@{$Param{XMLStructur}}) {
        if (ref($Item) eq 'HASH') {
            foreach (keys %{$Item}) {
                $Self->_TTT(Key => $_, Item => $Item->{$_});
            }
        }
    }
    $Self->{XMLHashReturn} = 0;
    return %{$Self->{XMLHash}};
}

=item XMLHashUpdate()

update a @XMLStructur with current TagKey param

    my @@XMLStructur = $XMLObject->XMLHashSearch(XMLStructur => \@XMLStructur);

    for example:

    $Hash{'{Planet}[0]{Content}'} = '{'Planet'}[0]';

=cut

sub XMLHashUpdate {
    my $Self = shift;
    my %Param = @_;
    my @NewXMLStructur;
    # check needed stuff
    foreach (qw(XMLStructur)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "$_ not defined!");
        return;
      }
    }

    $Self->{XMLLevel} = 0;
    $Self->{XMLTagCount} = 0;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};
    foreach my $Item (@{$Param{XMLStructur}}) {
        if (ref($Item) eq 'HASH') {
            foreach (keys %{$Item}) {
                $Self->_TTT(Key => $_, Item => $Item->{$_});
            }
        }
    }
    return @{$Param{XMLStructur}};
}
sub _TTT {
    my $Self = shift;
    my %Param = @_;

    if (!defined($Param{Item})) {
        return;
    }
    elsif (ref($Param{Item}) eq 'HASH') {
        $S->{XMLLevel}++;
        $S->{XMLTagCount}++;
        $S->{XMLLevelTag}->{$S->{XMLLevel}} = $Param{Key};
        if ($S->{Tll} && $S->{Tll} > $S->{XMLLevel}) {
            foreach (($S->{XMLLevel}+1)..30) {
                undef $S->{XMLLevelCount}->{$_}; #->{$Element} = 0;
            }
        }
        $S->{XMLLevelCount}->{$S->{XMLLevel}}->{$Param{Key}}++;
        # remember old level
        $S->{Tll} = $S->{XMLLevel};
    
        my $Key = '';
        foreach (1..($S->{XMLLevel})) {
            $Key .= "{'$S->{XMLLevelTag}->{$_}'}";
            $Key .= "[".$S->{XMLLevelCount}->{$_}->{$S->{XMLLevelTag}->{$_}}."]";
        }
        $Param{Item}->{TagKey} = $Key;
        foreach (keys %{$Param{Item}}) {
            if (defined($Param{Item}->{$_})) {
                $Self->{XMLHash}->{$Key."{'$_'}"} = $Param{Item}->{$_};
            }
            $Self->_TTT(Key => $_, Item => $Param{Item}->{$_});
        }
        $S->{XMLLevel} = $S->{XMLLevel} - 1;
    } 
    elsif (ref($Param{Item}) eq 'ARRAY') {
        foreach (@{$Param{Item}}) {
            $Self->_TTT(Key => $Param{Key}, Item => $_);
        }
    } 
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
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};
    # parse package
    my $Parser = new XML::Parser::Lite(Handlers => {Start => \&HS, End => \&ES, Char => \&CS});
    $Parser->parse($Param{String});
    return @{$Self->{XMLARRAY}};
}

sub HS {
    my ($Expat, $Element, %Attr) = @_;
#    print "s:'$Element'\n";
    if ($S->{LastTag}) {
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
#        TagKey => $Key,
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

$Revision: 1.3 $ $Date: 2005-01-24 15:47:25 $

=cut
