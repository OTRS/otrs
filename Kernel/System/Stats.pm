# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats;

use strict;
use warnings;

use MIME::Base64;

use Date::Pcalc
    qw(Add_Delta_YMD Add_Delta_DHMS Add_Delta_Days Days_in_Month Day_of_Week Day_of_Week_Abbreviation Day_of_Week_to_Text Monday_of_Week Week_of_Year);
use Storable qw();

use Kernel::System::VariableCheck qw(:all);
use Kernel::Output::HTML::Statistics::View;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Statistics::View',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::User',
    'Kernel::System::XML',
);

=head1 NAME

Kernel::System::Stats - stats lib

=head1 SYNOPSIS

All stats functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # temporary directory
    $Self->{StatsTempDir} = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/stats/';

    return $Self;
}

=item StatsAdd()

add new empty stats

    my $StatID = $StatsObject->StatsAdd(
        UserID => $UserID,
    );

=cut

sub StatsAdd {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    # get needed objects
    my $XMLObject  = $Kernel::OM->Get('Kernel::System::XML');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # get new StatID
    my $StatID = 1;
    my @Keys   = $XMLObject->XMLHashSearch(
        Type => 'Stats',
    );
    if (@Keys) {
        my @SortKeys = sort { $a <=> $b } @Keys;
        $StatID = $SortKeys[-1] + 1;
    }

    # requesting current time stamp
    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $TimeObject->SystemTime(),
    );

    # meta tags
    my $StatNumber = $StatID + $Kernel::OM->Get('Kernel::Config')->Get('Stats::StatsStartNumber');

    my %MetaData = (
        Created => [
            { Content => $TimeStamp },
        ],
        CreatedBy => [
            { Content => $Param{UserID} },
        ],
        Changed => [
            { Content => $TimeStamp },
        ],
        ChangedBy => [
            { Content => $Param{UserID} },
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
    my $Success = $XMLObject->XMLHashAdd(
        Type    => 'Stats',
        Key     => $StatID,
        XMLHash => \@XMLHash,
    );
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Can not add a new Stat!',
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need StatID!'
        );
    }

    $Param{NoObjectAttributes} = $Param{NoObjectAttributes} ? 1 : 0;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = "StatsGet::StatID::$Param{StatID}::NoObjectAttributes::$Param{NoObjectAttributes}";

    my $Cache = $CacheObject->Get(
        Type => 'Stats',
        Key  => $CacheKey,

        # Don't store complex structure in memory as it will be modified later.
        CacheInMemory => 0,
    );
    return $Cache if ref $Cache eq 'HASH';

    # get hash from storage
    my @XMLHash = $Kernel::OM->Get('Kernel::System::XML')->XMLHashGet(
        Type => 'Stats',
        Key  => $Param{StatID},
    );

    if ( !$XMLHash[0] ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    my $TimeElement = $Kernel::OM->Get('Kernel::Config')->Get('Stats::TimeElement') || 'Time';

    return \%Stat if !$Stat{Object};

    $Stat{ObjectName} = $Self->GetObjectName(
        ObjectModule => $Stat{ObjectModule},
    );

    if ( $Param{NoObjectAttributes} ) {

        $CacheObject->Set(
            Type  => 'Stats',
            Key   => $CacheKey,
            Value => \%Stat,
            TTL   => 24 * 60 * 60,

            # Don't store complex structure in memory as it will be modified later.
            CacheInMemory => 0,
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

    $CacheObject->Set(
        Type  => 'Stats',
        Key   => $CacheKey,
        Value => \%Stat,
        TTL   => 24 * 60 * 60,

        # Don't store complex structure in memory as it will be modified later.
        CacheInMemory => 0,
    );

    return \%Stat;
}

=item StatsUpdate()

update a stat

    $StatsObject->StatsUpdate(
        StatID => '123',
        Hash   => \%Hash,
        UserID => $UserID,
    );

=cut

sub StatsUpdate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    # declaration of the hash
    my %StatXML;

    # check necessary data
    if ( !$Param{StatID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need StatID!'
        );
    }

    # requesting stats reference
    my $StatOld = $Self->StatsGet( StatID => $Param{StatID} );
    if ( !$StatOld ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    KEY:
    for my $Key ( sort keys %{$StatOld} ) {

        # Don't store the behaviour data
        next KEY if $Key eq 'ObjectBehaviours';

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

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # meta tags
    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $TimeObject->SystemTime(),
    );
    $StatXML{Changed}->[1]->{Content}   = $TimeStamp;
    $StatXML{ChangedBy}->[1]->{Content} = $Param{UserID};

    # get xml object
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    # please don't change the functionality of XMLHashDelete and XMLHashAdd
    # into the new function XMLHashUpdate, there is an incompatibility.
    # Perhaps there are intricacies because of the 'Array[0] = undef' definition

    # delete the old record
    my $Success = $XMLObject->XMLHashDelete(
        Type => 'Stats',
        Key  => $Param{StatID},
    );
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't delete XMLHash!"
        );
        return;
    }

    # delete cache
    $Self->_DeleteCache( StatID => $Param{StatID} );

    my @Array = (
        {
            otrs_stats => [ \%StatXML ],
        },
    );

    # add the revised record
    $Success = $XMLObject->XMLHashAdd(
        Type    => 'Stats',
        Key     => $Param{StatID},
        XMLHash => \@Array
    );
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't add XMLHash!"
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need StatID!'
        );
    }

    # delete the record
    my $Success = $Kernel::OM->Get('Kernel::System::XML')->XMLHashDelete(
        Type => 'Stats',
        Key  => $Param{StatID},
    );

    # error handling
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't delete XMLHash!",
        );
        return;
    }

    # delete cache
    $Self->_DeleteCache( StatID => $Param{StatID} );

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # get list of installed stats files
    my @StatsFileList = $MainObject->DirectoryRead(
        Directory => $Self->{StatsTempDir},
        Filter    => '*.xml.installed',
    );

    # delete the .installed file in temp dir
    FILE:
    for my $File ( sort @StatsFileList ) {

        # read file content
        my $StatsIDRef = $MainObject->FileRead(
            Location => $File,
        );

        next FILE if !$StatsIDRef;
        next FILE if ref $StatsIDRef ne 'SCALAR';
        next FILE if !${$StatsIDRef};

        next FILE if ${$StatsIDRef} ne $Param{StatID};

        # delete .installed file
        $MainObject->FileDelete(
            Location => $File,
        );
    }

    # add log message
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => "Delete stats (StatsID = $Param{StatID})",
    );

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Stats',
    );

    return 1;
}

=item StatsListGet()

fetches all statistics that the current user may see

    my $StatsRef = $StatsObject->StatsListGet(
        AccessRw => 1, # Optional, indicates that user may see all statistics
        UserID   => $UserID,
    );

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

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    my @SearchResult;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Only cache the XML search as we need to filter based on user permissions later
    my $CacheKey = 'StatsListGet::XMLSearch';
    my $Cache    = $CacheObject->Get(
        Type => 'Stats',
        Key  => $CacheKey,

        # Don't store complex structure in memory as it will be modified later.
        CacheInMemory => 0,
    );

    # Do we have a cache available?
    if ( ref $Cache eq 'ARRAY' ) {
        @SearchResult = @{$Cache};
    }
    else {

        # get xml object
        my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

        # No cache. Is there stats data yet?
        if ( !( @SearchResult = $XMLObject->XMLHashSearch( Type => 'Stats' ) ) ) {

            # Import sample stats
            $Self->_AutomaticSampleImport(
                UserID => $Param{UserID},
            );

            # Load stats again
            return if !( @SearchResult = $XMLObject->XMLHashSearch( Type => 'Stats' ) );
        }
        $CacheObject->Set(
            Type  => 'Stats',
            Key   => $CacheKey,
            Value => \@SearchResult,
            TTL   => 24 * 60 * 60,

            # Don't store complex structure in memory as it will be modified later.
            CacheInMemory => 0,
        );

    }

    # get user groups
    my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
        UserID => $Param{UserID},
        Type   => 'ro',
    );

    my %Result;

    for my $StatID (@SearchResult) {

        my $Stat = $Self->StatsGet(
            StatID             => $StatID,
            NoObjectAttributes => 1,
        );

        my $UserPermission = 0;
        if ( $Param{AccessRw} || $Param{UserID} == 1 ) {

            $UserPermission = 1;
        }
        elsif ( $Stat->{Valid} ) {

            GROUPID:
            for my $GroupID ( @{ $Stat->{Permission} } ) {

                next GROUPID if !$GroupID;
                next GROUPID if !$GroupList{$GroupID};

                $UserPermission = 1;

                last GROUPID;
            }
        }

        if ( $UserPermission == 1 ) {
            $Result{$StatID} = $Stat;
        }
    }

    return \%Result;
}

=item GetStatsList()

lists all stats id's

    my $ArrayRef = $StatsObject->GetStatsList(
        AccessRw  => 1, # Optional, indicates that user may see all statistics
        OrderBy   => 'ID' || 'Title' || 'Object', # optional
        Direction => 'ASC' || 'DESC',             # optional
        UserID    => $UserID,
    );

=cut

sub GetStatsList {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    $Param{OrderBy}   ||= 'ID';
    $Param{Direction} ||= 'ASC';

    my %ResultHash = %{ $Self->StatsListGet(%Param) || {} };

    my @SortArray;

    if ( $Param{OrderBy} eq 'ID' ) {
        @SortArray = sort { $a <=> $b } keys %ResultHash;
    }
    else {
        @SortArray = sort { $ResultHash{$a}->{ $Param{OrderBy} } cmp $ResultHash{$b}->{ $Param{OrderBy} } }
            keys %ResultHash;
    }
    if ( $Param{Direction} eq 'DESC' ) {
        @SortArray = reverse @SortArray;
    }

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # load module
    my $ObjectModule = $Param{ObjectModule};
    return if !$Kernel::OM->Get('Kernel::System::Main')->Require($ObjectModule);
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
        UserID => $UserID,
    );

=cut

sub GetStaticFiles {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    if ( $Directory !~ m{^.*\/$}x ) {
        $Directory .= '/';
    }
    $Directory .= 'Kernel/System/Stats/Static/';

    if ( !opendir( DIR, $Directory ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can not open Directory: $Directory",
        );
        return ();
    }

    my %StaticFiles;
    if ( $Param{OnlyUnusedFiles} ) {

        # get all Stats from the db
        my $Result = $Self->GetStatsList(
            UserID => $Param{UserID},
        );

        if ( defined $Result ) {
            for my $StatID ( @{$Result} ) {
                my $Data = $Self->StatsGet(
                    StatID => $StatID,
                    UserID => $Param{UserID},
                );

                # check witch one are static statistics
                if ( $Data->{File} && $Data->{StatType} eq 'static' ) {
                    $StaticFiles{ $Data->{File} } = 1;
                }
            }
        }
    }

    # read files
    my %Filelist;

    DIRECTORY:
    while ( defined( my $Filename = readdir DIR ) ) {
        next DIRECTORY if $Filename eq '.';
        next DIRECTORY if $Filename eq '..';
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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Filelist = %{ $ConfigObject->Get('Stats::DynamicObjectRegistration') };
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
    return if !$Kernel::OM->Get('Kernel::System::Main')->Require($Module);

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

    my $Behaviours = $StatsObject->GetObjectBehaviours(
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
    if ( $Self->{'Cache::ObjectBehaviours'}->{$Module} ) {
        return $Self->{'Cache::ObjectBehaviours'}->{$Module}
    }

    # load module, return if module does not exist
    # (this is important when stats are uninstalled, see also bug# 4269)
    return if !$Kernel::OM->Get('Kernel::System::Main')->Require($Module);

    my $StatObject = $Module->new( %{$Self} );
    return if !$StatObject;

    return if !$StatObject->can('GetObjectBehaviours');
    my %ObjectBehaviours = $StatObject->GetObjectBehaviours();

    # cache the result
    $Self->{'Cache::ObjectBehaviours'}->{$Module} = \%ObjectBehaviours;

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

    my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home');
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Export: Need StatID!'
        );
        return;
    }

    # get xml object
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my @XMLHash = $XMLObject->XMLHashGet(
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
        my $File        = $Kernel::OM->Get('Kernel::Config')->Get('Home') . "/$FileLocation";
        my $FileContent = '';

        open my $Filehandle, '<', $File || die "Can't open: $File: $!";    ## no critic

        # set bin mode
        binmode $Filehandle;
        while (<$Filehandle>) {
            $FileContent .= $_;
        }
        close $Filehandle;

        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$FileContent );
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
    PERMISSION:
    for my $ID ( @{ $StatsXML->{Permission} } ) {
        next PERMISSION if !$ID;
        my $Name = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup( GroupID => $ID->{Content} );
        next PERMISSION if !$Name;
        $ID->{Content} = $Name;
    }

    # wrap object dependend ids
    if ( $StatsXML->{Object}->[1]->{Content} ) {

        # load module
        my $ObjectModule = $StatsXML->{ObjectModule}->[1]->{Content};
        return if !$Kernel::OM->Get('Kernel::System::Main')->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );
        return if !$StatObject;

        # load attributes
        $StatsXML = $StatObject->ExportWrapper(
            %{$StatsXML},
        );
    }

    # convert hash to string
    $File{Content} = $XMLObject->XMLHash2XML(
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
        UserID  => $UserID,
        Content => $UploadStuff{Content},
    );

=cut

sub Import {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID Content)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed.",
            );
            return;
        }
    }

    # get xml object
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my @XMLHash = $XMLObject->XMLParse2XMLHash( String => $Param{Content} );

    if ( !$XMLHash[0] ) {
        shift @XMLHash;
    }
    my $StatsXML = $XMLHash[0]->{otrs_stats}->[1];

    # Get new StatID
    my @Keys = $XMLObject->XMLHashSearch(
        Type => 'Stats',
    );

    # check if the required elements are available
    for my $Element (
        qw( Description Format Object ObjectModule Permission StatType SumCol SumRow Title Valid)
        )
    {
        if ( !defined $StatsXML->{$Element}->[1]->{Content} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Can't import Stat, because the required element $Element is not available!"
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # if-clause if a stat-xml includes a StatNumber
    my $StatID = 1;
    if ( $StatsXML->{StatNumber} ) {
        my $XMLStatsID = $StatsXML->{StatNumber}->[1]->{Content}
            - $ConfigObject->Get('Stats::StatsStartNumber');
        for my $Key (@Keys) {
            if ( $Key eq $XMLStatsID ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # get time
    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $TimeObject->SystemTime(),
    );

    # meta tags
    $StatsXML->{Created}->[1]->{Content}    = $TimeStamp;
    $StatsXML->{CreatedBy}->[1]->{Content}  = $Param{UserID};
    $StatsXML->{Changed}->[1]->{Content}    = $TimeStamp;
    $StatsXML->{ChangedBy}->[1]->{Content}  = $Param{UserID};
    $StatsXML->{StatNumber}->[1]->{Content} = $StatID + $ConfigObject->Get('Stats::StatsStartNumber');

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $FileLocation = $ConfigObject->Get('Home') . '/' . $FileLocation . '.pm';

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
                $StatsXML->{File}->[1]->{Content} = decode_base64( $StatsXML->{File}->[1]->{Content} );
                $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput(
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
    my %Groups = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        return if !$Kernel::OM->Get('Kernel::System::Main')->Require($ObjectModule);
        my $StatObject = $ObjectModule->new( %{$Self} );
        return if !$StatObject;

        # load attributes
        $StatsXML = $StatObject->ImportWrapper( %{$StatsXML} );
    }

    # new
    return if !$XMLObject->XMLHashAdd(
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

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        return if !$Kernel::OM->Get('Kernel::System::Main')->Require($ObjectModule);
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
        Preview    => 1,        # optional, return fake data for preview (only for dynamic stats)
        UserID     => $UserID,
    );

=cut

sub StatsRun {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(StatID GetParam UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Stat = $Self->StatsGet( StatID => $Param{StatID} );
    my %GetParam = %{ $Param{GetParam} };
    my @Result;

    # Perform calculations on the slave DB, if configured.
    local $Kernel::System::DB::UseSlaveDB = 1;

    # get data if it is a static stats
    if ( $Stat->{StatType} eq 'static' ) {

        return if $Param{Preview};    # not supported for static stats

        @Result = $Self->_GenerateStaticStats(
            ObjectModule => $Stat->{ObjectModule},
            GetParam     => $Param{GetParam},
            Title        => $Stat->{Title},
            StatID       => $Stat->{StatID},
            Cache        => $Stat->{Cache},
            UserID       => $Param{UserID},
        );
    }

    # get data if it is a dynaymic stats
    elsif ( $Stat->{StatType} eq 'dynamic' ) {
        @Result = $Self->_GenerateDynamicStats(
            ObjectModule     => $Stat->{ObjectModule},
            Object           => $Stat->{Object},
            UseAsXvalue      => $GetParam{UseAsXvalue},
            UseAsValueSeries => $GetParam{UseAsValueSeries} || [],
            UseAsRestriction => $GetParam{UseAsRestriction} || [],
            Title            => $Stat->{Title},
            StatID           => $Stat->{StatID},
            Cache            => $Stat->{Cache},
            Preview          => $Param{Preview},
            UserID           => $Param{UserID},
        );
    }

    # build sum in row or col
    if ( @Result && ( $Stat->{SumRow} || $Stat->{SumCol} ) && $Stat->{Format} !~ m{^GD::Graph\.*}x ) {
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
        UserID       => $UserID,        # target UserID
        UserGetParam => \%UserGetParam, # user settings of non-fixed fields
    );

=cut

sub StatsResultCacheCompute {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(StatID UserGetParam UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Stat = $Self->StatsGet(
        StatID => $Param{StatID},
    );

    my $StatsViewObject = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View');

    my $StatConfigurationValid = $StatsViewObject->StatsConfigurationValidate(
        Stat   => $Stat,
        Errors => {},
        UserID => $Param{UserID},
    );
    if ( !$StatConfigurationValid ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "This statistic contains configuration errors, skipping.",
        );
        return;
    }

    my %GetParam = eval {
        $StatsViewObject->StatsParamsGet(
            Stat         => $Stat,
            UserGetParam => $Param{UserGetParam},
        );
    };

    if ( $@ || !%GetParam ) {
        my $Errors = ref $@ ? join( "\n", @{$@} ) : $@;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The dashboard widget configuration for this user contains errors, skipping: $Errors"
        );
        return;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $DumpString = $MainObject->Dump( \%GetParam );

    my $MD5Sum = $MainObject->MD5sum(
        String => \$DumpString,
    );

    my $CacheKey = "StatsRunCached::$Param{UserID}::$Param{StatID}::$MD5Sum";

    my $Result = $Self->StatsRun(
        StatID   => $Param{StatID},
        GetParam => \%GetParam,
        UserID   => $Param{UserID},
    );

    # Only set/update the cache after computing it, otherwise no cache data
    #   would be available in between.
    return $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'StatsRun',
        Key   => $CacheKey,
        Value => $Result,
        TTL   => 24 * 60 * 60,    # cache it for a day, will be overwritten by next function call

        # Don't store complex structure in memory as it will be modified later.
        CacheInMemory => 0,
    );
}

=item StatsResultCacheGet()

gets cached statistic results. Will never run the statistic.
This can be used to fetch cached stats data e. g. for stats widgets in the dashboard.

    my $StatArray = $StatsObject->StatsResultCacheGet(
        StatID       => '123',
        UserID       => $UserID,    # target UserID
        GetParam     => \%GetParam,
    );

=cut

sub StatsResultCacheGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(StatID UserGetParam UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Stat = $Self->StatsGet(
        StatID => $Param{StatID},
    );

    my $StatsViewObject = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View');

    my $StatConfigurationValid = $StatsViewObject->StatsConfigurationValidate(
        Stat   => $Stat,
        Errors => {},
        UserID => $Param{UserID},
    );
    if ( !$StatConfigurationValid ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "This statistic contains configuration errors, skipping.",
        );
        return;
    }

    my %GetParam = eval {
        $StatsViewObject->StatsParamsGet(
            Stat         => $Stat,
            UserGetParam => $Param{UserGetParam},
            UserID       => $Param{UserID},
        );
    };

    if ( $@ || !%GetParam ) {
        my $Errors = ref $@ ? join( "\n", @{$@} ) : $@;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The dashboard widget configuration for this user contains errors, skipping: $Errors"
        );
        return;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $DumpString = $MainObject->Dump( \%GetParam );

    my $MD5Sum = $MainObject->MD5sum(
        String => \$DumpString,
    );

    my $CacheKey = "StatsRunCached::$Param{UserID}::$Param{StatID}::$MD5Sum";

    return $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'StatsRun',
        Key  => $CacheKey,

        # Don't store complex structure in memory as it will be modified later.
        CacheInMemory => 0,
    );
}

=item StringAndTimestamp2Filename()

builds a filename with a string and a timestamp.
(space will be replaced with _ and - e.g. Title-of-File_2006-12-31_11-59)

    my $Filename = $StatsObject->StringAndTimestamp2Filename( String => 'Title' );

=cut

sub StringAndTimestamp2Filename {
    my ( $Self, %Param ) = @_;

    if ( !$Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need String!'
        );
        return;
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );
    $M = sprintf( "%02d", $M );
    $D = sprintf( "%02d", $D );
    $h = sprintf( "%02d", $h );
    $m = sprintf( "%02d", $m );

    $Param{String} = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need StatNumber!',
        );
        return;
    }

    my @Key = $Kernel::OM->Get('Kernel::System::XML')->XMLHashSearch(
        Type => 'Stats',
        What => [ { "[%]{'otrs_stats'}[%]{'StatNumber'}[%]{'Content'}" => $Param{StatNumber} } ],
    );
    if ( @Key && $#Key < 1 ) {
        return $Key[0];
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'StatNumber invalid!',
    );
    return;
}

=item StatsInstall()

installs stats

    my $Result = $StatsObject->StatsInstall(
        FilePrefix => 'FAQ',  # (optional)
        UserID     => $UserID,
    );

=cut

sub StatsInstall {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # prepare prefix
    $Param{FilePrefix} = $Param{FilePrefix} ? $Param{FilePrefix} . '-' : '';

    # start AutomaticSampleImport if no stats are installed
    $Self->GetStatsList(
        UserID => $Param{UserID},
    );

    # cleanup stats
    $Self->StatsCleanUp(
        UserID => $Param{UserID},
    );

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # get list of stats files
    my @StatsFileList = $MainObject->DirectoryRead(
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
        my $XMLContentRef = $MainObject->FileRead(
            Location => $File,
        );

        # import stat
        my $StatID = $Self->Import(
            Content => ${$XMLContentRef},
            UserID  => $Param{UserID},
        );

        next FILE if !$StatID;

        # write installed file with stat id
        $MainObject->FileWrite(
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
        UserID     => $UserID,
    );

=cut

sub StatsUninstall {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # prepare prefix
    $Param{FilePrefix} = $Param{FilePrefix} ? $Param{FilePrefix} . '-' : '';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # get list of installed stats files
    my @StatsFileList = $MainObject->DirectoryRead(
        Directory => $Self->{StatsTempDir},
        Filter    => $Param{FilePrefix} . '*.xml.installed',
    );

    # delete the stats
    for my $File ( sort @StatsFileList ) {

        # read file content
        my $StatsIDRef = $MainObject->FileRead(
            Location => $File,
        );

        # delete stats
        $Self->StatsDelete(
            StatID => ${$StatsIDRef},
            UserID => $Param{UserID},
        );
    }

    # cleanup stats
    $Self->StatsCleanUp(
        UserID => $Param{UserID},
    );

    return 1;
}

=item StatsCleanUp()

removed stats with not existing backend file

    my $Result = $StatsObject->StatsCleanUp();

=cut

sub StatsCleanUp {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get a list of all stats
    my $ListRef = $Self->GetStatsList(
        UserID => $Param{UserID},
    );

    return if !$ListRef;
    return if ref $ListRef ne 'ARRAY';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

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
            && $MainObject->Require( $HashRef->{ObjectModule} );

        # delete stats
        $Self->StatsDelete(
            StatID => $StatsID,
            UserID => $Param{UserID},
        );
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
        UserID       => $UserID,
    );

=cut

sub _GenerateStaticStats {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEED:
    for my $Need (qw(ObjectModule GetParam Title StatID UserID)) {
        next NEED if $Param{$Need};
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Need!"
        );
        return;
    }

    # load static module
    my $ObjectModule = $Param{ObjectModule};
    return if !$Kernel::OM->Get('Kernel::System::Main')->Require($ObjectModule);
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

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my %User = $UserObject->GetUserData(
        UserID => $Param{UserID},
    );

    # run stats function
    @Result = $StatObject->Run(
        %GetParam,

        # these two lines are requirements of me, perhaps this
        # information is needed for former static stats
        Format       => $Param{Format}->[0],
        Module       => $Param{ObjectModule},
        UserLanguage => $User{UserLanguage},
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
        Cache            => 1,      # optional,
        Preview          => 1,      # optional, generate fake data
        UserID           => $UserID,
    );

=cut

# search for a better way to cache stats (see lines before StatID and Cache)

sub _GenerateDynamicStats {
    my ( $Self, %Param ) = @_;

    my @HeaderLine;
    my $TitleTimeStart = '';
    my $TitleTimeStop  = '';

    my $Preview = $Param{Preview};
    my $UserID  = $Param{UserID};

    NEED:
    for my $Need (qw(ObjectModule UseAsXvalue UseAsValueSeries Title Object StatID UserID)) {
        next NEED if $Param{$Need};
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Need!"
        );
        return;
    }

    # include the needed dynamic object
    my $ObjectModule = $Param{ObjectModule};
    return if !$Kernel::OM->Get('Kernel::System::Main')->Require($ObjectModule);
    my $StatObject = $ObjectModule->new( %{$Self} );
    return if !$StatObject;

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

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
                    my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
                        SystemTime => $TimeObject->SystemTime(),
                    );

                    my $Count = $Element->{TimeRelativeCount} ? $Element->{TimeRelativeCount} : 1;

                    # -1 because the current time will be not counted
                    $Count -= 1;

                    if ( $Element->{TimeRelativeUnit} eq 'Year' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, -1, 0, 0 );
                        $Element->{TimeStop} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, 12, 31, 23, 59, 59 );
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, -$Count, 0, 0 );
                        $Element->{TimeStart} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, 1, 1, 0, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Month' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, -1, 0 );
                        $Element->{TimeStop} = sprintf(
                            "%04d-%02d-%02d %02d:%02d:%02d",
                            $Y, $M, Days_in_Month( $Y, $M ),
                            23, 59, 59
                        );
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, -$Count, 0 );
                        $Element->{TimeStart} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, 1, 0, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Week' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, 0, -1 );
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
                        $Element->{TimeStart} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, 0, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Day' ) {
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, 0, -1 );
                        $Element->{TimeStop} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, 23, 59, 59 );
                        ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, 0, -$Count );
                        $Element->{TimeStart} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, 0, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Hour' ) {
                        ( $Y, $M, $D, $h, $m, $s ) = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, -1, 0, 0 );
                        $Element->{TimeStop} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, 59, 59 );
                        ( $Y, $M, $D, $h, $m, $s ) = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, -$Count, 0, 0 );
                        $Element->{TimeStart} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, 0, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Minute' ) {
                        ( $Y, $M, $D, $h, $m, $s ) = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, -1, 0 );
                        $Element->{TimeStop} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, 59 );
                        ( $Y, $M, $D, $h, $m, $s ) = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, -$Count, 0 );
                        $Element->{TimeStart} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, 0 );
                    }
                    elsif ( $Element->{TimeRelativeUnit} eq 'Second' ) {
                        ( $Y, $M, $D, $h, $m, $s ) = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, 0, -1 );
                        $Element->{TimeStop} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, $s );
                        ( $Y, $M, $D, $h, $m, $s ) = Add_Delta_DHMS( $Y, $M, $D, $h, $m, $s, 0, 0, 0, -$Count );
                        $Element->{TimeStart} = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, $D, $h, $m, $s );
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
            $RestrictionAttribute{ $RestrictionPart->{Values}{TimeStop} }  = $RestrictionPart->{TimeStop};
            $RestrictionAttribute{ $RestrictionPart->{Values}{TimeStart} } = $RestrictionPart->{TimeStart};
        }
        else {
            $RestrictionAttribute{$Element} = $RestrictionPart->{SelectedValues};
        }
    }

    # get needed objects
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');

    my %User = $UserObject->GetUserData(
        UserID => $UserID,
    );

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

        $TimeAbsolutStopUnixTime = $TimeObject->TimeStamp2SystemTime(
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
            || $TimeObject->TimeStamp2SystemTime( String => $TimeStop )
            < $TimeAbsolutStopUnixTime
            )
        {
            $TimeStart = sprintf(
                "%04d-%02d-%02d %02d:%02d:%02d",
                $Year, $Month, $Day, $Hour, $Minute, $Second
            );
            if ( $Element->{SelectedValues}[0] eq 'Second' ) {
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
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
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
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
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
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
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $Year, $Month, $Day, $Hour, $Minute, $Second, $Count, 0, 0,
                    -1
                );
                my $Dow = Day_of_Week( $Year, $Month, $Day );
                $Dow = $LanguageObject->Translate( Day_of_Week_Abbreviation($Dow) );
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
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_YMD( $Year, $Month, $Day, 0, 0, $Count * 7 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $Hour, $Minute, $Second, 0, 0, 0,
                    -1
                );
                my %WeekNum;
                ( $WeekNum{Week}, $WeekNum{Year} ) = Week_of_Year( $Year, $Month, $Day );
                my $TranslateWeek = $LanguageObject->Translate('week');
                push(
                    @HeaderLine,
                    sprintf( "$TranslateWeek %02d-%04d - ", $WeekNum{Week}, $WeekNum{Year} ) .
                        sprintf(
                        "%02d.%02d.%04d - %02d.%02d.%04d",
                        $Day, $Month, $Year, $ToDay, $ToMonth, $ToYear
                        )
                );
            }
            elsif ( $Element->{SelectedValues}[0] eq 'Month' ) {
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_YMD( $Year, $Month, $Day, 0, $Count, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $Hour, $Minute, $Second, 0, 0, 0,
                    -1
                );
                if ( $ToMonth eq $Month ) {
                    my $TranslateMonth = $LanguageObject->Translate( $MonthArrayRef->[$Month] );
                    push @HeaderLine, "$TranslateMonth $Month";
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
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
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
            ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = Add_Delta_DHMS(
                $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0, 0, 0,
                1
            );
            $TimeStop = sprintf(
                "%04d-%02d-%02d %02d:%02d:%02d",
                $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond
            );
            push(
                @{ $Xvalue->{SelectedValues} },
                {
                    TimeStart => $TimeStart,
                    TimeStop  => $TimeStop
                }
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
            push @HeaderLine, $LanguageObject->Translate( $Xvalue->{Values}{$Valuename} );
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
                $SelectedValues{$Ref2} = $LanguageObject->Translate( $Ref1->{Values}{$Ref2} );
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
                !$TimeStop || $TimeObject->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf( "%04d-01-01 00:00:00", $VSYear );
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_YMD( $VSYear, $VSMonth, $VSDay, $Count, 0, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, 0, -1
                );
                $TimeStop = sprintf( "%04d-12-31 23:59:59", $ToYear );

                $ValueSeries{$VSYear} = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Month' ) {
            while (
                !$TimeStop || $TimeObject->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf( "%04d-%02d-01 00:00:00", $VSYear, $VSMonth );
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_YMD( $VSYear, $VSMonth, $VSDay, 0, $Count, 0 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, 0, -1
                );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                $ValueSeries{
                    $VSYear . '-'
                        . sprintf( "%02d", $VSMonth ) . ' '
                        . $MonthArrayRef->[$VSMonth]
                    } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Week' ) {
            while (
                !$TimeStop || $TimeObject->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                my @Monday = Monday_of_Week( Week_of_Year( $VSYear, $VSMonth, $VSDay ) );

                $TimeStart = sprintf( "%04d-%02d-%02d 00:00:00", @Monday );
                ( $ToYear, $ToMonth, $ToDay ) = Add_Delta_Days( @Monday, $Count * 7 );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $VSHour, $VSMinute, $VSSecond, 0,
                    0, 0, -1
                );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                $ValueSeries{
                    sprintf( "%04d-%02d-%02d", @Monday ) . ' - '
                        . sprintf( "%04d-%02d-%02d", $ToYear, $ToMonth, $ToDay )
                    } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Day' ) {
            while (
                !$TimeStop || $TimeObject->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf( "%04d-%02d-%02d 00:00:00", $VSYear, $VSMonth, $VSDay );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond,
                    $Count, 0, 0, -1
                );
                $TimeStop = sprintf( "%04d-%02d-%02d 23:59:59", $ToYear, $ToMonth, $ToDay );

                $ValueSeries{ sprintf( "%04d-%02d-%02d", $VSYear, $VSMonth, $VSDay ) } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                };

                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                );
            }
        }
        elsif ( $Ref1->{SelectedValues}[0] eq 'Hour' ) {
            while (
                !$TimeStop || $TimeObject->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf( "%04d-%02d-%02d %02d:00:00", $VSYear, $VSMonth, $VSDay, $VSHour );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond, 0,
                    $Count, 0, -1
                );
                $TimeStop = sprintf( "%04d-%02d-%02d %02d:59:59", $ToYear, $ToMonth, $ToDay, $ToHour );
                $ValueSeries{
                    sprintf(
                        "%04d-%02d-%02d %02d:00:00 - %02d:59:59",
                        $VSYear, $VSMonth, $VSDay, $VSHour, $ToHour
                        )
                    } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };
                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond ) = Add_Delta_DHMS(
                    $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond, 0,
                    0, 0, 1
                );
            }
        }

        elsif ( $Ref1->{SelectedValues}[0] eq 'Minute' ) {
            while (
                !$TimeStop || $TimeObject->TimeStamp2SystemTime( String => $TimeStop )
                < $TimeAbsolutStopUnixTime
                )
            {
                $TimeStart = sprintf(
                    "%04d-%02d-%02d %02d:%02d:00",
                    $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute
                );
                ( $ToYear, $ToMonth, $ToDay, $ToHour, $ToMinute, $ToSecond ) = Add_Delta_DHMS(
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
                    } = {
                    $Ref1->{Values}{TimeStop}  => $TimeStop,
                    $Ref1->{Values}{TimeStart} => $TimeStart
                    };
                ( $VSYear, $VSMonth, $VSDay, $VSHour, $VSMinute, $VSSecond ) = Add_Delta_DHMS(
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
                $ValueSeries{ $ArraySelected[0]{Values}{$Key} } = { $ArraySelected[0]{Element} => $Value0 };
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
                    } = {
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
        unshift @HeaderLine, $LanguageObject->Translate($ColumnName);
    }
    elsif ( $ArraySelected[1] ) {
        unshift(
            @HeaderLine,
            $LanguageObject->Translate( $ArraySelected[0]{Name} ) . ' - '
                . $LanguageObject->Translate( $ArraySelected[1]{Name} )
        );
    }
    elsif ( $ArraySelected[0] ) {
        unshift( @HeaderLine, $LanguageObject->Translate( $ArraySelected[0]{Name} ) || '' );
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
    if ( $Param{Cache} && !$Preview ) {
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
        CELL:
        for my $Cell ( @{ $Xvalue->{SelectedValues} } ) {    # get each cell
            $ValueSeries{$Row} ||= {};
            my %Attributes = ( %{ $ValueSeries{$Row} }, %RestrictionAttribute );

            # the following is necessary if as x-axis and as value-series time is selected
            if ( $Xvalue->{Block} eq 'Time' ) {
                my $TimeStart = $Xvalue->{Values}{TimeStart};
                my $TimeStop  = $Xvalue->{Values}{TimeStop};
                if ( $ValueSeries{$Row}{$TimeStop} && $ValueSeries{$Row}{$TimeStart} ) {
                    if (
                        $TimeObject->TimeStamp2SystemTime( String => $Cell->{TimeStop} )
                        > $TimeObject->TimeStamp2SystemTime(
                            String => $ValueSeries{$Row}{$TimeStop}
                        )
                        || $TimeObject->TimeStamp2SystemTime( String => $Cell->{TimeStart} )
                        < $TimeObject->TimeStamp2SystemTime(
                            String => $ValueSeries{$Row}{$TimeStart}
                        )
                        )
                    {
                        next CELL;
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

    # Dynamic List Statistic
    if ( $StatObject->can('GetStatTable') ) {
        if ($Preview) {
            return if !$StatObject->can('GetStatTablePreview');

            @DataArray = $StatObject->GetStatTablePreview(
                ValueSeries    => $Param{UseAsValueSeries},    #\%ValueSeries,
                XValue         => $Xvalue,
                Restrictions   => \%RestrictionAttribute,
                TableStructure => \%TableStructure,
            );
        }
        else {
            # get the whole stats table
            @DataArray = $StatObject->GetStatTable(
                ValueSeries    => $Param{UseAsValueSeries},    #\%ValueSeries,
                XValue         => $Xvalue,
                Restrictions   => \%RestrictionAttribute,
                TableStructure => \%TableStructure,
            );
        }
    }

    # Dynamic Matrix Statistic
    else {
        if ($Preview) {
            return if !$StatObject->can('GetStatElementPreview');
        }

        for my $Row ( sort keys %TableStructure ) {
            my @ResultRow = ($Row);
            for my $Cell ( @{ $TableStructure{$Row} } ) {
                if ($Preview) {
                    push @ResultRow, $StatObject->GetStatElementPreview( %{$Cell} );
                }
                else {
                    push @ResultRow, $StatObject->GetStatElement( %{$Cell} );
                }
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

    if ( !$Param{Cache} || $Preview ) {
        return @StatArray
    }

    # check if we should cache this result
    if ( !$TitleTimeStart || !$TitleTimeStop ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Can't cache: StatID $Param{StatID} has no time period, so you can't cache the stat!",
        );
        return @StatArray;
    }

    if (
        $TimeObject->TimeStamp2SystemTime( String => $TitleTimeStop )
        > $TimeObject->SystemTime()
        )
    {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # check if we should cache this result
    # get the current time
    my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    my $MD5Key = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
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
    for my $Needed (qw(Filename Result)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'StatsRun',
        Key   => $Param{Filename},
        Value => $Param{Result},
        TTL   => 24 * 60 * 60,

        # Don't store complex structure in memory as it will be modified later.
        CacheInMemory => 0,
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => '_GetResultCache: Need Filename!',
        );
        return;
    }

    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'StatsRun',
        Key  => $Param{Filename},

        # Don't store complex structure in memory as it will be modified later.
        CacheInMemory => 0,
    );

    if ( ref $Cache ) {
        return @{$Cache};
    }

    return;
}

=item _DeleteCache()

clean up stats result cache.

=cut

sub _DeleteCache {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
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

    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Language  = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
    my $Directory = $Self->{StatsTempDir};

    if ( !opendir( DIRE, $Directory ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

            my $Filehandle;
            if ( !open $Filehandle, '<', $Directory . $Filename ) {    ## no critic
                $Kernel::OM->Get('Kernel::System::Log')->Log(
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

            my $StatID = $Self->Import(
                Content => $Content,
                UserID  => $Param{UserID},
            );
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
    my $Result = '';

    for my $Use (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {
        $Result .= "$Use:";
        for my $Element ( @{ $Param{$Use} } ) {
            $Result .= "Name:$Element->{Name}:";
            if ( $Element->{Block} eq 'Time' ) {
                if ( $Element->{SelectedValues}[0] && $Element->{TimeScaleCount} ) {
                    $Result .= "TimeScaleUnit:$Element->{SelectedValues}[0]:";
                    $Result .= "TimeScaleCount:$Element->{TimeScaleCount}:";
                }

                if ( $Element->{TimeStart} && $Element->{TimeStop} ) {
                    $Result .= "TimeStart:$Element->{TimeStart}:TimeStop:$Element->{TimeStop}:";
                }
            }
            if ( $Element->{SelectedValues} ) {
                $Result .= "SelectedValues:" . join( ',', sort @{ $Element->{SelectedValues} } ) . ':';
            }
        }
    }

    # Convert to MD5 (not sure if this is needed any more).
    $Result = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
        Filename => $Result,
        Type     => 'md5',
    );

    return $Result;
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
