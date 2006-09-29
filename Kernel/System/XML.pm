# --
# Kernel/System/XML.pm - lib xml
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: XML.pm,v 1.35 2006-09-29 14:25:11 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::XML;

use strict;
use Kernel::System::Encode;

use vars qw($VERSION $S);
$VERSION = '$Revision: 1.35 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::XML - xml lib

=head1 SYNOPSIS

All xml related functions.

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

    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    $S = $Self;

    return $Self;
}

=item XMLHashAdd()

add a XMLHash to storage

    $XMLObject->XMLHashAdd(
        Type => 'SomeType',
        Key => '123',
        XMLHash => \@XMLHash,
    );

=cut

sub XMLHashAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Type Key XMLHash)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %ValueHASH = $Self->XMLHash2D(XMLHash => $Param{XMLHash});
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
        return 1;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no \%ValueHASH from XMLHash2D()");
        return;
    }
}


=item XMLHashUpdate()

update an XMLHash part to storage

    $XMLHash[1]->{Name}->[1]->{Content} = 'Some Name';

    $XMLObject->XMLHashUpdate(
        Type => 'SomeType',
        Key => '123',
        XMLHash => \@XMLHash,
    );

=cut

sub XMLHashUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Type Key XMLHash)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %ValueHASH = $Self->XMLHash2D(XMLHash => $Param{XMLHash});
    if (%ValueHASH) {
#        $Self->XMLHashDelete(%Param);
        # db quote
        foreach (keys %Param) {
            $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
        }
        foreach my $Key (sort keys %ValueHASH) {
            my $Value = $Self->{DBObject}->Quote($ValueHASH{$Key});
            $Key = $Self->{DBObject}->Quote($Key);
            $Self->{DBObject}->Do(
                SQL => "DELETE FROM xml_storage WHERE xml_type = '$Param{Type}' AND xml_key = '$Param{Key}' AND xml_content_key = '$Key'",
            );
            $Self->{DBObject}->Do(
                SQL => "INSERT INTO xml_storage (xml_type, xml_key, xml_content_key, xml_content_value) VALUES ('$Param{Type}', '$Param{Key}', '$Key', '$Value')",
            );
        }
        return 1;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no \%ValueHASH from XMLHash2D()");
        return;
    }
}

=item XMLHashGet()

get a XMLHash from database

    my @XMLHash = $XMLObject->XMLHashGet(
        Type => 'SomeType',
        Key => '123',
    );

=cut

sub XMLHashGet {
    my $Self = shift;
    my %Param = @_;
    my $Content = '';
    my @XMLHash = ();
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
        if (defined($Data[1])) {
            $Data[1] =~ s/'/\\'/g;
        }
        else {
            $Data[1] = '';
        }
        $Content .= '$XMLHash'.$Data[0]." = '$Data[1]';\n";
    }
    if ($Content && !eval $Content) {
        print STDERR "ERROR: $@\n";
    }
    return @XMLHash;
}

=item XMLHashDelete()

delete a XMLHash from database

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

    my @Keys = $XMLObject->XMLHashSearch(
        Type => 'SomeType',
        What => [
            # each array element is a and condition
            {
                # or condition in hash
                "[%]{'ElementA'}[%]{'ElementB'}[%]{'Content'}" => '%contentA%',
                "[%]{'ElementA'}[%]{'ElementC'}[%]{'Content'}" => '%contentA%',
            },
            {
                "[%]{'ElementA'}[%]{'ElementB'}[%]{'Content'}" => '%contentB%',
                "[%]{'ElementA'}[%]{'ElementC'}[%]{'Content'}" => '%contentB%',
            }
        ],
    );

=cut

sub XMLHashSearch {
    my $Self = shift;
    my %Param = @_;
    my $SQL = '';
    my @Keys = ();
    my %Hash = ();
    my %HashNew = ();
    # check needed stuff
    foreach (qw(Type)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    $SQL = "SELECT xml_key FROM xml_storage WHERE xml_type = '$Param{Type}' GROUP BY xml_key";
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        $Hash{$Data[0]} = 1;
    }

    if ($Param{What}) {
        foreach my $And (@{$Param{What}}) {
            my %HashNew = ();
            my $SQL = '';
            foreach my $Key (sort keys %{$And}) {
                if ($SQL) {
                    $SQL .= " OR ";
                }
                my $Value = $Self->{DBObject}->Quote($And->{$Key});
                $Key = $Self->{DBObject}->Quote($Key);
                $SQL .= " (xml_content_key LIKE '$Key' AND xml_content_value LIKE '$Value')";

            }
            $SQL = "SELECT xml_key FROM xml_storage WHERE $SQL AND xml_type = '$Param{Type}' GROUP BY xml_key";
            if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
                return;
            }
            while (my @Data = $Self->{DBObject}->FetchrowArray()) {
                if ($Hash{$Data[0]}){
                    $HashNew{$Data[0]} = 1;
                }
            }
            %Hash = %HashNew;
        }
    }
    foreach my $Key(keys %Hash) {
        push(@Keys, $Key);
    }
    return @Keys;
}



=item XMLHash2XML()

generate a xml string from a XMLHash

    my $XMLString = $XMLObject->XMLHash2XML(@XMLHash);

=cut

sub XMLHash2XML {
    my $Self = shift;
    my @XMLHash = @_;

    my $Output = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
    $Self->{XMLHash2XMLLayer} = 0;
    foreach my $Key (@XMLHash) {
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
#            $Output .= "  ";
        }
        $Output .= "<$Param{Key}";
    }
    foreach (sort keys %Param) {
        if (ref($Param{$_}) eq 'ARRAY') {
            push (@Tag, $_);
            push (@Sub, $Param{$_});
        }
        elsif ($_ ne 'Content' && $_ ne 'Key' && $_ !~ /^Tag/) {
            if (defined($Param{$_})) {
                $Param{$_} =~ s/&/&amp;/g;
                $Param{$_} =~ s/</&lt;/g;
                $Param{$_} =~ s/>/&gt;/g;
                $Param{$_} =~ s/"/&quot;/g;
            }
            $Output .= " $_=\"$Param{$_}\"";
        }
    }
    if ($Param{Key}) {
        $Output .= ">";
    }
    if (defined($Param{Content})) {
        # encode
        $Param{Content} =~ s/&/&amp;/g;
        $Param{Content} =~ s/</&lt;/g;
        $Param{Content} =~ s/>/&gt;/g;
        $Param{Content} =~ s/"/&quot;/g;
        $Output .= $Param{Content};
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
#                $Output .= "  ";
            }
        }
        $Output .= "</$Param{Key}>\n";
        $Self->{XMLHash2XMLLayer} = $Self->{XMLHash2XMLLayer} - 1;
    }
    return $Output;
}

=item XMLParse2XMLHash()

parse a xml file and return a XMLHash structur

    my @XMLHash = $XMLObject->XMLParse2XMLHash(String => $FileString);

    XML:
    ====
    <Contact role="admin" type="organization">
      <Name type="long">Example Inc.</Name>
      <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
      <Email type="secundary">sales@example.com</Email>
      <Telephone country="germany">+49-999-99999</Telephone>
    </Contact>

    ARRAY:
    ======
    $XMLHash = (
      undef,
      {
        Contact => [
          undef,
          {
            role => 'admin',
            type => 'organization',
            Name => [
              undef,
              {
                Content => 'Example Inc.',
                type => 'long',
              },
            ]
            Email => [
              undef,
              {
                type => 'primary',
                Content => 'info@exampe.com',
                Domain => [
                  undef,
                  {
                    Content => '1234.com',
                  },
                ],
              },
              {
                type => 'secundary',
                Content => 'sales@exampe.com',
              },
            ],
            Telephone => [
              undef,
              {
                country => 'germany',
                Content => '+49-999-99999',
              },
            ],
          }
        ],
      }
    );

    $XMLHash[1]{Contact}[1]{TagKey} = "[1]{'Contact'}[1]";
    $XMLHash[1]{Contact}[1]{role} = "admin";
    $XMLHash[1]{Contact}[1]{type} = "organization";
    $XMLHash[1]{Contact}[1]{Name}[1]{TagKey} = "[1]{'Contact'}[1]{'Name'}[1]";
    $XMLHash[1]{Contact}[1]{Name}[1]{Content} = "Example Inc.";
    $XMLHash[1]{Contact}[1]{Name}[1]{type} = "long";
    $XMLHash[1]{Contact}[1]{Email}[1]{TagKey} = "[1]{'Contact'}[1]{'Email'}[1]";
    $XMLHash[1]{Contact}[1]{Email}[1]{Content} = "info\@exampe.com";
    $XMLHash[1]{Contact}[1]{Email}[1]{Domain}[1]{TagKey} = "[1]{'Contact'}[1]{'Email'}[1]{'Domain'}[1]";
    $XMLHash[1]{Contact}[1]{Email}[1]{Domain}[1]{Content} = "1234.com";
    $XMLHash[1]{Contact}[1]{Email}[2]{TagKey} = "[1]{'Contact'}[1]{'Email'}[2]";
    $XMLHash[1]{Contact}[1]{Email}[2]{type} = "secundary";
    $XMLHash[1]{Contact}[1]{Email}[2]{Content} = "sales\@exampe.com";

=cut

sub XMLParse2XMLHash {
    my $Self = shift;
    my %Param = @_;
    my @XMLStructur = $Self->XMLParse(%Param);
    if (!@XMLStructur) {
        return ();
    }
    else {
        my @XMLHash = (undef, $Self->XMLStructur2XMLHash(XMLStructur => \@XMLStructur));
#    $XMLHash[1]{'IODEF-Document'} = $XMLHash[1]{'otrs_package'};
#    $XMLHash[0]{Meta}[0]{Created} = 'admin';
        return @XMLHash;
    }
}

=item XMLHash2D()

return a hash with long hash key and content

    my %Hash = $XMLObject->XMLHash2D(XMLHash => \@XMLHash);

    for example:

    $Hash{"[1]{'Planet'}[1]{'Content'}"'} = 'Sun';

=cut

sub XMLHash2D {
    my $Self = shift;
    my %Param = @_;
    my @NewXMLStructur;
    # check needed stuff
    foreach (qw(XMLHash)) {
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
    my $Count = 0;
    foreach my $Item (@{$Param{XMLHash}}) {
        if (ref($Item) eq 'HASH') {
            foreach (keys %{$Item}) {
                $Self->_XMLHash2D(Key => $Item->{Tag}, Item => $Item, Counter => $Count);
            }
        }
        $Count++;
    }
    $Self->{XMLHashReturn} = 0;
    return %{$Self->{XMLHash}};
}

sub _XMLHash2D {
    my $Self = shift;
    my %Param = @_;

    if (!defined($Param{Item})) {
        return '';
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
        $S->{XMLLevelCount}->{$S->{XMLLevel}}->{$Param{Key}||''}++;
        # remember old level
        $S->{Tll} = $S->{XMLLevel};

        my $Key = "[$Param{Counter}]";
        foreach (2..($S->{XMLLevel})) {
            $Key .= "{'$S->{XMLLevelTag}->{$_}'}";
            $Key .= "[".$S->{XMLLevelCount}->{$_}->{$S->{XMLLevelTag}->{$_}}."]";
        }
        $Param{Item}->{TagKey} = $Key;
        foreach (keys %{$Param{Item}}) {
            if (defined($Param{Item}->{$_}) && ref($Param{Item}->{$_}) ne 'ARRAY') {
                $Self->{XMLHash}->{$Key."{'$_'}"} = $Param{Item}->{$_};
            }
            $Self->_XMLHash2D(Key => $_, Item => $Param{Item}->{$_}, Counter => $Param{Counter});
        }
        $S->{XMLLevel} = $S->{XMLLevel} - 1;
    }
    elsif (ref($Param{Item}) eq 'ARRAY') {
        foreach (@{$Param{Item}}) {
            $Self->_XMLHash2D(Key => $Param{Key}, Item => $_, Counter => $Param{Counter});
        }
    }
}

=item XMLStructur2XMLHash()

get a @XMLHash from a @XMLStructur with current TagKey param

    my @XMLHash = $XMLObject->XMLStructur2XMLHash(XMLStructur => \@XMLStructur);

=cut

sub XMLStructur2XMLHash {
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
    $Self->{Tll} = 0;
    $Self->{XMLTagCount} = 0;
    $Self->{XMLHash2} = {};
    $Self->{XMLHashReturn} = 1;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};
    my $Output = '';
    foreach my $Item (@{$Param{XMLStructur}}) {
        if (ref($Item) eq 'HASH') {
            $Self->_XMLStructur2XMLHash(Key => $Item->{Tag}, Item => $Item, Type => 'ARRAY');
        }
    }
    $Self->{XMLHashReturn} = 0;
    return (\%{$Self->{XMLHash2}});
}
sub _XMLStructur2XMLHash {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    if (!defined($Param{Item})) {
        return;
    }
    elsif (ref($Param{Item}) eq 'HASH') {
        if ($Param{Item}->{TagType} eq 'End') {
            return '';
        }
        $S->{XMLTagCount}++;
        $S->{XMLLevelTag}->{$Param{Item}->{TagLevel}} = $Param{Key};
        if ($S->{Tll} && $S->{Tll} > $Param{Item}->{TagLevel}) {
            foreach (($Param{Item}->{TagLevel}+1)..30) {
                undef $S->{XMLLevelCount}->{$_};
            }
        }
        $S->{XMLLevelCount}->{$Param{Item}->{TagLevel}}->{$Param{Key}}++;

        # remember old level
        $S->{Tll} = $Param{Item}->{TagLevel};

        if ($Param{Item}->{TagLevel} == 1) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 2) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 3) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 4) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 5) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 6) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 7) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 8) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 9) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$S->{XMLLevelTag}->{9}}->[$S->{XMLLevelCount}->{9}->{$S->{XMLLevelTag}->{9}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 10) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$S->{XMLLevelTag}->{9}}->[$S->{XMLLevelCount}->{9}->{$S->{XMLLevelTag}->{9}}]->{$S->{XMLLevelTag}->{10}}->[$S->{XMLLevelCount}->{10}->{$S->{XMLLevelTag}->{10}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 11) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$S->{XMLLevelTag}->{9}}->[$S->{XMLLevelCount}->{9}->{$S->{XMLLevelTag}->{9}}]->{$S->{XMLLevelTag}->{10}}->[$S->{XMLLevelCount}->{10}->{$S->{XMLLevelTag}->{10}}]->{$S->{XMLLevelTag}->{11}}->[$S->{XMLLevelCount}->{11}->{$S->{XMLLevelTag}->{11}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 12) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$S->{XMLLevelTag}->{9}}->[$S->{XMLLevelCount}->{9}->{$S->{XMLLevelTag}->{9}}]->{$S->{XMLLevelTag}->{10}}->[$S->{XMLLevelCount}->{10}->{$S->{XMLLevelTag}->{10}}]->{$S->{XMLLevelTag}->{11}}->[$S->{XMLLevelCount}->{11}->{$S->{XMLLevelTag}->{11}}]->{$S->{XMLLevelTag}->{12}}->[$S->{XMLLevelCount}->{12}->{$S->{XMLLevelTag}->{12}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 13) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$S->{XMLLevelTag}->{9}}->[$S->{XMLLevelCount}->{9}->{$S->{XMLLevelTag}->{9}}]->{$S->{XMLLevelTag}->{10}}->[$S->{XMLLevelCount}->{10}->{$S->{XMLLevelTag}->{10}}]->{$S->{XMLLevelTag}->{11}}->[$S->{XMLLevelCount}->{11}->{$S->{XMLLevelTag}->{11}}]->{$S->{XMLLevelTag}->{12}}->[$S->{XMLLevelCount}->{12}->{$S->{XMLLevelTag}->{12}}]->{$S->{XMLLevelTag}->{13}}->[$S->{XMLLevelCount}->{13}->{$S->{XMLLevelTag}->{13}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 14) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$S->{XMLLevelTag}->{9}}->[$S->{XMLLevelCount}->{9}->{$S->{XMLLevelTag}->{9}}]->{$S->{XMLLevelTag}->{10}}->[$S->{XMLLevelCount}->{10}->{$S->{XMLLevelTag}->{10}}]->{$S->{XMLLevelTag}->{11}}->[$S->{XMLLevelCount}->{11}->{$S->{XMLLevelTag}->{11}}]->{$S->{XMLLevelTag}->{12}}->[$S->{XMLLevelCount}->{12}->{$S->{XMLLevelTag}->{12}}]->{$S->{XMLLevelTag}->{13}}->[$S->{XMLLevelCount}->{13}->{$S->{XMLLevelTag}->{13}}]->{$S->{XMLLevelTag}->{14}}->[$S->{XMLLevelCount}->{14}->{$S->{XMLLevelTag}->{14}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
        elsif ($Param{Item}->{TagLevel} == 15) {
            foreach (keys %{$Param{Item}}) {
                if (!defined($Param{Item}->{$_})) {
                    $Param{Item}->{$_} = '';
                }
                if ($_ !~ /^Tag/) {
                    $Self->{XMLHash2}->{$S->{XMLLevelTag}->{1}}->[$S->{XMLLevelCount}->{1}->{$S->{XMLLevelTag}->{1}}]->{$S->{XMLLevelTag}->{2}}->[$S->{XMLLevelCount}->{2}->{$S->{XMLLevelTag}->{2}}]->{$S->{XMLLevelTag}->{3}}->[$S->{XMLLevelCount}->{3}->{$S->{XMLLevelTag}->{3}}]->{$S->{XMLLevelTag}->{4}}->[$S->{XMLLevelCount}->{4}->{$S->{XMLLevelTag}->{4}}]->{$S->{XMLLevelTag}->{5}}->[$S->{XMLLevelCount}->{5}->{$S->{XMLLevelTag}->{5}}]->{$S->{XMLLevelTag}->{6}}->[$S->{XMLLevelCount}->{6}->{$S->{XMLLevelTag}->{6}}]->{$S->{XMLLevelTag}->{7}}->[$S->{XMLLevelCount}->{7}->{$S->{XMLLevelTag}->{7}}]->{$S->{XMLLevelTag}->{8}}->[$S->{XMLLevelCount}->{8}->{$S->{XMLLevelTag}->{8}}]->{$S->{XMLLevelTag}->{9}}->[$S->{XMLLevelCount}->{9}->{$S->{XMLLevelTag}->{9}}]->{$S->{XMLLevelTag}->{10}}->[$S->{XMLLevelCount}->{10}->{$S->{XMLLevelTag}->{10}}]->{$S->{XMLLevelTag}->{11}}->[$S->{XMLLevelCount}->{11}->{$S->{XMLLevelTag}->{11}}]->{$S->{XMLLevelTag}->{12}}->[$S->{XMLLevelCount}->{12}->{$S->{XMLLevelTag}->{12}}]->{$S->{XMLLevelTag}->{13}}->[$S->{XMLLevelCount}->{13}->{$S->{XMLLevelTag}->{13}}]->{$S->{XMLLevelTag}->{14}}->[$S->{XMLLevelCount}->{14}->{$S->{XMLLevelTag}->{14}}]->{$S->{XMLLevelTag}->{15}}->[$S->{XMLLevelCount}->{15}->{$S->{XMLLevelTag}->{15}}]->{$_} = $Param{Item}->{$_};
                }
            }
        }
    }
    return 1;
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
    $S = $Self;
    # convert string
    if ($Param{String} =~ /(<.+?>)/) {
        if ($1 !~ /(utf-8|utf8)/i && $1 =~ /encoding=('|")(.+?)('|")/i) {
            my $SourceCharset = $2;
            $Param{String} =~ s/$SourceCharset/utf-8/i;
            $Param{String} = $Self->{EncodeObject}->Convert(
                Text => $Param{String},
                From => $SourceCharset,
                To => 'utf-8',
            );
        }
    }
    # load parse package and parse
    my $Parser;
    if (eval "require XML::Parser") {
        $Parser = XML::Parser->new(Handlers => {Start => \&HS, End => \&ES, Char => \&CS});
        if (!eval { $Parser->parse($Param{String}) }) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "C-Parser: $@!");
            return ();
        }
    }
    else {
        eval "require XML::Parser::Lite";
        $Parser = XML::Parser::Lite->new(Handlers => {Start => \&HS, End => \&ES, Char => \&CS});
        $Parser->parse($Param{String});
    }
    # quote
    foreach (@{$Self->{XMLARRAY}}) {
        $Self->_Decode($_);
    }
    return @{$Self->{XMLARRAY}};
}

sub _Decode{
    my $Self = shift;
    my $A = shift;
    foreach (keys %{$A}) {
        if (ref($A->{$_}) eq 'ARRAY') {
            foreach my $B (@{$A->{$_}}) {
                $Self->_Decode($B);
            }
        }
        # decode
        elsif (defined($A->{$_})) {
            $A->{$_} =~ s/&amp;/&/g;
            $A->{$_} =~ s/&lt;/</g;
            $A->{$_} =~ s/&gt;/>/g;
            $A->{$_} =~ s/&quot;/"/g;
            # convert into default charset
            $A->{$_} = $Self->{EncodeObject}->Convert(
                Text => $A->{$_},
                From => 'utf-8',
                To => $Self->{ConfigObject}->Get('DefaultCharset'),
                Force => 1,
            );
        }
    }
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
        $S->{C} .= $Element;
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

$Revision: 1.35 $ $Date: 2006-09-29 14:25:11 $

=cut
