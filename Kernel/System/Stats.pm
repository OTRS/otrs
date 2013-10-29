# --
# Kernel/System/Stats.pm - all stats core functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats;

use strict;
use warnings;

use MIME::Base64;
use Date::Pcalc qw(:all);
use Storable qw();

use Kernel::System::XML;
use Kernel::System::Cache;
use Kernel::System::CSV;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::Stats - stats lib

=head1 SYNOPSIS

All stats functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Group;
    use Kernel::System::Time;
    use Kernel::System::User;
    use Kernel::System::Stats;

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
    my $GroupObject = Kernel::System::Group->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        MainObject   => $MainObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );
    my $StatsObject = Kernel::System::Stats->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        GroupObject  => $GroupObject,
        UserObject   => $UserObject,
        UserID       => 123,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash ref to object
    my $Self = {};
    bless( $Self, $Type );

    # check object list for completeness
    for my $Object (
        qw(
        ConfigObject LogObject UserID GroupObject UserObject TimeObject MainObject
        DBObject EncodeObject
        )
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{CSVObject} = $Param{CSVObject} || Kernel::System::CSV->new(%Param);

    # create supplementary objects
    $Self->{XMLObject}   = Kernel::System::XML->new( %{$Self} );
    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );

    # temporary directory
    $Self->{StatsTempDir} = $Self->{ConfigObject}->Get('Home') . '/var/stats/';

    return $Self;
}

=item StatsAdd()

add new empty stats

    my $StatID = $StatsObject->StatsAdd();

=cut

sub StatsAdd {
    my $Self = shift;

    # get new StatID
    my $StatID = 1;
    my @Keys = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats', );
    if (@Keys) {
        my @SortKeys = sort { $a <=> $b } @Keys;
        $StatID = $SortKeys[-1] + 1;
    }

    # requesting current time stamp
    my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    # meta tags
    my $StatNumber = $StatID + $Self->{ConfigObject}->Get('Stats::StatsStartNumber');
    my %MetaData   = (
        Created => [
            { Content => $TimeStamp },
        ],
        CreatedBy => [
            { Content => $Self->{UserID} },
        ],
        Changed => [
            { Content => $TimeStamp },
        ],
        ChangedBy => [
            { Content => $Self->{UserID} },
        ],
        Valid => [
            { Content => 1 },
        ],
        StatNumber => [
            { Content => $StatNumber },
        ],
    );

    # start new stats record
    my @XMLHash = (
        { otrs_stats => [ \%MetaData ] },
    );
    my $Success = $Self->{XMLObject}->XMLHashAdd(
        Type    => 'Stats',
        Key     => $StatID,
        XMLHash => \@XMLHash,
    );
    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Can not add a new Stat!',
        );
        return;
    }

    $Self->{CacheObject}->CleanUp(
        Type => 'Stats',
    );

    return $StatID;
}

=item StatsGet()

get a hash ref of the stats you need

    my $HashRef = $StatsObject->StatsGet(
        StatID             => '123',
        NoObjectAttributes => 1,       # optional
    );

=cut

sub StatsGet {
    my ( $Self, %Param ) = @_;

    # check necessary data
    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need StatID!' );
    }

    my $CacheKey = 'StatsGet::' . ( join '::', %Param );
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'Stats',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache eq 'HASH';

    # get hash from storage
    my @XMLHash = $Self->{XMLObject}->XMLHashGet(
        Type => 'Stats',
        Key  => $Param{StatID},
    );

    if ( !$XMLHash[0] ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't get StatsID $Param{StatID}!",
        );
        return;
    }

    my %Stat;
    my $StatsXML = $XMLHash[0]->{otrs_stats}->[1];

    # process all strings
    $Stat{StatID} = $Param{StatID};
    for my $Key (
        qw(Title Object File Description SumRow SumCol StatNumber
        Cache StatType Valid ObjectModule CreatedBy ChangedBy Created Changed
        ShowAsDashboardWidget
        )
        )
    {
        if ( defined $StatsXML->{$Key}->[1]->{Content} ) {
            $Stat{$Key} = $StatsXML->{$Key}->[1]->{Content};
        }
    }

    # process all arrays
    KEY:
    for my $Key (qw(Permission Format GraphSize)) {
        next KEY if !$StatsXML->{$Key}->[1]->{Content};

        $Stat{$Key} = ();
        for my $Index ( 1 .. $#{ $StatsXML->{$Key} } ) {
            push @{ $Stat{$Key} }, $StatsXML->{$Key}->[$Index]->{Content};
        }
    }

    if ( $Stat{ObjectModule} ) {
        $Stat{ObjectBehaviours} = $Self->GetObjectBehaviours(
            ObjectModule => $Stat{ObjectModule},
        );
    }

    # get the configuration elements of the dynamic stats
    # %Allowed is used to avoid double selection in different forms
    my %Allowed;
    my %TimeAllowed;
    my $TimeElement = $Self->{ConfigObject}->Get('Stats::TimeElement') || 'Time';
    return \%Stat if !$Stat{Object};

    $Stat{ObjectName} = $Self->GetObjectName(
        ObjectModule => $Stat{ObjectModule},
    );

    if ( $Param{NoObjectAttributes} ) {

        $Self->{CacheObject}->Set(
            Type  => 'Stats',
            Key   => $CacheKey,
            Value => \%Stat,
            TTL   => 24 * 60 * 60,
        );

        return \%Stat;
    }

    KEY:
    for my $Key (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {

        # @StatAttributesSimplified give you arrays without undef array elements
        my @StatAttributesSimplified;

        # get the attributes of the object
        my @ObjectAttributes = $Self->GetStatsObjectAttributes(
            ObjectModule => $Stat{ObjectModule},
            Use          => $Key,
        );

        next KEY if !@ObjectAttributes;

        ATTRIBUTE:
        for my $Attribute (@ObjectAttributes) {
            my $Element = $Attribute->{Element};
            if ( $Attribute->{Block} eq 'Time' ) {
                if ( $Key eq 'UseAsValueSeries' ) {
                    if ( $Allowed{$Element} && $Allowed{$Element} == 1 ) {
                        $Allowed{$Element}     = 0;
                        $TimeAllowed{$Element} = 1;
                    }
                    else {
                        $Allowed{$Element} = 1;
                    }
                }
                elsif ( $Key eq 'UseAsRestriction' ) {
                    if ( $TimeAllowed{$Element} && $TimeAllowed{$Element} == 1 ) {
                        $Allowed{$Element} = 1;
                    }
                    else {
                        $Allowed{$Element} = 0;
                    }
                }
            }
            next ATTRIBUTE if $Allowed{$Element};

            if ( $StatsXML->{$Key} ) {
                my @StatAttributes = @{ $StatsXML->{$Key} };
                if ( !$StatAttributes[0] ) {
                    shift @StatAttributes;
                }
                REF:
                for my $Ref (@StatAttributes) {
                    if ( !defined $Attribute->{Translation} ) {
                        $Attribute->{Translation} = 1;
                    }

                    next REF
                        if !(
                        $Element
                        && $Ref->{Element}
                        && $Element eq $Ref->{Element}
                        );

                    # if selected elements exit, add the information to the StatAttributes
                    $Attribute->{Selected} = 1;
                    if ( $Ref->{Fixed} ) {
                        $Attribute->{Fixed} = 1;
                    }

                    for my $Index ( 1 .. $#{ $Ref->{SelectedValues} } ) {
                        push(
                            @{ $Attribute->{SelectedValues} },
                            $Ref->{SelectedValues}->[$Index]->{Content}
                        );
                    }

                    # settings for working with time elements
                    for (
                        qw(TimeStop TimeStart TimeRelativeUnit
                        TimeRelativeCount TimeScaleCount
                        )
                        )
                    {
                        if ( $Ref->{$_} && ( !$Attribute->{$_} || $Ref->{Fixed} ) ) {
                            $Attribute->{$_} = $Ref->{$_};
                        }
                    }
                    $Allowed{$Element} = 1;
                }
            }
            push @StatAttributesSimplified, $Attribute;

        }
        $Stat{$Key} = \@StatAttributesSimplified;
    }

    $Self->{CacheObject}->Set(
        Type  => 'Stats',
        Key   => $CacheKey,
        Value => \%Stat,
        TTL   => 24 * 60 * 60,
    );

    return \%Stat;
}

=item StatsUpdate()

update a stat

    $StatsObject->StatsUpdate(
        StatID => '123',
        Hash   => \%Hash
    );

=cut

sub StatsUpdate {
    my ( $Self, %Param ) = @_;

    # declaration of the hash
    my %StatXML;

    # check necessary data
    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need StatID!' );
    }

    # requesting stats reference
    my $StatOld = $Self->StatsGet( StatID => $Param{StatID} );
    if ( !$StatOld ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't get stats, perhaps you have an invalid stats id! (StatsID => $Param{StatID})"
        );
        return;
    }

    # declare variable
    my $StatNew = $Param{Hash};

    # a delete function can be the better solution
    for my $Key (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {
        for ( @{ $StatOld->{$Key} } ) {
            if ( !$_->{Selected} ) {
                $_ = undef;
            }
        }
    }

    # adopt changes
    for my $Key ( sort keys %{$StatNew} ) {
        $StatOld->{$Key} = $StatNew->{$Key};
    }

    for my $Key ( sort keys %{$StatOld} ) {

        # Don't store the behaviour data
        next if $Key eq 'ObjectBehaviours';

        if ( $Key eq 'UseAsXvalue' || $Key eq 'UseAsValueSeries' || $Key eq 'UseAsRestriction' ) {
            my $Index = 0;
            REF:
            for my $Ref ( @{ $StatOld->{$Key} } ) {
                next REF if !$Ref;

                $Index++;
                $StatXML{$Key}->[$Index]->{Element} = $Ref->{Element};
                $StatXML{$Key}->[$Index]->{Fixed}   = $Ref->{Fixed};
                my $SubIndex = 0;
                for my $Value ( @{ $Ref->{SelectedValues} } ) {
                    $SubIndex++;
                    $StatXML{$Key}->[$Index]->{SelectedValues}->[$SubIndex]->{Content} = $Value;
                }

                # stetting for working with time elements
                for (qw(TimeStop TimeStart TimeRelativeUnit TimeRelativeCount TimeScaleCount)) {
                    if ( $Ref->{$_} ) {
                        $StatXML{$Key}->[$Index]->{$_} = $Ref->{$_};
                    }
                }
            }
        }
        elsif ( ref $StatOld->{$Key} eq 'ARRAY' ) {
            for my $Index ( 0 .. $#{ $StatOld->{$Key} } ) {
                $StatXML{$Key}->[$Index]->{Content} = $StatOld->{$Key}->[$Index];
            }
        }
        else {
            if ( defined $StatOld->{$Key} ) {
                $StatXML{$Key}->[1]->{Content} = $StatOld->{$Key};
            }
        }
    }

    # meta tags
    my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $StatXML{Changed}->[1]->{Content}   = $TimeStamp;
    $StatXML{ChangedBy}->[1]->{Content} = $Self->{UserID};

    # please don't change the functionality of XMLHashDelete and XMLHashAdd
    # into the new function XMLHashUpdate, there is an incompatibility.
    # Perhaps there are intricacies because of the 'Array[0] = undef' definition

    # delete the old record
    my $Success = $Self->{XMLObject}->XMLHashDelete(
        Type => 'Stats',
        Key  => $Param{StatID},
    );
    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete XMLHash!"
        );
        return;
    }

    # delete cache
    $Self->_DeleteCache( StatID => $Param{StatID} );

    my @Array = (
        { otrs_stats => [ \%StatXML ], },
    );

    # add the revised record
    $Success = $Self->{XMLObject}->XMLHashAdd(
        Type    => 'Stats',
        Key     => $Param{StatID},
        XMLHash => \@Array
    );
    if ( !$Success ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't add XMLHash!" );
        return;
    }

    $Self->{CacheObject}->CleanUp(
        Type => 'Stats',
    );

    return 1;
}

=item StatsDelete()

delete a stats

    $StatsObject->StatsDelete( StatID => '123' );

=cut

sub StatsDelete {
    my ( $Self, %Param ) = @_;

    # check necessary data
    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need StatID!' );
    }

    # delete the record
    my $Success = $Self->{XMLObject}->XMLHashDelete(
        Type => 'Stats',
        Key  => $Param{StatID},
    );

    # error handling
    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete XMLHash!",
        );
        return;
    }

    # delete cache
    $Self->_DeleteCache( StatID => $Param{StatID} );

    # get list of installed stats files
    my @StatsFileList = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{StatsTempDir},
        Filter    => '*.xml.installed',
    );

    # delete the .installed file in temp dir
    FILE:
    for my $File ( sort @StatsFileList ) {

        # read file content
        my $StatsIDRef = $Self->{MainObject}->FileRead(
            Location => $File,
        );

        next FILE if !$StatsIDRef;
        next FILE if ref $StatsIDRef ne 'SCALAR';
        next FILE if !${$StatsIDRef};

        next FILE if ${$StatsIDRef} ne $Param{StatID};

        # delete .installed file
        $Self->{MainObject}->FileDelete(
            Location => $File,
        );
    }

    # add log message
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Delete stats (StatsID = $Param{StatID})",
    );

    $Self->{CacheObject}->CleanUp(
        Type => 'Stats',
    );

    return 1;
}

=item StatsListGet()

fetches all statistics that the current user may see

    my $StatsRef = $StatsObject->StatsListGet();

    Returns

    {
        6 => {
            Title => "Title of stat",
            ...
        }
    }

=cut

sub StatsListGet {
    my ( $Self, %Param ) = @_;

    my $CacheKey = 'StatsListGet::' . ( join '::', %Param );
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'Stats',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache eq 'HASH';

    my @SearchResult;
    if ( !( @SearchResult = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats' ) ) ) {
        $Self->_AutomaticSampleImport();
        return if !( @SearchResult = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats' ) );
    }

    # get user groups
    my @Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'ro',
        Result => 'ID',
    );

    my %Result;

    for my $StatID (@SearchResult) {
        my $Stat = $Self->StatsGet(
            StatID             => $StatID,
            NoObjectAttributes => 1,
        );
        my $UserPermission = 0;
        if ( $Self->{AccessRw} || $Self->{UserID} == 1 ) {
            $UserPermission = 1;
        }

        # these function is similar like other function in the code perhaps we should
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
            $Result{$StatID} = $Stat;
        }
    }

    $Self->{CacheObject}->Set(
        Type  => 'Stats',
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => 24 * 60 * 60,
    );

    return \%Result;
}

=item GetStatsList()

lists all stats id's

    my $ArrayRef = $StatsObject->GetStatsList(
        OrderBy   => 'ID' || 'Title' || 'Object', # optional
        Direction => 'ASC' || 'DESC',             # optional
    );

=cut

sub GetStatsList {
    my ( $Self, %Param ) = @_;

    my $CacheKey = 'GetStatsList::' . ( join '::', %Param );
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'Stats',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache eq 'ARRAY';

    my %ResultHash = %{ $Self->StatsListGet() || {} };

    my @SortArray;

    $Param{OrderBy} ||= 'ID';

    if ( $Param{OrderBy} eq 'ID' ) {
        @SortArray = sort { $a <=> $b } keys %ResultHash;
    }
    else {
        @SortArray
            = sort { $ResultHash{$a}->{ $Param{OrderBy} } cmp $ResultHash{$b}->{ $Param{OrderBy} } }
            keys %ResultHash;
    }
    if ( $Param{Direction} && $Param{Direction} eq 'DESC' ) {
        @SortArray = reverse @SortArray;
    }

    $Self->{CacheObject}->Set(
        Type  => 'Stats',
        Key   => $CacheKey,
        Value => \@SortArray,
        TTL   => 24 * 60 * 60,
    );

    return \@SortArray;
}

=item SumBuild()

build sum in x or/and y axis

    $StatArray = $StatsObject->SumBuild(
        Array  => \@Result,
        SumRow => 1,
        SumCol => 0,
    );

=cut

sub SumBuild {
    my ( $Self, %Param ) = @_;

    my @Data = @{ $Param{Array} };

    # add sum y
    if ( $Param{SumRow} ) {

        push @{ $Data[1] }, 'Sum';

        for my $Index1 ( 2 .. $#Data ) {

            my $Sum = 0;
            INDEX2:
            for my $Index2 ( 1 .. $#{ $Data[$Index1] } ) {

                next INDEX2 if !$Data[$Index1][$Index2];

                # extract the value
                my $Value = $Data[$Index1][$Index2];

                # clean the string
                $Value =~ s{ \A \s+ }{}xms;
                $Value =~ s{ \s+ \z }{}xms;
                $Value =~ s{ , }{.}xms;

                # add value to summary
                if ( $Value =~ m{^-?\d+(\.\d+)?$} ) {
                    $Sum += $Value;
                }
            }

            push @{ $Data[$Index1] }, $Sum;
        }
    }

    # add sum x
    if ( $Param{SumCol} ) {

        my @SumRow = ();
        $SumRow[0] = 'Sum';

        for my $Index1 ( 2 .. $#Data ) {

            INDEX2:
            for my $Index2 ( 1 .. $#{ $Data[$Index1] } ) {

                # make sure we have a value to add
                if ( !defined $Data[$Index1][$Index2] ) {
                    $Data[$Index1][$Index2] = 0;
                }

                # extract the value
                my $Value = $Data[$Index1][$Index2];

                # clean the string
                $Value =~ s{ \A \s+ }{}xms;
                $Value =~ s{ \s+ \z }{}xms;
                $Value =~ s{ , }{.}xms;

                # add value to summary
                if ( $Value =~ m{^-?\d+(\.\d+)?$} ) {
                    $SumRow[$Index2] += $Value;
                }
            }
        }

        push @Data, \@SumRow;
    }
    return \@Data;
}

=item GenerateGraph()

make graph from result array

    my $Graph = $StatsObject->GenerateGraph(
        Array        => \@StatArray,
        GraphSize    => '800x600',
        HeadArrayRef => $HeadArrayRef,
        Title        => 'All Tickets of the month',
        Format       => 'GD::Graph::lines',
    );

=cut

sub GenerateGraph {
    my ( $Self, %Param ) = @_;

    # check if need params are available
    for (qw(Array GraphSize HeadArrayRef Title Format)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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
        pop @{$HeadArrayRef};
        for my $Row (@StatArray) {
            pop @{$Row};
        }
    }

    # load gd modules
    for my $Module ( 'GD', 'GD::Graph', $GDBackend ) {
        if ( !$Self->{MainObject}->Require($Module) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Module!"
            );
            return;
        }
    }

    # remove first y/x position
    my $Xlabel = shift @{$HeadArrayRef};

    # get first col for legend
    my @YLine;
    for my $Tmp (@StatArray) {
        push @YLine, $Tmp->[0];
        shift @{$Tmp};
    }

    # build plot data
    my @PData = ( $HeadArrayRef, @StatArray );
    my ( $XSize, $YSize ) = split( m{x}x, $Param{GraphSize} );
    my $Graph = $GDBackend->new( $XSize || 550, $YSize || 350 );

    # set fonts so we can use non-latin characters
    my $FontDir    = $Self->{ConfigObject}->Get('Home') . '/var/fonts/';
    my $TitleFont  = $FontDir . 'DejaVuSans-Bold.ttf';
    my $LegendFont = $FontDir . 'DejaVuSans.ttf';
    $Graph->set_title_font( $TitleFont, 14 );

    # there are different font options for different font types
    if ( $GDBackend eq 'GD::Graph::pie' ) {
        $Graph->set_value_font( $LegendFont, 9 );
    }
    else {
        $Graph->set_values_font( $LegendFont, 9 );
        $Graph->set_legend_font( $LegendFont, 9 );
        $Graph->set_x_label_font( $LegendFont, 9 );
        $Graph->set_y_label_font( $LegendFont, 9 );
        $Graph->set_x_axis_font( $LegendFont, 9 );
        $Graph->set_y_axis_font( $LegendFont, 9 );
    }
    $Graph->set(
        x_label => $Xlabel,

        #        y_label => 'Ylabel',
        title => $Param{Title},

        #        y_max_value => 20,
        #        y_tick_number => 16,
        #        y_label_skip => 4,
        #        x_tick_number => 8,
        t_margin    => $Self->{ConfigObject}->Get('Stats::Graph::t_margin')    || 10,
        b_margin    => $Self->{ConfigObject}->Get('Stats::Graph::b_margin')    || 10,
        l_margin    => $Self->{ConfigObject}->Get('Stats::Graph::l_margin')    || 10,
        r_margin    => $Self->{ConfigObject}->Get('Stats::Graph::r_margin')    || 20,
        bgclr       => $Self->{ConfigObject}->Get('Stats::Graph::bgclr')       || 'white',
        transparent => $Self->{ConfigObject}->Get('Stats::Graph::transparent') || 0,
        interlaced  => 1,
        fgclr       => $Self->{ConfigObject}->Get('Stats::Graph::fgclr')       || 'black',
        boxclr      => $Self->{ConfigObject}->Get('Stats::Graph::boxclr')      || 'white',
        accentclr   => $Self->{ConfigObject}->Get('Stats::Graph::accentclr')   || 'black',
        shadowclr   => $Self->{ConfigObject}->Get('Stats::Graph::shadowclr')   || 'black',
        legendclr   => $Self->{ConfigObject}->Get('Stats::Graph::legendclr')   || 'black',
        textclr     => $Self->{ConfigObject}->Get('Stats::Graph::textclr')     || 'black',
        dclrs       => $Self->{ConfigObject}->Get('Stats::Graph::dclrs')
            || [
            qw(red green blue yellow black purple orange pink marine cyan lgray lblue lyellow lgreen lred lpurple lorange lbrown)
            ],
        x_tick_offset       => 0,
        x_label_position    => 1 / 2,
        y_label_position    => 1 / 2,
        x_labels_vertical   => 31,
        line_width          => $Self->{ConfigObject}->Get('Stats::Graph::line_width') || 1,
        legend_placement    => $Self->{ConfigObject}->Get('Stats::Graph::legend_placement') || 'BC',
        legend_spacing      => $Self->{ConfigObject}->Get('Stats::Graph::legend_spacing') || 4,
        legend_marker_width => $Self->{ConfigObject}->Get('Stats::Graph::legend_marker_width')
            || 12,
        legend_marker_height => $Self->{ConfigObject}->Get('Stats::Graph::legend_marker_height')
            || 8,
    );

    # set legend (y-line)
    if ( $Param{Format} ne 'GD::Graph::pie' ) {
        $Graph->set_legend(@YLine);
    }

    # investigate the possible output types
    my @OutputTypeList = $Graph->export_format();

    # transfer array to hash
    my %OutputTypes;
    for my $OutputType (@OutputTypeList) {
        $OutputTypes{$OutputType} = 1;
    }

    # select output type
    my $Ext;
    if ( $OutputTypes{'png'} ) {
        $Ext = 'png';
    }
    elsif ( $OutputTypes{'gif'} ) {
        $Ext = 'gif';
    }
    elsif ( $OutputTypes{'jpeg'} ) {
        $Ext = 'jpeg';
    }

    # error handling
    if ( !$Ext ) {

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "The support of png, jpeg and gif output is not activated in the GD CPAN module!",
        );

        return;
    }

    # create graph
    my $Content = eval { $Graph->plot( \@PData )->$Ext() };

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

    my @Notify;
    my @NotifySelected;
    my @IndexArray;

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
        Info     => 'Your reporting time interval is too small, please use a larger time scale!',
        Priority => 'Error'
    };
    $Notify[16] = {
        Info     => 'There is something wrong with your time scale selection. Please check it!',
        Priority => 'Error'
    };
    $Notify[17] = {
        Info     => 'You have to select a time scale like day or month!',
        Priority => 'Error'
    };

    # check if need params are available
    NEED:
    for my $Need (qw(StatData Section)) {
        next NEED if $Param{$Need};
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Need"
        );
        return;
    }

    my %StatData = %{ $Param{StatData} };
    if ( $Param{Section} eq 'Specification' || $Param{Section} eq 'All' ) {
        for (qw(Title Description StatType Permission Format ObjectModule)) {
            if ( !$StatData{$_} ) {
                push @IndexArray, 0;
                last;
            }
        }
        if ( $StatData{StatType} && $StatData{StatType} eq 'static' && !$StatData{File} ) {
            push @IndexArray, 1;
        }
        if ( $StatData{StatType} && $StatData{StatType} eq 'dynamic' && !$StatData{Object} ) {
            push @IndexArray, 2;
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
        if (
            ( $Param{Section} eq 'Xaxis' || $Param{Section} eq 'All' )
            && $StatData{StatType} eq 'dynamic'
            )
        {
            my $Flag = 0;
            XVALUE:
            for my $Xvalue ( @{ $StatData{UseAsXvalue} } ) {
                next XVALUE if !$Xvalue->{Selected};

                if ( $Xvalue->{Block} eq 'Time' ) {
                    if ( $Xvalue->{TimeStart} && $Xvalue->{TimeStop} ) {
                        my $TimeStart = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Xvalue->{TimeStart}
                        );
                        my $TimeStop = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Xvalue->{TimeStop}
                        );
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
                        push @IndexArray, 9;
                        last XVALUE;
                    }

                    if ( !$Xvalue->{SelectedValues}[0] ) {
                        push @IndexArray, 16;
                    }
                    elsif ( $Xvalue->{Fixed} && $#{ $Xvalue->{SelectedValues} } > 0 ) {
                        push @IndexArray, 16;
                    }
                }
                $Flag = 1;
                last XVALUE;
            }
            if ( !$Flag ) {
                push @IndexArray, 4;
            }
        }
        if (
            ( $Param{Section} eq 'ValueSeries' || $Param{Section} eq 'All' )
            && $StatData{StatType} eq 'dynamic'
            )
        {
            my $Counter = 0;
            my $Flag    = 0;
            VALUESERIES:
            for my $ValueSeries ( @{ $StatData{UseAsValueSeries} } ) {
                next VALUESERIES if !$ValueSeries->{Selected};

                if (
                    $ValueSeries->{Block} eq 'Time'
                    || $ValueSeries->{Block} eq 'TimeExtended'
                    )
                {
                    if ( $ValueSeries->{Fixed} && $#{ $ValueSeries->{SelectedValues} } > 0 ) {
                        push @IndexArray, 6;
                    }
                    elsif ( !$ValueSeries->{SelectedValues}[0] ) {
                        push @IndexArray, 7;
                    }
                    $Flag = 1;
                }

                $Counter++;
            }
            if ( $Counter > 1 && $Flag ) {
                push @IndexArray, 13;
            }
            elsif ( $Counter > 2 ) {
                push @IndexArray, 12;
            }
        }
        if (
            ( $Param{Section} eq 'Restrictions' || $Param{Section} eq 'All' )
            && $StatData{StatType} eq 'dynamic'
            )
        {
            RESTRICTION:
            for my $Restriction ( @{ $StatData{UseAsRestriction} } ) {
                next RESTRICTION if !$Restriction->{Selected};

                if ( $Restriction->{Block} eq 'SelectField' ) {
                    if ( $Restriction->{Fixed} && $#{ $Restriction->{SelectedValues} } > 0 ) {
                        push @IndexArray, 6;
                        last RESTRICTION;
                    }
                    elsif ( !$Restriction->{SelectedValues}[0] ) {
                        push @IndexArray, 7;
                        last RESTRICTION;
                    }
                }
                elsif (
                    $Restriction->{Block} eq 'InputField'
                    && !$Restriction->{SelectedValues}[0]
                    && $Restriction->{Fixed}
                    )
                {
                    push @IndexArray, 8;
                    last RESTRICTION;
                }
                elsif (
                    $Restriction->{Block} eq 'Time'
                    || $Restriction->{Block} eq 'TimeExtended'
                    )
                {
                    if ( $Restriction->{TimeStart} && $Restriction->{TimeStop} ) {
                        my $TimeStart = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Restriction->{TimeStart}
                        );
                        my $TimeStop = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Restriction->{TimeStop}
                        );
                        if ( !$TimeStart || !$TimeStop ) {
                            push @IndexArray, 11;
                            last RESTRICTION;
                        }
                        elsif ( $TimeStart > $TimeStop ) {
                            push @IndexArray, 9;
                            last RESTRICTION;
                        }
                    }
                    elsif (
                        !$Restriction->{TimeRelativeUnit}
                        || !$Restriction->{TimeRelativeCount}
                        )
                    {
                        push @IndexArray, 9;
                        last RESTRICTION;
                    }
                }
            }
        }

        # check if the timeperiod is too big or the time scale too small
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

                my $Count = $Xvalue->{TimeScaleCount} ? $Xvalue->{TimeScaleCount} : 1;

                my %TimeInSeconds = (
                    Year   => 31536000,    # 60 * 60 * 60 * 365
                    Month  => 2592000,     # 60 * 60 * 24 * 30
                    Week   => 604800,      # 60 * 60 * 24 * 7
                    Day    => 86400,       # 60 * 60 * 24
                    Hour   => 3600,        # 60 * 60
                    Minute => 60,
                    Second => 1,
                );

                $ScalePeriod = $TimeInSeconds{ $Xvalue->{SelectedValues}[0] };

                if ( !$ScalePeriod ) {
                    push @IndexArray, 17;
                    last XVALUE;
                }

                if ( $Xvalue->{TimeStop} && $Xvalue->{TimeStart} ) {
                    $TimePeriod
                        = (
                        $Self->{TimeObject}->TimeStamp2SystemTime( String => $Xvalue->{TimeStop} )
                        )
                        - (
                        $Self->{TimeObject}->TimeStamp2SystemTime( String => $Xvalue->{TimeStart} )
                        );
                }
                else {
                    $TimePeriod = $TimeInSeconds{ $Xvalue->{TimeRelativeUnit} }
                        * $Xvalue->{TimeRelativeCount};
                }

                my $MaxAttr = $Self->{ConfigObject}->Get('Stats::MaxXaxisAttributes') || 1000;
                if ( $TimePeriod / ( $ScalePeriod * $Count ) > $MaxAttr ) {
                    push @IndexArray, 15;
                }

                last XVALUE;
            }
        }
    }
    for (@IndexArray) {
        push @NotifySelected, $Notify[$_];
    }

    return @NotifySelected;

}

=item GetStatsObjectAttributes()

Get all attributes from the object in dependence of the use

    my %ObjectAttributes = $StatsObject->GetStatsObjectAttributes(
        ObjectModule => 'Ticket',
        Use          => 'UseAsXvalue' || 'UseAsValueSeries' || 'UseAsRestriction',
    );

=cut

sub GetStatsObjectAttributes {
    my ( $Self, %Param ) = @_;

    # check needed params
    for (qw(ObjectModule Use)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # load module
    my $ObjectModule = $Param{ObjectModule};
    return if !$Self->{MainObject}->Require($ObjectModule);
    my $StatObject = $ObjectModule->new( %{$Self} );
    return if !$StatObject;

    # load attributes
    my @ObjectAttributesRaw = $StatObject->GetObjectAttributes();

    # build the objectattribute array
    my @ObjectAttributes;
    for my $HashRef (@ObjectAttributesRaw) {
        if ( $HashRef->{ $Param{Use} } ) {
            delete $HashRef->{UseAsXvalue};
            delete $HashRef->{UseAsValueSeries};
            delete $HashRef->{UseAsRestriction};

            push @ObjectAttributes, $HashRef;
        }
    }

    return @ObjectAttributes;
}

=item GetStaticFiles()

Get all static files

    my $FileHash = $StatsObject->GetStaticFiles(
        OnlyUnusedFiles => 1 | 0, # optional default 0
    );

=cut

sub GetStaticFiles {
    my ( $Self, %Param ) = @_;

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

    my %StaticFiles;
    if ( $Param{OnlyUnusedFiles} ) {

        # get all Stats from the db
        my $Result = $Self->GetStatsList();

        if ( defined $Result ) {
            for my $StatID ( @{$Result} ) {
                my $Data = $Self->StatsGet( StatID => $StatID );

                # check witch one are static statistics
                if ( $Data->{File} && $Data->{StatType} eq 'static' ) {
                    $StaticFiles{ $Data->{File} } = 1;
                }
            }
        }
    }

    # read files
    my %Filelist;
    while ( defined( my $Filename = readdir DIR ) ) {
        next if $Filename eq '.';
        next if $Filename eq '..';
        if ( $Filename =~ m{^(.*)\.pm$}x ) {
            if ( !defined $StaticFiles{$1} ) {
                $Filelist{$1} = $1;
            }
        }
    }
    closedir(DIR);

    return \%Filelist;
}

=item GetDynamicFiles()

Get all static objects

    my $FileHash = $StatsObject->GetDynamicFiles();

=cut

sub GetDynamicFiles {
    my $Self = shift;

    my %Filelist = %{ $Self->{ConfigObject}->Get('Stats::DynamicObjectRegistration') };
    OBJECT:
    for my $Object ( sort keys %Filelist ) {
        if ( !$Filelist{$Object} ) {
            delete $Filelist{$Object};
            next OBJECT;
        }
        $Filelist{$Object} = $Self->GetObjectName(
            ObjectModule => $Filelist{$Object}{Module},
        );
    }
    return if !%Filelist;

    return \%Filelist;
}

=item GetObjectName()

Get the name of a dynamic object

    my $ObjectName = $StatsObject->GetObjectName(
        ObjectModule => 'Kernel::System::Stats::Dynamic::TicketList',
    );

=cut

sub GetObjectName {
    my ( $Self, %Param ) = @_;
    my $Module = $Param{ObjectModule};

    # check if it is cached
    return $Self->{'Cache::ObjectName'}->{$Module} if $Self->{'Cache::ObjectName'}->{$Module};

    # load module, return if module does not exist
    # (this is important when stats are uninstalled, see also bug# 4269)
    return if !$Self->{MainObject}->Require($Module);

    # get name
    my $StatObject = $Module->new( %{$Self} );
    return if !$StatObject;
    my $Name = $StatObject->GetObjectName();

    # cache the result
    $Self->{'Cache::ObjectName'}->{$Module} = $Name;

    return $Name;
}

=item GetObjectBehaviours()

get behaviours that a statistic supports

    my %Behaviours = $StatsObject->GetObjectBehaviours(
        ObjectModule => 'Kernel::System::Stats::Dynamic::TicketList',
    );

    returns

    {
        ProvidesDashboardWidget => 1,
        ...
    }

=cut

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;
    my $Module = $Param{ObjectModule};

    # check if it is cached
    return $Self->{'Cache::ObjectBehaviours'}->{$Module}
        if $Self->{'Cache::ObjectBehaviours'}->{$Module};

    # load module, return if module does not exist
    # (this is important when stats are uninstalled, see also bug# 4269)
    return if !$Self->{MainObject}->Require($Module);

    my $StatObject = $Module->new( %{$Self} );
    return if !$StatObject;

    return if !$StatObject->can('GetObjectBehaviours');
    my %ObjectBehaviours = $StatObject->GetObjectBehaviours();

    # cache the result
    $Self->{'Cache::ObjectBehaviours'}->{$Module} = %ObjectBehaviours;

    return \%ObjectBehaviours;
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

    return 1 if -r $Directory;
    return;
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

    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Export: Need StatID!'
        );
        return;
    }

    my @XMLHash = $Self->{XMLObject}->XMLHashGet(
        Type => 'Stats',

        #Cache => 0,
        Key => $Param{StatID}
    );
    my $StatsXML = $XMLHash[0]->{otrs_stats}->[1];

    my %File;
    $File{Filename} = $Self->StringAndTimestamp2Filename(
        String => $StatsXML->{Title}->[1]->{Content},
    );
    $File{Filename} .= '.xml';

    # settings for static files
    if (
        $StatsXML->{StatType}->[1]->{Content}
        && $StatsXML->{StatType}->[1]->{Content} eq 'static'
        )
    {
        my $FileLocation = $StatsXML->{ObjectModule}->[1]->{Content};
        $FileLocation =~ s{::}{\/}xg;
        $FileLocation .= '.pm';
        my $File        = $Self->{ConfigObject}->Get('Home') . "/$FileLocation";
        my $FileContent = '';

        open my $Filehandle, '<', $File || die "Can't open: $File: $!";    ## no critic

        # set bin mode
        binmode $Filehandle;
        while (<$Filehandle>) {
            $FileContent .= $_;
        }
        close $Filehandle;

        $Self->{EncodeObject}->EncodeInput( \$FileContent );
        $StatsXML->{File}->[1]->{File}       = $StatsXML->{File}->[1]->{Content};
        $StatsXML->{File}->[1]->{Content}    = encode_base64( $FileContent, '' );
        $StatsXML->{File}->[1]->{Location}   = $FileLocation;
        $StatsXML->{File}->[1]->{Permission} = '644';
        $StatsXML->{File}->[1]->{Encode}     = 'Base64';
    }

    # delete create and change data
    for my $Key (qw(Changed ChangedBy Created CreatedBy StatID)) {
        delete $StatsXML->{$Key};
    }
    if ( !$Param{ExportStatNumber} ) {
        delete $StatsXML->{StatNumber};
    }

    # wrapper to change ids in used spelling
    # wrap permissions
    for my $ID ( @{ $StatsXML->{Permission} } ) {
        next if !$ID;
        my $Name = $Self->{GroupObject}->GroupLookup( GroupID => $ID->{Content} );
        next if !$Name;
        $ID->{Content} = $Name;
    }

    # wrap object dependend ids
    if ( $StatsXML->{Object}->[1]->{Content} ) {

        # load module
        my $ObjectModule = $StatsXML->{ObjectModule}->[1]->{Content};
        return if !$Self->{MainObject}->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );
        return if !$StatObject;

        # load attributes
        $StatsXML = $StatObject->ExportWrapper(
            %{$StatsXML},
        );
    }

    # convert hash to string
    $File{Content} = $Self->{XMLObject}->XMLHash2XML(
        {
            otrs_stats => [
                undef,
                $StatsXML,
            ],
        },
    );

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

    if ( !$Param{Content} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Content!'
        );
        return;
    }
    my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => $Param{Content} );

    if ( !$XMLHash[0] ) {
        shift @XMLHash;
    }
    my $StatsXML = $XMLHash[0]->{otrs_stats}->[1];

    # Get new StatID
    my @Keys = $Self->{XMLObject}->XMLHashSearch( Type => 'Stats', );

    # check if the required elements are available
    for my $Element (
        qw( Description Format Object ObjectModule Permission StatType SumCol SumRow Title Valid)
        )
    {
        if ( !defined $StatsXML->{$Element}->[1]->{Content} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Can't import Stat, because the required element $Element is not available!"
            );
            return;
        }
    }

    # if-clause if a stat-xml includes a StatNumber
    my $StatID = 1;
    if ( $StatsXML->{StatNumber} ) {
        my $XMLStatsID = $StatsXML->{StatNumber}->[1]->{Content}
            - $Self->{ConfigObject}->Get('Stats::StatsStartNumber');
        for my $Key (@Keys) {
            if ( $Key eq $XMLStatsID ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Can't import StatNumber $Key, because this StatNumber is already used!"
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
    my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    # meta tags
    $StatsXML->{Created}->[1]->{Content}   = $TimeStamp;
    $StatsXML->{CreatedBy}->[1]->{Content} = $Self->{UserID};
    $StatsXML->{Changed}->[1]->{Content}   = $TimeStamp;
    $StatsXML->{ChangedBy}->[1]->{Content} = $Self->{UserID};
    $StatsXML->{StatNumber}->[1]->{Content}
        = $StatID + $Self->{ConfigObject}->Get('Stats::StatsStartNumber');

    my $DynamicFiles = $Self->GetDynamicFiles();

    # Because some xml-parser insert \n instead of <example><example>
    if ( $StatsXML->{Object}->[1]->{Content} ) {
        $StatsXML->{Object}->[1]->{Content} =~ s{\n}{}x;
    }

    if (
        $StatsXML->{Object}->[1]->{Content}
        && !$DynamicFiles->{ $StatsXML->{Object}->[1]->{Content} }
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Object $StatsXML->{Object}->[1]->{Content} doesn't exist!"
        );
        return;
    }

    # static statistic
    if (
        $StatsXML->{StatType}->[1]->{Content}
        && $StatsXML->{StatType}->[1]->{Content} eq 'static'
        )
    {
        my $FileLocation = $StatsXML->{ObjectModule}[1]{Content};
        $FileLocation =~ s{::}{\/}gx;
        $FileLocation = $Self->{ConfigObject}->Get('Home') . '/' . $FileLocation . '.pm';

        # if no inline file is given in the stats definition
        if ( !$StatsXML->{File}->[1]->{Content} ) {

            # get the file name
            $FileLocation =~ s{ \A .*? ( [^/]+ ) \. pm  \z }{$1}xms;

            # set the file name
            $StatsXML->{File}->[1]->{Content} = $FileLocation;
        }

        # write file if it is included in the stats definition
        ## no critic
        elsif ( open my $Filehandle, '>', $FileLocation ) {
            ## use critic

            print STDERR "Notice: Install $FileLocation ($StatsXML->{File}[1]{Permission})!\n";
            if ( $StatsXML->{File}->[1]->{Encode} && $StatsXML->{File}->[1]->{Encode} eq 'Base64' )
            {
                $StatsXML->{File}->[1]->{Content}
                    = decode_base64( $StatsXML->{File}->[1]->{Content} );
                $Self->{EncodeObject}->EncodeOutput(
                    \$StatsXML->{File}->[1]->{Content}
                );
            }

            # set utf8 or bin mode
            if ( $StatsXML->{File}->[1]->{Content} =~ /use\sutf8;/ ) {
                open $Filehandle, '>:utf8', $FileLocation;    ## no critic
            }
            else {
                binmode $Filehandle;
            }
            print $Filehandle $StatsXML->{File}->[1]->{Content};
            close $Filehandle;

            # set permission
            if ( length( $StatsXML->{File}->[1]->{Permission} ) == 3 ) {
                $StatsXML->{File}->[1]->{Permission} = "0$StatsXML->{File}->[1]->{Permission}";
            }
            chmod( oct( $StatsXML->{File}->[1]->{Permission} ), $FileLocation );
            $StatsXML->{File}->[1]->{Content} = $StatsXML->{File}->[1]->{File};

            delete $StatsXML->{File}->[1]->{File};
            delete $StatsXML->{File}->[1]->{Location};
            delete $StatsXML->{File}->[1]->{Permission};
            delete $StatsXML->{File}->[1]->{Encode};
        }
    }

    # wrapper to change used spelling in ids
    # wrap permissions
    my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );

    NAME:
    for my $Name ( @{ $StatsXML->{Permission} } ) {
        next NAME if !$Name;

        my $Flag = 1;
        ID:
        for my $ID ( sort keys %Groups ) {
            if ( $Groups{$ID} eq $Name->{Content} ) {
                $Name->{Content} = $ID;
                $Flag = 0;
                last ID;
            }
        }
        if ($Flag) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't find the permission (group) $Name->{Content}!"
            );
            $Name = undef;
        }
    }

    # wrap object dependend ids
    if ( $StatsXML->{Object}->[1]->{Content} ) {

        # load module
        my $ObjectModule = $StatsXML->{ObjectModule}->[1]->{Content};
        return if !$Self->{MainObject}->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );
        return if !$StatObject;

        # load attributes
        $StatsXML = $StatObject->ImportWrapper( %{$StatsXML} );
    }

    # new
    return if !$Self->{XMLObject}->XMLHashAdd(
        Type    => 'Stats',
        Key     => $StatID,
        XMLHash => [
            {
                otrs_stats => [
                    undef,
                    $StatsXML,
                ],
            },
        ],
    );

    $Self->{CacheObject}->CleanUp(
        Type => 'Stats',
    );

    return $StatID;
}

=item GetParams()

    get all edit params from stats for view

    my $Params = $StatsObject->GetParams( StatID => '123' );

=cut

sub GetParams {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StatID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need StatID!'
        );
        return;
    }

    my $Stat = $Self->StatsGet( StatID => $Param{StatID} );

    # static
    # don't remove this if clause, because is required for otrs.GenerateStats.pl
    my @Params;
    if ( $Stat->{StatType} eq 'static' ) {

        # load static modul
        my $ObjectModule = $Stat->{ObjectModule};
        return if !$Self->{MainObject}->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );
        return if !$StatObject;

        # get params
        @Params = $StatObject->Param();
    }
    return \@Params;
}

=item StatsRun()

run a statistic.

    my $StatArray = $StatsObject->StatsRun(
        StatID     => '123',
        GetParam   => \%GetParam,
    );

=cut

sub StatsRun {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEED:
    for my $Need (qw(StatID GetParam)) {
        next NEED if $Param{$Need};
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Need!"
        );
        return;
    }

    # use the mirror db if configured
    if ( $Self->{ConfigObject}->Get('Core::MirrorDB::DSN') ) {
        my $ExtraDatabaseObject = Kernel::System::DB->new(
            LogObject    => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            EncodeObject => $Self->{EncodeObject},
            DatabaseDSN  => $Self->{ConfigObject}->Get('Core::MirrorDB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Core::MirrorDB::User'),
            DatabasePw   => $Self->{ConfigObject}->Get('Core::MirrorDB::Password'),
        );
        if ( !$ExtraDatabaseObject ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'There is no MirroDB!',
            );
            return;
        }
        $Self->{DBObject} = $ExtraDatabaseObject;
    }

    my $Stat = $Self->StatsGet( StatID => $Param{StatID} );
    my %GetParam = %{ $Param{GetParam} };
    my @Result;

    # get data if it is a static stats
    if ( $Stat->{StatType} eq 'static' ) {
        @Result = $Self->_GenerateStaticStats(
            ObjectModule => $Stat->{ObjectModule},
            GetParam     => $Param{GetParam},
            Title        => $Stat->{Title},
            StatID       => $Stat->{StatID},
            Cache        => $Stat->{Cache},
        );
    }

    # get data if it is a dynaymic stats
    elsif ( $Stat->{StatType} eq 'dynamic' ) {
        @Result = $Self->_GenerateDynamicStats(
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

=item StatsResultCacheCompute()

computes stats results and adds them to the cache.
This can be used to precompute stats data e. g. for dashboard widgets in a cron job.

    my $StatArray = $StatsObject->StatsResultCacheCompute(
        StatID       => '123',
        UserGetParam => \%UserGetParam, # user settings of non-fixed fields
    );

=cut

sub StatsResultCacheCompute {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(StatID UserGetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my %GetParam = $Self->_StatsParamsGenerate(%Param);
    return if !%GetParam;

    my $CacheKey = "StatsRunCached::$Self->{UserID}::$Param{StatID}::";
    $CacheKey .= $Self->{MainObject}->Dump( \%GetParam );

    my $Result = $Self->StatsRun(
        StatID   => $Param{StatID},
        GetParam => \%GetParam,
    );

    # Only set/update the cache after computing it, otherwise no cache data
    #   would be available in between.
    return $Self->{CacheObject}->Set(
        Type  => 'StatsRun',
        Key   => $CacheKey,
        Value => $Result,
        TTL   => 24 * 60 * 60,    # cache it for a day, will be overwritten by next function call
    );
}

=item StatsResultCacheGet()

gets cached statistic results. Will never run the statistic.
This can be used to fetch cached stats data e. g. for stats widgets in the dashboard.

    my $StatArray = $StatsObject->StatsResultCacheGet(
        StatID       => '123',
        GetParam     => \%GetParam,
    );

=cut

sub StatsResultCacheGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(StatID UserGetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my %GetParam = $Self->_StatsParamsGenerate(%Param);
    return if !%GetParam;

    my $CacheKey = "StatsRunCached::$Self->{UserID}::$Param{StatID}::";
    $CacheKey .= $Self->{MainObject}->Dump( \%GetParam );

    return $Self->{CacheObject}->Get(
        Type => 'StatsRun',
        Key  => $CacheKey,
    );
}

# This internal function gets the full stats parameters merged with the user's
#   parameters.
sub _StatsParamsGenerate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(StatID UserGetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my %UserGetParam = %{ $Param{UserGetParam} };

    my $Stat = $Self->StatsGet( StatID => $Param{StatID} );
    if ( !IsHashRefWithData($Stat) ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "Could not load stat $Param{StatID}!" );
    }

    # Get current date for static stats.
    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    # get params
    my %GetParam;

    my %TimeInSeconds = (
        Year   => 31536000,    # 60 * 60 * 60 * 365
        Month  => 2592000,     # 60 * 60 * 24 * 30
        Week   => 604800,      # 60 * 60 * 24 * 7
        Day    => 86400,       # 60 * 60 * 24
        Hour   => 3600,        # 60 * 60
        Minute => 60,
        Second => 1,
    );

    # not sure, if this is the right way
    if ( $Stat->{StatType} eq 'static' ) {
        $GetParam{Year}  = $Y;
        $GetParam{Month} = $M;
        $GetParam{Day}   = $D;

        my $Params = $Self->GetParams( StatID => $Param{StatID} );
        PARAMITEM:
        for my $ParamItem ( @{$Params} ) {

            next if !defined $UserGetParam{ $ParamItem->{Name} };

            # param is array
            if ( $ParamItem->{Multiple} ) {
                $GetParam{ $ParamItem->{Name} } = $UserGetParam{ $ParamItem->{Name} } || [];
                next PARAMITEM;
            }

            # param is string
            $GetParam{ $ParamItem->{Name} } = $UserGetParam{ $ParamItem->{Name} };
        }
    }
    else {
        my $TimePeriod = 0;

        for my $Use (qw(UseAsRestriction UseAsXvalue UseAsValueSeries)) {
            $Stat->{$Use} ||= [];

            my @Array   = @{ $Stat->{$Use} };
            my $Counter = 0;
            ELEMENT:
            for my $Element (@Array) {
                next ELEMENT if !$Element->{Selected};

                if ( !$Element->{Fixed} ) {
                    if ( $UserGetParam{ $Use . $Element->{Element} } )
                    {
                        if ( ref $UserGetParam{ $Use . $Element->{Element} } ) {
                            $Element->{SelectedValues}
                                = $UserGetParam{ $Use . $Element->{Element} };
                        }
                        else {
                            $Element->{SelectedValues}
                                = [ $UserGetParam{ $Use . $Element->{Element} } ];
                        }
                    }
                    if ( $Element->{Block} eq 'Time' ) {

                        # Check if it is an absolute time period
                        if ( $Element->{TimeStart} )
                        {

                            # Use the stat data as fallback
                            my %Time = (
                                TimeStart => $Element->{TimeStart},
                                TimeStop  => $Element->{TimeStop},
                            );

                            for my $Limit (qw(Start Stop)) {
                                for my $Unit (qw(Year Month Day Hour Minute Second)) {
                                    if (
                                        defined(
                                            $UserGetParam{
                                                $Use
                                                    . $Element->{Element}
                                                    . "$Limit$Unit"
                                                }
                                        )
                                        )
                                    {
                                        $Time{ $Limit . $Unit }
                                            = $UserGetParam{
                                            $Use
                                                . $Element->{Element}
                                                . "$Limit$Unit"
                                            };
                                    }
                                }
                                if ( !defined( $Time{ $Limit . 'Hour' } ) ) {
                                    if ( $Limit eq 'Start' ) {
                                        $Time{StartHour}   = 0;
                                        $Time{StartMinute} = 0;
                                        $Time{StartSecond} = 0;
                                    }
                                    elsif ( $Limit eq 'Stop' ) {
                                        $Time{StopHour}   = 23;
                                        $Time{StopMinute} = 59;
                                        $Time{StopSecond} = 59;
                                    }
                                }
                                elsif ( !defined( $Time{ $Limit . 'Second' } ) ) {
                                    if ( $Limit eq 'Start' ) {
                                        $Time{StartSecond} = 0;
                                    }
                                    elsif ( $Limit eq 'Stop' ) {
                                        $Time{StopSecond} = 59;
                                    }
                                }
                                if ( $Time{ $Limit . 'Year' } ) {
                                    $Time{"Time$Limit"} = sprintf(
                                        "%04d-%02d-%02d %02d:%02d:%02d",
                                        $Time{ $Limit . 'Year' },
                                        $Time{ $Limit . 'Month' },
                                        $Time{ $Limit . 'Day' },
                                        $Time{ $Limit . 'Hour' },
                                        $Time{ $Limit . 'Minute' },
                                        $Time{ $Limit . 'Second' },
                                    );
                                }
                            }

                            # integrate this functionality in the completenesscheck
                            if (
                                $Self->{TimeObject}->TimeStamp2SystemTime(
                                    String => $Time{TimeStart}
                                )
                                < $Self->{TimeObject}->TimeStamp2SystemTime(
                                    String => $Element->{TimeStart}
                                )
                                )
                            {

                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message =>
                                        "User StartTime $Time{TimeStart} is before configured StartTime $Element->{TimeStart}!",
                                );

                                return;
                            }

                            # integrate this functionality in the completenesscheck
                            if (
                                $Self->{TimeObject}->TimeStamp2SystemTime(
                                    String => $Time{TimeStop}
                                )
                                > $Self->{TimeObject}->TimeStamp2SystemTime(
                                    String => $Element->{TimeStop}
                                )
                                )
                            {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message =>
                                        "User StopTime $Time{TimeStop} is after configured StopTime $Element->{TimeStop}!",
                                );

                                return;
                            }

                            $Element->{TimeStart} = $Time{TimeStart};
                            $Element->{TimeStop}  = $Time{TimeStop};
                            $TimePeriod
                                = (
                                $Self->{TimeObject}->TimeStamp2SystemTime(
                                    String => $Element->{TimeStop}
                                    )
                                )
                                - (
                                $Self->{TimeObject}->TimeStamp2SystemTime(
                                    String => $Element->{TimeStart}
                                    )
                                );
                        }
                        else {
                            my %Time;
                            $Time{TimeRelativeUnit}
                                = $UserGetParam{ $Use . $Element->{Element} . 'TimeRelativeUnit' };
                            $Time{TimeRelativeCount}
                                = $UserGetParam{ $Use . $Element->{Element} . 'TimeRelativeCount' };

                            # Use Values of the stat as fallback
                            $Time{TimeRelativeCount} //= $Element->{TimeRelativeCount};
                            $Time{TimeRelativeUnit}  //= $Element->{TimeRelativeUnit};

                            my $TimePeriodAdmin = $Element->{TimeRelativeCount}
                                * $TimeInSeconds{ $Element->{TimeRelativeUnit} };
                            my $TimePeriodAgent = $Time{TimeRelativeCount}
                                * $TimeInSeconds{ $Time{TimeRelativeUnit} };

                            # integrate this functionality in the completenesscheck
                            if ( $TimePeriodAgent > $TimePeriodAdmin ) {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message =>
                                        "User TimePeriod is greater than allowed TimePeriod!",
                                );

                                return;
                            }

                            $TimePeriod                   = $TimePeriodAgent;
                            $Element->{TimeRelativeCount} = $Time{TimeRelativeCount};
                            $Element->{TimeRelativeUnit}  = $Time{TimeRelativeUnit};
                        }
                        if ( $UserGetParam{ $Use . $Element->{Element} . 'TimeScaleCount' } )
                        {
                            $Element->{TimeScaleCount}
                                = $UserGetParam{ $Use . $Element->{Element} . 'TimeScaleCount' };
                        }
                        else {
                            $Element->{TimeScaleCount} = 1;
                        }
                    }
                }

                $GetParam{$Use}[$Counter] = $Element;
                $Counter++;

            }
            if ( ref $GetParam{$Use} ne 'ARRAY' ) {
                $GetParam{$Use} = [];
            }
        }

        # check if the timeperiod is too big or the time scale too small
        if (
            $GetParam{UseAsXvalue}[0]{Block} eq 'Time'
            && (
                !$GetParam{UseAsValueSeries}[0]
                || (
                    $GetParam{UseAsValueSeries}[0]
                    && $GetParam{UseAsValueSeries}[0]{Block} ne 'Time'
                )
            )
            )
        {
            my $ScalePeriod = $TimeInSeconds{ $GetParam{UseAsXvalue}[0]{SelectedValues}[0] } || 0;

            # integrate this functionality in the completenesscheck
            if (
                $TimePeriod / ( $ScalePeriod * $GetParam{UseAsXvalue}[0]{TimeScaleCount} )
                > ( $Self->{ConfigObject}->Get('Stats::MaxXaxisAttributes') || 1000 )
                )
            {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "The reporting time interval is too small, please use a larger time scale!",
                );

                return;
            }
        }
    }

    return %GetParam;
}

=item StringAndTimestamp2Filename()

builds a filename with a string and a timestamp.
(space will be replaced with _ and - e.g. Title-of-File_2006-12-31_11-59)

    my $Filename = $StatsObject->StringAndTimestamp2Filename( String => 'Title' );

=cut

sub StringAndTimestamp2Filename {
    my ( $Self, %Param ) = @_;

    if ( !$Param{String} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need String!'
        );
        return;
    }

    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $M = sprintf( "%02d", $M );
    $D = sprintf( "%02d", $D );
    $h = sprintf( "%02d", $h );
    $m = sprintf( "%02d", $m );

    $Param{String} = $Self->{MainObject}->FilenameCleanUp(
        Filename => $Param{String},
        Type     => 'Attachment',
    );

    my $Filename = $Param{String} . '_' . "$Y-$M-$D" . '_' . "$h-$m";

    return $Filename;
}

=item StatNumber2StatID()

insert the stat number get the stat id

    my $StatID = $StatsObject->StatNumber2StatID(
        StatNumber => 11212,
    );

=cut

sub StatNumber2StatID {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StatNumber} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need StatNumber!',
        );
        return;
    }

    my @Key = $Self->{XMLObject}->XMLHashSearch(
        Type => 'Stats',
        What => [ { "[%]{'otrs_stats'}[%]{'StatNumber'}[%]{'Content'}" => $Param{StatNumber} } ],
    );
    if ( @Key && $#Key < 1 ) {
        return $Key[0];
    }

    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => 'StatNumber invalid!',
    );
    return;
}

=item StatsInstall()

installs stats

    my $Result = $StatsObject->StatsInstall(
        FilePrefix => 'FAQ',  # (optional)
    );

=cut

sub StatsInstall {
    my ( $Self, %Param ) = @_;

    # prepare prefix
    $Param{FilePrefix} = $Param{FilePrefix} ? $Param{FilePrefix} . '-' : '';

    # start AutomaticSampleImport if no stats are installed
    $Self->GetStatsList();

    # cleanup stats
    $Self->StatsCleanUp();

    # get list of stats files
    my @StatsFileList = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{StatsTempDir},
        Filter    => $Param{FilePrefix} . '*.xml',
    );

    # import the stats
    my $InstalledPostfix = '.installed';
    FILE:
    for my $File ( sort @StatsFileList ) {

        next FILE if !-f $File;
        next FILE if -e $File . $InstalledPostfix;

        # read file content
        my $XMLContentRef = $Self->{MainObject}->FileRead(
            Location => $File,
        );

        # import stat
        my $StatID = $Self->Import(
            Content => ${$XMLContentRef},
        );

        next FILE if !$StatID;

        # write installed file with stat id
        $Self->{MainObject}->FileWrite(
            Content  => \$StatID,
            Location => $File . $InstalledPostfix,
        );
    }

    return 1;
}

=item StatsUninstall()

uninstalls stats

    my $Result = $StatsObject->StatsUninstall(
        FilePrefix => 'FAQ',  # (optional)
    );

=cut

sub StatsUninstall {
    my ( $Self, %Param ) = @_;

    # prepare prefix
    $Param{FilePrefix} = $Param{FilePrefix} ? $Param{FilePrefix} . '-' : '';

    # get list of installed stats files
    my @StatsFileList = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{StatsTempDir},
        Filter    => $Param{FilePrefix} . '*.xml.installed',
    );

    # delete the stats
    for my $File ( sort @StatsFileList ) {

        # read file content
        my $StatsIDRef = $Self->{MainObject}->FileRead(
            Location => $File,
        );

        # delete stats
        $Self->StatsDelete(
            StatID => ${$StatsIDRef},
        );
    }

    # cleanup stats
    $Self->StatsCleanUp();

    return 1;
}

=item StatsCleanUp()

removed stats with not existing backend file

    my $Result = $StatsObject->StatsCleanUp();

=cut

sub StatsCleanUp {
    my $Self = shift;

    # get a list of all stats
    my $ListRef = $Self->GetStatsList();

    return if !$ListRef;
    return if ref $ListRef ne 'ARRAY';

    STATSID:
    for my $StatsID ( @{$ListRef} ) {

        # get stats
        my $HashRef = $Self->StatsGet(
            StatID             => $StatsID,
            NoObjectAttributes => 1,
        );

        next STATSID if $HashRef
                && ref $HashRef eq 'HASH'
                && $HashRef->{ObjectModule}
                && $Self->{MainObject}->Require( $HashRef->{ObjectModule} );

        # delete stats
        $Self->StatsDelete( StatID => $StatsID );
    }

    return 1;
}

=begin Internal:

=item _GenerateStaticStats()

    take the stat configuration and get the stat table

    my @StatArray = $StatsObject->_GenerateStaticStats(
        ObjectModule => $Stat->{ObjectModule},
        GetParam     => $Param{GetParam},
        Title        => $Stat->{Title},
        StatID       => $Stat->{StatID},
        Cache        => $Stat->{Cache},
    );

=cut

sub _GenerateStaticStats {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEED:
    for my $Need (qw(ObjectModule GetParam Title StatID)) {
        next NEED if $Param{$Need};
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Need!"
        );
        return;
    }

    # load static module
    my $ObjectModule = $Param{ObjectModule};
    return if !$Self->{MainObject}->Require($ObjectModule);
    my $StatObject = $ObjectModule->new( %{$Self} );
    return if !$StatObject;

    my @Result;
    my %GetParam = %{ $Param{GetParam} };

    # use result cache if configured
    if ( $Param{Cache} ) {
        my $Filename = $Self->_CreateStaticResultCacheFilename(
            GetParam => \%GetParam,
            StatID   => $Param{StatID},
        );

        @Result = $Self->_GetResultCache( Filename => $Filename );
        if (@Result) {
            return @Result;
        }
    }

    # run stats function
    @Result = $StatObject->Run(
        %GetParam,

        # these two lines are requirements of me, perhaps this
        # information is needed for former static stats
        Format => $Param{Format}->[0],
        Module => $Param{ObjectModule},
    );

    $Result[0]->[0] = $Param{Title} . ' ' . $Result[0]->[0];

    # write cache if configured
    if ( $Param{Cache} ) {
        $Self->_WriteResultCache(
            GetParam => \%GetParam,
            StatID   => $Param{StatID},
            Data     => \@Result,
        );
    }

    return @Result;
}

=item _GenerateDynamicStats()

    take the stat configuration and get the stat table

    my @StatArray = $StatsObject->_GenerateDynamicStats(
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

sub _GenerateDynamicStats {
    my ( $Self, %Param ) = @_;

    my @HeaderLine;
    my $TitleTimeStart = '';
    my $TitleTimeStop  = '';

    NEED:
    for my $Need (qw(ObjectModule UseAsXvalue UseAsValueSeries Title Object StatID)) {
        next NEED if $Param{$Need};
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Need!"
        );
        return;
    }

    # include the needed dynamic object
    my $ObjectModule = $Param{ObjectModule};
    return if !$Self->{MainObject}->Require($ObjectModule);
    my $StatObject = $ObjectModule->new( %{$Self} );
    return if !$StatObject;

    # get the selected values
    # perhaps i can split the StatGet function to make this needless
    # Problem, i need the block information
    my %NewParam;

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

            # Clone the element as we are going to modify it - avoid modifying the original data
            $Element = ${ Storable::dclone( \$Element ) };

            delete $Element->{Selected};
            delete $Element->{Fixed};
            if ( $Element->{Block} eq 'Time' ) {
                delete $Element->{TimePeriodFormat};
                if ( $Element->{TimeRelativeUnit} ) {
                    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
                        SystemTime => $Self->{TimeObject}->SystemTime(),
                    );

                    my $Count = $Element->{TimeRelativeCount} ? $Element->{TimeRelativeCount} : 1;

                    # -1 because the current time will be not counted
                    $Count -= 1;

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
                    elsif ( $Element->{TimeRelativeUnit} eq 'Week' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, 0, 0 );
                        $Element->{TimeStop} = sprintf(
                            "%04d-%02d-%02d %02d:%02d:%02d",
                            $Y, $M, $D, 23, 59, 59
                        );

                        # $Count was reduced by 1 before, this has to be reverted for Week
                        #     Examples:
                        #     Week set to 1, $Count will be 0 then - 0 * 7 = 0 (means today)
                        #     Week set to 2, $Count will be 1 then - 1 * 7 = 7 (means last week)
                        #     With the fix, example 1 will mean last week and example 2 will mean
                        #     last two weeks
                        $Count++;
                        ( $Y, $M, $D ) = Add_Delta_Days( $Y, $M, $D, -$Count * 7 );
                        $Element->{TimeStart}
                            = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, 0, 0, 0 );
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
                    delete $Element->{TimeRelativeUnit};
                    delete $Element->{TimeRelativeCount};
                }
                $TitleTimeStart = $Element->{TimeStart};
                $TitleTimeStop  = $Element->{TimeStop};
            }

            # Select All function needed from otrs.GenerateStats.pl and fixed values of the frontend
            elsif ( !$Element->{SelectedValues}[0] ) {
                my @Values = keys( %{ $Element->{Values} } );
                $Element->{SelectedValues} = \@Values;
            }
            push @{ $NewParam{$Use} }, $Element;
        }
    }

    %Param = %NewParam;

    # get all restrictions for the search
    my %RestrictionAttribute;
    for my $RestrictionPart ( @{ $Param{UseAsRestriction} } ) {
        my $Element = $RestrictionPart->{Element};
        if ( $RestrictionPart->{Block} eq 'InputField' ) {
            $RestrictionAttribute{$Element} = $RestrictionPart->{SelectedValues}[0];
        }
        elsif ( $RestrictionPart->{Block} eq 'SelectField' ) {
            $RestrictionAttribute{$Element} = $RestrictionPart->{SelectedValues}[0];
        }
        elsif ( $RestrictionPart->{Block} eq 'Time' ) {
            $RestrictionAttribute{ $RestrictionPart->{Values}{TimeStop} }
                = $RestrictionPart->{TimeStop};
            $RestrictionAttribute{ $RestrictionPart->{Values}{TimeStart} }
                = $RestrictionPart->{TimeStart};
        }
        else {
            $RestrictionAttribute{$Element} = $RestrictionPart->{SelectedValues};
        }
    }

    # get the selected Xvalue
    my $Xvalue = {};
    my (
        $VSYear,     $VSMonth,     $VSDay,     $VSHour,     $VSMinute,     $VSSecond,
        $VSStopYear, $VSStopMonth, $VSStopDay, $VSStopHour, $VSStopMinute, $VSStopSecond
    );
    my $TimeAbsolutStopUnixTime = 0;
    my $Count                   = 0;
    my $MonthArrayRef           = _MonthArray();

    my $Element = $Param{UseAsXvalue}[0];
    if ( $Element->{Block} eq 'Time' ) {
        my (
            $Year,   $Month,   $Day,   $Hour,   $Minute,   $Second,
            $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond
        );
        if ( $Element->{TimeStart} =~ m{^(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)$}ix ) {
            $Year   = $VSYear   = $1;
            $Month  = $VSMonth  = int $2;
            $Day    = $VSDay    = int $3;
            $Hour   = $VSHour   = int $4;
            $Minute = $VSMinute = int $5;
            $Second = $VSSecond = int $6;
        }

        $TimeAbsolutStopUnixTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Element->{TimeStop},
        );
        my $TimeStart = 0;
        my $TimeStop  = 0;

        $Count = $Element->{TimeScaleCount} ? $Element->{TimeScaleCount} : 1;

        # in these constellation $Count > 1 is not useful!!
        if (
            $Param{UseAsValueSeries}[0]{Block}
            && $Param{UseAsValueSeries}[0]{Block} eq 'Time'
            && $Element->{SelectedValues}[0] eq 'Day'
            )
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
        elsif ( $Element->{SelectedValues}[0] eq 'Week' ) {
            $Second = 0;
            $Minute = 0;
            $Hour   = 0;
            ( $Year, $Month, $Day ) = Monday_of_Week( Week_of_Year( $Year, $Month, $Day ) )
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

        # FIXME Timeheader zusammenbauen
        while (
            !$TimeStop
            || $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
            < $TimeAbsolutStopUnixTime
            )
        {
            $TimeStart = sprintf(
                "%04d-%02d-%02d %02d:%02d:%02d",
                $Year, $Month, $Day, $Hour, $Minute, $Second
            );
            if ( $Element->{SelectedValues}[0] eq 'Second' ) {
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $Year, $Month, $Day, $Hour, $Minute, $Second, 0, 0, 0,
                    $Count - 1
                    );
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
                    = Add_Delta_DHMS(
                    $Year, $Month, $Day, $Hour, $Minute, $Second, 0, 0, $Count,
                    -1
                    );
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
                    = Add_Delta_DHMS(
                    $Year, $Month, $Day, $Hour, $Minute, $Second, 0, $Count, 0,
                    -1
                    );
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
                    = Add_Delta_DHMS(
                    $Year, $Month, $Day, $Hour, $Minute, $Second, $Count, 0, 0,
                    -1
                    );
                my $Dow = Day_of_Week( $Year, $Month, $Day );
                $Dow = Day_of_Week_Abbreviation($Dow);
                if ( $ToDay eq $Day ) {
                    push @HeaderLine, "$Dow $Day";
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
            elsif ( $Element->{SelectedValues}[0] eq 'Week' ) {
                ( $ToYear, $ToMonth, $ToDay )
                    = Add_Delta_YMD( $Year, $Month, $Day, 0, 0, $Count * 7 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $Hour, $Minute, $Second, 0, 0, 0,
                    -1
                    );
                my %WeekNum;
                ( $WeekNum{Week}, $WeekNum{Year} ) = Week_of_Year( $Year, $Month, $Day );
                push(
                    @HeaderLine,
                    sprintf( "Week %02d-%04d - ", $WeekNum{Week}, $WeekNum{Year} ) .
                        sprintf(
                        "%02d.%02d.%04d - %02d.%02d.%04d",
                        $Day, $Month, $Year, $ToDay, $ToMonth, $ToYear
                        )
                );
            }
            elsif ( $Element->{SelectedValues}[0] eq 'Month' ) {
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_YMD( $Year, $Month, $Day, 0, $Count, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $Hour, $Minute, $Second, 0, 0, 0,
                    -1
                    );
                if ( $ToMonth eq $Month ) {
                    push @HeaderLine, "$MonthArrayRef->[$Month] $Month";
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
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $Hour, $Minute, $Second, 0, 0, 0,
                    -1
                    );
                if ( $ToYear eq $Year ) {
                    push @HeaderLine, $Year;
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
                = Add_Delta_DHMS(
                $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0, 0, 0,
                1
                );
            $TimeStop = sprintf(
                "%04d-%02d-%02d %02d:%02d:%02d",
                $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond
            );
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
    my %ValueSeries;
    my @ArraySelected;
    my $ColumnName = '';

    # give me all possible elements for Value Series
    REF1:
    for my $Ref1 ( @{ $Param{UseAsValueSeries} } ) {

        # all elements which are shown with multiselectfields
        if ( $Ref1->{Block} ne 'Time' ) {
            my %SelectedValues;
            for my $Ref2 ( @{ $Ref1->{SelectedValues} } ) {
                $SelectedValues{$Ref2} = $Ref1->{Values}{$Ref2};
            }
            push(
                @ArraySelected,
                {
                    Values  => \%SelectedValues,
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
                    push @HeaderLine, "$MonthArrayRef->[$_] $_";
                }
            }
            else {
                for ( my $Month = 1; $Month < 12; $Month += $Count ) {
                    push(
                        @HeaderLine,
                        "$MonthArrayRef->[$Month] - $MonthArrayRef->[$Month + $Count - 1]"
                    );
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

            for my $Count ( 1 .. 31 ) {
                push @HeaderLine, $Count;
            }

            $VSSecond   = 0;
            $VSMinute   = 0;
            $VSHour     = 0;
            $VSDay      = 1;
            $ColumnName = 'Month';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Week' ) {

            for my $Count ( 1 .. 7 ) {
                push @HeaderLine, Day_of_Week_to_Text($Count);
            }

            $VSSecond   = 0;
            $VSMinute   = 0;
            $VSHour     = 0;
            $ColumnName = 'Week';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Day' ) {
            for ( my $Hour = 0; $Hour < 24; $Hour += $Count ) {
                push @HeaderLine, sprintf( "%02d:00:00-%02d:59:59", $Hour, $Hour + $Count - 1 );
            }
            $VSSecond   = 0;
            $VSMinute   = 0;
            $VSHour     = 0;
            $ColumnName = 'Day';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Hour' ) {
            for ( my $Minute = 0; $Minute < 60; $Minute += $Count ) {
                my $Time = 'min ' . $Minute . ' - ' . ( $Minute + $Count );
                push @HeaderLine, $Time;
            }
            $VSSecond   = 0;
            $VSMinute   = 0;
            $ColumnName = 'Hour';
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Minute' ) {
            if ( $Count == 1 ) {
                for ( 0 .. 59 ) {
                    my $Time = 'sec ' . $_;
                    push @HeaderLine, $Time;
                }
            }
            else {
                for ( my $Second = 0; $Second < 60; $Second += $Count ) {
                    my $Time = 'sec ' . $Second . '-' . ( $Second + $Count );
                    push @HeaderLine, $Time;
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
            while (
                $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf( "%04d-01-01 00:00:00", $VSYear );
                ( $ToYear, $ToMonth, $ToDay )
                    = Add_Delta_YMD( $VSYear, $VSMonth, $VSDay, $Count, 0, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, 0, -1
                    );
                $TimeStop = sprintf( "%04d-12-31 23:59:59", $ToYear );

                $ValueSeries{$VSYear} = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                    );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Month' ) {
            while (
                $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf( "%04d-%02d-01 00:00:00", $VSYear, $VSMonth );
                ( $ToYear, $ToMonth, $ToDay )
                    = Add_Delta_YMD( $VSYear, $VSMonth, $VSDay, 0, $Count, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, 0, -1
                    );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                #                    if ($Count == 1) {
                $ValueSeries{
                    $VSYear . '-'
                        . sprintf( "%02d", $VSMonth ) . ' '
                        . $MonthArrayRef->[$VSMonth]
                    }
                    = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                    );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Week' ) {
            while (
                $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                my @Monday = Monday_of_Week( Week_of_Year( $VSYear, $VSMonth, $VSDay ) );

                $TimeStart = sprintf( "%04d-%02d-%02d 00:00:00", @Monday );
                ( $ToYear, $ToMonth, $ToDay )
                    = Add_Delta_Days( @Monday, 6 );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                $ValueSeries{
                    $VSYear . '-'
                        . sprintf( "%02d", $VSMonth ) . ' '
                        . $MonthArrayRef->[$VSMonth]
                    }
                    = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                    );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Day' ) {
            while (
                $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf( "%04d-%02d-%02d 00:00:00", $VSYear, $VSMonth, $VSDay );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond,
                    $Count, 0, 0, -1
                    );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                #                    if ($Count == 1) {
                $ValueSeries{ sprintf( "%04d-%02d-%02d", $VSYear, $VSMonth, $VSDay ) } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                    );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Hour' ) {
            while (
                $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart
                    = sprintf( "%04d-%02d-%02d %02d:00:00", $VSYear, $VSMonth, $VSDay, $VSHour );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond, 0,
                    $Count, 0, -1
                    );
                $TimeStop
                    = sprintf( "%04d-%02d-%02d %02d:59:59", $ToYear, $ToMonth, $ToDay, $ToHour );
                $ValueSeries{
                    sprintf(
                        "%04d-%02d-%02d %02d:00:00 - %02d:59:59",
                        $VSYear, $VSMonth, $VSDay, $VSHour, $ToHour
                        )
                    }
                    = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };
                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                    );
            }
        }

        elsif ( $Ref1->{SelectedValues}[0] eq 'Minute' ) {
            while (
                $Self->{TimeObject}->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf(
                    "%04d-%02d-%02d %02d:%02d:00",
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute
                );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond )
                    = Add_Delta_DHMS(
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, $Count, -1
                    );
                $TimeStop = sprintf(
                    "%04d-%02d-%02d %02d:%02d:59",
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute
                );
                $ValueSeries{
                    sprintf(
                        "%04d-%02d-%02d %02d:%02d:00 - %02d:%02d:59",
                        $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $ToHour, $ToMinute
                        )
                    }
                    = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };
                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond )
                    = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                    );
            }

        }
    }

    # merge the array if two elements for the valueseries are avialable
    if ( $ArraySelected[0] ) {
        KEY:
        for my $Key ( sort keys %{ $ArraySelected[0]{Values} } ) {
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

            for my $SubKey ( sort keys %{ $ArraySelected[1]{Values} } ) {
                my $Value1;
                if ( $ArraySelected[1]{Block} eq 'SelectField' ) {
                    $Value1 = $SubKey;
                }
                elsif ( $ArraySelected[1]{Block} eq 'MultiSelectField' ) {
                    $Value1 = [$SubKey];
                }
                $ValueSeries{
                    $ArraySelected[0]{Values}{$Key} . ' - '
                        . $ArraySelected[1]{Values}{$SubKey}
                    }
                    = {
                    $ArraySelected[0]{Element} => $Value0,
                    $ArraySelected[1]{Element} => $Value1
                    };
            }
        }
    }

    # Use this if no valueseries available
    if ( !%ValueSeries ) {
        $ValueSeries{ $Param{Object} . 's' } = undef;
    }

    # get the first column name in the headerline
    if ($ColumnName) {
        unshift @HeaderLine, $ColumnName;
    }
    elsif ( $ArraySelected[1] ) {
        unshift( @HeaderLine, $ArraySelected[0]{Name} . ' - ' . $ArraySelected[1]{Name} );
    }
    elsif ( $ArraySelected[0] ) {
        unshift( @HeaderLine, $ArraySelected[0]{Name} || '' );
    }
    else {

        # in cases where there is no value set, then the headers get wrong unless a empty element
        #    is added in the header, bug 9796
        #
        #   e.g. from:
        #    Raw    | Misc | PostMaster |    |
        #    Ticket | 10   | 20         | 30 |
        #
        #    to:
        #           | Raw | Misc | PostMaster |
        #    Ticket | 10  | 20   | 30         |
        unshift( @HeaderLine, '' );
    }

    # push the first array elements in the StatsArray
    my $Title = $Param{Title};
    if ( $TitleTimeStart && $TitleTimeStop ) {
        $Title .= " $TitleTimeStart-$TitleTimeStop";
    }

    # create the cache string
    my $CacheString = $Self->_GetCacheString(%Param);

    # take the cache value if configured and available
    if ( $Param{Cache} ) {
        my @StatArray = $Self->_GetResultCache(
            Filename => 'Stats' . $Param{StatID} . '-' . $CacheString . '.cache',
        );

        if (@StatArray) {
            return @StatArray;
        }
    }

    # create the table structure
    my %TableStructure;
    for my $Row ( sort keys %ValueSeries ) {
        my @Cells;
        for my $Cell ( @{ $Xvalue->{SelectedValues} } ) {    # get each cell
            $ValueSeries{$Row} ||= {};
            my %Attributes = ( %{ $ValueSeries{$Row} }, %RestrictionAttribute );

            # the following is necessary if as x-axis and as value-series time is selected
            if ( $Xvalue->{Block} eq 'Time' ) {
                my $TimeStart = $Xvalue->{Values}{TimeStart};
                my $TimeStop  = $Xvalue->{Values}{TimeStop};
                if ( $ValueSeries{$Row}{$TimeStop} && $ValueSeries{$Row}{$TimeStart} ) {
                    if (
                        $Self->{TimeObject}->TimeStamp2SystemTime( String => $Cell->{TimeStop} )
                        > $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $ValueSeries{$Row}{$TimeStop}
                        )
                        || $Self->{TimeObject}->TimeStamp2SystemTime( String => $Cell->{TimeStart} )
                        < $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $ValueSeries{$Row}{$TimeStart}
                        )
                        )
                    {
                        next;
                    }
                }
                $Attributes{$TimeStop}  = $Cell->{TimeStop};
                $Attributes{$TimeStart} = $Cell->{TimeStart};
            }
            elsif ( $Xvalue->{Block} eq 'SelectField' ) {
                $Attributes{ $Xvalue->{Element} } = $Cell;
            }
            else {
                $Attributes{ $Xvalue->{Element} } = [$Cell];
            }
            push @Cells, \%Attributes;
        }
        $TableStructure{$Row} = \@Cells;
    }

    my @DataArray;
    if ( $StatObject->can('GetStatTable') ) {

        # get the whole stats table
        @DataArray = $StatObject->GetStatTable(
            ValueSeries    => $Param{UseAsValueSeries},    #\%ValueSeries,
            XValue         => $Xvalue,
            Restrictions   => \%RestrictionAttribute,
            TableStructure => \%TableStructure,
        );
    }
    else {
        for my $Row ( sort keys %TableStructure ) {
            my @ResultRow = ($Row);
            for my $Cell ( @{ $TableStructure{$Row} } ) {
                my $Quantity = $StatObject->GetStatElement( %{$Cell} );
                push @ResultRow, $Quantity;
            }
            push @DataArray, \@ResultRow;
        }
    }

    # fill up empty array elements, e.g month as value series (February has 28 day and Januar 31)
    for my $Row (@DataArray) {
        for my $Index ( 1 .. $#HeaderLine ) {
            if ( !defined $Row->[$Index] ) {
                $Row->[$Index] = '';
            }
        }
    }

    # REMARK: it could be also useful to use the indiviual sort if difined
    # so you don't need this function
    if ( $StatObject->can('GetHeaderLine') ) {
        my $HeaderRef = $StatObject->GetHeaderLine(
            XValue => $Xvalue,
        );

        if ($HeaderRef) {
            @HeaderLine = @{$HeaderRef};
        }
    }

    my @StatArray = ( [$Title], \@HeaderLine, @DataArray );

    return @StatArray if !$Param{Cache};

    # check if we should cache this result
    if ( !$TitleTimeStart || !$TitleTimeStop ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't cache: StatID $Param{StatID} has no time period, so you can't cache the stat!",
        );
        return @StatArray;
    }

    if (
        $Self->{TimeObject}->TimeStamp2SystemTime( String => $TitleTimeStop )
        > $Self->{TimeObject}->SystemTime()
        )
    {

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't cache StatID $Param{StatID}: The selected end time is in the future!",
        );
        return @StatArray;
    }

    # write the stats cache
    $Self->_SetResultCache(
        Filename => 'Stats' . $Param{StatID} . '-' . $CacheString . '.cache',
        Result   => \@StatArray,
    );
    return @StatArray;
}

sub _WriteResultCache {
    my ( $Self, %Param ) = @_;

    my %GetParam = %{ $Param{GetParam} };

    # check if we should cache this result
    # get the current time
    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    # if get params in future do not cache
    if ( $GetParam{Year} && $GetParam{Month} ) {
        return if $GetParam{Year} > $Y;
        return if $GetParam{Year} == $Y && $GetParam{Month} > $M;
        return
            if $GetParam{Year} == $Y
                && $GetParam{Month} == $M
                && $GetParam{Day}
                && $GetParam{Day} >= $D;
    }

    # write cache file
    my $Filename = $Self->_CreateStaticResultCacheFilename(
        GetParam => $Param{GetParam},
        StatID   => $Param{StatID},
    );

    $Self->_SetResultCache(
        Filename => $Filename,
        Result   => $Param{Data},
    );

    return 1;
}

=item _CreateStaticResultCacheFilename()

create a filename out of the GetParam information and the stat id

    my $Filename = $StatsObject->_CreateStaticResultCacheFilename(
        GetParam => {
            Year  => 2008,
            Month => 3,
            Day   => 5
        },
        StatID   => $Param{StatID},
    );

=cut

sub _CreateStaticResultCacheFilename {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $NeededParam (qw( StatID GetParam )) {
        if ( !$Param{$NeededParam} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $NeededParam!"
            );
            return;
        }
    }

    my $GetParamRef = $Param{GetParam};

    # format month and day params
    for (qw(Month Day)) {
        if ( $GetParamRef->{$_} ) {
            $GetParamRef->{$_} = sprintf( "%02d", $GetParamRef->{$_} );
        }
    }

    my $Key = '';
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

=item _SetResultCache()

cache the stats result with a given cache key (Filename).

    $StatsObject->_SetResultCache(
        Filename => 'Stats' . $Param{StatID} . '-' . $MD5Key . '.cache',
        Result   => $Param{Data},
    );

=cut

sub _SetResultCache {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $NeededParam (qw( Filename Result)) {
        if ( !$Param{$NeededParam} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $NeededParam!"
            );
            return;
        }
    }

    $Self->{CacheObject}->Set(
        Type  => 'StatsRun',
        Key   => $Param{Filename},
        Value => $Param{Result},
        TTL   => 24 * 60 * 60,
    );

    return 1;
}

=item _GetResultCache()

get stats result from cache, if any

    my @Result = $StatsObject->_GetResultCache(
        Filename => 'Stats' . $Param{StatID} . '-' . $MD5Key . '.cache',
    );

=cut

sub _GetResultCache {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Filename} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => '_GetResultCache: Need Filename!',
        );
        return;
    }

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'StatsRun',
        Key  => $Param{Filename},
    );

    if ( ref $Cache ) {

        #print STDERR "Using cache...\n";
        return @{$Cache};
    }

    #print STDERR "Not using cache...\n";
    return;
}

=item _DeleteCache()

clean up stats result cache.

=cut

sub _DeleteCache {
    my ( $Self, %Param ) = @_;

    return $Self->{CacheObject}->CleanUp(
        Type => 'Stats',
    );
}

sub _MonthArray {
    my @MonthArray = (
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    );

    return \@MonthArray;
}

sub _AutomaticSampleImport {
    my ( $Self, %Param ) = @_;

    my $Language  = $Self->{ConfigObject}->Get('DefaultLanguage');
    my $Directory = $Self->{StatsTempDir};

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
        if ( $Filename =~ m{^.*\.$Language\.xml$}x ) {
            $Flag = 1;
        }
    }

    rewinddir(DIRE);
    if ( !$Flag ) {
        $Language = 'en';
    }

    while ( defined( my $Filename = readdir DIRE ) ) {
        if ( $Filename =~ m{^.*\.$Language\.xml$}x ) {

            # check filesize
            #            my $Filesize = -s $Directory.$Filename;
            #            if ($Filesize > $MaxFilesize) {
            #                print "File: $Filename too big! max. $MaxFilesize byte allowed.\n";
            #                $CommonObject{LogObject}->Log(
            #                    Priority => 'error',
            #                    Message => "Can't file imported: $Directory.$Filename",
            #                );
            #                next;
            #            }

            # read file
            my $Filehandle;
            if ( !open $Filehandle, '<', $Directory . $Filename ) {    ## no critic
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

=item _GetCacheString()

returns a string that can be used for caching this particular statistic
with the given parameters.

    my $Result = $StatsObject->_GetCacheString(
        UseAsXvalue      => $UseAsXvalueRef
        UseAsValueSeries => $UseAsValueSeriesRef,
        UseAsRestriction => $UseAsRestrictionRef,
    );

=cut

sub _GetCacheString {
    my ( $Self, %Param ) = @_;
    my $CacheString = '';

    for my $Use (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {
        USEREF:
        for my $UseRef ( @{ $Param{$Use} } ) {
            $CacheString .= '__' . $UseRef->{Name} . '_';
            if ( $UseRef->{SelectedValues} ) {
                $CacheString .= join( '_', sort @{ $UseRef->{SelectedValues} } )
            }
            elsif ( $UseRef->{TimeStart} && $UseRef->{TimeStop} ) {
                $CacheString .= $UseRef->{TimeStart} . '-' . $UseRef->{TimeStop};
            }
        }
    }

    my $MD5Key = $Self->{MainObject}->FilenameCleanUp(
        Filename => $CacheString,
        Type     => 'md5',
    );

    return $MD5Key;
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
