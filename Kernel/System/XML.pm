# --
# Kernel/System/XML.pm - lib xml
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::XML;
## nofilter(TidyAll::Plugin::OTRS::Perl::Require)

use strict;
use warnings;

use Digest::MD5;

use Kernel::System::Cache;

=head1 NAME

Kernel::System::XML - xml lib

=head1 SYNOPSIS

All xml related functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::XML;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $XMLObject = Kernel::System::XML->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ConfigObject LogObject DBObject MainObject EncodeObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );

    return $Self;
}

=item XMLHashAdd()

add an XMLHash to storage

    my $Key = $XMLObject->XMLHashAdd(
        Type    => 'SomeType',
        Key     => '123',
        XMLHash => \@XMLHash,
    );

    my $AutoKey = $XMLObject->XMLHashAdd(
        Type             => 'SomeType',
        KeyAutoIncrement => 1,
        XMLHash          => \@XMLHash,
    );

=cut

sub XMLHashAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type XMLHash)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    if ( !$Param{Key} && !$Param{KeyAutoIncrement} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Key or KeyAutoIncrement param!',
        );
        return;
    }

    my %ValueHASH = $Self->XMLHash2D( XMLHash => $Param{XMLHash} );
    if (%ValueHASH) {
        if ( !$Param{Key} ) {
            $Param{Key} = $Self->_XMLHashAddAutoIncrement(%Param);
        }
        if ( !$Param{Key} ) {
            return;
        }
        $Self->XMLHashDelete(%Param);

        # create rand number
        my $Rand   = int( rand(1000000) );
        my $TmpKey = "TMP-$Rand-$Param{Type}";
        for my $Key ( sort keys %ValueHASH ) {
            $Self->{DBObject}->Do(
                SQL =>
                    'INSERT INTO xml_storage (xml_type, xml_key, xml_content_key, xml_content_value) VALUES (?, ?, ?, ?)',
                Bind => [ \$TmpKey, \$Param{Key}, \$Key, \$ValueHASH{$Key}, ],
            );
        }

        # move new hash if insert is complete
        $Self->XMLHashMove(
            OldType => $TmpKey,
            OldKey  => $Param{Key},
            NewType => $Param{Type},
            NewKey  => $Param{Key},
        );
        return $Param{Key};
    }

    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => 'Got no %ValueHASH from XMLHash2D()',
    );

    return;
}

=item XMLHashUpdate()

update an XMLHash to storage

    $XMLHash[1]->{Name}->[1]->{Content} = 'Some Name';

    $XMLObject->XMLHashUpdate(
        Type    => 'SomeType',
        Key     => '123',
        XMLHash => \@XMLHash,
    );

=cut

sub XMLHashUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key XMLHash)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return $Self->XMLHashAdd(%Param);
}

=item XMLHashGet()

get an XMLHash from the database

    my @XMLHash = $XMLObject->XMLHashGet(
        Type => 'SomeType',
        Key  => '123',
    );

    my @XMLHash = $XMLObject->XMLHashGet(
        Type  => 'SomeType',
        Key   => '123',
        Cache => 0,   # (optional) do not use cached data
    );

=cut

sub XMLHashGet {
    my ( $Self, %Param ) = @_;

    my $Content = '';
    my @XMLHash;

    # check needed stuff
    for (qw(Type Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !defined $Param{Cache} ) {
        $Param{Cache} = 1;
    }

    # check cache
    if ( $Param{Cache} ) {
        my $Cache = $Self->{CacheObject}->Get(
            Type => 'XML',
            Key  => "$Param{Type}-$Param{Key}",
        );
        return @{$Cache} if $Cache;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT xml_content_key, xml_content_value '
            . ' FROM xml_storage WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{Type}, \$Param{Key} ],

    );
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        if ( defined $Data[1] ) {
            $Data[1] =~ s/\\/\\\\/g;
            $Data[1] =~ s/'/\\'/g;
        }
        else {
            $Data[1] = '';
        }
        $Content .= '$XMLHash' . $Data[0] . " = '$Data[1]';\n 1;\n";
    }
    if ( $Content && !eval $Content ) {    ## no critic
        print STDERR "ERROR: XML.pm $@\n";
    }

    # set cache
    if ( $Param{Cache} && $Content ) {
        $Self->{CacheObject}->Set(
            Type  => 'XML',
            Key   => "$Param{Type}-$Param{Key}",
            Value => \@XMLHash,
            TTL   => 24 * 60 * 60,
        );
    }

    return @XMLHash;
}

=item XMLHashDelete()

delete an XMLHash from the database

    $XMLObject->XMLHashDelete(
        Type => 'SomeType',
        Key  => '123',
    );

=cut

sub XMLHashDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # remove cache
    $Self->{CacheObject}->Delete(
        Type => 'XML',
        Key  => "$Param{Type}-$Param{Key}",
    );

    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM xml_storage WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{Type}, \$Param{Key} ],
    );

    return 1;
}

=item XMLHashMove()

move an XMLHash from one type or/and key to another

    $XMLObject->XMLHashMove(
        OldType => 'SomeType',
        OldKey  => '123',
        NewType => 'NewType',
        NewKey  => '321',
    );

=cut

sub XMLHashMove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(OldType OldKey NewType NewKey)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # remove cache
    $Self->{CacheObject}->Delete(
        Type => 'XML',
        Key  => "$Param{OldType}-$Param{OldKey}",
    );
    $Self->{CacheObject}->Delete(
        Type => 'XML',
        Key  => "$Param{NewType}-$Param{NewKey}",
    );

    # delete existing xml hash
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM xml_storage WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{NewType}, \$Param{NewKey} ],
    );

    # update xml hash
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE xml_storage SET xml_type = ?, xml_key = ? '
            . 'WHERE xml_type = ? AND xml_key = ?',
        Bind => [ \$Param{NewType}, \$Param{NewKey}, \$Param{OldType}, \$Param{OldKey} ],
    );

    return 1;
}

=item XMLHashSearch()

Search an XMLHash in the database.

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
            },
            {
                # use array reference if different content with same key was searched
                "[%]{'ElementA'}[%]{'ElementB'}[%]{'Content'}" => ['%contentC%', '%contentD%', '%contentE%'],
                "[%]{'ElementA'}[%]{'ElementC'}[%]{'Content'}" => ['%contentC%', '%contentD%', '%contentE%'],
            },
        ],
    );

=cut

sub XMLHashSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Type} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Type!' );
        return;
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT DISTINCT(xml_key) FROM xml_storage WHERE xml_type = ?',
        Bind => [ \$Param{Type} ],
    );

    # the keys of this hash will be returned
    my %Hash;

    # initially all keys with the correct type are possible
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Hash{ $Data[0] } = 1;
    }

    if ( $Param{What} && ref $Param{What} eq 'ARRAY' ) {

        # get like escape string needed for some databases (e.g. oracle)
        my $LikeEscapeString = $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString');

        # the array elements are 'and' combined
        for my $And ( @{ $Param{What} } ) {

            # the key/value pairs are 'or' combined
            my @OrConditions;
            for my $Key ( sort keys %{$And} ) {
                my $Value = $Self->{DBObject}->Quote( $And->{$Key} );
                $Key = $Self->{DBObject}->Quote( $Key, 'Like' );
                if ( $Value && ref $Value eq 'ARRAY' ) {

                    # when an array of possible values is given,
                    # we use 'LIKE'-conditions and combine them with 'OR'
                    for my $Element ( @{$Value} ) {
                        $Element = $Self->{DBObject}->Quote( $Element, 'Like' );
                        push @OrConditions,
                            " (xml_content_key LIKE '$Key' $LikeEscapeString "
                            . "AND xml_content_value LIKE '$Element' $LikeEscapeString)";
                    }
                }
                else {

                    # when a single  possible value is given,
                    # we use a 'LIKE'-condition
                    $Value = $Self->{DBObject}->Quote( $Value, 'Like' );
                    push @OrConditions,
                        " (xml_content_key LIKE '$Key' $LikeEscapeString "
                        . "AND xml_content_value LIKE '$Value' $LikeEscapeString )";
                }
            }

            # assemble the SQL
            my $SQL = 'SELECT DISTINCT(xml_key) FROM xml_storage WHERE xml_type = ? ';
            if (@OrConditions) {
                $SQL .= 'AND ( ' . join( ' OR ', @OrConditions ) . ' ) ';
            }

            # execute
            $Self->{DBObject}->Prepare(
                SQL  => $SQL,
                Bind => [ \$Param{Type} ],
            );

            # intersection between the current key set, and the keys from the last 'SELECT'
            # only the keys which are in all results survive
            my %HashNew;
            while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
                if ( $Hash{ $Data[0] } ) {
                    $HashNew{ $Data[0] } = 1;
                }
            }
            %Hash = %HashNew;
        }
    }

    my @Keys = keys %Hash;

    return @Keys;
}

=item XMLHashList()

generate a list of XMLHashes in the database

    my @Keys = $XMLObject->XMLHashList(
        Type => 'SomeType',
    );

=cut

sub XMLHashList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Type} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Type!' );
        return;
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT distinct(xml_key) FROM xml_storage WHERE xml_type = ?',
        Bind => [ \$Param{Type} ],
    );

    my @Keys;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @Keys, $Data[0];
    }

    return @Keys;
}

=item XMLHash2XML()

generate an XML string from an XMLHash

    my $XMLString = $XMLObject->XMLHash2XML(@XMLHash);

=cut

sub XMLHash2XML {
    my ( $Self, @XMLHash ) = @_;

    my $Output = '<?xml version="1.0" encoding="utf-8"?>' . "\n";

    $Self->{XMLHash2XMLLayer} = 0;
    for my $Key (@XMLHash) {
        $Output .= $Self->_ElementBuild( %{$Key} );
    }

    return $Output;
}

=item XMLParse2XMLHash()

parse an XML file and return an XMLHash structure

    my @XMLHash = $XMLObject->XMLParse2XMLHash( String => $FileString );

    XML:
    ====
    <Contact role="admin" type="organization">
        <Name type="long">Example Inc.</Name>
        <Email type="primary">info@exampe.com<Domain>1234.com</Domain></Email>
        <Email type="secondary">sales@example.com</Email>
        <Telephone country="germany">+49-999-99999</Telephone>
    </Contact>

    ARRAY:
    ======
    @XMLHash = (
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
                    ],
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
                            type => 'secondary',
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
    $XMLHash[1]{Contact}[1]{Email}[2]{type} = "secondary";
    $XMLHash[1]{Contact}[1]{Email}[2]{Content} = "sales\@exampe.com";

=cut

sub XMLParse2XMLHash {
    my ( $Self, %Param ) = @_;

    my @XMLStructure = $Self->XMLParse(%Param);
    return () if !@XMLStructure;

    my @XMLHash = ( undef, $Self->XMLStructure2XMLHash( XMLStructure => \@XMLStructure ) );
    return @XMLHash;

}

=item XMLHash2D()

returns a simple hash with tag keys as keys and the values of C<XMLHash> as values.
As a side effect the data structure C<XMLHash> is enriched with tag keys.

    my %Hash = $XMLObject->XMLHash2D( XMLHash => \@XMLHash );

For example:

    $Hash{"[1]{'Planet'}[1]{'Content'}"'} = 'Sun';

=cut

sub XMLHash2D {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{XMLHash} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'XMLHash not defined!',
        );
        return;
    }

    $Self->{XMLLevel}      = 0;
    $Self->{XMLTagCount}   = 0;
    $Self->{XMLHash}       = {};
    $Self->{XMLHashReturn} = 1;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};

    my $Count = 0;
    for my $Item ( @{ $Param{XMLHash} } ) {
        if ( ref $Item eq 'HASH' ) {
            for ( sort keys %{$Item} ) {
                $Self->_XMLHash2D( Key => $Item->{Tag}, Item => $Item, Counter => $Count );
            }
        }
        $Count++;
    }
    $Self->{XMLHashReturn} = 0;

    return %{ $Self->{XMLHash} };
}

=item XMLStructure2XMLHash()

get an @XMLHash from a @XMLStructure with current TagKey param

    my @XMLHash = $XMLObject->XMLStructure2XMLHash( XMLStructure => \@XMLStructure );

=cut

sub XMLStructure2XMLHash {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{XMLStructure} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'XMLStructure not defined!' );
        return;
    }

    $Self->{Tll}           = 0;
    $Self->{XMLTagCount}   = 0;
    $Self->{XMLHash2}      = {};
    $Self->{XMLHashReturn} = 1;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};

    for my $Item ( @{ $Param{XMLStructure} } ) {
        if ( ref $Item eq 'HASH' ) {
            $Self->_XMLStructure2XMLHash( Key => $Item->{Tag}, Item => $Item, Type => 'ARRAY' );
        }
    }
    $Self->{XMLHashReturn} = 0;

    return ( \%{ $Self->{XMLHash2} } );
}

=item XMLParse()

parse an XML file

    my @XMLStructure = $XMLObject->XMLParse( String => $FileString );

    my @XMLStructure = $XMLObject->XMLParse( String => \$FileStringScalar );

=cut

sub XMLParse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
        return;
    }

    # check input type
    if ( ref $Param{String} ) {
        $Param{String} = ${ $Param{String} };
    }

    # create checksum
    my $CookedString = $Param{String};
    $Self->{EncodeObject}->EncodeOutput( \$CookedString );
    my $MD5Object = Digest::MD5->new();
    $MD5Object->add($CookedString);
    my $Checksum = $MD5Object->hexdigest();

    # check cache
    if ($Checksum) {
        my $Cache = $Self->{CacheObject}->Get(
            Type => 'XMLParse',
            Key  => $Checksum,
        );
        return @{$Cache} if $Cache;
    }

    # cleanup global vars
    undef $Self->{XMLARRAY};
    $Self->{XMLLevel}    = 0;
    $Self->{XMLTagCount} = 0;
    undef $Self->{XMLLevelTag};
    undef $Self->{XMLLevelCount};

    # convert string
    if ( $Param{String} =~ /(<.+?>)/ ) {
        if ( $1 !~ /(utf-8|utf8)/i && $1 =~ /encoding=('|")(.+?)('|")/i ) {
            my $SourceCharset = $2;
            $Param{String} =~ s/$SourceCharset/utf-8/i;
            $Param{String} = $Self->{EncodeObject}->Convert(
                Text  => $Param{String},
                From  => $SourceCharset,
                To    => 'utf-8',
                Force => 1,
            );
        }
    }

    # load parse package and parse
    my $UseFallback = 1;

    if ( eval 'require XML::Parser' ) {    ## no critic
        my $Parser = XML::Parser->new(
            Handlers => {
                Start => sub { $Self->_HS(@_); },
                End   => sub { $Self->_ES(@_); },
                Char  => sub { $Self->_CS(@_); },
            },
        );

        if ( eval { $Parser->parse( $Param{String} ) } ) {
            $UseFallback = 0;

            # remember, XML::Parser is managing e. g. &amp; by it self
            $Self->{XMLQuote} = 0;
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "C-Parser: $@!" );
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'XML::Parser produced errors. I use XML::Parser::Lite as fallback!'
            );
        }
    }

    if ($UseFallback) {
        require XML::Parser::Lite;    ## no critic

        my $Parser = XML::Parser::Lite->new(
            Handlers => {
                Start => sub { $Self->_HS(@_); },
                End   => sub { $Self->_ES(@_); },
                Char  => sub { $Self->_CS(@_); },
            },
        );
        $Parser->parse( $Param{String} );

        # remember, XML::Parser::Lite is managing e. g. &amp; NOT by it self
        $Self->{XMLQuote} = 1;
    }

    # quote
    for my $XMLElement ( @{ $Self->{XMLARRAY} } ) {
        $Self->_Decode($XMLElement);
    }

    # set cache
    if ($Checksum) {
        $Self->{CacheObject}->Set(
            Type  => 'XMLParse',
            Key   => $Checksum,
            Value => $Self->{XMLARRAY},
            TTL   => 30 * 24 * 60 * 60,
        );
    }

    return @{ $Self->{XMLARRAY} };
}

=begin Internal:

=item  _XMLHashAddAutoIncrement()

Generate a new integer key.
All keys for that type must be integers.

    my $Key = $XMLObject->_XMLHashAddAutoIncrement(
        Type             => 'SomeType',
        KeyAutoIncrement => 1,
    );

=cut

sub _XMLHashAddAutoIncrement {
    my ( $Self, %Param ) = @_;

    my $KeyAutoIncrement = 0;
    my @KeysExists;

    # check needed stuff
    for (qw(Type KeyAutoIncrement)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT DISTINCT(xml_key) FROM xml_storage WHERE xml_type = ?',
        Bind => [ \$Param{Type} ],
    );

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Data[0] ) {
            push @KeysExists, $Data[0];
        }
    }

    for my $Key (@KeysExists) {
        if ( $Key !~ /^\d{1,99}$/ ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No KeyAutoIncrement possible, no int key exists ($Key)!",
            );
            return;
        }
        if ( $Key > $KeyAutoIncrement ) {
            $KeyAutoIncrement = $Key;
        }
    }

    $KeyAutoIncrement++;
    return $KeyAutoIncrement;
}

sub _ElementBuild {
    my ( $Self, %Param ) = @_;

    my @Tag;
    my @Sub;
    my $Output = '';

    if ( $Param{Key} ) {
        $Self->{XMLHash2XMLLayer}++;
        $Output .= "<$Param{Key}";
    }

    for ( sort keys %Param ) {
        if ( ref $Param{$_} eq 'ARRAY' ) {
            push @Tag, $_;
            push @Sub, $Param{$_};
        }
        elsif ( $_ ne 'Content' && $_ ne 'Key' && $_ !~ /^Tag/ ) {
            if ( defined $Param{$_} ) {
                $Param{$_} =~ s/&/&amp;/g;
                $Param{$_} =~ s/</&lt;/g;
                $Param{$_} =~ s/>/&gt;/g;
                $Param{$_} =~ s/"/&quot;/g;
            }
            $Output .= " $_=\"$Param{$_}\"";
        }
    }
    if ( $Param{Key} ) {
        $Output .= '>';
    }
    if ( defined $Param{Content} ) {

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
    for ( 0 .. $#Sub ) {
        for my $K ( @{ $Sub[$_] } ) {
            if ( defined $K ) {
                $Output .= $Self->_ElementBuild( %{$K}, Key => $Tag[$_], );
            }
        }
    }

    if ( $Param{Key} ) {
        $Output .= "</$Param{Key}>\n";
        $Self->{XMLHash2XMLLayer} = $Self->{XMLHash2XMLLayer} - 1;
    }

    return $Output;
}

sub _XMLHash2D {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Item} ) {
        return '';
    }
    elsif ( ref $Param{Item} eq 'HASH' ) {
        $Self->{XMLLevel}++;
        $Self->{XMLTagCount}++;
        $Self->{XMLLevelTag}->{ $Self->{XMLLevel} } = $Param{Key};
        if ( $Self->{Tll} && $Self->{Tll} > $Self->{XMLLevel} ) {
            for ( ( $Self->{XMLLevel} + 1 ) .. 30 ) {
                undef $Self->{XMLLevelCount}->{$_};    #->{$Element} = 0;
            }
        }
        $Self->{XMLLevelCount}->{ $Self->{XMLLevel} }->{ $Param{Key} || '' }++;

        # remember old level
        $Self->{Tll} = $Self->{XMLLevel};

        my $Key = "[$Param{Counter}]";
        for ( 2 .. ( $Self->{XMLLevel} ) ) {
            $Key .= "{'$Self->{XMLLevelTag}->{$_}'}";
            $Key .= "[" . $Self->{XMLLevelCount}->{$_}->{ $Self->{XMLLevelTag}->{$_} } . "]";
        }

        # add tag key to the passed in data structure
        $Param{Item}->{TagKey} = $Key;

        for ( sort keys %{ $Param{Item} } ) {
            if ( defined $Param{Item}->{$_} && ref $Param{Item}->{$_} ne 'ARRAY' ) {
                $Self->{XMLHash}->{ $Key . "{'$_'}" } = $Param{Item}->{$_};
            }
            $Self->_XMLHash2D( Key => $_, Item => $Param{Item}->{$_}, Counter => $Param{Counter} );
        }
        $Self->{XMLLevel} = $Self->{XMLLevel} - 1;
    }
    elsif ( ref $Param{Item} eq 'ARRAY' ) {
        for ( @{ $Param{Item} } ) {
            $Self->_XMLHash2D( Key => $Param{Key}, Item => $_, Counter => $Param{Counter} );
        }
    }

    return 1;
}

sub _XMLStructure2XMLHash {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    if ( !defined $Param{Item} ) {
        return;
    }
    elsif ( ref $Param{Item} eq 'HASH' ) {
        if ( $Param{Item}->{TagType} eq 'End' ) {
            return '';
        }
        $Self->{XMLTagCount}++;
        $Self->{XMLLevelTag}->{ $Param{Item}->{TagLevel} } = $Param{Key};
        if ( $Self->{Tll} && $Self->{Tll} > $Param{Item}->{TagLevel} ) {
            for ( ( $Param{Item}->{TagLevel} + 1 ) .. 30 ) {
                undef $Self->{XMLLevelCount}->{$_};
            }
        }
        $Self->{XMLLevelCount}->{ $Param{Item}->{TagLevel} }->{ $Param{Key} }++;

        # remember old level
        $Self->{Tll} = $Param{Item}->{TagLevel};

        if ( $Param{Item}->{TagLevel} == 1 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 2 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 3 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 4 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 5 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 6 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 7 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 8 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 9 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]
                        ->{ $Self->{XMLLevelTag}->{9} }
                        ->[ $Self->{XMLLevelCount}->{9}->{ $Self->{XMLLevelTag}->{9} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 10 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]
                        ->{ $Self->{XMLLevelTag}->{9} }
                        ->[ $Self->{XMLLevelCount}->{9}->{ $Self->{XMLLevelTag}->{9} } ]
                        ->{ $Self->{XMLLevelTag}->{10} }
                        ->[ $Self->{XMLLevelCount}->{10}->{ $Self->{XMLLevelTag}->{10} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 11 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]
                        ->{ $Self->{XMLLevelTag}->{9} }
                        ->[ $Self->{XMLLevelCount}->{9}->{ $Self->{XMLLevelTag}->{9} } ]
                        ->{ $Self->{XMLLevelTag}->{10} }
                        ->[ $Self->{XMLLevelCount}->{10}->{ $Self->{XMLLevelTag}->{10} } ]
                        ->{ $Self->{XMLLevelTag}->{11} }
                        ->[ $Self->{XMLLevelCount}->{11}->{ $Self->{XMLLevelTag}->{11} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 12 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]
                        ->{ $Self->{XMLLevelTag}->{9} }
                        ->[ $Self->{XMLLevelCount}->{9}->{ $Self->{XMLLevelTag}->{9} } ]
                        ->{ $Self->{XMLLevelTag}->{10} }
                        ->[ $Self->{XMLLevelCount}->{10}->{ $Self->{XMLLevelTag}->{10} } ]
                        ->{ $Self->{XMLLevelTag}->{11} }
                        ->[ $Self->{XMLLevelCount}->{11}->{ $Self->{XMLLevelTag}->{11} } ]
                        ->{ $Self->{XMLLevelTag}->{12} }
                        ->[ $Self->{XMLLevelCount}->{12}->{ $Self->{XMLLevelTag}->{12} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 13 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]
                        ->{ $Self->{XMLLevelTag}->{9} }
                        ->[ $Self->{XMLLevelCount}->{9}->{ $Self->{XMLLevelTag}->{9} } ]
                        ->{ $Self->{XMLLevelTag}->{10} }
                        ->[ $Self->{XMLLevelCount}->{10}->{ $Self->{XMLLevelTag}->{10} } ]
                        ->{ $Self->{XMLLevelTag}->{11} }
                        ->[ $Self->{XMLLevelCount}->{11}->{ $Self->{XMLLevelTag}->{11} } ]
                        ->{ $Self->{XMLLevelTag}->{12} }
                        ->[ $Self->{XMLLevelCount}->{12}->{ $Self->{XMLLevelTag}->{12} } ]
                        ->{ $Self->{XMLLevelTag}->{13} }
                        ->[ $Self->{XMLLevelCount}->{13}->{ $Self->{XMLLevelTag}->{13} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 14 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]
                        ->{ $Self->{XMLLevelTag}->{9} }
                        ->[ $Self->{XMLLevelCount}->{9}->{ $Self->{XMLLevelTag}->{9} } ]
                        ->{ $Self->{XMLLevelTag}->{10} }
                        ->[ $Self->{XMLLevelCount}->{10}->{ $Self->{XMLLevelTag}->{10} } ]
                        ->{ $Self->{XMLLevelTag}->{11} }
                        ->[ $Self->{XMLLevelCount}->{11}->{ $Self->{XMLLevelTag}->{11} } ]
                        ->{ $Self->{XMLLevelTag}->{12} }
                        ->[ $Self->{XMLLevelCount}->{12}->{ $Self->{XMLLevelTag}->{12} } ]
                        ->{ $Self->{XMLLevelTag}->{13} }
                        ->[ $Self->{XMLLevelCount}->{13}->{ $Self->{XMLLevelTag}->{13} } ]
                        ->{ $Self->{XMLLevelTag}->{14} }
                        ->[ $Self->{XMLLevelCount}->{14}->{ $Self->{XMLLevelTag}->{14} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
        elsif ( $Param{Item}->{TagLevel} == 15 ) {
            for ( sort keys %{ $Param{Item} } ) {
                if ( !defined $Param{Item}->{$_} ) {
                    $Param{Item}->{$_} = '';
                }
                if ( $_ !~ /^Tag/ ) {
                    $Self->{XMLHash2}->{ $Self->{XMLLevelTag}->{1} }
                        ->[ $Self->{XMLLevelCount}->{1}->{ $Self->{XMLLevelTag}->{1} } ]
                        ->{ $Self->{XMLLevelTag}->{2} }
                        ->[ $Self->{XMLLevelCount}->{2}->{ $Self->{XMLLevelTag}->{2} } ]
                        ->{ $Self->{XMLLevelTag}->{3} }
                        ->[ $Self->{XMLLevelCount}->{3}->{ $Self->{XMLLevelTag}->{3} } ]
                        ->{ $Self->{XMLLevelTag}->{4} }
                        ->[ $Self->{XMLLevelCount}->{4}->{ $Self->{XMLLevelTag}->{4} } ]
                        ->{ $Self->{XMLLevelTag}->{5} }
                        ->[ $Self->{XMLLevelCount}->{5}->{ $Self->{XMLLevelTag}->{5} } ]
                        ->{ $Self->{XMLLevelTag}->{6} }
                        ->[ $Self->{XMLLevelCount}->{6}->{ $Self->{XMLLevelTag}->{6} } ]
                        ->{ $Self->{XMLLevelTag}->{7} }
                        ->[ $Self->{XMLLevelCount}->{7}->{ $Self->{XMLLevelTag}->{7} } ]
                        ->{ $Self->{XMLLevelTag}->{8} }
                        ->[ $Self->{XMLLevelCount}->{8}->{ $Self->{XMLLevelTag}->{8} } ]
                        ->{ $Self->{XMLLevelTag}->{9} }
                        ->[ $Self->{XMLLevelCount}->{9}->{ $Self->{XMLLevelTag}->{9} } ]
                        ->{ $Self->{XMLLevelTag}->{10} }
                        ->[ $Self->{XMLLevelCount}->{10}->{ $Self->{XMLLevelTag}->{10} } ]
                        ->{ $Self->{XMLLevelTag}->{11} }
                        ->[ $Self->{XMLLevelCount}->{11}->{ $Self->{XMLLevelTag}->{11} } ]
                        ->{ $Self->{XMLLevelTag}->{12} }
                        ->[ $Self->{XMLLevelCount}->{12}->{ $Self->{XMLLevelTag}->{12} } ]
                        ->{ $Self->{XMLLevelTag}->{13} }
                        ->[ $Self->{XMLLevelCount}->{13}->{ $Self->{XMLLevelTag}->{13} } ]
                        ->{ $Self->{XMLLevelTag}->{14} }
                        ->[ $Self->{XMLLevelCount}->{14}->{ $Self->{XMLLevelTag}->{14} } ]
                        ->{ $Self->{XMLLevelTag}->{15} }
                        ->[ $Self->{XMLLevelCount}->{15}->{ $Self->{XMLLevelTag}->{15} } ]->{$_}
                        = $Param{Item}->{$_};
                }
            }
        }
    }

    return 1;
}

sub _Decode {
    my ( $Self, $A ) = @_;

    for ( sort keys %{$A} ) {
        if ( ref $A->{$_} eq 'ARRAY' ) {
            for my $B ( @{ $A->{$_} } ) {
                $Self->_Decode($B);
            }
        }

        # decode
        elsif ( defined $A->{$_} ) {

            # check if decode is already done by parser
            if ( $Self->{XMLQuote} ) {
                my %Map = (
                    'amp'  => '&',
                    'lt'   => '<',
                    'gt'   => '>',
                    'quot' => '"',
                );
                $A->{$_} =~ s/&(amp|lt|gt|quot);/$Map{$1}/g;
            }

            # convert into default charset
            $A->{$_} = $Self->{EncodeObject}->Convert(
                Text  => $A->{$_},
                From  => 'utf-8',
                To    => 'utf-8',
                Force => 1,
            );
        }
    }

    return 1;
}

sub _HS {
    my ( $Self, $Expat, $Element, %Attr ) = @_;

    if ( $Self->{LastTag} ) {
        push @{ $Self->{XMLARRAY} }, { %{ $Self->{LastTag} }, Content => $Self->{C} };
    }

    undef $Self->{LastTag};
    undef $Self->{C};

    $Self->{XMLLevel}++;
    $Self->{XMLTagCount}++;
    $Self->{XMLLevelTag}->{ $Self->{XMLLevel} } = $Element;

    if ( $Self->{Tll} && $Self->{Tll} > $Self->{XMLLevel} ) {
        for ( ( $Self->{XMLLevel} + 1 ) .. 30 ) {
            undef $Self->{XMLLevelCount}->{$_};
        }
    }

    $Self->{XMLLevelCount}->{ $Self->{XMLLevel} }->{$Element}++;

    # remember old level
    $Self->{Tll} = $Self->{XMLLevel};

    my $Key = '';
    for ( 1 .. ( $Self->{XMLLevel} ) ) {
        $Key .= "{'$Self->{XMLLevelTag}->{$_}'}";
        $Key .= "[" . $Self->{XMLLevelCount}->{$_}->{ $Self->{XMLLevelTag}->{$_} } . "]";
    }

    $Self->{LastTag} = {
        %Attr,
        TagType      => 'Start',
        Tag          => $Element,
        TagLevel     => $Self->{XMLLevel},
        TagCount     => $Self->{XMLTagCount},
        TagLastLevel => $Self->{XMLLevelTag}->{ ( $Self->{XMLLevel} - 1 ) },
    };

    return 1;
}

sub _CS {
    my ( $Self, $Expat, $Element, $I, $II ) = @_;

    if ( $Self->{LastTag} ) {
        $Self->{C} .= $Element;
    }

    return 1;
}

sub _ES {
    my ( $Self, $Expat, $Element ) = @_;

    $Self->{XMLTagCount}++;

    if ( $Self->{LastTag} ) {
        push @{ $Self->{XMLARRAY} }, { %{ $Self->{LastTag} }, Content => $Self->{C} };
    }

    undef $Self->{LastTag};
    undef $Self->{C};

    push(
        @{ $Self->{XMLARRAY} },
        {
            TagType  => 'End',
            TagLevel => $Self->{XMLLevel},
            TagCount => $Self->{XMLTagCount},
            Tag      => $Element
        },
    );

    $Self->{XMLLevel} = $Self->{XMLLevel} - 1;

    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
