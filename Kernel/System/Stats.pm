# --
# Kernel/System/Stats.pm - all advice functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Stats.pm,v 1.37 2008-01-24 08:42:04 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Stats;

use strict;
use warnings;

use MIME::Base64;
use Date::Pcalc qw(:all);
use Kernel::System::XML;
use Kernel::System::Encode;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.37 $) [1];

=head1 SYNOPSIS

All call functions. E. g. to get,

=head1 PUBLIC INTERFACE

=over 4

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Stats;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $StatsObject = Kernel::System::Stats->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
        UserID => 123,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(
        ConfigObject LogObject UserID GroupObject
        UserObject TimeObject MainObject CSVObject
        DBObject
        )
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{XMLObject}    = Kernel::System::XML->new(%Param);
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    return $Self;
}

=item StatsAdd()

add a new stat

    my $StatID = $StatsObject->StatsAdd();

=cut

sub StatsAdd {
    my ( $Self, %Param ) = @_;
    my $StatID = 1;

    # Get new StatID
    my @Keys = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats', );
    if (@Keys) {
        my @SortKeys = sort { $a <=> $b } @Keys;
        $StatID = $SortKeys[-1] + 1;
    }

    my $TimeStamp = $Self->{TimeObject}
        ->SystemTime2TimeStamp( SystemTime => $Self->{TimeObject}->SystemTime(), );

    # meta tags
    my %MetaData = ();
    $MetaData{Created}[0]{Content}   = $TimeStamp;
    $MetaData{CreatedBy}[0]{Content} = $Self->{UserID};
    $MetaData{Changed}[0]{Content}   = $TimeStamp;
    $MetaData{ChangedBy}[0]{Content} = $Self->{UserID};
    $MetaData{Valid}[0]{Content}     = 1;
    $MetaData{StatNumber}[0]{Content}
        = $StatID + $Self->{ConfigObject}->Get("Stats::StatsStartNumber");

    # new
    my @XMLHash;    # it's a array but the wording is hash
    $XMLHash[0]{otrs_stats}[0] = \%MetaData;
    if (!$Self->{XMLObject}->XMLHashAdd(
            Type    => 'Stats',
            Key     => $StatID,
            XMLHash => \@XMLHash,
        )
        )
    {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "StatsAdd: Can not add a new Stat!" );
        return 0;
    }
    return $StatID;
}

=item StatsGet()

get a hashref with the stat you need

    my $HashRef = $StatsObject->StatsGet(
        StatID => '123',
        NoObjectAttributes => 1,       # optional
    );

=cut

sub StatsGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "StatsGet: Need StatID!" );
    }

    # get hash from storage
    my @XMLHash = $Self->{XMLObject}->XMLHashGet(
        Type => 'Stats',
        Key  => $Param{StatID},
    );

    if ( !$XMLHash[0] ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "StatsGet: Can\'t get Stat!" );
        return 0;
    }

    my %Stat    = ();
    my $StatXML = $XMLHash[0]{otrs_stats}[1];

    # string
    $Stat{StatID} = $Param{StatID};
    for my $Key (
        qw(Title Object File Description SumRow SumCol StatNumber
        Cache StatType Valid ObjectModule CreatedBy ChangedBy Created Changed
        )
        )
    {
        if ( defined( $StatXML->{$Key}[1]{Content} ) ) {
            $Stat{$Key} = $StatXML->{$Key}[1]{Content};
        }
    }

    # array
    KEY:
    for my $Key (qw(Permission Format GraphSize)) {
        next KEY if !$StatXML->{$Key}[1]{Content};

        $Stat{$Key} = ();
        for my $Index ( 1 .. $#{ $StatXML->{$Key} } ) {
            push( @{ $Stat{$Key} }, $StatXML->{$Key}[$Index]->{Content} );
        }
    }

    # get the configuration elements of the dynamic stats
    # %Allowed is used to inhibit douple selction in the different forms
    my %Allowed     = ();
    my %TimeAllowed = ();
    my $TimeElement = $Self->{ConfigObject}->Get("Stats::TimeElement") || 'Time';

    return \%Stat if !$Stat{Object};
    return \%Stat if $Param{NoObjectAttributes};

    KEY:
    for my $Key (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {

        # @StatAttributesSimplified give you Arrays without undef Arrayelements
        my @StatAttributesSimplified = ();

        # get the Attributes of the Object
        my @ObjectAttributes = $Self->GetStatsObjectAttributes(
            ObjectModule => $Stat{ObjectModule},
            Use          => $Key,
        );

        next KEY if !@ObjectAttributes;

        ATTRIBUTE:
        for my $Attribute (@ObjectAttributes) {
            if ( $Attribute->{Block} eq 'Time' ) {
                if ( $Key eq 'UseAsValueSeries' ) {
                    if (   $Allowed{ $Attribute->{Element} }
                        && $Allowed{ $Attribute->{Element} } == 1 )
                    {
                        $Allowed{ $Attribute->{Element} }     = 0;
                        $TimeAllowed{ $Attribute->{Element} } = 1;
                    }
                    else {
                        $Allowed{ $Attribute->{Element} } = 1;
                    }
                }
                elsif ( $Key eq 'UseAsRestriction' ) {
                    if (   $TimeAllowed{ $Attribute->{Element} }
                        && $TimeAllowed{ $Attribute->{Element} } == 1 )
                    {
                        $Allowed{ $Attribute->{Element} } = 1;
                    }
                    else {
                        $Allowed{ $Attribute->{Element} } = 0;
                    }
                }
            }
            next ATTRIBUTE if $Allowed{ $Attribute->{Element} };

            if ( $StatXML->{$Key} ) {
                my @StatAttributes = @{ $StatXML->{$Key} };
                if ( !$StatAttributes[0] ) {
                    shift(@StatAttributes);
                }
                REF:
                for my $Ref (@StatAttributes) {
                    if ( !defined( $Attribute->{LanguageTranslation} ) ) {
                        $Attribute->{LanguageTranslation} = 1;
                    }

                    next REF
                        if !(      $Attribute->{Element}
                                && $Ref->{Element}
                                && $Attribute->{Element} eq $Ref->{Element}
                        );

                    # if selected elements exits add the information to the StatAttributes
                    $Attribute->{Selected} = 1;
                    if ( $Ref->{Fixed} ) {
                        $Attribute->{Fixed} = 1;
                    }
                    for my $Index ( 1 .. $#{ $Ref->{SelectedValues} } ) {
                        push(
                            @{ $Attribute->{SelectedValues} },
                            $Ref->{SelectedValues}[$Index]->{Content}
                        );
                    }

                    # stettings for working with time elements
                    for (
                        qw(TimeStop TimeStart TimeRelativeUnit
                        TimeRelativeCount TimeScaleCount
                        )
                        )
                    {
                        if ( $Ref->{$_} ) {
                            $Attribute->{$_} = $Ref->{$_};
                        }
                    }
                    $Allowed{ $Attribute->{Element} } = 1;
                }
            }
            push @StatAttributesSimplified, $Attribute;

        }
        $Stat{$Key} = \@StatAttributesSimplified;
    }

    return \%Stat;
}

=item StatsUpdate()

update a stat

    $StatsObject->StatsUpdate(
        StatID => '123',
        Hash => \%Hash
    );

=cut

sub StatsUpdate {
    my ( $Self, %Param ) = @_;

    my %StatXML = ();

    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "StatsUpdate: Need StatID!" );
    }

    my $StatOld = $Self->StatsGet( StatID => $Param{StatID} );

    if ( !$StatOld ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StatsUpddate: Can't get stat, perhaps you have an invalid stat id!"
        );
        return 0;
    }

    my $StatNew = $Param{Hash};

    # a delete function can be the better solution
    for my $Key (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {
        for ( @{ $StatOld->{$Key} } ) {
            if ( !$_->{Selected} ) {
                $_ = undef;
            }
        }
    }

    # merge
    for my $Key ( keys %{$StatNew} ) {
        $StatOld->{$Key} = $StatNew->{$Key};
    }
    for my $Key ( keys %{$StatOld} ) {
        if ( $Key eq 'UseAsXvalue' || $Key eq 'UseAsValueSeries' || $Key eq 'UseAsRestriction' ) {
            my $Index = 0;
            REF:
            for my $Ref ( @{ $StatOld->{$Key} } ) {
                next REF if !$Ref;

                $Index++;
                $StatXML{$Key}[$Index]{Element} = $Ref->{Element};
                $StatXML{$Key}[$Index]{Fixed}   = $Ref->{Fixed};
                my $SubIndex = 0;
                for my $Value ( @{ $Ref->{SelectedValues} } ) {
                    $SubIndex++;
                    $StatXML{$Key}[$Index]{SelectedValues}[$SubIndex]{Content} = $Value;
                }

                # stettings for working with time elements
                for (qw(TimeStop TimeStart TimeRelativeUnit TimeRelativeCount TimeScaleCount)) {
                    if ( $Ref->{$_} ) {
                        $StatXML{$Key}[$Index]{$_} = $Ref->{$_};
                    }
                }
            }
        }
        elsif ( ref( $StatOld->{$Key} ) eq 'ARRAY' ) {
            for my $Index ( 0 .. $#{ $StatOld->{$Key} } ) {
                $StatXML{$Key}[$Index]{Content} = $StatOld->{$Key}[$Index];
            }
        }
        else {
            if ( defined( $StatOld->{$Key} ) ) {
                $StatXML{$Key}[1]{Content} = $StatOld->{$Key};
            }
        }
    }

    # meta tags
    my $TimeStamp = $Self->{TimeObject}
        ->SystemTime2TimeStamp( SystemTime => $Self->{TimeObject}->SystemTime(), );
    $StatXML{Changed}[1]{Content}   = $TimeStamp;
    $StatXML{ChangedBy}[1]{Content} = $Self->{UserID};

    # please don't change the functionality of XMLHashDelete and XMLHashAdd
    # into the new function XMLHashUpdate, there is an incompatiblty.
    # Perhaps these are intricacies because of the 'Array[0] = undef' definition

    # delete
    if (!$Self->{XMLObject}->XMLHashDelete(
            Type => 'Stats',
            Key  => $Param{StatID},
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StatsUpddate: Can't delete XMLHash!"
        );
        return 0;
    }

    # delete cache
    $Self->_DeleteCache( StatID => $Param{StatID} );

    my @Array = ();
    $Array[0]{otrs_stats}[0] = \%StatXML;

    # add
    if ($Self->{XMLObject}->XMLHashAdd(
            Type    => 'Stats',
            Key     => $Param{StatID},
            XMLHash => \@Array
        )
        )
    {
        return 1;
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => "StatsUpddate: Can't add XMLHash!" );

    return 0;
}

=item StatsDelete()

delete a stat

    $StatsObject->StatsDelete(StatID => '123');

=cut

sub StatsDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "StatsDelete: Need StatID!" );
    }

    if ($Self->{XMLObject}->XMLHashDelete(
            Type => 'Stats',
            Key  => $Param{StatID},
        )
        )
    {

        # delete cache
        $Self->_DeleteCache( StatID => $Param{StatID} );
        return 1;
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => "StatsDelete: Can't delete XMLHash!" );
    return 0;
}

=item GetStatsList()

list all id's from stats

    my $ArrayRef = $StatsObject->GetStatsList(
        OrderBy => 'ID' || 'Title' || 'Object', # optional
        Direction => 'ASC' || 'DESC',             # optional
    );

=cut

sub GetStatsList {
    my ( $Self, %Param ) = @_;

    my @SearchResult = ();
    if ( !( @SearchResult = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats' ) ) ) {
        $Self->_AutomaticSampleImport();
        if ( !( @SearchResult = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats' ) ) ) {
            return ();
        }
    }

    # get user groups
    my @Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'ro',
        Result => 'ID',
    );
    if ( !$Param{OrderBy} ) {
        $Param{OrderBy} = 'ID';
    }

    # a solution with more performance is useful
    my %ResultHash = ();
    for my $StatID (@SearchResult) {
        my $Stat = $Self->StatsGet(
            StatID             => $StatID,
            NoObjectAttributes => 1,
        );
        my $UserPermission = 0;
        if ( $Self->{AccessRw} || $Self->{UserID} == 1 ) {
            $UserPermission = 1;
        }
        # these function is simular like other function in the code perhaps we should
        # merge them
        # permission check
        elsif ( $Stat->{Valid} ) {
            MARKE:
            for my $GroupID ( @{ $Stat->{Permission} } ) {
                for my $UserGroup (@Groups) {
                    if ( $GroupID == $UserGroup ) {
                        $UserPermission = 1;
                        last MARKE;
                    }
                }
            }
        }
        if ( $UserPermission == 1 ) {

            # order by title
            if ( $Param{OrderBy} eq 'Title' ) {
                $ResultHash{$StatID} = $Stat->{Title} || '';
            }

            # order by object
            elsif ( $Param{OrderBy} eq 'Object' ) {
                $ResultHash{$StatID} = $Stat->{Object} || '';
            }

            # order by id
            else {
                $ResultHash{$StatID} = int($StatID);
            }
        }
    }
    my @SortArray = ();
    if ( $Param{OrderBy} eq 'ID' ) {
        @SortArray = sort { $ResultHash{$a} <=> $ResultHash{$b} } keys %ResultHash;
    }
    else {
        @SortArray = sort { $ResultHash{$a} cmp $ResultHash{$b} } keys %ResultHash;
    }
    if ( $Param{Direction} && $Param{Direction} eq 'DESC' ) {
        @SortArray = reverse(@SortArray);
    }

    return \@SortArray;
}

=item SumBuild()

build sum in x or/and y axis

    $StatArray = $StatsObject->SumBuild(
        Array => \@Result,
        SumRow => 1,
        SumCol => 0,
    );

=cut

sub SumBuild {
    my ( $Self, %Param ) = @_;

    my @Data = @{ $Param{Array} };

    # add sum y
    if ( $Param{SumRow} ) {
        push( @{ $Data[1] }, 'Sum' );
        for my $Index1 ( 2 .. $#Data ) {
            my $Sum = 0;
            for my $Index2 ( 1 .. $#{ $Data[$Index1] } ) {
                if ( $Data[$Index1][$Index2] =~ m{^[0-9]{1,7}$}x ) {
                    $Sum += $Data[$Index1][$Index2];
                }
            }
            push( @{ $Data[$Index1] }, $Sum );
        }
    }

    # add sum x
    if ( $Param{SumCol} ) {
        my @SumRow = ();
        $SumRow[0] = 'Sum';
        for my $Index1 ( 2 .. $#Data ) {
            for my $Index2 ( 1 .. $#{ $Data[$Index1] } ) {
                if ( $Data[$Index1][$Index2] =~ m{^[0-9]{1,7}$}x ) {
                    $SumRow[$Index2] += $Data[$Index1][$Index2];
                }
            }
        }
        push( @Data, \@SumRow );
    }
    return \@Data;
}

=item GenerateDynamicStats()

    take the stat configuration and get the stat table

    my @StatArray = $StatsObject->GenerateDynamicStats(
        ObjectModule     => 'Kernel::System::Stats::Dynamic::Ticket',
        Object           => 'Ticket',
        UseAsXvalue      => \UseAsXvalueElements,
        UseAsValueSeries => \UseAsValueSeriesElements,
        UseAsRestriction => \UseAsRestrictionElements,
        Title            => 'TicketStat',
        StatID           => 123,
        Cache            => 1,      # optional
    );

=cut

# search for a better way to cache stats (see lines before StatID and Cache)

sub GenerateDynamicStats {
    my ( $Self, %Param ) = @_;

    my @StatArray      = ();
    my @HeaderLine     = ();
    my $TitleTimeStart = '';
    my $TitleTimeStop  = '';
    for (qw(ObjectModule UseAsXvalue UseAsValueSeries Title Object StatID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}
                ->Log( Priority => 'error', Message => "GenerateDynamicStats: Need $_!" );
            return;
        }
    }

    # include the needed dynamic object
    my $ObjectModule = $Param{ObjectModule};
    $Self->{MainObject}->Require($ObjectModule);
    my $StatObject = $ObjectModule->new( %{$Self} );

    # get the selected values
    # perhaps i can split the StatGet function to make this needless
    # Problem, i need the block informations
    my %NewParam = ();

    $NewParam{Title}        = $Param{Title};
    $NewParam{Object}       = $Param{Object};
    $NewParam{ObjectModule} = $Param{ObjectModule};

    # search for a better way to cache stats (StatID and Cache)
    $NewParam{StatID} = $Param{StatID};
    $NewParam{Cache}  = $Param{Cache};
    for my $Use (qw(UseAsRestriction UseAsXvalue UseAsValueSeries)) {
        my @Array = @{ $Param{$Use} };
        ELEMENT:
        for my $Element (@Array) {
            next ELEMENT if !$Element->{Selected};

            delete( $Element->{Selected} );
            delete( $Element->{Fixed} );
            if ( $Element->{Block} eq 'Time' ) {
                delete( $Element->{TimePeriodFormat} );
                if ( $Element->{TimeRelativeUnit} ) {
                    my ( $s, $m, $h, $D, $M, $Y )
                        = $Self->{TimeObject}
                        ->SystemTime2Date( SystemTime => $Self->{TimeObject}->SystemTime(), );
                    my $Count = 0;

                    if ( $Element->{TimeRelativeCount} ) {
                        $Count = $Element->{TimeRelativeCount};
                    }
                    else {
                        $Count = 1;
                    }

                    # -1 because the current time will be not counted
                    $Count = $Count - 1;

                    if ( $Element->{TimeRelativeUnit} eq 'Year' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, -1, 0, 0 );
                        $Element->{TimeStop}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, 12, 31, 23, 59, 59 );
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, -$Count, 0, 0 );
                        $Element->{TimeStart}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, 1, 1, 0, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Month' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, -1, 0 );
                        $Element->{TimeStop} = sprintf(
                            "%04d-%02d-%02d %02d:%02d:%02d",
                            $Y, $M, Days_in_Month( $Y, $M ),
                            23, 59, 59
                        );
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, -$Count, 0 );
                        $Element->{TimeStart}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, 1, 0, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Day' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, 0, -1 );
                        $Element->{TimeStop}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, 23, 59, 59 );
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, 0, -$Count );
                        $Element->{TimeStart}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, 0, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Hour' ) {
                        ( $Y, $M, $D, $h, $m, $s )
                            = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, -1, 0, 0 );
                        $Element->{TimeStop}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, 59, 59 );
                        ( $Y, $M, $D, $h, $m, $s )
                            = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, -$Count, 0, 0 );
                        $Element->{TimeStart}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Minute' ) {
                        ( $Y, $M, $D, $h, $m, $s )
                            = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, -1, 0 );
                        $Element->{TimeStop}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, 59 );
                        ( $Y, $M, $D, $h, $m, $s )
                            = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, -$Count, 0 );
                        $Element->{TimeStart}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $h, $m, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Second' ) {
                        ( $Y, $M, $D, $h, $m, $s )
                            = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, 0, -1 );
                        $Element->{TimeStop}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, $s );
                        ( $Y, $M, $D, $h, $m, $s )
                            = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, 0, -$Count );
                        $Element->{TimeStart}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, $s );
                    }
                    delete( $Element->{TimeRelativeUnit} );
                    delete( $Element->{TimeRelativeCount} );
                }
                $TitleTimeStart = $Element->{TimeStart};
                $TitleTimeStop  = $Element->{TimeStop};
            }

            # Select All function needed from mkStats.pl and fixed values of the frontend
            elsif ( !$Element->{SelectedValues}[0] ) {
                my @Values = keys( %{ $Element->{Values} } );
                $Element->{SelectedValues} = \@Values;
            }
            push @{ $NewParam{$Use} }, $Element;
        }
    }

    %Param = %NewParam;

    # get all restrictions for the search
    my %RestrictionAttribute = ();
    for my $RestrictionPart ( @{ $Param{UseAsRestriction} } ) {
        if ( $RestrictionPart->{Block} eq 'InputField' ) {
            $RestrictionAttribute{ $RestrictionPart->{Element} }
                = "%" . $RestrictionPart->{SelectedValues}[0] . "%";
        }
        elsif ( $RestrictionPart->{Block} eq 'SelectField' ) {
            $RestrictionAttribute{ $RestrictionPart->{Element} }
                = $RestrictionPart->{SelectedValues}[0];
        }
        elsif ( $RestrictionPart->{Block} eq 'Time' ) {
            $RestrictionAttribute{ $RestrictionPart->{Values}{TimeStop} }
                = $RestrictionPart->{TimeStop};
            $RestrictionAttribute{ $RestrictionPart->{Values}{TimeStart} }
                = $RestrictionPart->{TimeStart};
        }
        else {
            $RestrictionAttribute{ $RestrictionPart->{Element} }
                = $RestrictionPart->{SelectedValues};
        }
    }

    # get the selected Xvalue
    my $Xvalue = {};
    my ($VSYear,     $VSMonth,     $VSDay,     $VSHour,     $VSMinute,     $VSSecond,
        $VSStopYear, $VSStopMonth, $VSStopDay, $VSStopHour, $VSStopMinute, $VSStopSecond
    );
    my $TimeAbsolutStopUnixTime = 0;
    my $Count                   = 0;
    my $MonthArrayRef           = _MonthArray();

    my $Element = $Param{UseAsXvalue}[0];
    if ( $Element->{Block} eq 'Time' ) {
        my ($Year,   $Month,   $Day,   $Hour,   $Minute,   $Second,
            $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond
        );
        if ( $Element->{'TimeStart'} =~ m{^(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)$}ix ) {
            $Year   = $VSYear   = $1;
            $Month  = $VSMonth  = int($2);
            $Day    = $VSDay    = int($3);
            $Hour   = $VSHour   = int($4);
            $Minute = $VSMinute = int($5);
            $Second = $VSSecond = int($6);
        }

        $TimeAbsolutStopUnixTime
            = $Self->{TimeObject}->TimeStamp2SystemTime( String => $Element->{'TimeStop'} );
        my $TimeStart = 0;
        my $TimeStop  = 0;

        $Count = $Element->{TimeScaleCount} ? $Element->{TimeScaleCount} : 1;

        # in these constellation $Count > 1 is not useful!!
        if (   $Param{UseAsValueSeries}[0]{Block}
            && $Param{UseAsValueSeries}[0]{Block} eq 'Time'
            && $Element->{SelectedValues}[0]      eq 'Day' )
        {
            $Count = 1;
        }

        if ( $Element->{SelectedValues}[0] eq 'Minute' ) {
            $Second = 0;
        }
        elsif ( $Element->{SelectedValues}[0] eq 'Hour' ) {
            $Second = 0;
            $Minute = 0;
        }
        elsif ( $Element->{SelectedValues}[0] eq 'Day' ) {
            $Second = 0;
            $Minute = 0;
            $Hour   = 0;
        }
        elsif ( $Element->{SelectedValues}[0] eq 'Month' ) {
            $Second = 0;
            $Minute = 0;
            $Hour   = 0;
            $Day    = 1;
        }
        elsif ( $Element->{SelectedValues}[0] eq 'Year' ) {
            $Second = 0;
            $Minute = 0;
            $Hour   = 0;
            $Day    = 1;
            $Month  = 1;
        }

        while ( !$TimeStop
            || $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
            < $TimeAbsolutStopUnixTime )
        {
            $TimeStart = sprintf( "%04d-%02d-%02d %02d:%02d:%02d",
                $Year, $Month, $Day, $Hour, $Minute, $Second );
            if ( $Element->{SelectedValues}[0] eq 'Second' ) {
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $Year, $Month, $Day, $Hour, $Minute, $Second, 0, 0, 0,
                    $Count - 1 );
                push(
                    @HeaderLine,
                    sprintf(
                        "%02d:%02d:%02d-%02d:%02d:%02d",
                        $Hour, $Minute, $Second, $ToHour, $ToMinute, $ToSecond
                    )
                );
            }
            elsif ( $Element->{SelectedValues}[0] eq 'Minute' ) {
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $Year, $Month, $Day, $Hour, $Minute, $Second, 0, 0, $Count,
                    -1 );
                push(
                    @HeaderLine,
                    sprintf(
                        "%02d:%02d:%02d-%02d:%02d:%02d",
                        $Hour, $Minute, $Second, $ToHour, $ToMinute, $ToSecond
                    )
                );
            }
            elsif ( $Element->{SelectedValues}[0] eq 'Hour' ) {
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $Year, $Month, $Day, $Hour, $Minute, $Second, 0, $Count, 0,
                    -1 );
                push(
                    @HeaderLine,
                    sprintf(
                        "%02d:%02d:%02d-%02d:%02d:%02d",
                        $Hour, $Minute, $Second, $ToHour, $ToMinute, $ToSecond
                    )
                );
            }
            elsif ( $Element->{SelectedValues}[0] eq 'Day' ) {
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $Year, $Month, $Day, $Hour, $Minute, $Second, $Count, 0, 0,
                    -1 );
                my $Dow = Day_of_Week( $Year, $Month, $Day );
                $Dow = Day_of_Week_Abbreviation($Dow);
                if ( $ToDay eq $Day ) {
                    push( @HeaderLine, "$Dow $Day" );
                }
                else {
                    push(
                        @HeaderLine,
                        sprintf(
                            "%02d.%02d.%04d - %02d.%02d.%04d",
                            $Day, $Month, $Year, $ToDay, $ToMonth, $ToYear
                        )
                    );
                }
            }
            elsif ( $Element->{SelectedValues}[0] eq 'Month' ) {
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_YMD( $Year, $Month, $Day, 0, $Count, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $Hour, $Minute, $Second, 0, 0, 0,
                    -1 );
                if ( $ToMonth eq $Month ) {
                    push( @HeaderLine, "$MonthArrayRef->[$Month] $Month" );
                }
                else {
                    push(
                        @HeaderLine,
                        sprintf(
                            "%02d.%02d.%04d - %02d.%02d.%04d",
                            $Day, $Month, $Year, $ToDay, $ToMonth, $ToYear
                        )
                    );
                }
            }
            elsif ( $Element->{SelectedValues}[0] eq 'Year' ) {
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_YMD( $Year, $Month, $Day, $Count, 0, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $Hour, $Minute, $Second, 0, 0, 0,
                    -1 );
                if ( $ToYear eq $Year ) {
                    push( @HeaderLine, "$Year" );
                }
                else {
                    push(
                        @HeaderLine,
                        sprintf(
                            "%02d.%02d.%04d - %02d.%02d.%04d",
                            $Day, $Month, $Year, $ToDay, $ToMonth, $ToYear
                        )
                    );
                }
            }
            ( $Year, $Month, $Day, $Hour, $Minute, $Second )
                = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0, 0, 0,
                1 );
            $TimeStop = sprintf( "%04d-%02d-%02d %02d:%02d:%02d",
                $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond );
            push(
                @{ $Xvalue->{SelectedValues} },
                { TimeStart => $TimeStart, TimeStop => $TimeStop }
            );
        }
        $Xvalue->{Block}  = 'Time';
        $Xvalue->{Values} = $Element->{Values};
    }

    # if Block equal MultiSelectField, Selectfield
    else {
        $Xvalue = $Element;

        # build the headerline
        for my $Valuename ( @{ $Xvalue->{SelectedValues} } ) {
            push @HeaderLine, $Xvalue->{Values}{$Valuename};
        }
    }

    # get the value series
    my %ValueSeries   = ();
    my @ArraySelected = ();
    my $ColumnName    = '';

    # give me all possilbe elements for Value Series
    REF1:
    for my $Ref1 ( @{ $Param{UseAsValueSeries} } ) {

        # all elements which are shown with multiselectfields
        if ( $Ref1->{Block} ne 'Time' ) {
            my %SelectedValues = ();
            for my $Ref2 ( @{ $Ref1->{SelectedValues} } ) {
                $SelectedValues{$Ref2} = $Ref1->{Values}{$Ref2};
            }
            push(
                @ArraySelected,
                {   Values  => \%SelectedValues,
                    Element => $Ref1->{Element},
                    Name    => $Ref1->{Name},
                    Block   => $Ref1->{Block},
                }
            );
            next REF1;
        }

        # timescale elements need a special handling
        @HeaderLine = ();

        # these all makes only sense, if the count of xaxis is 1
        if ( $Ref1->{SelectedValues}[0] eq 'Year' ) {
            if ( $Count == 1 ) {
                for ( 1 .. 12 ) {
                    push( @HeaderLine, "$MonthArrayRef->[$_] $_" );
                }
            }
            else {
                for ( my $Month = 1; $Month < 12; $Month = $Month + $Count ) {
                    push( @HeaderLine,
                        "$MonthArrayRef->[$Month] - $MonthArrayRef->[$Month + $Count - 1]" );
                }
            }
            $VSSecond   = 0;
            $VSMinute   = 0;
            $VSHour     = 0;
            $VSDay      = 1;
            $VSMonth    = 1;
            $ColumnName = 'Year';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Month' ) {

            #if ( $Count == 1 ) {
            #    for ( 1 .. 31 ) {
            #        push @HeaderLine, $_;
            #    }
            #}
            #else {
            $Count = 1;
            for ( 1 .. 31 ) {
                push @HeaderLine, $_;
            }

            #}

            $VSSecond   = 0;
            $VSMinute   = 0;
            $VSHour     = 0;
            $VSDay      = 1;
            $ColumnName = 'Month';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Day' ) {
            for ( my $Hour = 0; $Hour < 24; $Hour = $Hour + $Count ) {
                push( @HeaderLine, sprintf( "%02d:00:00-%02d:59:59", $Hour, $Hour + $Count - 1 ) );
            }
            $VSSecond   = 0;
            $VSMinute   = 0;
            $VSHour     = 0;
            $ColumnName = 'Day';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Hour' ) {
            for ( my $Minute = 0; $Minute < 60; $Minute = $Minute + $Count ) {
                my $Time = 'min ' . $Minute . ' - ' . ( $Minute + $Count );
                push( @HeaderLine, $Time );
            }
            $VSSecond   = 0;
            $VSMinute   = 0;
            $ColumnName = 'Hour';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Minute' ) {
            if ( $Count == 1 ) {
                for ( 0 .. 59 ) {
                    my $Time = 'sec ' . $_;
                    push( @HeaderLine, $Time );
                }
            }
            else {
                for ( my $Second = 0; $Second < 60; $Second = $Second + $Count ) {
                    my $Time = 'sec ' . $Second . '-' . ( $Second + $Count );
                    push( @HeaderLine, $Time );
                }
            }
            $VSSecond   = 0;
            $ColumnName = 'Minute';
        }

        my $TimeStart     = 0;
        my $TimeStop      = 0;
        my $MonthArrayRef = _MonthArray();

        $Count = 1;

        # Generate the time value series
        my ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond );

        if ( $Ref1->{SelectedValues}[0] eq 'Year' ) {
            while ( $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime )
            {
                $TimeStart = sprintf( "%04d-01-01 00:00:00", $VSYear );
                ( $ToYear, $ToMonth, $ToDay )
                    = Add_Delta_YMD( $VSYear, $VSMonth, $VSDay, $Count, 0, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, 0, -1 );
                $TimeStop = sprintf( "%04d-12-31 23:59:59", $ToYear );

                $ValueSeries{$VSYear} = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1 );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Month' ) {
            while ( $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime )
            {
                $TimeStart = sprintf( "%04d-%02d-01 00:00:00", $VSYear, $VSMonth );
                ( $ToYear, $ToMonth, $ToDay )
                    = Add_Delta_YMD( $VSYear, $VSMonth, $VSDay, 0, $Count, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, 0, -1 );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                #                    if ($Count == 1) {
                $ValueSeries{ $VSYear . '-'
                        . sprintf( "%02d", $VSMonth ) . ' '
                        . $MonthArrayRef->[$VSMonth] } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                        };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1 );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Day' ) {
            while ( $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime )
            {
                $TimeStart = sprintf( "%04d-%02d-%02d 00:00:00", $VSYear, $VSMonth, $VSDay );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond,
                    $Count, 0, 0, -1 );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                #                    if ($Count == 1) {
                $ValueSeries{ sprintf( "%04d-%02d-%02d", $VSYear, $VSMonth, $VSDay ) } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1 );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Hour' ) {
            while ( $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime )
            {
                $TimeStart
                    = sprintf( "%04d-%02d-%02d %02d:00:00", $VSYear, $VSMonth, $VSDay, $VSHour );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond, 0,
                    $Count, 0, -1 );
                $TimeStop
                    = sprintf( "%04d-%02d-%02d %02d:59:59", $ToYear, $ToMonth, $ToDay, $ToHour );
                $ValueSeries{
                    sprintf( "%04d-%02d-%02d %02d:00:00 - %02d:59:59",
                        $VSYear, $VSMonth, $VSDay, $VSHour, $ToHour )
                    }
                    = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };
                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1 );
            }
        }

        elsif ( $Ref1->{SelectedValues}[0] eq 'Minute' ) {
            while ( $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime )
            {
                $TimeStart = sprintf( "%04d-%02d-%02d %02d:%02d:00",
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, $Count, -1 );
                $TimeStop = sprintf( "%04d-%02d-%02d %02d:%02d:59",
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute );
                $ValueSeries{
                    sprintf( "%04d-%02d-%02d %02d:%02d:00 - %02d:%02d:59",
                        $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $ToHour, $ToMinute )
                    }
                    = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };
                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1 );
            }

        }
    }

    # merge the array if two elements for the valueseries are avialable
    KEY:
    for my $Key ( keys %{ $ArraySelected[0]{Values} } ) {
        my $Value0;
        if ( $ArraySelected[0]{Block} eq 'SelectField' ) {
            $Value0 = $Key;
        }
        elsif ( $ArraySelected[0]{Block} eq 'MultiSelectField' ) {
            $Value0 = [$Key];
        }

        if ( !$ArraySelected[1] ) {
            $ValueSeries{ $ArraySelected[0]{Values}{$Key} }
                = { $ArraySelected[0]{Element} => $Value0 };
            next KEY;
        }

        for my $SubKey ( keys %{ $ArraySelected[1]{Values} } ) {
            my $Value1;
            if ( $ArraySelected[1]{Block} eq 'SelectField' ) {
                $Value1 = $SubKey;
            }
            elsif ( $ArraySelected[1]{Block} eq 'MultiSelectField' ) {
                $Value1 = [$SubKey];
            }
            $ValueSeries{ $ArraySelected[0]{Values}{$Key} . ' - '
                    . $ArraySelected[1]{Values}{$SubKey} } = {
                $ArraySelected[0]{Element} => $Value0,
                $ArraySelected[1]{Element} => $Value1
                    };
        }
    }

    # Use this if no valueseries available
    if ( !%ValueSeries ) {
        $ValueSeries{ $Param{Object} . 's' } = undef;
    }

    # get the first column name in the headerline
    if ($ColumnName) {
        unshift( @HeaderLine, $ColumnName );
    }
    elsif ( $ArraySelected[1] ) {
        unshift( @HeaderLine, $ArraySelected[0]{Name} . ' - ' . $ArraySelected[1]{Name} );
    }
    elsif ( $ArraySelected[0] ) {
        unshift( @HeaderLine, $ArraySelected[0]{Name} || '' );
    }

    # push the first array elements in the StatsArray
    my $Title = $Param{Title};
    if ( $TitleTimeStart && $TitleTimeStop ) {
        $Title .= " $TitleTimeStart-$TitleTimeStop";
    }

    # search for a better way to cache stats (StatID and Cache)
    if ( $Param{Cache} ) {
        my $MD5Key    = $Self->{MainObject}->FilenameCleanUp(
            Filename => $TitleTimeStart . "-" . $TitleTimeStop,
            Type     => 'md5',
        );

        my @StatArray = $Self->_GetResultCache(
            Filename => 'Stats' . $Param{StatID} . '-' . $MD5Key . '.cache',
        );

        return @StatArray if @StatArray;
    }

    push @StatArray, [$Title];
    push @StatArray, \@HeaderLine;

    #Get the stat elements
    for my $Row ( sort keys %ValueSeries ) {    # get each row
        my @ResultRow      = ();
        my %SearchAttribut = ();

        # if is needed for stats without valueseries
        if ( $ValueSeries{$Row} ) {
            %SearchAttribut = %{ $ValueSeries{$Row} };
        }
        push( @ResultRow, $Row );
        for my $Cell ( @{ $Xvalue->{SelectedValues} } ) {    # get each cell
            if ( $Xvalue->{Block} eq 'Time' ) {
                if (   $ValueSeries{$Row}{ $Xvalue->{Values}{TimeStop} }
                    && $ValueSeries{$Row}{ $Xvalue->{Values}{TimeStart} } )
                {
                    if ($Self->{TimeObject}->TimeStamp2SystemTime( String => $Cell->{TimeStop} )
                        > $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $ValueSeries{$Row}{ $Xvalue->{Values}{TimeStop} }
                        )
                        || $Self->{TimeObject}->TimeStamp2SystemTime( String => $Cell->{TimeStart} )
                        < $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $ValueSeries{$Row}{ $Xvalue->{Values}{TimeStart} }
                        )
                        )
                    {
                        next;
                    }
                }
                $SearchAttribut{ $Xvalue->{Values}{TimeStop} }  = $Cell->{TimeStop};
                $SearchAttribut{ $Xvalue->{Values}{TimeStart} } = $Cell->{TimeStart};
            }
            elsif ( $Xvalue->{Block} eq 'SelectField' ) {
                $SearchAttribut{ $Xvalue->{Element} } = $Cell;
            }
            else {
                $SearchAttribut{ $Xvalue->{Element} } = [$Cell];
            }
            my $Quantity = $StatObject->GetStatElement( %SearchAttribut, %RestrictionAttribute );
            push @ResultRow, $Quantity;
        }
        push @StatArray, \@ResultRow;
    }

    # fill up empty array elements, e.g month as value series (February has 28 day and Januar 31)
    for my $Index1 ( 2 .. $#StatArray ) {
        for my $Index2 ( 1 .. $#{ $StatArray[1] } ) {
            if ( !defined( $StatArray[$Index1][$Index2] ) ) {
                $StatArray[$Index1][$Index2] = '';
            }
        }
    }

    # search for a better way to cache stats (StatID and Cache)
    if ( $Param{Cache} ) {

        # check if we should cache this result
        # get the current time
        if ( $TitleTimeStart && $TitleTimeStop ) {
            if ( $Self->{TimeObject}->TimeStamp2SystemTime( String => $TitleTimeStop )
                < $Self->{TimeObject}->SystemTime() )
            {
                my $MD5Key = $Self->{MainObject}->FilenameCleanUp(
                    Filename => $TitleTimeStart . "-" . $TitleTimeStop,
                    Type     => 'md5',
                );

                # write the stats cache
                $Self->_SetResultCache(
                    Filename => 'Stats' . $Param{StatID} . '-' . $MD5Key . '.cache',
                    Result   => \@StatArray,
                );
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Can't cache StatID $Param{StatID}: The selected end time is in the future!",
                );
            }
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Can't cache: StatID $Param{StatID} have no time period, so you can't cache the stat!",
            );
        }
    }
    return @StatArray;
}

=item GenerateGraph()

make graph from result array

    my $Graph = $StatsObject->GenerateGraph(
        Array => \@StatArray,
        GraphSize => \%GraphConfig,
        HeadArrayRef => $HeadArrayRef,
        Title => 'All Tickets of the month',
        Format => 'graph-lines',
    );

=cut

sub GenerateGraph {
    my ( $Self, %Param ) = @_;

    # check if need params are available
    for (qw(Array GraphSize HeadArrayRef Title Format)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "GenerateGraph: Need $_!" );
            return;
        }
    }

    my @StatArray    = @{ $Param{Array} };
    my $HeadArrayRef = $Param{HeadArrayRef};
    my $GDBackend    = $Param{Format};

    # delete SumCol and SumRow if present
    if ( $StatArray[-1][0] eq 'Sum' ) {
        pop @StatArray;
    }
    if ( $HeadArrayRef->[-1] eq 'Sum' ) {
        pop( @{$HeadArrayRef} );
        for my $Row (@StatArray) {
            pop @{$Row};
        }
    }

    # load gd modules
    for my $Module ( 'GD', 'GD::Graph', $GDBackend ) {
        if ( !$Self->{MainObject}->Require($Module) ) {
            $Self->{LogObject}
                ->Log( Priority => 'error', Message => "GenerateGraph: Need $Module!" );
            return;
        }
    }

    # remove first y/x position
    my $XLable = shift( @{$HeadArrayRef} );

    # get first col for legend
    my @YLine = ();
    for my $Tmp (@StatArray) {
        push( @YLine, $Tmp->[0] );
        shift( @{$Tmp} );
    }

    # build plot data
    my @PData = ( $HeadArrayRef, @StatArray );
    my ( $XSize, $YSize ) = split( m{x}x, $Param{GraphSize} );
    my $graph = $GDBackend->new( $XSize || 550, $YSize || 350 );
    $graph->set(
        x_label => $XLable,

        #        y_label => 'YLable',
        title => $Param{Title},

        #        y_max_value => 20,
        #        y_tick_number => 16,
        #        y_label_skip => 4,
        #        x_tick_number => 8,
        t_margin    => $Self->{ConfigObject}->Get("Stats::Graph::t_margin")    || 10,
        b_margin    => $Self->{ConfigObject}->Get("Stats::Graph::b_margin")    || 10,
        l_margin    => $Self->{ConfigObject}->Get("Stats::Graph::l_margin")    || 10,
        r_margin    => $Self->{ConfigObject}->Get("Stats::Graph::r_margin")    || 20,
        bgclr       => $Self->{ConfigObject}->Get("Stats::Graph::bgclr")       || 'white',
        transparent => $Self->{ConfigObject}->Get("Stats::Graph::transparent") || 0,
        interlaced  => 1,
        fgclr       => $Self->{ConfigObject}->Get("Stats::Graph::fgclr")       || 'black',
        boxclr      => $Self->{ConfigObject}->Get("Stats::Graph::boxclr")      || 'white',
        accentclr   => $Self->{ConfigObject}->Get("Stats::Graph::accentclr")   || 'black',
        shadowclr   => $Self->{ConfigObject}->Get("Stats::Graph::shadowclr")   || 'black',
        legendclr   => $Self->{ConfigObject}->Get("Stats::Graph::legendclr")   || 'black',
        textclr     => $Self->{ConfigObject}->Get("Stats::Graph::textclr")     || 'black',
        dclrs       => $Self->{ConfigObject}->Get("Stats::Graph::dclrs")
            || [
            qw(red green blue yellow black purple orange pink marine cyan lgray lblue lyellow lgreen lred lpurple lorange lbrown)
            ],
        x_tick_offset       => 0,
        x_label_position    => 1 / 2,
        y_label_position    => 1 / 2,
        x_labels_vertical   => 31,
        line_width          => $Self->{ConfigObject}->Get("Stats::Graph::line_width") || 1,
        legend_placement    => $Self->{ConfigObject}->Get("Stats::Graph::legend_placement") || 'BC',
        legend_spacing      => $Self->{ConfigObject}->Get("Stats::Graph::legend_spacing") || 4,
        legend_marker_width => $Self->{ConfigObject}->Get("Stats::Graph::legend_marker_width")
            || 12,
        legend_marker_height => $Self->{ConfigObject}->Get("Stats::Graph::legend_marker_height")
            || 8,
    );

    # set legend (y-line)
    if ( $Param{Format} ne 'GD::Graph::pie' ) {
        $graph->set_legend(@YLine);
    }

    # plot graph
    my $Ext = '';
    if ( !$graph->can('png') ) {
        $Ext = 'png';
    }
    else {
        $Ext = $graph->export_format;
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Can't write png! Write: $Ext",
        );
    }
    my $Content = eval { $graph->plot( \@PData )->$Ext() };
    return $Content;
}

=item CompletenessCheck()

    my @Notify = $StatsObject->CompletenessCheck(
        StatData => \%StatData,
        Section => 'All' || 'Specification' || 'ValueSeries' || 'Restrictions || Xaxis'
    );

=cut

sub CompletenessCheck {
    my ( $Self, %Param ) = @_;

    my @Notify         = ();
    my @NotifySelected = ();
    my @IndexArray     = ();

    $Notify[0] = {
        Info     => 'Please fill out the required fields!',
        Priority => 'Error'
    };
    $Notify[1] = {
        Info     => 'Please select a file!',
        Priority => 'Error'
    };
    $Notify[2] = {
        Info     => 'Please select an object!',
        Priority => 'Error'
    };
    $Notify[3] = {
        Info     => 'Please select a graph size!',
        Priority => 'Error'
    };
    $Notify[4] = {
        Info     => 'Please select one element for the X-axis!',
        Priority => 'Error'
    };
    $Notify[5] = {
        Info     => 'You have to select two or more attributes from the select field!',
        Priority => 'Error'
    };
    $Notify[6] = {
        Info =>
            'Please select only one element or turn of the button \'Fixed\' where the select field is marked!',
        Priority => 'Error'
    };
    $Notify[7] = {
        Info     => 'If you use a checkbox you have to select some attributes of the select field!',
        Priority => 'Error'
    };
    $Notify[8] = {
        Info =>
            'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!',
        Priority => 'Error'
    };
    $Notify[9] = {
        Info     => 'The selected end time is before the start time!',
        Priority => 'Error'
    };
    $Notify[10] = {
        Info     => 'You have to select one or more attributes from the select field!',
        Priority => 'Error'
    };
    $Notify[11] = {
        Info     => 'The selected Date isn\'t valid!',
        Priority => 'Error'
    };
    $Notify[12] = {
        Info     => 'Please select only one or two elements via the checkbox!',
        Priority => 'Error'
    };
    $Notify[13] = {
        Info     => 'If you use a time scale element you can only select one element!',
        Priority => 'Error'
    };
    $Notify[14] = {
        Info     => 'You have an error in your time selection!',
        Priority => 'Error'
    };
    $Notify[15] = {
        Info     => 'Your reporting time interval is to small, please use a larger time scale!',
        Priority => 'Error'
    };

    # check if need params are available
    for (qw(StatData Section)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}
                ->Log( Priority => 'error', Message => "GenerateDynamicStats: Need $_!" );
            return;
        }
    }

    my %StatData = %{ $Param{StatData} };
    if ( $Param{Section} eq 'Specification' || $Param{Section} eq 'All' ) {
        for (qw(Title Description StatType Permission Format ObjectModule)) {
            if ( !$StatData{$_} ) {
                push( @IndexArray, 0 );
                last;
            }
        }
        if ( $StatData{StatType} && $StatData{StatType} eq 'static' && !$StatData{File} ) {
            push( @IndexArray, 1 );
        }
        if ( $StatData{StatType} && $StatData{StatType} eq 'dynamic' && !$StatData{Object} ) {
            push( @IndexArray, 2 );
        }
        if ( !$Param{StatData}{GraphSize} && $Param{StatData}{Format} ) {
            for ( @{ $StatData{Format} } ) {
                if ( $_ =~ m{^GD::Graph\.*}x ) {
                    push @IndexArray, 3;
                    last;
                }
            }
        }
    }

    # for form calls
    if ( $StatData{StatType} && $StatData{StatType} eq 'dynamic' ) {
        if ( ( $Param{Section} eq 'Xaxis' || $Param{Section} eq 'All' )
            && $StatData{StatType} eq 'dynamic' )
        {
            my $Flag = 0;
            XVALUE:
            for my $Xvalue ( @{ $StatData{UseAsXvalue} } ) {
                next XVALUE if !$Xvalue->{Selected};

                if (   $Xvalue->{Block} ne 'Time'
                    && $#{ $Xvalue->{SelectedValues} } < 1
                    && $Xvalue->{SelectedValues}[0] )
                {
                    push @IndexArray, 5;
                }
                if ( $Xvalue->{Block} eq 'Time' ) {
                    if ( $Xvalue->{TimeStart} && $Xvalue->{TimeStop} ) {
                        my $TimeStart = $Self->{TimeObject}
                            ->TimeStamp2SystemTime( String => $Xvalue->{TimeStart} );
                        my $TimeStop = $Self->{TimeObject}
                            ->TimeStamp2SystemTime( String => $Xvalue->{TimeStop} );
                        if ( !$TimeStart || !$TimeStop ) {
                            push @IndexArray, 11;
                            last XVALUE;
                        }
                        elsif ( $TimeStart > $TimeStop ) {
                            push @IndexArray, 9;
                            last XVALUE;
                        }
                    }
                    elsif ( !$Xvalue->{TimeRelativeUnit} || !$Xvalue->{TimeRelativeCount} ) {
                        push( @IndexArray, 9 );
                        last XVALUE;
                    }

                    if ( !$Xvalue->{SelectedValues}[0] ) {
                        push @IndexArray, 10 ;
                    }
                    elsif ( $Xvalue->{Fixed} && $#{ $Xvalue->{SelectedValues} } > 0 ) {
                        push @IndexArray, 6 ;
                    }
                }
                $Flag = 1;
                last XVALUE;
            }
            if ( !$Flag ) {
                push @IndexArray, 4;
            }
        }
        if ( ( $Param{Section} eq 'ValueSeries' || $Param{Section} eq 'All' )
            && $StatData{StatType} eq 'dynamic' )
        {
            my $Counter = 0;
            my $Flag    = 0;
            VALUESERIES:
            for my $ValueSeries ( @{ $StatData{UseAsValueSeries} } ) {
                next VALUESERIES if !$ValueSeries->{Selected};

                if (   $ValueSeries->{Block} eq 'Time'
                    || $ValueSeries->{Block} eq 'TimeExtended' )
                {
                    if ( $ValueSeries->{Fixed} && $#{ $ValueSeries->{SelectedValues} } > 0 ) {
                        push @IndexArray, 6;
                    }
                    elsif ( !$ValueSeries->{SelectedValues}[0] ) {
                        push @IndexArray, 7;
                    }
                    $Flag = 1;
                }
                elsif ($ValueSeries->{SelectedValues}[0]
                    && $#{ $ValueSeries->{SelectedValues} } < 1 )
                {
                    push @IndexArray, 5;
                }
                $Counter++;
            }
            if ( $Counter > 1 && $Flag ) {
                push( @IndexArray, 13 );
            }
            elsif ( $Counter > 2 ) {
                push( @IndexArray, 12 );
            }
        }
        if ( ( $Param{Section} eq 'Restrictions' || $Param{Section} eq 'All' )
            && $StatData{StatType} eq 'dynamic' )
        {
            RESTRICTION:
            for my $Restriction ( @{ $StatData{UseAsRestriction} } ) {
                next RESTRICTION if !$Restriction->{Selected};

                if ( $Restriction->{Block} eq 'SelectField' ) {
                    if ( $Restriction->{Fixed} && $#{ $Restriction->{SelectedValues} } > 0 ) {
                        push( @IndexArray, 6 );
                        last RESTRICTION;
                    }
                    elsif ( !$Restriction->{SelectedValues}[0] ) {
                        push( @IndexArray, 7 );
                        last RESTRICTION;
                    }
                }
                elsif ($Restriction->{Block} eq 'InputField'
                    && !$Restriction->{SelectedValues}[0]
                    && $Restriction->{Fixed} )
                {
                    push( @IndexArray, 8 );
                    last RESTRICTION;
                }
                elsif ($Restriction->{Block} eq 'Time'
                    || $Restriction->{Block} eq 'TimeExtended' )
                {
                    if ( $Restriction->{TimeStart} && $Restriction->{TimeStop} ) {
                        my $TimeStart = $Self->{TimeObject}
                            ->TimeStamp2SystemTime( String => $Restriction->{TimeStart} );
                        my $TimeStop = $Self->{TimeObject}
                            ->TimeStamp2SystemTime( String => $Restriction->{TimeStop} );
                        if ( !$TimeStart || !$TimeStop ) {
                            push @IndexArray, 11;
                            last RESTRICTION;
                        }
                        elsif ( $TimeStart > $TimeStop ) {
                            push @IndexArray, 9;
                            last RESTRICTION;
                        }
                    }
                    elsif (!$Restriction->{TimeRelativeUnit}
                        || !$Restriction->{TimeRelativeCount} )
                    {
                        push @IndexArray, 9;
                        last RESTRICTION;
                    }
                }
            }
        }

        # check if the timeperiod is to big or the time scale to small
        # used only for fixed time values
        # remark time functions should be exportet in external functions (tr)
        if ( $Param{Section} eq 'All' && $StatData{StatType} eq 'dynamic' ) {
            my $Stat = $Self->StatsGet( StatID => $StatData{StatID} );

            XVALUE:
            for my $Xvalue ( @{ $Stat->{UseAsXvalue} } ) {
                next XVALUE
                    if !( $Xvalue->{Selected} && $Xvalue->{Fixed} && $Xvalue->{Block} eq 'Time' );

                my $Flag = 1;
                VALUESERIES:
                for my $ValueSeries ( @{ $Stat->{UseAsValueSeries} } ) {
                    if ( $ValueSeries->{Selected} && $ValueSeries->{Block} eq 'Time' ) {
                        $Flag = 0;
                        last VALUESERIES;
                    }
                }

                last XVALUE if !$Flag;

                my $ScalePeriod = 0;
                my $TimePeriod  = 0;
                my $Count       = 1;

                if ( $Xvalue->{TimeScaleCount} ) {
                    $Count = $Xvalue->{TimeScaleCount};
                }

                my %TimeInSeconds = (
                    Year   => 31536000,    # 60 * 60 * 60 * 365
                    Month  => 2592000,     # 60 * 60 * 24 * 30
                    Day    => 86400,       # 60 * 60 * 24
                    Hour   => 3600,        # 60 * 60
                    Minute => 60,
                    Second => 1,
                );

                $ScalePeriod = $TimeInSeconds{$Xvalue->{SelectedValues}[0]};

                if ( $Xvalue->{TimeStop} && $Xvalue->{TimeStart} ) {
                    $TimePeriod
                        = (
                        $Self->{TimeObject}->TimeStamp2SystemTime( String => $Xvalue->{TimeStop} ) )
                        - (
                        $Self->{TimeObject}->TimeStamp2SystemTime( String => $Xvalue->{TimeStart} )
                        );
                }
                else {
                    $TimePeriod = $TimeInSeconds{$Xvalue->{TimeRelativeUnit}} * $Xvalue->{TimeRelativeCount};
                }
                if ( $TimePeriod / ( $ScalePeriod * $Count )
                    > ( $Self->{ConfigObject}->Get('Stats::MaxXaxisAttributes') || 1000 ) )
                {
                    push @IndexArray, 15;
                }

                last XVALUE;
            }
        }
    }
    for (@IndexArray) {
        push( @NotifySelected, $Notify[$_] );
    }

    return @NotifySelected;

}

=item GetStatsObjectAttributes()

Get all attributes from the object in dependence of the use

    my %ObjectAttributes => $StatsObject->GetStatsObjectAttributes(
        ObjectModule => 'Ticket',
        Use          => 'UseAsXvalue' || 'UseAsValueSeries' || 'UseAsRestriction',
    );

=cut

sub GetStatsObjectAttributes {
    my ( $Self, %Param ) = @_;

    my @ObjectAttributes = ();

    # check needed params
    for (qw(ObjectModule Use)) {
        if ( !$Param{$_} ) {
            return $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "GetStatsObjectAttributes: Need $_!"
            );
        }
    }

    # load module
    my $ObjectModule = $Param{ObjectModule};
    $Self->{MainObject}->Require($ObjectModule);
    my $StatObject = $ObjectModule->new( %{$Self} );

    # load attributes
    my @ObjectAttributesRaw = $StatObject->GetObjectAttributes();

    # build the objectattribute array
    for my $HashRef (@ObjectAttributesRaw) {
        if ( $HashRef->{ $Param{Use} } ) {
            delete $HashRef->{UseAsXvalue};
            delete $HashRef->{UseAsValueSeries};
            delete $HashRef->{UseAsRestriction};

            push( @ObjectAttributes, $HashRef );
        }
    }
    return @ObjectAttributes;
}

=item GetStaticFiles()

Get all static files

    my $FileHash => $StatsObject->GetStaticFiles();

=cut

sub GetStaticFiles {
    my ( $Self, %Param ) = @_;

    my %Filelist = ();

    my $Directory = $Self->{ConfigObject}->Get('Home');
    if ( $Directory !~ m{^.*\/$}x ) {
        $Directory .= '/';
    }
    $Directory .= 'Kernel/System/Stats/Static/';

    if ( !opendir( DIR, $Directory ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can not open Directory: $Directory",
        );
        return ();
    }

    # get all Stats from the db
    my %StaticFiles = ();
    my $Result      = $Self->GetStatsList();

    if ( defined($Result) ) {
        for my $StatID ( @{$Result} ) {
            my $Data = $Self->StatsGet( StatID => $StatID );

            # check witch one are static statistics
            if ( $Data->{File} && $Data->{StatType} eq 'static' ) {
                $StaticFiles{ $Data->{File} } = 1;
            }
        }
    }

    # read files
    while ( defined( my $Filename = readdir DIR ) ) {
        next if $Filename eq '.';
        next if $Filename eq '..';
        if ( $Filename =~ m{^(.*)\.pm$}x ) {
            if ( !defined( $StaticFiles{$1} ) ) {
                $Filelist{$1} = $1;
            }
        }
    }
    closedir(DIR);
    return \%Filelist;
}

=item GetDynamicFiles()

Get all static objects

    my $FileHash => $StatsObject->GetDynamicFiles();

=cut

sub GetDynamicFiles {
    my ( $Self, %Param ) = @_;

    my %Filelist = %{ $Self->{ConfigObject}->Get('Stats::DynamicObjectRegistration') };
    for ( keys %Filelist ) {
        if ( $Filelist{$_} ) {
            my $ObjectModule = $Filelist{$_}{Module};
            $Self->{MainObject}->Require($ObjectModule);
            my $StatObject = $ObjectModule->new( %{$Self} );
            $Filelist{$_} = $StatObject->GetObjectName();
        }
        else {
            delete( $Filelist{$_} );
        }
    }
    if ( !%Filelist ) {
        return;
    }

    return \%Filelist;
}

=item ObjectFileCheck()

check readable object file

    my $ObjectFileCheck = $StatsObject->ObjectFileCheck(
        Type => 'static',
        Name => 'NewTickets',
    );

=cut

sub ObjectFileCheck {
    my ( $Self, %Param ) = @_;

    my $Directory = $Self->{ConfigObject}->Get('Home');
    if ( $Directory !~ m{^.*\/$}x ) {
        $Directory .= '/';
    }
    if ( $Param{Type} eq 'static' ) {
        $Directory .= 'Kernel/System/Stats/Static/' . $Param{Name} . '.pm';
    }
    elsif ( $Param{Type} eq 'dynamic' ) {
        $Directory .= 'Kernel/System/Stats/Dynamic/' . $Param{Name} . '.pm';
    }
    else {
        return 0;
    }
    if ( -r "$Directory" ) {
        return 1;
    }
    return 0;
}

sub _WriteResultCache {
    my ( $Self, %Param ) = @_;

    my %GetParam = %{ $Param{GetParam} };
    my $Cache    = 0;

    # check if we should cache this result
    # get the current time
    my ( $s, $m, $h, $D, $M, $Y )
        = $Self->{TimeObject}->SystemTime2Date( SystemTime => $Self->{TimeObject}->SystemTime(), );

    # if get params in future do not cache
    if ( $GetParam{Year} && $GetParam{Month} ) {
        if ( $Y > $GetParam{Year} ) {
            $Cache = 1;
        }
        elsif ( $GetParam{Year} == $Y && $GetParam{Month} <= $M ) {
            if ( $GetParam{Month} < $M ) {
                $Cache = 1;
            }
            if ( $GetParam{Month} == $M && $GetParam{Day} && $GetParam{Day} < $D ) {
                $Cache = 1;
            }
        }
    }

    # write cache file
    if ($Cache) {
        my $Filename = $Self->_CreateStaticResultCacheFilename(
            GetParam => $Param{GetParam},
            StatID   => $Param{StatID},
        );

        $Self->_SetResultCache(
            Filename => $Filename,
            Result   => $Param{Data},
        );
    }
    return $Cache;
}

#=item _CreateStaticResultCacheFilename()
#
#create a filename out of the GetParam information and the stat id
#
#    my $Filename = $Self->_CreateStaticResultCacheFilename(
#        GetParam => $Param{GetParam},
#        StatID   => $Param{StatID},
#    );
#
#=cut

sub _CreateStaticResultCacheFilename {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $NeededParam (qw( StatID GetParam )) {
        if (!$Param{$NeededParam}) {
            return $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "_CreateStaticResultCacheFilename: Need $NeededParam!"
            );
        }
    }

    my $GetParamRef = $Param{GetParam};

    # format month and day params
    for (qw(Month Day)) {
        if ( $GetParamRef->{$_} ) {
            $GetParamRef->{$_} = sprintf( "%02d", $GetParamRef->{$_} );
        }
    }

    my $Key  = '';
    if ( $GetParamRef->{Year} ) {
        $Key .= $GetParamRef->{Year};
    }
    if ( $GetParamRef->{Month} ) {
        $Key .= "-$GetParamRef->{Month}";
    }
    if ( $GetParamRef->{Day} ) {
        $Key .= "-$GetParamRef->{Day}";
    }

    my $MD5Key = $Self->{MainObject}->FilenameCleanUp(
        Filename => $Key,
        Type     => 'md5',
    );

    return 'Stats' . $Param{StatID} . '-' . $MD5Key . '.cache';
}

#=item _SetResultCache()
#
#write the result array as cache in the filesystem
#
#    $Self->_SetResultCache(
#        Filename => 'Stats' . $Param{StatID} . '-' . $MD5Key . '.cache',
#        Result   => $Param{Data},
#    );
#
#=cut

sub _SetResultCache {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $NeededParam (qw( Filename Result)) {
        if (!$Param{$NeededParam}) {
            return $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "_SetResultCache: Need $NeededParam!"
            );
        }
    }

    # convert the result array into a csv string
    my $CSVString = $Self->{CSVObject}->Array2CSV( Data => $Param{Result}, );
    $Self->{EncodeObject}->EncodeOutput( \$CSVString );

    # write the csv string into the filesystem
    my $Filehandle;
    my $Path = $Self->{ConfigObject}->Get('TempDir');
    if ( !open $Filehandle, '>', "$Path/$Param{Filename}" ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't write: $Path/$Param{Filename}!",
        );
        return;
    }

    binmode $Filehandle;
    print   $Filehandle $CSVString;
    close   $Filehandle;

    return 1;
}

#=item _GetResultCache()
#
#get the result array cache out of the filesystem
#
#    my @Result = $Self->_GetResultCache(
#        Filename => 'Stats' . $Param{StatID} . '-' . $MD5Key . '.cache',
#    );
#
#=cut

sub _GetResultCache {
    my ( $Self, %Param ) = @_;

    # check needed params
    if (!$Param{Filename}) {
        return $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => '_GetResultCache: Need Filename!',
        );
    }

    my $Path = $Self->{ConfigObject}->Get('TempDir');
    my $CSVString = '';
    if ( open my $Filehandle, '<', "$Path/$Param{Filename}" ) {
        binmode $Filehandle;
        while (<$Filehandle>) {
            $CSVString .= $_;
        }
        close $Filehandle;
        $Self->{EncodeObject}->Encode( \$CSVString );
    }

    my $ResultRef = $Self->{CSVObject}->CSV2Array(
        String    => $CSVString,
        Separator => ';',
        Quote     => '"',
    );

    return @{$ResultRef};
}

sub _DeleteCache {
    my ( $Self, %Param ) = @_;

    my $Path = $Self->{ConfigObject}->Get('TempDir');

    if ( $Path !~ m{^.*\/$}x ) {
        $Path .= '/';
    }

    my @Files = glob $Path . 'Stats' . $Param{StatID} . '-*.cache';

    for my $File (@Files) {
        unlink $File;
    }
    return 1;
}

=item Export()

get content from stats for export

    my $ExportFile = $StatsObject->Export(
        StatID => '123',
        ExportStatNumber => 1 || 0, # optional, only useful move statistics from the test system to the productive system
    );

=cut

sub Export {
    my ( $Self, %Param ) = @_;

    my %File = ();

    if ( !$Param{StatID} ) {
        return $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Export: Need StatID!"
        );
    }

    my @XMLHash = $Self->{XMLObject}->XMLHashGet(
        Type => 'Stats',

        #Cache => 0,
        Key => $Param{StatID}
    );

    $File{Filename} = $Self->StringAndTimestamp2Filename(
        String => $XMLHash[0]->{otrs_stats}[1]{Title}[1]{Content}, );
    $File{Filename} .= '.xml';

    # settings for static files
    if (   $XMLHash[0]->{otrs_stats}[1]{StatType}[1]{Content}
        && $XMLHash[0]->{otrs_stats}[1]{StatType}[1]{Content} eq 'static' )
    {
        my $FileLocation = $XMLHash[0]->{otrs_stats}[1]{ObjectModule}[1]{Content};
        $FileLocation =~ s{::}{\/}xg;
        $FileLocation .= '.pm';
        my $File        = $Self->{ConfigObject}->Get('Home') . "/$FileLocation";
        my $FileContent = '';
        if ( open my $Filehandle, '<', $File ) {

            # set bin mode
            binmode $Filehandle;
            while (<$Filehandle>) {
                $FileContent .= $_;
            }
            close $Filehandle;
        }
        else {
            die "Can't open: $File: $!";
        }
        $Self->{EncodeObject}->Encode( \$FileContent );
        $XMLHash[0]->{otrs_stats}[1]{File}[1]{File}
            = $XMLHash[0]->{otrs_stats}[1]{File}[1]{Content};
        $XMLHash[0]->{otrs_stats}[1]{File}[1]{Content}    = encode_base64( $FileContent, '' );
        $XMLHash[0]->{otrs_stats}[1]{File}[1]{Location}   = $FileLocation;
        $XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission} = "644";
        $XMLHash[0]->{otrs_stats}[1]{File}[1]{Encode}     = "Base64";
    }

    # delete create and change data
    delete( $XMLHash[0]->{otrs_stats}[1]{Changed} );
    delete( $XMLHash[0]->{otrs_stats}[1]{ChangedBy} );
    delete( $XMLHash[0]->{otrs_stats}[1]{Created} );
    delete( $XMLHash[0]->{otrs_stats}[1]{CreatedBy} );
    delete( $XMLHash[0]->{otrs_stats}[1]{StatID} );
    if ( !$Param{ExportStatNumber} ) {
        delete( $XMLHash[0]->{otrs_stats}[1]{StatNumber} );
    }

    # wrapper to change ids in used spelling
    # wrap permissions
    for my $ID ( @{ $XMLHash[0]->{otrs_stats}[1]{Permission} } ) {
        if ($ID) {
            my %Group = $Self->{GroupObject}->GroupGet( ID => ( $ID->{Content} ) );
            $ID->{Content} = $Group{Name};
        }
    }

    # wrap object dependend ids
    if ( $XMLHash[0]->{otrs_stats}[1]{Object}[1]{Content} ) {

        # load module
        my $ObjectModule = $XMLHash[0]->{otrs_stats}[1]{ObjectModule}[1]{Content};
        $Self->{MainObject}->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );

        # load attributes
        $XMLHash[0]->{otrs_stats}[1]
            = $StatObject->ExportWrapper( %{ $XMLHash[0]->{otrs_stats}[1] } );
    }

    # convert hash to string

    $File{Content} = $Self->{XMLObject}->XMLHash2XML(@XMLHash);
    return \%File;
}

=item Import()

import a stats from xml file

    my $StatID = $StatsObject->Import(
        Content => $UploadStuff{Content},
    );

=cut

sub Import {
    my ( $Self, %Param ) = @_;

    my $StatID = 1;
    my @Keys   = ();

    if ( !$Param{Content} ) {
        return $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Import: Need Content!"
        );
    }
    my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $Param{Content} );

    if ( !$XMLHash[0] ) {
        shift(@XMLHash);
    }

    # Get new StatID
    @Keys = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats', );

    # check if the required elements are available
    for my $Element (qw( Description Format Object ObjectModule Permission StatType SumCol SumRow Title Valid)) {
        if (!defined($XMLHash[0]{otrs_stats}[1]{$Element}[1]{Content})) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                        "Import: Can't import Stat, becauce the required element $Element is not available!"
            );
            return;
        }
    }

    # if-clause if a stat-xml includes a StatNumber
    if ( $XMLHash[0]{otrs_stats}[1]{StatNumber} ) {
        my $XMLStatsID = $XMLHash[0]{otrs_stats}[1]{StatNumber}[1]{Content}
            - $Self->{ConfigObject}->Get("Stats::StatsStartNumber");
        for my $Key (@Keys) {
            if ( $Key eq $XMLStatsID ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Import: Can't import StatNumber $Key, becauce this StatNumber is already used!"
                );
                return;
            }
        }
        $StatID = $XMLStatsID;
    }

    # if no stats number available use this function
    else {
        my @SortKeys = sort { $a <=> $b } @Keys;
        if (@SortKeys) {
            $StatID = $SortKeys[-1] + 1;
        }
    }

    # get time
    my $TimeStamp = $Self->{TimeObject}
        ->SystemTime2TimeStamp( SystemTime => $Self->{TimeObject}->SystemTime(), );

    # meta tags
    $XMLHash[0]{otrs_stats}[1]{Created}[1]{Content}   = $TimeStamp;
    $XMLHash[0]{otrs_stats}[1]{CreatedBy}[1]{Content} = $Self->{UserID};
    $XMLHash[0]{otrs_stats}[1]{Changed}[1]{Content}   = $TimeStamp;
    $XMLHash[0]{otrs_stats}[1]{ChangedBy}[1]{Content} = $Self->{UserID};
    $XMLHash[0]{otrs_stats}[1]{StatNumber}[1]{Content}
        = $StatID + $Self->{ConfigObject}->Get("Stats::StatsStartNumber");

    my $DynamicFiles = $Self->GetDynamicFiles();

    # Because some xml-parser insert \n instead of <example><example>
    if ( $XMLHash[0]->{otrs_stats}[1]{Object}[1]{Content} ) {
        $XMLHash[0]->{otrs_stats}[1]{Object}[1]{Content} =~ s{\n}{}x;
    }

    if ( $XMLHash[0]->{otrs_stats}[1]{Object}[1]{Content}
        && !$DynamicFiles->{ $XMLHash[0]->{otrs_stats}[1]{Object}[1]{Content} } )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Import: Object $XMLHash[0]->{otrs_stats}[1]{Object}[1]{Content} doesn't exists!"
        );
        return 0;
    }
    if (   $XMLHash[0]->{otrs_stats}[1]{StatType}[1]{Content}
        && $XMLHash[0]->{otrs_stats}[1]{StatType}[1]{Content} eq 'static' )
    {
        my $FileLocation = $XMLHash[0]->{otrs_stats}[1]{ObjectModule}[1]{Content};
        $FileLocation =~ s{::}{\/}gx;
        $FileLocation = $Self->{ConfigObject}->Get('Home') . '/' . $FileLocation . '.pm';

        # write file
        if ( open my $Filehandle, '>', $FileLocation ) {
            print STDERR
                "Notice: Install $FileLocation ($XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission})!\n";
            if (   $XMLHash[0]->{otrs_stats}[1]{File}[1]{Encode}
                && $XMLHash[0]->{otrs_stats}[1]{File}[1]{Encode} eq 'Base64' )
            {
                $XMLHash[0]->{otrs_stats}[1]{File}[1]{Content}
                    = decode_base64( $XMLHash[0]->{otrs_stats}[1]{File}[1]{Content} );
                $Self->{EncodeObject}
                    ->EncodeOutput( \$XMLHash[0]->{otrs_stats}[1]{File}[1]{Content} );
            }

            # set bin mode
            binmode $Filehandle;
            print $Filehandle $XMLHash[0]->{otrs_stats}[1]{File}[1]{Content};
            close $Filehandle;

            # set permission
            if ( length( $XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission} ) == 3 ) {
                $XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission}
                    = "0$XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission}";
            }
            chmod( oct( $XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission} ), $FileLocation );
            $XMLHash[0]->{otrs_stats}[1]{File}[1]{Content}
                = $XMLHash[0]->{otrs_stats}[1]{File}[1]{File};
            delete( $XMLHash[0]->{otrs_stats}[1]{File}[1]{File} );
            delete( $XMLHash[0]->{otrs_stats}[1]{File}[1]{Location} );
            delete( $XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission} );
            delete( $XMLHash[0]->{otrs_stats}[1]{File}[1]{Encode} );
        }
    }

    # wrapper to change used spelling in ids
    # wrap permissions
    my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );

    NAME:
    for my $Name ( @{ $XMLHash[0]->{otrs_stats}[1]{Permission} } ) {
        next NAME if !$Name;

        my $Flag = 1;
        ID:
        for my $ID ( keys %Groups ) {
            if ( $Groups{$ID} eq $Name->{Content} ) {
                $Name->{Content} = $ID;
                $Flag = 0;
                last ID;
            }
        }
        if ($Flag) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Import: Can' find the permission (group) $Name->{Content}!"
            );
            $Name = undef;
        }
    }

    # wrap object dependend ids
    if ( $XMLHash[0]->{otrs_stats}[1]{Object}[1]{Content} ) {

        # load module
        my $ObjectModule = $XMLHash[0]->{otrs_stats}[1]{ObjectModule}[1]{Content};
        $Self->{MainObject}->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );

        # load attributes
        $XMLHash[0]->{otrs_stats}[1]
            = $StatObject->ImportWrapper( %{ $XMLHash[0]->{otrs_stats}[1] } );
    }

    # new
    if ($Self->{XMLObject}->XMLHashAdd(
            Type    => 'Stats',
            Key     => $StatID,
            XMLHash => \@XMLHash,
        )
        )
    {

        return $StatID;
    }
    return 0;
}

=item GetParams()

    get all edit params from stats for view

    my $Params = $StatsObject->GetParams(StatID => '123');

=cut

sub GetParams {
    my ( $Self, %Param ) = @_;

    my @Params = ();

    if ( !$Param{StatID} ) {
        return $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "GetParams: Need StatID!"
        );
    }

    my $Stat = $Self->StatsGet( StatID => $Param{StatID} );

    # static
    # don't remove this if clause, because is required for mkStats.pl
    if ( $Stat->{StatType} eq 'static' ) {

        # load static modul
        my $ObjectModule = $Stat->{ObjectModule};
        $Self->{MainObject}->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );

        # get params
        @Params = $StatObject->Param();
    }
    return \@Params;
}

=item StatsRun()
run a stats...

    my $StatArray = $StatsObject->StatsRun(
        StatID => '123',
        GetParam => \%GetParam,
    );

=cut

sub StatsRun {
    my ( $Self, %Param ) = @_;

    my @Result = ();
    for (qw(StatID GetParam)) {
        if ( !$Param{$_} ) {
            return $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "StatsRun: Need $_!"
            );
        }
    }

    # use the mirror db if configured
    if ( $Self->{ConfigObject}->Get('Core::MirrorDB::DSN') ) {
        my $ExtraDatabaseObject = Kernel::System::DB->new(
            LogObject    => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            DatabaseDSN  => $Self->{ConfigObject}->Get('Core::MirrorDB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Core::MirrorDB::User'),
            DatabasePw   => $Self->{ConfigObject}->Get('Core::MirrorDB::Password'),
        );
        if ( !$ExtraDatabaseObject ) {
            $Self->{LayoutObject}->FatalError();
        }
        $Self->{DBObject} = $ExtraDatabaseObject;
    }

    my $Stat = $Self->StatsGet( StatID => $Param{StatID} );
    my %GetParam = %{ $Param{GetParam} };

    if ( $Stat->{StatType} eq 'static' ) {

        # load static modul
        my $ObjectModule = $Stat->{ObjectModule};
        $Self->{MainObject}->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );

        # use result cache if configured
        if ( $Stat->{Cache} ) {
            my $Filename = $Self->_CreateStaticResultCacheFilename(
                GetParam => \%GetParam,
                StatID   => $Param{StatID},
            );

            @Result = $Self->_GetResultCache(
                 Filename => $Filename,
            );
        }

        # try to get data if noting is there
        if ( !@Result ) {

            # run stats function
            @Result = $StatObject->Run(
                %GetParam,
                # these two lines are requirements of me, perhaps this
                # information is needed for former static stats
                Format => $Stat->{Format}[0],
                Module => $Stat->{ObjectModule},
            );

            # write cache if configured
            if ( $Stat->{Cache} ) {
                $Self->_WriteResultCache(
                    GetParam => \%GetParam,
                    StatID   => $Param{StatID},
                    Data     => \@Result,
                );
            }
        }
        $Result[0][0] = $Stat->{Title} . " " . $Result[0][0];
    }
    elsif ( $Stat->{StatType} eq 'dynamic' ) {
        @Result = $Self->GenerateDynamicStats(
            ObjectModule     => $Stat->{ObjectModule},
            Object           => $Stat->{Object},
            UseAsXvalue      => $GetParam{UseAsXvalue},
            UseAsValueSeries => $GetParam{UseAsValueSeries},
            UseAsRestriction => $GetParam{UseAsRestriction},
            Title            => $Stat->{Title},
            StatID           => $Stat->{StatID},
            Cache            => $Stat->{Cache},

        );
    }

    # build sum in row or col
    if ( ( $Stat->{SumRow} || $Stat->{SumCol} ) && $Stat->{Format} !~ m{^GD::Graph\.*}x ) {
        return $Self->SumBuild(
            Array  => \@Result,
            SumRow => $Stat->{SumRow},
            SumCol => $Stat->{SumCol},
        );
    }
    return \@Result;
}

=item StringAndTimestamp2Filename()

builds a filename with a string and a timestamp.
(space will be replaced with _ and - e.g. Title-of-File_2006-12-31_11-59)

    my $Filename = $StatsObject->StringAndTimestamp2Filename(String => 'Title');

=cut

sub StringAndTimestamp2Filename {
    my ( $Self, %Param ) = @_;

    if ( !$Param{String} ) {
        return $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StringAndTimestamp2Filename: Need String!"
        );
    }

    my ( $s, $m, $h, $D, $M, $Y )
        = $Self->{TimeObject}->SystemTime2Date( SystemTime => $Self->{TimeObject}->SystemTime(), );
    $M = sprintf( "%02d", $M );
    $D = sprintf( "%02d", $D );
    $h = sprintf( "%02d", $h );
    $m = sprintf( "%02d", $m );

    # replace invalid token like < > ? " : | \ or *
    $Param{String} =~ s{[\s <>\?":\\\*\|\/]} {-}xg;
    $Param{String} =~ s{ä} {ae}xg;
    $Param{String} =~ s{ö} {oe}xg;
    $Param{String} =~ s{ü} {ue}xg;
    $Param{String} =~ s{Ä} {Ae}xg;
    $Param{String} =~ s{Ö} {Oe}xg;
    $Param{String} =~ s{Ü} {Ue}xg;
    $Param{String} =~ s{ß} {ss}xg;
    $Param{String} =~ s{-+} {-}xg;

    # Cut the String if to long
    if ( length( $Param{String} ) > 100 ) {
        $Param{String} = substr( $Param{String}, 0, 100 );
    }

    my $Filename = $Param{String} . "_" . "$Y-$M-$D" . "_" . "$h-$m";

    return $Filename;
}

sub _MonthArray {
    my @MonthArray
        = ( '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        );
    return \@MonthArray;
}

=item StatNumber2StatID()

insert the stat number get the stat id

    my $StatID = $StatsObject->StatNumber2StatID(
        StatNumber => 11212
    );

=cut

sub StatNumber2StatID {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StatNumber} ) {
        return $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StatNumber2StatID: Need StatNumber!"
        );
    }

    my @Key = $Self->{XMLObject}->XMLHashSearch(
        Type => 'Stats',
        What => [ { "[%]{'otrs_stats'}[%]{'StatNumber'}[%]{'Content'}" => $Param{StatNumber}, }, ],
    );
    if ( @Key && $#Key < 1 ) {
        return $Key[0];
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StatNumber invalid!"
        );
        return 0;
    }
}

sub _AutomaticSampleImport {
    my ( $Self, %Param ) = @_;

    my $Language  = $Self->{ConfigObject}->Get('DefaultLanguage');
    my $Directory = $Self->{ConfigObject}->Get('Home');
    if ( $Directory !~ m{^.*\/$}x ) {
        $Directory .= '/';
    }
    $Directory .= 'scripts/test/sample/';

    if ( !opendir( DIRE, $Directory ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can not open Directory: $Directory",
        );
        return;
    }

    # check if stats in the default language available, if not use en
    my $Flag = 0;
    while ( defined( my $Filename = readdir DIRE ) ) {
        if ( $Filename =~ m{^Stats.*\.$Language\.xml$}x ) {
            $Flag = 1;

        }
    }

    rewinddir(DIRE);
    if ( !$Flag ) {
        $Language = 'en';
    }

    while ( defined( my $Filename = readdir DIRE ) ) {
        if ( $Filename =~ m{^Stats.*\.$Language\.xml$}x ) {

            # check filesize
            #            my $Filesize = -s $Directory.$Filename;
            #            if ($Filesize > $MaxFilesize) {
            #                print "File: $Filename to big! max. $MaxFilesize byte allowed.\n";
            #                $CommonObject{LogObject}->Log(
            #                    Priority => 'error',
            #                    Message => "Can't file imported: $Directory.$Filename",
            #                );
            #                next;
            #            }
            # read file
            my $Filehandle;
            if ( !open $Filehandle, '<', $Directory . $Filename ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can not open File: " . $Directory . $Filename,
                );
                closedir(DIRE);
                return;
            }

            my $Content = '';
            while (<$Filehandle>) {
                $Content .= $_;
            }
            close $Filehandle;

            my $StatID = $Self->Import( Content => $Content, );
        }
    }
    closedir(DIRE);
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=head1 VERSION

$Revision: 1.37 $ $Date: 2008-01-24 08:42:04 $

=cut
