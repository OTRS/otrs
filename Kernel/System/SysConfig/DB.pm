# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::DB;

use strict;
use warnings;

use MIME::Base64;
use Time::HiRes();
use utf8;

use Kernel::System::VariableCheck qw( :all );

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::SysConfig::DB - Functions to manage system configuration settings interactions with the database.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheTTL} = 24 * 3600 * 30;    # 1 month

    return $Self;
}

=head2 DefaultSettingAdd()

Add a new SysConfig default entry.

    my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
        Name                     => "ProductName",                 # (required)
        Description              => "Setting description",         # (required)
        Navigation               => "ASimple::Path::Structure",    # (required)
        IsInvisible              => 1,                             # (optional) 1 or 0, default 0
        IsReadonly               => 0,                             # (optional) 1 or 0, default 0
        IsRequired               => 1,                             # (optional) 1 or 0, default 0
        IsValid                  => 1,                             # (optional) 1 or 0, default 0
        HasConfigLevel           => 200,                           # (optional) default 0
        UserModificationPossible => 0,                             # (optional) 1 or 0, default 0
        UserModificationActive   => 0,                             # (optional) 1 or 0, default 0
        UserPreferencesGroup     => 'Some Group'                   # (optional)
        XMLContentRaw            => $XMLString,                    # (required) the setting XML structure as it is on the config file
        XMLContentParsed         => $XMLParsedToPerl,              # (required) the setting XML structure converted into a Perl structure
        XMLFilename              => 'Framework.xml'                # (required) the name of the XML file
        EffectiveValue           => $SettingEffectiveValue,        # (required) the value as will be stored in the Perl configuration file
        ExclusiveLockExpiryTime  => '2017-02-01 12:23:13',         # (optional) If not provided, method will calculate it.
        UserID                   => 123,
        NoCleanup                => 0,                             # (optional) Default 0. If enabled, system WILL NOT DELETE CACHE. In this case, it must be done manually.
                                                                   #    USE IT CAREFULLY.
    );

Returns:

    my $DefaultID = 123;  # false in case of an error

=cut

sub DefaultSettingAdd {
    my ( $Self, %Param ) = @_;

    # Store params for further usage.
    my %DefaultVersionParams = %Param;

    for my $Key (
        qw(Name Description Navigation XMLContentRaw XMLContentParsed XMLFilename EffectiveValue UserID)
        )
    {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    my @DefaultSettings = $Self->DefaultSettingList(
        IncludeInvisible => 1,
    );

    # Check duplicate name
    my ($SettingData) = grep { $_->{Name} eq $Param{Name} } @DefaultSettings;
    return if IsHashRefWithData($SettingData);

    # Check config level.
    $Param{HasConfigLevel} //= 0;

    # The value should be a positive integer if defined.
    if ( !IsPositiveInteger( $Param{HasConfigLevel} ) && $Param{HasConfigLevel} ne '0' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "HasConfigLevel must be an integer!",
        );
        return;
    }

    # Check boolean parameters (0 as default value).
    for my $Key (qw(IsInvisible IsReadonly IsRequired IsValid UserModificationPossible UserModificationActive)) {
        $Param{$Key} = ( defined $Param{$Key} && $Param{$Key} ? 1 : 0 );
    }

    # Serialize data as string.
    for my $Key (qw(XMLContentParsed EffectiveValue)) {
        $Param{$Key} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
            Data => $Param{$Key},
        );
        $DefaultVersionParams{$Key} = $Param{$Key};
    }

    # Set GuID.
    $Param{ExclusiveLockGUID} //= 1;

    # Set is dirty as enabled due it is a new setting.
    $Param{IsDirty} = 1;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Insert the default.
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO sysconfig_default
                (name, description, navigation, is_invisible, is_readonly, is_required, is_valid, has_configlevel,
                user_modification_possible, user_modification_active, user_preferences_group, xml_content_raw, xml_content_parsed, xml_filename, effective_value,
                is_dirty, exclusive_lock_guid, create_time, create_by, change_time, change_by)
            VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name},       \$Param{Description}, \$Param{Navigation}, \$Param{IsInvisible},
            \$Param{IsReadonly}, \$Param{IsRequired},  \$Param{IsValid},    \$Param{HasConfigLevel},
            \$Param{UserModificationPossible}, \$Param{UserModificationActive}, \$Param{UserPreferencesGroup},
            \$Param{XMLContentRaw}, \$Param{XMLContentParsed}, \$Param{XMLFilename}, \$Param{EffectiveValue},
            \$Param{IsDirty}, \$Param{ExclusiveLockGUID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # Get default ID.
    $DBObject->Prepare(
        SQL   => 'SELECT id FROM sysconfig_default WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    my $DefaultID;

    # Fetch the default setting ID.
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DefaultID = $Row[0];
        last ROW;
    }

    # Add default setting version.
    my $DefaultVersionID = $Self->DefaultSettingVersionAdd(
        DefaultID => $DefaultID,
        %DefaultVersionParams,
        NoVersionID => 1,
    );

    if ( !$Param{NoCleanup} ) {
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        $CacheObject->Delete(
            Type => 'SysConfigDefault',
            Key  => 'DefaultSettingGet::' . $Param{Name},
        );
        $CacheObject->CleanUp(
            Type => 'SysConfigDefaultListGet',
        );
        $CacheObject->Delete(
            Type => 'SysConfigDefaultList',
            Key  => 'DefaultSettingList',
        );
        $CacheObject->CleanUp(
            Type => 'SysConfigNavigation',
        );
        $CacheObject->CleanUp(
            Type => 'SysConfigEntities',
        );
        $CacheObject->CleanUp(
            Type => 'SysConfigIsDirty',
        );
    }

    # Return if not version inserted.
    return if !$DefaultVersionID;

    return $DefaultID;
}

=head2 DefaultSettingBulkAdd()

Add new SysConfig default entries.

    my $Success = $SysConfigDBObject->DefaultSettingBulkAdd(
        Settings => {                                                 # (required) Hash of settings
            "ACL::CacheTTL" => {
                "EffectiveValue" => "--- '3600'\n",
                "XMLContentParsed" => {
                    "Description" => [
                        {
                            "Content" => "Cache time in ...",
                            "Translatable" => 1
                        },
                    ],
                    "Name" => "ACL::CacheTTL",
                    "Navigation" => [
                        {
                            "Content" => "Core::Ticket::ACL"
                        },
                    ],
                    "Required" => 1,
                    "Valid" => 1,
                    "Value" => [
                        {
                            "Item" => [
                                {
                                    "Content" => 3600,
                                    "ValueRegex" => "^\\d+\$",
                                    "ValueType" => "String"
                                },
                            ],
                        },
                    ],
                },
                "XMLContentParsedYAML" => "---\nDescription:\n- Content: Cache...",
                "XMLContentRaw" => "<Setting Name=\"ACL::CacheTTL\" Required=\"1\" ...",
                "XMLFilename" => "Ticket.xml"
            },
            ...
        },
        SettingList => [                                                # list of current settings in DB
            {
                DefaultID         => '123',
                Name              => 'SettingName1',
                IsDirty           => 1,
                ExclusiveLockGUID => 0,
            },
            # ...
        ],
        UserID => 1,                                                    # (required) UserID
    );

=cut

sub DefaultSettingBulkAdd {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Settings UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( ref $Param{Settings} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings must be a hash!"
        );
        return;
    }

    $Param{SettingList} //= [];
    if ( ref $Param{SettingList} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "SettingList must be an array",
        );
    }

    my @Data;

    SETTINGNAME:
    for my $SettingName ( sort keys %{ $Param{Settings} } ) {

        my ($BasicData) = grep { $_->{Name} eq $SettingName } @{ $Param{SettingList} };

        if ($BasicData) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$SettingName should not exist!"
            );
            next SETTINGNAME;
        }

        # Gather data for all records.
        push @Data, [
            $SettingName,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Description}->[0]->{Content} || '',
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Navigation}->[0]->{Content}  || '',
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Invisible}                   || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{ReadOnly}                    || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Required}                    || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Valid}                       || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{ConfigLevel}                 || 100,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{UserModificationPossible}    || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{UserModificationActive}      || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{UserPreferencesGroup},
            $Param{Settings}->{$SettingName}->{XMLContentRaw},
            $Param{Settings}->{$SettingName}->{XMLContentParsedYAML},
            $Param{Settings}->{$SettingName}->{XMLFilename},
            $Param{Settings}->{$SettingName}->{EffectiveValue},
            1,
            1,
            'current_timestamp',
            $Param{UserID},
            'current_timestamp',
            $Param{UserID},
        ];
    }

    return if !$Self->_BulkInsert(
        Table   => 'sysconfig_default',
        Columns => [
            'name',
            'description',
            'navigation',
            'is_invisible',
            'is_readonly',
            'is_required',
            'is_valid',
            'has_configlevel',
            'user_modification_possible',
            'user_modification_active',
            'user_preferences_group',
            'xml_content_raw',
            'xml_content_parsed',
            'xml_filename',
            'effective_value',
            'is_dirty',
            'exclusive_lock_guid',
            'create_time',
            'create_by',
            'change_time',
            'change_by'
        ],
        Data => \@Data,
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultListGet',
    );
    $CacheObject->Delete(
        Type => 'SysConfigDefaultList',
        Key  => 'DefaultSettingList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigNavigation',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigEntities',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    return 1;
}

=head2 DefaultSettingVersionBulkAdd()

    my $Success = $SysConfigDBObject->DefaultSettingVersionBulkAdd(
        Settings => {                                                 # (required) Hash of settings
            "ACL::CacheTTL" => {
                "EffectiveValue" => "--- '3600'\n",
                "XMLContentParsed" => {
                    "Description" => [
                        {
                            "Content" => "Cache time in ...",
                            "Translatable" => 1
                        },
                    ],
                    "Name" => "ACL::CacheTTL",
                    "Navigation" => [
                        {
                            "Content" => "Core::Ticket::ACL"
                        },
                    ],
                    "Required" => 1,
                    "Valid" => 1,
                    "Value" => [
                        {
                            "Item" => [
                                {
                                    "Content" => 3600,
                                    "ValueRegex" => "^\\d+\$",
                                    "ValueType" => "String"
                                },
                            ],
                        },
                    ],
                },
                "XMLContentParsedYAML" => "---\nDescription:\n- Content: Cache...",
                "XMLContentRaw" => "<Setting Name=\"ACL::CacheTTL\" Required=\"1\" ...",
                "XMLFilename" => "Ticket.xml"
            },
            ...
        },
        SettingList => [                                                # list of current settings in DB
            {
                DefaultID         => '123',
                Name              => 'SettingName1',
                IsDirty           => 1,
                ExclusiveLockGUID => 0,
            },
            # ...
        ],
        UserID => 1,                                                    # (required) UserID
    );

=cut

sub DefaultSettingVersionBulkAdd {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Settings SettingList UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( ref $Param{Settings} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings must be a hash!"
        );
        return;
    }

    my @Data;

    SETTINGNAME:
    for my $SettingName ( sort keys %{ $Param{Settings} } ) {

        my ($BasicData) = grep { $_->{Name} eq $SettingName } @{ $Param{SettingList} };

        if ( !$BasicData || !$BasicData->{DefaultID} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "DefaultID for $SettingName couldn't be determined, skipped!"
            );
            next SETTINGNAME;
        }

        # Gather data for all records.
        push @Data, [
            $BasicData->{DefaultID},
            $SettingName,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Description}->[0]->{Content} || '',
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Navigation}->[0]->{Content}  || '',
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Invisible}                   || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{ReadOnly}                    || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Required}                    || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{Valid}                       || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{ConfigLevel}                 || 100,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{UserModificationPossible}    || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{UserModificationActive}      || 0,
            $Param{Settings}->{$SettingName}->{XMLContentParsed}->{UserPreferencesGroup},
            $Param{Settings}->{$SettingName}->{XMLContentRaw},
            $Param{Settings}->{$SettingName}->{XMLContentParsedYAML},
            $Param{Settings}->{$SettingName}->{XMLFilename},
            $Param{Settings}->{$SettingName}->{EffectiveValue},
            'current_timestamp',
            $Param{UserID},
            'current_timestamp',
            $Param{UserID},
        ];
    }

    return if !$Self->_BulkInsert(
        Table   => 'sysconfig_default_version',
        Columns => [
            'sysconfig_default_id',
            'name',
            'description',
            'navigation',
            'is_invisible',
            'is_readonly',
            'is_required',
            'is_valid',
            'has_configlevel',
            'user_modification_possible',
            'user_modification_active',
            'user_preferences_group',
            'xml_content_raw',
            'xml_content_parsed',
            'xml_filename',
            'effective_value',
            'create_time',
            'create_by',
            'change_time',
            'change_by',
        ],
        Data => \@Data,
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultVersion',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultVersionList',
    );

    return 1;
}

=head2 DefaultSettingGet()

Get SysConfig default entry.

    my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
        Name        => "TheName", # (required) Setting name - prefered parameter.
                                  # or
        DefaultID   => 4,         # (required) DefaultID. Slightly slower execution.
        NoCache     => 0,         # (optional) Default 0. If 1, cache will not be created.
    );

Returns:

    %DefaultSetting = (
        DefaultID                => "123",
        Name                     => "ProductName",
        Description              => "Defines the name of the application ...",
        Navigation               => "ASimple::Path::Structure",
        IsInvisible              => 1,         # 1 or 0
        IsReadonly               => 0,         # 1 or 0
        IsRequired               => 1,         # 1 or 0
        IsValid                  => 1,         # 1 or 0
        HasConfigLevel           => 200,
        UserModificationPossible => 0,         # 1 or 0
        UserModificationActive   => 0,         # 1 or 0
        UserPreferencesGroup     => 'Some Group',
        XMLContentRaw            => "The XML structure as it is on the config file",
        XMLContentParsed         => "XML parsed to Perl",
        XMLFilename              => "Framework.xml",
        EffectiveValue           => "Product 6",
        IsDirty                  => 1,         # 1 or 0
        ExclusiveLockGUID        => 'A32CHARACTERLONGSTRINGFORLOCKING',
        ExclusiveLockUserID      => 1,
        ExclusiveLockExpiryTime  => '2016-05-29 11:09:04',
        CreateTime               => "2016-05-29 11:04:04",
        CreateBy                 => 1,
        ChangeTime               => "2016-05-29 11:04:04",
        ChangeBy                 => 1,
        SettingUID               => 'Default12320160529110404',
    );

=cut

sub DefaultSettingGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need DefaultID or Name!',
        );
        return;
    }

    my $SettingName = $Param{Name};

    if ( !$SettingName ) {
        my %SettingData = $Self->DefaultSettingLookup(
            DefaultID => $Param{DefaultID},
        );

        if ( !%SettingData || !$SettingData{Name} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Setting with DefaultID = $Param{DefaultID} not found!",
            );

            return;
        }

        $SettingName = $SettingData{Name};
    }

    my $CacheType = "SysConfigDefault";
    my $CacheKey  = "DefaultSettingGet::$SettingName";

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get default from database.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, description, navigation, is_invisible, is_readonly, is_required, is_valid, has_configlevel,
                user_modification_possible, user_modification_active, user_preferences_group, xml_content_raw,
                xml_content_parsed, xml_filename, effective_value, is_dirty, exclusive_lock_guid, exclusive_lock_user_id,
                exclusive_lock_expiry_time, create_time, create_by, change_time, change_by

            FROM sysconfig_default
            WHERE name = ?',
        Bind => [ \$SettingName ],
    );

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %DefaultSetting;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # De-serialize default data.
        my $XMLContentParsed = $YAMLObject->Load( Data => $Data[13] );
        my $EffectiveValue   = $YAMLObject->Load( Data => $Data[15] );

        my $TimeStamp = $Data[22];
        $TimeStamp =~ s{:|-|[ ]}{}gmsx;

        %DefaultSetting = (
            DefaultID                => $Data[0],
            Name                     => $Data[1],
            Description              => $Data[2],
            Navigation               => $Data[3],
            IsInvisible              => $Data[4],
            IsReadonly               => $Data[5],
            IsRequired               => $Data[6],
            IsValid                  => $Data[7],
            HasConfigLevel           => $Data[8],
            UserModificationPossible => $Data[9],
            UserModificationActive   => $Data[10],
            UserPreferencesGroup     => $Data[11] || '',
            XMLContentRaw            => $Data[12],
            XMLContentParsed         => $XMLContentParsed,
            XMLFilename              => $Data[14],
            EffectiveValue           => $EffectiveValue,
            IsDirty                  => $Data[16] ? 1 : 0,
            ExclusiveLockGUID        => $Data[17],
            ExclusiveLockUserID      => $Data[18],
            ExclusiveLockExpiryTime  => $Data[19],
            CreateTime               => $Data[20],
            CreateBy                 => $Data[21],
            ChangeTime               => $Data[22],
            ChangeBy                 => $Data[23],
            SettingUID               => "Default$Data[0]$TimeStamp",
        );
    }

    if ( !$Param{NoCache} ) {
        $CacheObject->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => \%DefaultSetting,
            TTL   => $Self->{CacheTTL},
        );
    }

    return %DefaultSetting;
}

=head2 DefaultSettingLookup()

Default setting lookup.

    my %Result = $SysConfigDBObject->DefaultSettingLookup(
        Name        => "TheName", # (required)
                                  # or
        DefaultID   => 4,         # (required)
    );

Returns:

    %Result = (
        DefaultID      => 4,
        Name           => 'TheName',
    );

=cut

sub DefaultSettingLookup {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Name} && !$Param{DefaultID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Name or DefaultID!",
        );
        return;
    }

    my @Bind;

    my $SQL = '
        SELECT id, name
        FROM sysconfig_default
        WHERE
    ';

    if ( $Param{Name} ) {
        $SQL .= 'name = ? ';
        push @Bind, \$Param{Name};
    }
    else {
        $SQL .= "id = ? ";
        push @Bind, \$Param{DefaultID};
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db query
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my %Result;

    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{DefaultID} = $Row[0];
        $Result{Name}      = $Row[1];
        last ROW;
    }

    return %Result;
}

=head2 DefaultSettingDelete()

Delete a default setting from the database.

    my $Success = $SysConfigDBObject->DefaultSettingDelete(
        DefaultID => 123,
    );

    my $Success = $SysConfigDBObject->DefaultSettingDelete(
        Name => 'Name',
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub DefaultSettingDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need DefaultID or Name!',
        );
        return;
    }

    my %DefaultSetting = $Self->DefaultSettingGet(
        DefaultID => $Param{DefaultID} || undef,
        Name      => $Param{Name}      || undef,
    );
    return 1 if !IsHashRefWithData( \%DefaultSetting );

    my $DefaultID = $DefaultSetting{DefaultID};

    # Delete the entries in SysConfig default version.
    my $DeleteDefaultVersion = $Self->DefaultSettingVersionDelete(
        DefaultID => $DefaultID,
    );

    # Return if not version deleted.
    return if !$DeleteDefaultVersion;

    # Delete default from the list.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM sysconfig_default WHERE id = ?',
        Bind => [ \$DefaultID ],
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->Delete(
        Type => 'SysConfigDefault',
        Key  => 'DefaultSettingGet::' . $DefaultSetting{Name},
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultListGet',
    );
    $CacheObject->Delete(
        Type => 'SysConfigDefaultList',
        Key  => 'DefaultSettingList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigNavigation',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigEntities',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    # Clean cache for setting translations.
    my %Languages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
    for my $Language ( sort keys %Languages ) {
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "SettingTranslatedGet::$Language" . "::$DefaultSetting{Name}",
        );
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "ConfigurationTranslatedGet::$Language",
        );
    }

    return 1;
}

=head2 DefaultSettingUpdate()

Update SysConfig default entry.

    my $Success = $SysConfigDBObject->DefaultSettingUpdate(
        DefaultID                => 123,
        Name                     => "ProductName",
        Description              => "Defines the name of the application ...",
        Navigation               => "ASimple::Path::Structure",
        IsInvisible              => 1,             # 1 or 0, optional, default 0
        IsReadonly               => 0,             # 1 or 0, optional, default 0
        IsRequired               => 1,             # 1 or 0, optional, default 0
        IsValid                  => 1,             # 1 or 0, optional, default 0
        HasConfigLevel           => 200,           # optional, default 0
        UserModificationPossible => 0,             # 1 or 0, optional, default 0
        UserModificationActive   => 0,             # 1 or 0, optional, default 0
        UserPreferencesGroup     => 'Some Group',
        UserPreferencesGroup     => 'Advanced',    # optional
        XMLContentRaw            => $XMLString,    # the XML structure as it is on the config file
        XMLContentParsed         => $XMLParsedToPerl,
        XMLFilename              => 'Framework.xml',
        ExclusiveLockGUID        => 1,
        EffectiveValue           => $SettingEffectiveValue,
        UserID                   => 1,
    );

Returns:

    $Success = 1;   # or false in case of an error.

=cut

sub DefaultSettingUpdate {
    my ( $Self, %Param ) = @_;

    # Store params for further usage.
    my %DefaultVersionParams = %Param;

    for my $Key (
        qw(
        DefaultID Name Description Navigation XMLContentRaw XMLContentParsed XMLFilename
        ExclusiveLockGUID EffectiveValue UserID
        )
        )
    {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # Get default setting
    my %DefaultSetting = $Self->DefaultSettingGet(
        DefaultID => $Param{DefaultID},
    );

    # Check if setting exists.
    return if !IsHashRefWithData( \%DefaultSetting );

    # Don't allow name changes, due this is consider a NEW setting.
    return if $DefaultSetting{Name} ne $Param{Name};

    # Check if the setting is locked by the current user.
    return if !$Self->DefaultSettingIsLockedByUser(
        %Param,
        ExclusiveLockUserID => $Param{UserID},
    );

    # Check config level, set 0 as default value.
    $Param{HasConfigLevel} //= 0;

    if ( !IsPositiveInteger( $Param{HasConfigLevel} ) && $Param{HasConfigLevel} ne '0' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "HasConfigLevel must be an integer!",
        );

        return;
    }

    # Check boolean parameters, set 0 as default value.
    for my $Key (qw(IsInvisible IsReadonly IsRequired IsValid UserModificationPossible UserModificationActive)) {
        $Param{$Key} = ( defined $Param{$Key} && $Param{$Key} ? 1 : 0 );
    }

    # Check if we really need to update.
    my $IsDifferent = 0;
    for my $Key (
        qw(
        DefaultID Description Navigation IsInvisible HasConfigLevel XMLContentRaw
        XMLContentParsed XMLFilename ExclusiveLockGUID EffectiveValue HasConfigLevel IsInvisible
        IsReadonly IsRequired IsValid UserModificationPossible UserModificationActive UserPreferencesGroup
        )
        )
    {
        my $DataIsDifferent = DataIsDifferent(
            Data1 => $Param{$Key},
            Data2 => $DefaultSetting{$Key},
        );
        if ($DataIsDifferent) {
            $IsDifferent = 1;
        }
    }

    return 1 if !$IsDifferent;

    # Serialize data as string.
    for my $Key (qw(XMLContentParsed EffectiveValue)) {
        $Param{$Key} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
            Data => $Param{$Key},
        );
        $DefaultVersionParams{$Key} = $Param{$Key};
    }

    # Set is dirty value.
    $Param{IsDirty} = 1;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Insert the default.
    return if !$DBObject->Do(
        SQL => '
            UPDATE sysconfig_default
            SET description = ?, navigation = ?, is_invisible = ?, is_readonly = ?,
                is_required = ?, is_valid = ?, has_configlevel = ?, user_modification_possible = ?, user_modification_active = ?,
                user_preferences_group = ?, xml_content_raw = ?, xml_content_parsed = ?, xml_filename =?, effective_value = ?,
                is_dirty = ?, change_time = current_timestamp, change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{Description}, \$Param{Navigation}, \$Param{IsInvisible},    \$Param{IsReadonly},
            \$Param{IsRequired},  \$Param{IsValid},    \$Param{HasConfigLevel}, \$Param{UserModificationPossible},
            \$Param{UserModificationActive}, \$Param{UserPreferencesGroup}, \$Param{XMLContentRaw},
            \$Param{XMLContentParsed},
            \$Param{XMLFilename}, \$Param{EffectiveValue}, \$Param{IsDirty}, \$Param{UserID}, \$Param{DefaultID},
        ],
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->Delete(
        Type => 'SysConfigDefault',
        Key  => 'DefaultSettingGet::' . $DefaultSetting{Name},
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultListGet',
    );
    $CacheObject->Delete(
        Type => 'SysConfigDefaultList',
        Key  => 'DefaultSettingList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigNavigation',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigEntities',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    # Clean cache for setting translations.
    my %Languages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
    for my $Language ( sort keys %Languages ) {
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "SettingTranslatedGet::$Language" . "::$DefaultSetting{Name}",
        );
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "ConfigurationTranslatedGet::$Language",
        );
    }

    # Add default setting version.
    my $DefaultVersionID = $Self->DefaultSettingVersionAdd(
        DefaultID => $Param{DefaultID},
        %DefaultVersionParams,
        NoVersionID => 1,
    );

    # Return if not version inserted.
    return if !$DefaultVersionID;

    # Unlock setting
    my $IsUnlock = $Self->DefaultSettingUnlock(
        DefaultID => $Param{DefaultID},
    );
    if ( !$IsUnlock ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Default setting with ID: $Param{DefaultID} was not possible to unlock!",
        );
        return;
    }

    return 1;
}

=head2 DefaultSettingSearch()

Search for settings which contains given term(Search) in the xml_content_raw column.

    my @Result = $SysConfigDBObject->DefaultSettingSearch(
        Search          => 'Entity',                              # Search term
        SearchType      => 'XMLContent',                          # XMLContent or Metadata
        CategoryFiles   => ['Framework.xml', 'Ticket.xml', ],     # (optional)
        Valid           => 0,                                     # (optional) By default, system returns all Settings (valid and invalid)
                                                                  #   if set to 1, search only for valid,
                                                                  #   if set to 0, search also for invalid.
        IncludeInvisible => 0,                                    # (optional) Default 0
    );

or

    my @Result = $SysConfigDBObject->DefaultSettingSearch(
        Search         => ['Framework.xml' 'Ticket,xml'],
        SearchType     => 'Filename',
        Valid          => 1,
    );

Returns:

    @Result = (
        'ACL::CacheTTL',
        'ACLKeysLevel1Change',
        ...
    );

=cut

sub DefaultSettingSearch {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Search} && !$Param{CategoryFiles} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Search or CategoryFiles!",
        );
        return;
    }

    if ( $Param{CategoryFiles} && !IsArrayRefWithData( $Param{CategoryFiles} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "CategoryFiles is invalid!",
        );
        return;
    }

    $Param{SearchType}       //= 'XMLContent';
    $Param{IncludeInvisible} //= 0;

    my $Valid = 0;
    if ( defined $Param{Valid} ) {
        $Valid = $Param{Valid} ? 1 : 0;
    }

    my @Bind = ();

    my $SQL = '
        SELECT name
        FROM sysconfig_default
        WHERE 1 = 1';

    if ($Valid) {
        $SQL .= '
        AND is_valid = ?';
        push @Bind, \$Valid;
    }

    if ( !$Param{IncludeInvisible} ) {
        $SQL .= '
        AND is_invisible = ?';
        push @Bind, \0;
    }

    my $Column = 'xml_content_raw';

    if ( lc $Param{SearchType} eq 'metadata' ) {
        $Column = [qw(name description navigation)];
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{Search} ) {
        my %QueryCondition = $DBObject->QueryCondition(
            Key          => $Column,
            Value        => $Param{Search},
            SearchPrefix => "*",
            SearchSuffix => "*",
            BindMode     => 1,
        );

        $SQL .= ' AND ' . $QueryCondition{SQL};
        push @Bind, @{ $QueryCondition{Values} };
    }

    if ( $Param{CategoryFiles} ) {

        @{ $Param{CategoryFiles} } = map {"($_)"} @{ $Param{CategoryFiles} };
        $Param{CategoryFiles} = join 'OR', @{ $Param{CategoryFiles} };

        my %QueryCondition = $DBObject->QueryCondition(
            Key          => 'xml_filename',
            Value        => $Param{CategoryFiles},
            SearchPrefix => "",
            SearchSuffix => "",
            BindMode     => 1,
        );

        $SQL .= ' AND ( ' . $QueryCondition{SQL} . ' )';
        push @Bind, @{ $QueryCondition{Values} };

    }

    $SQL .= '
        ORDER BY name asc';

    # db query
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Result;

    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    return @Result;
}

=head2 DefaultSettingListGet()

Get default setting list with complete data.

    my @List = $SysConfigDBObject->DefaultSettingListGet(
        IsInvisible              => 1,                                  # 1 or 0
        IsReadonly               => 0,                                  # 1 or 0
        IsRequired               => 1,                                  # 1 or 0
        IsValid                  => 1,                                  # 1 or 0
        IsDirty                  => 1,                                  # 1 or 0
        HasConfigLevel           => 0,                                  # 1 or 0
        UserModificationPossible => 0,                                  # 1 or 0
        UserModificationActive   => 0,                                  # 1 or 0
        UserPreferencesGroup     => 'Some Group',
        Navigation               => 'ASimple::Path::Structure',
        Locked                   => 1, # check for locked settings
        Category                 => 'OTRS',                             # optional (requires CategoryFiles)
        CategoryFiles            => ['Framework.xml', 'Ticket.xml', ],  # optional (requires Category)
        NoCache                  => 0,                                  # (optional) Default 0. If set, system will not generate cache.
    );

Returns:

    @List = (
        {
            DefaultID                => 123,
            Name                     => "ProductName",
            Description              => "Defines the name of the application ...",
            Navigation               => "ASimple::Path::Structure",
            IsInvisible              => 1,
            IsReadonly               => 0,
            IsRequired               => 1,
            IsValid                  => 1,
            HasConfigLevel           => 200,
            UserModificationPossible => 0,          # 1 or 0
            UserModificationActive   => 0,          # 1 or 0
            UserPreferencesGroup     => 'Advanced', # optional
            XMLContentRaw            => "The XML structure as it is on the config file",
            XMLContentParsed         => "XML parsed to Perl",
            XMLFilename              => "Framework.xml",
            EffectiveValue           => "Product 6",
            IsDirty                  => 1,       # 1 or 0
            ExclusiveLockGUID        => 'A32CHARACTERLONGSTRINGFORLOCKING',
            ExclusiveLockUserID      => 1,
            ExclusiveLockExpiryTime  => '2016-05-29 11:09:04',
            CreateTime               => "2016-05-29 11:04:04",
            CreateBy                 => 1,
            ChangeTime               => "2016-05-29 11:04:04",
            ChangeBy                 => 1,
            SettingUID               => 'Default4717141789',
        },
        {
            DefaultID => 321,
            Name      => 'FieldName',
            # ...
            ChangeTime => '2011-01-01 01:01:01',
            ChangeBy                 => 1,
            SettingUID               => 'Default4717141781',
        },
        # ...
    );

=cut

sub DefaultSettingListGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{Category} ) {
        if ( !IsArrayRefWithData( $Param{CategoryFiles} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "CategoryFiles are invalid!",
            );
            return;
        }
    }
    if ( $Param{CategoryFiles} && !$Param{Category} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Category!",
        );
    }

    # Define SQL filters to be used in the queries.
    my %FieldFilters = (
        IsInvisible              => 'is_invisible',
        IsReadonly               => 'is_readonly',
        IsRequired               => 'is_required',
        IsValid                  => 'is_valid',
        IsDirty                  => 'is_dirty',
        HasConfigLevel           => 'has_configlevel',
        UserModificationPossible => 'user_modification_possible',
        UserModificationActive   => 'user_modification_active',
        UserPreferencesGroup     => 'user_preferences_group',
        Navigation               => 'navigation',
    );

    my @Filters;
    my @Bind;

    my $CacheType = 'SysConfigDefaultListGet';
    my $CacheKey  = 'DefaultSettingListGet';     # this cache key gets more elements

    # Check params have a default value.
    for my $Key ( sort keys %FieldFilters ) {
        if ( defined $Param{$Key} ) {
            push @Filters, " $FieldFilters{$Key} = ? ";
            push @Bind,    \$Param{$Key};

            $CacheKey .= "::$FieldFilters{$Key} = $Param{$Key}";
        }
    }

    # Check for locked settings.
    if ( $Param{Locked} ) {
        push @Filters, " exclusive_lock_guid != '0' ";
        $CacheKey .= "::exclusive_lock_guid != '0'";
    }

    # Check for categories.
    if ( $Param{Category} ) {
        $CacheKey .= "::Category=$Param{Category}";
    }

    my $SQLFilter = '';

    # Loop over filters and set them on SQL and cache key.
    if ( IsArrayRefWithData( \@Filters ) ) {
        $SQLFilter = ' WHERE ' . join ' AND ', @Filters;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{Category} ) {
        @{ $Param{CategoryFiles} } = map {"($_)"} @{ $Param{CategoryFiles} };
        $Param{CategoryFiles} = join 'OR', @{ $Param{CategoryFiles} };

        my %QueryCondition = $DBObject->QueryCondition(
            Key          => 'xml_filename',
            Value        => $Param{CategoryFiles},
            SearchPrefix => "",
            SearchSuffix => "",
            BindMode     => 1,
        );

        if ($SQLFilter) {
            $SQLFilter .= ' AND ( ' . $QueryCondition{SQL} . ' )';
        }
        else {
            $SQLFilter = ' WHERE ' . $QueryCondition{SQL};
        }

        push @Bind, @{ $QueryCondition{Values} };
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY';

    my $SQL = '
        SELECT id, name, description, navigation, is_invisible, is_readonly, is_required, is_valid, has_configlevel,
            user_modification_possible, user_modification_active, user_preferences_group, xml_content_raw,
            xml_content_parsed, xml_filename, effective_value, is_dirty, exclusive_lock_guid, exclusive_lock_user_id,
            exclusive_lock_expiry_time, create_time, create_by, change_time, change_by
        FROM sysconfig_default';

    $SQLFilter //= '';

    $SQL .= $SQLFilter . ' ORDER BY id';

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Data;
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    while ( my @Row = $DBObject->FetchrowArray() ) {

        # De-serialize default data.
        my $XMLContentParsed = $YAMLObject->Load( Data => $Row[13] );
        my $EffectiveValue   = $YAMLObject->Load( Data => $Row[15] );

        my $TimeStamp = $Row[22];
        $TimeStamp =~ s{:|-|[ ]}{}gmsx;

        my %DefaultSetting = (
            DefaultID                => $Row[0],
            Name                     => $Row[1],
            Description              => $Row[2],
            Navigation               => $Row[3],
            IsInvisible              => $Row[4],
            IsReadonly               => $Row[5],
            IsRequired               => $Row[6],
            IsValid                  => $Row[7],
            HasConfigLevel           => $Row[8],
            UserModificationPossible => $Row[9],
            UserModificationActive   => $Row[10],
            UserPreferencesGroup     => $Row[11] || '',
            XMLContentRaw            => $Row[12],
            XMLContentParsed         => $XMLContentParsed,
            XMLFilename              => $Row[14],
            EffectiveValue           => $EffectiveValue,
            IsDirty                  => $Row[16] ? 1 : 0,
            ExclusiveLockGUID        => $Row[17],
            ExclusiveLockUserID      => $Row[18],
            ExclusiveLockExpiryTime  => $Row[19],
            CreateTime               => $Row[20],
            CreateBy                 => $Row[21],
            ChangeTime               => $Row[22],
            ChangeBy                 => $Row[23],
            SettingUID               => "Default$Row[0]$TimeStamp",
        );
        push @Data, \%DefaultSetting;
    }

    if ( !$Param{NoCache} ) {
        $CacheObject->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => \@Data,
            TTL   => $Self->{CacheTTL},
        );
    }

    return @Data;
}

=head2 DefaultSettingList()

Get list of all settings.

    my @DefaultSettings = $SysConfigDBObject->DefaultSettingList(
        IncludeInvisible => 0,   # (optional) Include invisible. Default 0.
        IsDirty          => 0,   # (optional) Filter settings by IsDirty. If not provided, returns all settings.
        Locked           => 0,   # (optional) Filter locked settings.
    );

Returns:

    @DefaultSettings = (
        {
            DefaultID         => '123',
            Name              => 'SettingName1',
            IsDirty           => 1,
            IsVisible         => 1,
            ExclusiveLockGUID => 0,
            XMLFilename       => 'Filename.xml',
        },
        {
            DefaultID         => '124',
            Name              => 'SettingName2',
            IsDirty           => 0,
            IsVisible         => 1,
            ExclusiveLockGUID => 'fjewifjowj...',
            XMLFilename       => 'Filename.xml',
        },
        ...
    );

=cut

sub DefaultSettingList {
    my ( $Self, %Param ) = @_;

    my $CacheType = 'SysConfigDefaultList';
    my $CacheKey  = 'DefaultSettingList';

    $Param{IncludeInvisible} //= 0;

    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    my @DataRaw;
    if ( ref $Cache eq 'ARRAY' ) {
        @DataRaw = @{$Cache};
    }

    if ( !@DataRaw ) {

        # Start SQL statement.
        my $SQL = '
            SELECT id, name, is_dirty, exclusive_lock_guid, xml_content_raw, xml_filename, is_invisible
            FROM sysconfig_default
            ORDER BY id';

        return if !$DBObject->Prepare(
            SQL => $SQL,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @DataRaw, {
                DefaultID         => $Row[0],
                Name              => $Row[1],
                IsDirty           => $Row[2],
                ExclusiveLockGUID => $Row[3],
                XMLContentRaw     => $Row[4],
                XMLFilename       => $Row[5],
                IsInvisible       => $Row[6],
            };
        }

        $CacheObject->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => \@DataRaw,
            TTL   => $Self->{CacheTTL},
        );
    }

    # Copy DataRaw to prevent modifications to in memory cache.
    my @Data = @DataRaw;

    # filter
    if ( defined $Param{IsDirty} ) {
        @Data = grep { $_->{IsDirty} == $Param{IsDirty} } @Data;
    }
    if ( defined $Param{Locked} ) {
        if ( $Param{Locked} ) {

            # Filter only locked settings
            @Data = grep { $_->{ExclusiveLockGUID} } @Data;
        }
        else {
            # Filter only unlocked settings
            @Data = grep { !$_->{ExclusiveLockGUID} } @Data;
        }
    }

    if ( !$Param{IncludeInvisible} ) {

        # Filter only those settings that are visible.
        @Data = grep { !$_->{IsInvisible} } @Data;
    }

    return @Data;
}

=head2 DefaultSettingLock()

Lock Default setting(s) to the particular user.

    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        DefaultID => 1,                     # the ID of the setting that needs to be locked
                                            #    or
        Name      => 'SettingName',         # the Name of the setting that needs to be locked
                                            #    or
        LockAll   => 1,                     # system locks all settings.
        Force     => 1,                     # (optional) Force locking (do not check if it's already locked by another user). Default: 0.
        UserID    => 1,                     # (required)
    );

Returns:

    $ExclusiveLockGUID = 'azzHab72wIlAXDrxHexsI5aENsESxAO7';     # Setting locked

    or

    $ExclusiveLockGUID = undef;     # Not locked

=cut

sub DefaultSettingLock {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }
    if ( !$Param{DefaultID} && !$Param{Name} && !$Param{LockAll} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DefaultID, Name or LockAll!",
        );
        return;
    }

    # Check if a deployment is locked, in that case it's not possible to lock a setting.
    my $DeploymentLocked = $Self->DeploymentIsLocked();

    if ($DeploymentLocked) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "It's not possible to lock a setting if a deployment is currently locked.",
        );
        return;
    }

    my $Locked;

    if ( !$Param{LockAll} ) {

        # Check if it's already locked (skip if force is used).
        $Locked = $Self->DefaultSettingIsLocked(
            DefaultID => $Param{DefaultID},
            Name      => $Param{Name},
        );
    }

    return if ( !$Param{Force} && $Locked );

    # Check if setting can be locked(IsReadonly).
    my %DefaultSetting;
    if ( !$Param{LockAll} ) {

        %DefaultSetting = $Self->DefaultSettingGet(%Param);
        if ( $DefaultSetting{IsReadonly} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "It's not possible to lock readonly setting $DefaultSetting{Name}"
                    . " (UserID=$Param{UserID}!",
            );
            return;
        }
    }

    # Check correct length for ExclusiveLockGUID if defined.
    if ( defined $Param{ExclusiveLockGUID} && length( $Param{ExclusiveLockGUID} ) != 32 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The ExclusiveLockGUID is invalid!",
        );
        return;
    }

    # Setting is not locked, generate or use a locking string.
    my $ExclusiveLockGUID = $Param{ExclusiveLockGUID} || $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 32,
    );

    my $SettingExpireTimeMinutes = 5;

    # Get current time.
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $DateTimeObject->Add(
        Minutes => $SettingExpireTimeMinutes,
    );

    my $SQL = '
        UPDATE sysconfig_default
        SET
            exclusive_lock_guid = ?,
            exclusive_lock_user_id = ?,
            exclusive_lock_expiry_time = ?
        ';
    my $ExpiryTime = $DateTimeObject->ToString();
    my @Bind       = (
        \$ExclusiveLockGUID, \$Param{UserID},
        \$ExpiryTime,
    );

    if ( $Param{DefaultID} ) {
        $SQL .= '
            WHERE id = ?';
        push @Bind, \$Param{DefaultID};
    }
    elsif ( $Param{Name} ) {
        $SQL .= '
            WHERE name = ?';
        push @Bind, \$Param{Name};
    }

    # Add locking data to the setting record
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Check if there was cache for this type/key pair.
    my $DefaultSettingListGet = $CacheObject->Get(
        Type => 'SysConfigDefaultListGet',
        Key  => 'DefaultSettingListGet',
    );

    if ( $Param{LockAll} ) {
        $CacheObject->CleanUp(
            Type => 'SysConfigDefault',
        );
    }
    else {
        $CacheObject->Delete(
            Type => 'SysConfigDefault',
            Key  => 'DefaultSettingGet::' . $DefaultSetting{Name},
        );
    }
    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultListGet',
    );

    # Warm up the cache.
    if ($DefaultSettingListGet) {

        # Warm up existing cache.

        if (%DefaultSetting) {

            # Update one setting.

            my $Index;

            # Determine index of the element.
            LOOPINDEX:
            for my $LoopIndex ( 0 .. scalar @{$DefaultSettingListGet} - 1 ) {
                next LOOPINDEX if $DefaultSettingListGet->[$LoopIndex]->{DefaultID} ne $DefaultSetting{DefaultID};

                $Index = $LoopIndex;
                last LOOPINDEX;
            }

            # Update value.
            $DefaultSettingListGet->[$Index] = {
                %{ $DefaultSettingListGet->[$Index] },
                ExclusiveLockExpiryTime => $ExpiryTime,
                ExclusiveLockGUID       => $ExclusiveLockGUID,
                ExclusiveLockUserID     => $Param{UserID},
            };
        }
        else {
            # Update all settings.
            for my $Index ( 0 .. scalar @{$DefaultSettingListGet} - 1 ) {
                $DefaultSettingListGet->[$Index] = {
                    %{ $DefaultSettingListGet->[$Index] },
                    ExclusiveLockExpiryTime => $ExpiryTime,
                    ExclusiveLockGUID       => $ExclusiveLockGUID,
                    ExclusiveLockUserID     => $Param{UserID},
                };
            }
        }

        # Set new cache value.
        $CacheObject->Set(
            Type           => 'SysConfigDefaultListGet',
            Key            => 'DefaultSettingListGet',
            Value          => $DefaultSettingListGet,
            TTL            => $Self->{CacheTTL},
            CacheInBackend => 0,
        );
    }

    $CacheObject->Delete(
        Type => 'SysConfigDefaultList',
        Key  => 'DefaultSettingList',
    );

    return $ExclusiveLockGUID;
}

=head2 DefaultSettingIsLocked()

Check if particular Default Setting is locked.

    my $Locked = $SysConfigDBObject->DefaultSettingIsLocked(
        DefaultID     => 1,                 # the ID of the setting that needs to be checked
                                        #   or
        Name          => 'SettingName',     # the Name of the setting that needs to be checked
        GetLockUserID => 1,                 # optional, it will return the ExclusiveLockUserID in case it exist
    );

Returns:

    $Locked = 1;    # Locked
    or
    $Locked = 123   # The UserID

=cut

sub DefaultSettingIsLocked {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DefaultID or Name!",
        );
        return;
    }

    my %DefaultSetting = $Self->DefaultSettingGet(
        DefaultID => $Param{DefaultID},
        Name      => $Param{Name},
    );

    # The setting is not available, user can't update it anyways
    return 0 if !%DefaultSetting;

    # Check if it's locked.
    return 0 if !$DefaultSetting{ExclusiveLockExpiryTime};

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # Setting was locked, check if lock has expired.
    my $LockedDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $DefaultSetting{ExclusiveLockExpiryTime},
        },
    );

    my $Locked = $LockedDateTimeObject > $DateTimeObject ? 1 : 0;

    #  Remove locking if lock time is expired.
    if ( !$Locked ) {
        $Self->DefaultSettingUnlock( DefaultID => $Param{DefaultID} );
    }

    # Check if retrieve the ExclusiveLockUserID is needed
    elsif ( $Param{GetLockUserID} ) {
        $Locked = $DefaultSetting{ExclusiveLockUserID};
    }

    return $Locked;
}

=head2 DefaultSettingIsLockedByUser()

Check if particular Default Setting is locked.

    my $LockedByUser = $SysConfigDBObject->DefaultSettingIsLockedByUser(
        DefaultID             => 1,                 # the ID of the setting that needs to be checked
                                                    #   or
        Name                  => 'SettingName',     # the name of the setting that needs to be checked
        ExclusiveLockUserID   => 2,                 # the user should have locked the setting
        ExclusiveLockGUID     => 'AGUIDSTRING',     # the GUID used to locking the setting
    );

Returns:

    $LockedByUser = 1;

=cut

sub DefaultSettingIsLockedByUser {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ExclusiveLockUserID ExclusiveLockGUID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    if ( !$Param{DefaultID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DefaultID or Name!",
        );
        return;
    }

    return if !IsStringWithData( $Param{ExclusiveLockGUID} );

    # Get default setting.
    my %DefaultSetting = $Self->DefaultSettingGet(
        DefaultID => $Param{DefaultID},
        Name      => $Param{Name},
    );

    # Check if setting exists.
    return if !IsHashRefWithData( \%DefaultSetting );

    # Check ExclusiveLockUserID
    return if !$DefaultSetting{ExclusiveLockUserID};
    return if $DefaultSetting{ExclusiveLockUserID} ne $Param{ExclusiveLockUserID};

    # Check ExclusiveLockGUID.
    return if !$DefaultSetting{ExclusiveLockGUID};
    return if $DefaultSetting{ExclusiveLockGUID} ne $Param{ExclusiveLockGUID};

    my $ExclusiveLockGUID = $DefaultSetting{ExclusiveLockGUID};

    # Setting was locked, check if lock has expired.
    my $CurrentDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $LockedDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $DefaultSetting{ExclusiveLockExpiryTime},
        },
    );

    my $Locked = $LockedDateTimeObject > $CurrentDateTimeObject ? 1 : 0;

    # Extend locking time if the settings was already locked for this user but the time was expired.
    if ( !$Locked ) {

        $ExclusiveLockGUID = $Self->DefaultSettingLock(
            UserID            => $Param{ExclusiveLockUserID},
            DefaultID         => $Param{DefaultID},
            Name              => $Param{Name},
            ExclusiveLockGUID => $Param{ExclusiveLockGUID},
        );
    }

    return 1 if $ExclusiveLockGUID;
    return;
}

=head2 DefaultSettingUnlock()

Unlock particular or all Default Setting(s).

    my $Success = $SysConfigDBObject->DefaultSettingUnlock(
        DefaultID => 1,                     # the ID of the setting that needs to be unlocked
                                            #   or
        Name      => 'SettingName',         # the name of the setting that needs to be locked
                                            #   or
        UnlockAll => 1,                     # unlock all settings
    );

Returns:

    $Success = 1;

=cut

sub DefaultSettingUnlock {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultID} && !$Param{Name} && !$Param{UnlockAll} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DefaultID, Name or UnlockAll!",
        );
        return;
    }

    my @SettingsLocked;

    my %DefaultSetting;
    if ( $Param{UnlockAll} ) {

        # Get locked settings only.
        @SettingsLocked = $Self->DefaultSettingList(
            Locked => 1,
        );

        # all settings are unlocked already
        return 1 if !@SettingsLocked;
    }
    else {
        %DefaultSetting = $Self->DefaultSettingGet(
            %Param,
            NoCache => 1,
        );
        return if !%DefaultSetting;

        push @SettingsLocked, \%DefaultSetting;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        UPDATE sysconfig_default
        SET
            exclusive_lock_guid = ?,
            exclusive_lock_user_id = ?,
            exclusive_lock_expiry_time = ?
        WHERE
        ';

    my @Bind = ( \0, \undef, \undef );
    if ( $Param{DefaultID} ) {
        $SQL .= '
            id = ?';
        push @Bind, \$Param{DefaultID};
    }
    elsif ( $Param{Name} ) {
        $SQL .= '
            name = ?';
        push @Bind, \$Param{Name};
    }
    else {
        # UnlockAll

        $SQL .= '
            exclusive_lock_guid != ? ';
        push @Bind, \0;
    }

    # Remove locking from setting record.
    return if !$DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Check if there was cache for this type/key pair.
    my $DefaultSettingListGet = $CacheObject->Get(
        Type => 'SysConfigDefaultListGet',
        Key  => 'DefaultSettingListGet',
    );

    for my $Setting (@SettingsLocked) {
        $CacheObject->Delete(
            Type => 'SysConfigDefault',
            Key  => 'DefaultSettingGet::' . $Setting->{Name},
        );
    }

    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultListGet',
    );

    # Warm up the cache.
    if ($DefaultSettingListGet) {

        # Warm up existing cache.

        if (%DefaultSetting) {

            # Update one setting.

            my $Index;

            # Determine index of the element.
            LOOPINDEX:
            for my $LoopIndex ( 0 .. scalar @{$DefaultSettingListGet} - 1 ) {
                next LOOPINDEX if $DefaultSettingListGet->[$LoopIndex]->{DefaultID} ne $DefaultSetting{DefaultID};

                $Index = $LoopIndex;
                last LOOPINDEX;
            }

            # Update value.
            $DefaultSettingListGet->[$Index] = {
                %{ $DefaultSettingListGet->[$Index] },
                ExclusiveLockExpiryTime => undef,
                ExclusiveLockGUID       => 0,
                ExclusiveLockUserID     => undef,
            };
        }
        else {
            # Update all settings.
            for my $Index ( 0 .. scalar @{$DefaultSettingListGet} - 1 ) {
                $DefaultSettingListGet->[$Index] = {
                    %{ $DefaultSettingListGet->[$Index] },
                    ExclusiveLockExpiryTime => undef,
                    ExclusiveLockGUID       => 0,
                    ExclusiveLockUserID     => undef,
                };
            }
        }

        # Set new cache value.
        $CacheObject->Set(
            Type           => 'SysConfigDefaultListGet',
            Key            => 'DefaultSettingListGet',
            Value          => $DefaultSettingListGet,
            TTL            => $Self->{CacheTTL},
            CacheInBackend => 0,
        );
    }
    $CacheObject->Delete(
        Type => 'SysConfigDefaultList',
        Key  => 'DefaultSettingList',
    );

    return 1;
}

=head2 DefaultSettingDirtyCleanUp()

Removes the IsDirty flag from default settings.

    my $Success = $SysConfigDBObject->DefaultSettingDirtyCleanUp(
        AllSettings => 0,   # (default 0) Reset all dirty settings.
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub DefaultSettingDirtyCleanUp {
    my ( $Self, %Param ) = @_;

    my @DirtySettings;
    if ( !$Param{AllSettings} ) {
        @DirtySettings = $Self->DefaultSettingList(
            IsDirty => 1,
        );
    }

    # Remove is dirty flag for default settings.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE sysconfig_default
            SET is_dirty = 0
            WHERE is_dirty = 1',
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Check if there was cache for this type/key pair.
    my $DefaultSettingListGet = $CacheObject->Get(
        Type => 'SysConfigDefaultListGet',
        Key  => 'DefaultSettingListGet',
    );

    if ( $Param{AllSettings} ) {
        $CacheObject->CleanUp(
            Type => 'SysConfigDefault',
        );
    }
    else {
        for my $Setting (@DirtySettings) {
            $CacheObject->Delete(
                Type => 'SysConfigDefault',
                Key  => 'DefaultSettingGet::' . $Setting->{Name},
            );
        }
    }
    $CacheObject->CleanUp(
        Type => 'SysConfigDefaultListGet',
    );

    # Warm up the cache.
    if ($DefaultSettingListGet) {

        # Warm up existing cache.

        # Update all settings.
        for my $Index ( 0 .. scalar @{$DefaultSettingListGet} - 1 ) {
            $DefaultSettingListGet->[$Index]->{IsDirty} = 0;
        }

        # Set new cache value.
        $CacheObject->Set(
            Type           => 'SysConfigDefaultListGet',
            Key            => 'DefaultSettingListGet',
            Value          => $DefaultSettingListGet,
            TTL            => $Self->{CacheTTL},
            CacheInBackend => 0,
        );
    }

    $CacheObject->Delete(
        Type => 'SysConfigDefaultList',
        Key  => 'DefaultSettingList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    return 1;
}

=head2 DefaultSettingVersionAdd()

Add a new SysConfig default version entry.

    my $DefaultVersionID = $SysConfigDBObject->DefaultSettingVersionAdd(
        DefaultID                => 456,
        Name                     => "ProductName",
        Description              => "Defines the name of the application ...",
        Navigation               => "ASimple::Path::Structure",
        IsInvisible              => 1,                             # 1 or 0, optional, default 0
        IsReadonly               => 0,                             # 1 or 0, optional, default 0
        IsRequired               => 1,                             # 1 or 0, optional, default 0
        IsValid                  => 1,                             # 1 or 0, optional, default 0
        HasConfigLevel           => 200,                           # optional, default 0
        UserModificationPossible => 0,                             # 1 or 0, optional, default 0
        UserModificationActive   => 0,                             # 1 or 0, optional, default 0
        UserPreferencesGroup     => 'Advanced',                    # optional
        XMLContentRaw            => $XMLString,                    # the XML structure as it is on the config file
        XMLContentParsed         => $XMLParsedToPerl,              # the setting XML structure converted into YAML
        XMLFilename              => 'Framework.xml'                # the name of the XML file
        EffectiveValue           => $YAMLEffectiveValue,           # YAML EffectiveValue
        UserID                   => 1,
        NoCleanup                => 0,                             # (optional) Default 0. If enabled, system WILL NOT DELETE CACHE. In this case, it must be done manually.
                                                                   #    USE IT CAREFULLY.
        NoVersionID              => 1,                             # 1 or 0, optional, default 0, prevents the return of DefaultVersionID and returns only 1 in case of success.
    );

Returns:

    my $DefaultVersionID = 123;  # false in case of an error

=cut

sub DefaultSettingVersionAdd {
    my ( $Self, %Param ) = @_;

    for my $Key (
        qw(DefaultID Name Description Navigation XMLContentRaw XMLContentParsed XMLFilename EffectiveValue UserID)
        )
    {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # Check config level.
    $Param{HasConfigLevel} //= 0;

    if ( !IsPositiveInteger( $Param{HasConfigLevel} ) && $Param{HasConfigLevel} ne '0' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "HasConfigLevel must be an integer!",
        );

        return;
    }

    # Check boolean parameters, set 0 as default value.
    for my $Key (qw(IsInvisible IsReadonly IsRequired IsValid UserModificationPossible UserModificationActive)) {
        $Param{$Key} = ( defined $Param{$Key} && $Param{$Key} ? 1 : 0 );
    }
    if ( $Param{EffectiveValue} eq "/usr/bin/gpg/mod" ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need!"
        );
    }
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Insert the default.
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO sysconfig_default_version
                (sysconfig_default_id, name, description, navigation, is_invisible, is_readonly, is_required, is_valid,
                has_configlevel, user_modification_possible, user_modification_active, user_preferences_group,
                xml_content_raw, xml_content_parsed, xml_filename, effective_value, create_time, create_by,
                change_time, change_by)
            VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{DefaultID}, \$Param{Name}, \$Param{Description}, \$Param{Navigation},
            \$Param{IsInvisible}, \$Param{IsReadonly}, \$Param{IsRequired}, \$Param{IsValid}, \$Param{HasConfigLevel},
            \$Param{UserModificationPossible}, \$Param{UserModificationActive}, \$Param{UserPreferencesGroup},
            \$Param{XMLContentRaw}, \$Param{XMLContentParsed}, \$Param{XMLFilename}, \$Param{EffectiveValue},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # Get default version ID.
    $DBObject->Prepare(
        SQL => '
            SELECT id
            FROM sysconfig_default_version
            WHERE sysconfig_default_id = ? AND name = ?
            ORDER BY id DESC
            ',
        Bind  => [ \$Param{DefaultID}, \$Param{Name} ],
        Limit => 1,
    );

    # Fetch the default setting ID
    my $DefaultVersionID;

    if ( $Param{NoVersionID} ) {
        $DefaultVersionID = 1;
    }
    else {
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $DefaultVersionID = $Row[0];
        }
    }
    if ( !$Param{NoCleanup} ) {
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        $CacheObject->CleanUp(
            Type => 'SysConfigDefaultVersion',
        );

        $CacheObject->CleanUp(
            Type => 'SysConfigDefaultVersionList',
        );
    }

    return $DefaultVersionID;
}

=head2 DefaultSettingVersionGet()

Get SysConfig default version entry.

    my %DefaultSettingVersion = $SysConfigDBObject->DefaultSettingVersionGet(
        DefaultVersionID => 123,
    );

Returns:

    %DefaultSettingVersion = (
        DefaultVersionID         => 123,
        DefaultID                => 456,
        Name                     => "ProductName",
        Description              => "Defines the name of the application ...",
        Navigation               => "ASimple::Path::Structure",
        IsInvisible              => 1,         # 1 or 0
        IsReadonly               => 0,         # 1 or 0
        IsRequired               => 1,         # 1 or 0
        IsValid                  => 1,         # 1 or 0
        HasConfigLevel           => 200,
        UserModificationPossible => 0,         # 1 or 0
        UserModificationActive   => 0,         # 1 or 0
        UsePreferencesGroup      => 'Advanced',         # optional
        XMLContentRaw            => "The XML structure as it is on the config file",
        XMLContentParsed         => "XML parsed to Perl",
        XMLFilename              => 'Framework.xml',
        EffectiveValue           => "Product 6",
        CreateTime               => "2016-05-29 11:04:04",
        CreateBy                 => 44,
        ChangeTime               => "2016-05-29 11:04:04",
        ChangeBy                 => 88,
    );

=cut

sub DefaultSettingVersionGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultVersionID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need DefaultVersionID!',
        );
        return;
    }

    my $FieldName;
    my $FieldValue;

    if ( $Param{DefaultVersionID} ) {

        # Set DefaultID as filter.
        $FieldName  = 'id';
        $FieldValue = $Param{DefaultVersionID};
    }
    elsif ( $Param{Name} ) {

        # Set Name as filter
        $FieldName  = 'name';
        $FieldValue = $Param{Name};
    }

    my $CacheType = "SysConfigDefaultVersion";
    my $CacheKey  = 'DefaultSettingVersionGet::' . $FieldName . '::' . $FieldValue;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get default from database.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, sysconfig_default_id, name, description, navigation, is_invisible, is_readonly, is_required,
                is_valid, has_configlevel, user_modification_possible, user_modification_active, user_preferences_group,
                xml_content_raw, xml_content_parsed, xml_filename, effective_value, create_time, create_by,
                change_time, change_by
            FROM sysconfig_default_version
            WHERE ' . $FieldName . ' = ?',
        Bind => [ \$FieldValue ],
    );

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %DefaultSettingVersion;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # De-serialize default data.
        my $XMLContentParsed = $YAMLObject->Load( Data => $Data[14] );
        my $EffectiveValue   = $YAMLObject->Load( Data => $Data[16] );

        %DefaultSettingVersion = (
            DefaultVersionID         => $Data[0],
            DefaultID                => $Data[1],
            Name                     => $Data[2],
            Description              => $Data[3],
            Navigation               => $Data[4],
            IsInvisible              => $Data[5],
            IsReadonly               => $Data[6],
            IsRequired               => $Data[7],
            IsValid                  => $Data[8],
            HasConfigLevel           => $Data[9],
            UserModificationPossible => $Data[10],
            UserModificationActive   => $Data[11],
            UserPreferencesGroup     => $Data[12] || '',
            XMLContentRaw            => $Data[13],
            XMLContentParsed         => $XMLContentParsed,
            XMLFilename              => $Data[15],
            EffectiveValue           => $EffectiveValue,
            CreateTime               => $Data[17],
            CreateBy                 => $Data[18],
            ChangeTime               => $Data[19],
            ChangeBy                 => $Data[20],
        );
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%DefaultSettingVersion,
        TTL   => $Self->{CacheTTL},
    );

    return %DefaultSettingVersion;
}

=head2 DefaultSettingVersionDelete()

Delete a default setting version from list based on default version ID or default ID.

    my $Success = $SysConfigDBObject->DefaultSettingVersionDelete(
        DefaultVersionID => 123,
    );

or

    my $Success = $SysConfigDBObject->DefaultSettingVersionDelete(
        DefaultID => 45,
    );

or

    my $Success = $SysConfigDBObject->DefaultSettingVersionDelete(
        Name => 'AnyName',
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub DefaultSettingVersionDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultVersionID} && !$Param{DefaultID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID, DefaultID or Name!',
        );
        return;
    }

    my $FieldName;
    my $FieldValue;

    if ( $Param{DefaultVersionID} ) {

        # Set conditions for id.
        $FieldName  = 'id';
        $FieldValue = $Param{DefaultVersionID};
    }
    elsif ( $Param{DefaultID} ) {

        # Set conditions for default id.
        $FieldName  = 'sysconfig_default_id';
        $FieldValue = $Param{DefaultID};
    }
    elsif ( $Param{Name} ) {

        # Set conditions for name.
        $FieldName  = 'name';
        $FieldValue = $Param{Name};

    }

    # Delete default from the list.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM sysconfig_default_version WHERE ' . $FieldName . ' = ?',
        Bind => [ \$FieldValue ],
    );

    if ( !$Param{DefaultVersionID} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'SysConfigDefaultVersion',
        );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigDefaultVersion',
            Key  => 'DefaultSettingVersionGet::id::' . $Param{DefaultVersionID},
        );
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'SysConfigDefaultVersionList',
    );

    return 1;
}

=head2 DefaultSettingVersionGetLast()

Get last deployment.

    my %DefaultSettingVersionGetLast = $SysConfigDBObject->DefaultSettingVersionGetLast(
        DefaultID => 456,
    );

Returns:


    %DefaultSettingVersion = (
        DefaultVersionID         => 123,
        DefaultID                => 456,
        Name                     => "ProductName",
        Description              => "Defines the name of the application ...",
        Navigation               => "ASimple::Path::Structure",
        IsInvisible              => 1,         # 1 or 0
        IsReadonly               => 0,         # 1 or 0
        IsRequired               => 1,         # 1 or 0
        IsValid                  => 1,         # 1 or 0
        HasConfigLevel           => 200,
        UserModificationPossible => 0,         # 1 or 0
        UserModificationActive   => 0,         # 1 or 0
        UsePreferencesGroup      => 'Advanced',         # optional
        XMLContentRaw            => "The XML structure as it is on the config file",
        XMLContentParsed         => "XML parsed to Perl",
        XMLFilename              => 'Framework.xml',
        EffectiveValue           => "Product 6",
        CreateTime               => "2016-05-29 11:04:04",
        ChangeTime               => "2016-05-29 11:04:04",
    );

=cut

sub DefaultSettingVersionGetLast {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need DefaultID!',
        );
        return;
    }

    my $CacheType = 'SysConfigDefaultVersion';
    my $CacheKey  = 'DefaultSettingVersionGetLast::' . $Param{DefaultID};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => 'SELECT MAX(id) FROM sysconfig_default_version WHERE sysconfig_default_id = ?',
        Bind => [ \$Param{DefaultID} ],
    );

    my $DefaultVersionID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DefaultVersionID = $Row[0];
    }

    return if !$DefaultVersionID;

    my %DefaultSettingVersion = $Self->DefaultSettingVersionGet(
        DefaultVersionID => $DefaultVersionID,
    );

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%DefaultSettingVersion,
        TTL   => $Self->{CacheTTL},
    );

    return %DefaultSettingVersion;
}

=head2 DefaultSettingVersionListGet()

Get version setting list with complete data.

    my @List = $SysConfigDBObject->DefaultSettingVersionListGet(
        Name       => 'SettingName',      # optional
                                          # or
        DefaultID  => 123,                # optional
    );

Returns:

    @List = (
        {
            DefaultVersionID         => 123,
            DefaultID                => 456,
            Name                     => "ProductName",
            Description              => "Defines the name of the application ...",
            Navigation               => "ASimple::Path::Structure",
            IsInvisible              => 1,          # 1 or 0
            IsReadonly               => 0,          # 1 or 0
            IsRequired               => 1,          # 1 or 0
            IsValid                  => 1,          # 1 or 0
            HasConfigLevel           => 200,
            UserModificationPossible => 0,          # 1 or 0
            UserModificationActive   => 0,          # 1 or 0
            UserPreferencesGroup     => 'Advanced', # optional
            XMLContentRaw            => "The XML structure as it is on the config file",
            XMLContentParsed         => "XML parsed to Perl",
            XMLFilename              => 'Framework.xml',
            EffectiveValue           => "Product 6",
            CreateTime               => "2016-05-29 11:04:04",
            ChangeTime               => "2016-05-29 11:04:04",
        },
        {
            DefaultVersionID => 321,
            DefaultID        => 890,
            Name             => 'FieldName',
            # ...
            CreateTime => '2010-09-11 10:08:00',
            ChangeTime => '2011-01-01 01:01:01',
        },
        # ...
    );

=cut

sub DefaultSettingVersionListGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need DefaultID or Name!',
        );
        return;
    }

    my $FieldName;
    my $FieldValue;
    my $FieldCache;

    if ( $Param{DefaultID} ) {

        # Set conditions for default id.
        $FieldName  = 'sysconfig_default_id';
        $FieldValue = $Param{DefaultID};
        $FieldCache = "DefaultID::$Param{DefaultID}";
    }
    elsif ( $Param{Name} ) {

        # Set conditions for name.
        $FieldName  = 'name';
        $FieldValue = $Param{Name};
        $FieldCache = "Name::$Param{Name}";
    }

    # Set filters on SQL and cache key.
    my $SQLFilter = "WHERE $FieldName = '$FieldValue' ";

    my $CacheType = 'SysConfigDefaultVersionList';
    my $CacheKey  = 'DefaultSettingVersionList::' . $FieldCache;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY';

    # Start SQL statement.
    my $SQL = 'SELECT id, name FROM sysconfig_default_version ' . $SQLFilter . ' ORDER BY id DESC';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @Data;
    return if !$DBObject->Prepare( SQL => $SQL );

    my @DefaultVersionIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @DefaultVersionIDs, $Row[0];
    }

    # Get default settings.
    for my $ItemID (@DefaultVersionIDs) {

        my %DefaultSetting = $Self->DefaultSettingVersionGet(
            DefaultVersionID => $ItemID,
        );
        push @Data, \%DefaultSetting;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return @Data;
}

=head2 ModifiedSettingAdd()

Add a new SysConfig modified entry.

    my $ModifiedID = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID                   => 456,
        Name                        => "ProductName",
        IsValid                     => 1,                             # 1 or 0, optional (uses the value from DefaultSetting if not defined)
        UserModificationPossible    => 0,                             # 1 or 0, optional (uses the value from DefaultSetting if not defined)
        UserModificationActive      => 0,                             # 1 or 0, optional (uses the value from DefaultSetting if not defined)
        ResetToDefault              => 0,                             # 1 or 0, optional, modified 0
        EffectiveValue              => $SettingEffectiveValue,
        TargetUserID                => 2,                             # Optional, ID of the user for which the modified setting is meant,
                                                                      #   leave it undef for global changes.
        ExclusiveLockGUID           => $LockingString,                # the GUID used to lock the setting
        DeploymentExclusiveLockGUID => $LockingString,                # the GUID used to lock the deployment (in case of deployment failure)
        UserID                      => 1,
    );

Returns:

    my $ModifiedID = 123;  # false in case of an error

=cut

sub ModifiedSettingAdd {
    my ( $Self, %Param ) = @_;

    # Store params for further usage.
    my %ModifiedVersionParams = %Param;

    for my $Key (qw(DefaultID Name UserID)) {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    if ( !$Param{TargetUserID} && !$Param{ExclusiveLockGUID} && !$Param{DeploymentExclusiveLockGUID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ExclusiveLockGUID or DeploymentExclusiveLockGUID!",
        );
    }

    # Check duplicate name (with same TargetUserID).
    my %ModifiedSetting = $Self->ModifiedSettingGet(
        Name         => $Param{Name},
        TargetUserID => $Param{TargetUserID},
    );

    if (%ModifiedSetting) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "There is already a modified setting for this user (or global)!",
        );
        return;
    }

    # Check duplicate name.
    my %DefaultSetting = $Self->DefaultSettingGet(
        DefaultID => $Param{DefaultID},
    );

    if ( !%DefaultSetting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "DefaultID is invalid!",
        );

        return;
    }

    if ( $Param{Name} ne $DefaultSetting{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Name doesn't match ('$Param{Name}')! It should be '$DefaultSetting{Name}'.",
        );

        return;
    }

    # Check we have not UserModificationActive if we have TargetUserID they are exclusive.
    if ( defined $Param{UserModificationActive} && $Param{TargetUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not set UserModificationActive on a user setting!",
        );

        return;
    }

    # Update params with DefaultSetting if not defined.
    for my $Attribute (qw(UserModificationActive IsValid)) {
        $Param{$Attribute} //= $DefaultSetting{$Attribute};
        $Param{$Attribute} = $Param{$Attribute} ? 1 : 0;
    }

    # Is possible to disable UserModificationActive just if it is enabled on default.
    if ( !$DefaultSetting{UserModificationPossible} && $Param{UserModificationActive} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not UserModificationActive if default setting prohibits!",
        );

        return;
    }

    # Serialize data as string.
    $Param{EffectiveValue} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Param{EffectiveValue},
    );

    # Set is dirty as enabled due it is a new setting.
    my $IsDirty = 1;

    $Param{ResetToDefault} = $Param{ResetToDefault} ? 1 : 0;

    # Default should be locked.
    my $LockedByUser = 1;
    if ( !$Param{TargetUserID} ) {
        $LockedByUser = $Self->DefaultSettingIsLockedByUser(
            DefaultID           => $Param{DefaultID},
            ExclusiveLockUserID => $Param{UserID},
            ExclusiveLockGUID   => $Param{ExclusiveLockGUID},
        );
    }

    # Check if we are on a deployment and a deleted value needs to be restored due an error
    if ( !$LockedByUser && $Param{DeploymentExclusiveLockGUID} ) {
        $LockedByUser = $Self->DeploymentIsLockedByUser(
            ExclusiveLockGUID => $Param{DeploymentExclusiveLockGUID},
            UserID            => $Param{UserID},
        );
    }

    if ( !$LockedByUser ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Default setting is not locked to this user!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Insert the modified.
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO sysconfig_modified
                (sysconfig_default_id, name, user_id, is_valid, user_modification_active,
                effective_value, is_dirty, reset_to_default, create_time, create_by, change_time, change_by)
            VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{DefaultID}, \$Param{Name}, \$Param{TargetUserID}, \$Param{IsValid},
            \$Param{UserModificationActive}, \$Param{EffectiveValue},
            \$IsDirty, \$Param{ResetToDefault}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    my $SQLSelect = 'SELECT id, effective_value FROM sysconfig_modified
            WHERE sysconfig_default_id = ?
                AND name = ?
                AND is_dirty = ? ';

    my @BindSelect = ( \$Param{DefaultID}, \$Param{Name}, \$IsDirty );

    if ( $Param{TargetUserID} ) {
        $SQLSelect .= "AND user_id = ? ";
        push @BindSelect, \$Param{TargetUserID};
    }
    else {
        $SQLSelect .= "AND user_id IS NULL ";
    }

    # Get modified ID.
    $DBObject->Prepare(
        SQL   => $SQLSelect,
        Bind  => \@BindSelect,
        Limit => 1,
    );

    # Fetch the modified setting ID.
    my $ModifiedSettingID;

    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        next ROW if $Row[1] ne $Param{EffectiveValue};
        $ModifiedSettingID = $Row[0];
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'SysConfigModified',
    );
    $CacheObject->Delete(
        Type => 'SysConfigModifiedList',
        Key  => 'ModifiedSettingList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigNavigation',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigEntities',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    # Clean cache for setting translations.
    my %Languages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
    for my $Language ( sort keys %Languages ) {
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "SettingTranslatedGet::$Language" . "::$Param{Name}",
        );
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "ConfigurationTranslatedGet::$Language",
        );
    }

    # Unlock the setting.
    my $IsUnlock = $Self->DefaultSettingUnlock(
        DefaultID => $Param{DefaultID},
    );
    if ( !$IsUnlock ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Default setting with ID: $Param{DefaultID} was not possible to unlock!",
        );
        return;
    }

    return $ModifiedSettingID;
}

=head2 ModifiedSettingGet()

Get SysConfig modified value.

    my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
        ModifiedID            => 123,               # ModifiedID or NAME are required.
        Name                  => 'Setting::Name',
        TargetUserID          => 2,                 # The ID of the user for which the modified setting is meant,
                                                    #   exclusive with IsGlobal.
        IsGlobal              => 1,                 # Define a search for settings don't belong an user,
                                                    #   exclusive with TargetUserID.
    );

Returns:

    %ModifiedSetting = (
        ModifiedID             => "123",
        DefaultID              => 456,
        Name                   => "ProductName",
        IsGlobal               => 1,     # 1 or 0, optional
        IsValid                => 1,     # 1 or 0, optional, modified 0
        IsDirty                => 1,     # 1 or 0, optional, modified 0
        ResetToDefault         => 1,     # 1 or 0, optional, modified 0
        UserModificationActive => 0,     # 1 or 0, optional, modified 0
        EffectiveValue         => $SettingEffectiveValue,
        TargetUserID           => 2,     # ID of the user for which the modified setting is meant
        CreateTime             => "2016-05-29 11:04:04",
        CreateBy               => 1,
        ChangeTime             => "2016-05-29 11:04:04",
        ChangeBy               => 1,
        SettingUID             => 'Modified12320160529110404',
    );

=cut

sub ModifiedSettingGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ModifiedID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ModifiedID or Name!',
        );
        return;
    }

    my $FieldName;
    my $FieldValue;

    if ( $Param{ModifiedID} ) {

        # Set DefaultID as filter.
        $FieldName  = 'id';
        $FieldValue = $Param{ModifiedID};
    }
    elsif ( $Param{Name} ) {

        # Set Name as filter.
        $FieldName  = 'name';
        $FieldValue = $Param{Name};
    }

    # IsGlobal and TargetUserID are exclusive each other.
    if ( defined $Param{IsGlobal} && defined $Param{TargetUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Use IsGlobal and TargetUserID at the same time is not allowed!",
        );
        return;
    }

    # Check optional settings.
    for my $Item (qw(IsGlobal TargetUserID)) {
        $Param{$Item} //= 0;
    }

    # Ff not defined TargetUserID it should be global.
    if ( !$Param{TargetUserID} && $FieldName eq 'name' ) {
        $Param{IsGlobal} = 1;
    }

    my $SQLExtra = '';
    my @Bind     = ( \$FieldValue );

    # In case of global search user value is needed as null.
    if ( $Param{IsGlobal} ) {
        $SQLExtra = '
            AND user_id IS NULL';
    }

    # Otherwise check effective user id.
    elsif ( $Param{TargetUserID} ) {
        $SQLExtra = "
            AND user_id = ? ";
        push @Bind, \$Param{TargetUserID};
    }

    my $CacheType = "SysConfigModified";
    my $CacheKey  = 'ModifiedSettingGet::'    # this cache key gets more elements
        . $FieldName . '::'
        . $FieldValue . '::'
        . $Param{IsGlobal} . '::'
        . $Param{TargetUserID};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        SELECT id, sysconfig_default_id, name, user_id, is_valid, user_modification_active,
            effective_value, is_dirty, reset_to_default, create_time, create_by, change_time, change_by
        FROM sysconfig_modified
        WHERE';

    $SQL .= ' ' . $FieldName . ' = ?' . $SQLExtra;

    $SQL .= '
        ORDER BY id DESC';

    # Get modified from database.
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %ModifiedSetting;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # De-serialize modified data.
        my $EffectiveValue = $YAMLObject->Load( Data => $Data[6] );

        my $TimeStamp = $Data[11];
        $TimeStamp =~ s{:|-|[ ]}{}gmsx;

        %ModifiedSetting = (
            ModifiedID             => $Data[0],
            DefaultID              => $Data[1],
            Name                   => $Data[2],
            TargetUserID           => $Data[3],
            IsValid                => $Data[4],
            UserModificationActive => $Data[5],
            EffectiveValue         => $EffectiveValue,
            IsDirty                => $Data[7] ? 1 : 0,
            ResetToDefault         => $Data[8] ? 1 : 0,
            CreateTime             => $Data[9],
            CreateBy               => $Data[10],
            ChangeTime             => $Data[11],
            ChangeBy               => $Data[12],
            SettingUID             => "Modified$Data[0]$TimeStamp",
        );
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%ModifiedSetting,
        TTL   => $Self->{CacheTTL},
    );

    return %ModifiedSetting;
}

=head2 ModifiedSettingListGet()

Get modified setting list with complete data.

    my @List = $SysConfigDBObject->ModifiedSettingListGet(
        IsInvisible            => 1,                 # 1 or 0
        IsReadonly             => 0,                 # 1 or 0
        IsRequired             => 1,                 # 1 or 0
        IsValid                => 1,                 # 1 or 0
        IsDirty                => 1,                 # 1 or 0
        ResetToDefault         => 1,                 # 1 or 0
        TargetUserID           => 2,                 # the ID of the user for which the modified setting is meant,
                                                     # exclusive with IsGlobal.
        IsGlobal               => 1,                 # Define a search for settings don't belong an user,
                                                     #   exclusive with TargetUserID.
        HasConfigLevel         => 0,                 # 1 or 0
        UserModificationActive => 0,                 # 1 or 0
        Name                   => 'ACL::CacheTTL',   # setting name
        ChangeBy               => 123,
    );

Returns:

    @List = (
        {
            ModifiedID              => 123,
            Name                    => "ProductName",
            Description             => "Defines the name of the application ...",
            Navigation              => "ASimple::Path::Structure",
            IsInvisible             => 1,
            IsReadonly              => 0,
            IsRequired              => 1,
            IsValid                 => 1,
            ResetToDefault         => 1,                 # 1 or 0
            HasConfigLevel          => 200,
            UserModificationActive  => 0,       # 1 or 0
            XMLContentRaw           => "The XML structure as it is on the config file",
            XMLContentParsed        => "XML parsed to Perl",
            EffectiveValue          => "Product 6",
            IsDirty                 => 1,       # 1 or 0
            ExclusiveLockGUID       => 'A32CHARACTERLONGSTRINGFORLOCKING',
            ExclusiveLockUserID     => 1,
            ExclusiveLockExpiryTime => '2016-05-29 11:09:04',
            CreateTime              => "2016-05-29 11:04:04",
            ChangeTime              => "2016-05-29 11:04:04",
        },
        {
            ModifiedID => 321,
            Name       => 'FieldName',
            # ...
            CreateTime => '2010-09-11 10:08:00',
            ChangeTime => '2011-01-01 01:01:01',
        },
        # ...
    );

=cut

sub ModifiedSettingListGet {
    my ( $Self, %Param ) = @_;

    # IsGlobal and TargetUserID are exclusive each other.
    if ( defined $Param{IsGlobal} && defined $Param{TargetUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Use IsGlobal and TargetUserID at the same time is not allowed!",
        );
        return;
    }

    my @Filters;
    my @Bind;

    my $CacheType = 'SysConfigModifiedList';
    my $CacheKey  = 'ModifiedSettingList';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    my @DataRaw;

    if ( ref $Cache eq 'ARRAY' ) {
        @DataRaw = @{$Cache};
    }
    else {
        my $SQL = '
            SELECT id, sysconfig_default_id, name, user_id, is_valid, user_modification_active,
                effective_value, is_dirty, reset_to_default, create_time, create_by, change_time, change_by
            FROM sysconfig_modified';

        $SQL .= ' ORDER BY id';

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Get modified from database.
        return if !$DBObject->Prepare(
            SQL  => $SQL,
            Bind => \@Bind,
        );

        my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

        while ( my @Row = $DBObject->FetchrowArray() ) {

            # De-serialize modified data.
            my $EffectiveValue = $YAMLObject->Load( Data => $Row[6] );

            my $TimeStamp = $Row[11];
            $TimeStamp =~ s{:|-|[ ]}{}gmsx;

            my %ModifiedSetting = (
                ModifiedID             => $Row[0],
                DefaultID              => $Row[1],
                Name                   => $Row[2],
                TargetUserID           => $Row[3],
                IsValid                => $Row[4],
                UserModificationActive => $Row[5],
                EffectiveValue         => $EffectiveValue,
                IsDirty                => $Row[7] ? 1 : 0,
                ResetToDefault         => $Row[8] ? 1 : 0,
                CreateTime             => $Row[9],
                CreateBy               => $Row[10],
                ChangeTime             => $Row[11],
                ChangeBy               => $Row[12],
                SettingUID             => "Modified$Row[0]$TimeStamp",
            );

            push @DataRaw, \%ModifiedSetting;
        }

        $CacheObject->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => \@DataRaw,
            TTL   => $Self->{CacheTTL},
        );
    }

    # Copy DataRaw to prevent modifications to in memory cache.
    my @Data = @DataRaw;

    if ( defined $Param{IsInvisible} ) {
        @Data = grep { $_->{IsInvisible} eq $Param{IsInvisible} } @Data;
    }
    if ( defined $Param{IsReadonly} ) {
        @Data = grep { $_->{IsReadonly} eq $Param{IsReadonly} } @Data;
    }
    if ( defined $Param{IsRequired} ) {
        @Data = grep { $_->{IsRequired} eq $Param{IsRequired} } @Data;
    }
    if ( defined $Param{IsValid} ) {
        @Data = grep { $_->{IsValid} eq $Param{IsValid} } @Data;
    }
    if ( defined $Param{IsDirty} ) {
        @Data = grep { $_->{IsDirty} eq $Param{IsDirty} } @Data;
    }
    if ( defined $Param{HasConfigLevel} ) {
        @Data = grep { $_->{HasConfigLevel} eq $Param{HasConfigLevel} } @Data;
    }
    if ( defined $Param{UserModificationActive} ) {
        @Data = grep { $_->{UserModificationActive} eq $Param{UserModificationActive} } @Data;
    }
    if ( defined $Param{Name} ) {
        @Data = grep { $_->{Name} eq $Param{Name} } @Data;
    }
    if ( defined $Param{TargetUserID} ) {
        @Data = grep { $_->{TargetUserID} && $_->{TargetUserID} eq $Param{TargetUserID} } @Data;
    }
    if ( defined $Param{ChangeBy} ) {
        @Data = grep { $_->{ChangeBy} eq $Param{ChangeBy} } @Data;
    }
    if ( defined $Param{Locked} ) {
        if ( $Param{Locked} ) {
            @Data = grep { $_->{ExclusiveLockGUID} } @Data;
        }
        else {
            @Data = grep { !$_->{ExclusiveLockGUID} } @Data;
        }
    }
    if ( $Param{IsGlobal} ) {
        @Data = grep { !$_->{TargetUserID} } @Data;
    }

    return @Data;
}

=head2 ModifiedSettingDelete()

Delete a modified setting from list.

    my $Success = $SysConfigDBObject->ModifiedSettingDelete(
        ModifiedID => 123,
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub ModifiedSettingDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ModifiedID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ModifiedID!',
        );
        return;
    }

    my %ModifiedSetting = $Self->ModifiedSettingGet(
        ModifiedID => $Param{ModifiedID},
    );

    return if !IsHashRefWithData( \%ModifiedSetting );

    # Delete modified from the list.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM sysconfig_modified WHERE id = ?',
        Bind => [ \$Param{ModifiedID} ],
    );

    for my $Item (qw(0 1)) {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigModified',
            Key  => 'ModifiedSettingGet::id::'
                . $ModifiedSetting{ModifiedID} . '::'
                . $Item . '::0',
        );
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigModified',
            Key  => 'ModifiedSettingGet::name::'
                . $ModifiedSetting{Name} . '::'
                . $Item . '::0',
        );
    }

    if ( $ModifiedSetting{TargetUserID} ) {

        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigModified',
            Key  => 'ModifiedSettingGet::id::'
                . $ModifiedSetting{ModifiedID} . '::0::'
                . $ModifiedSetting{TargetUserID},
        );
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigModified',
            Key  => 'ModifiedSettingGet::name::'
                . $ModifiedSetting{Name} . '::0::'
                . $ModifiedSetting{TargetUserID},
        );
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->Delete(
        Type => 'SysConfigModifiedList',
        Key  => 'ModifiedSettingList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigNavigation',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigEntities',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    # Clean cache for setting translations.
    my %Languages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
    for my $Language ( sort keys %Languages ) {
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "SettingTranslatedGet::$Language" . "::$ModifiedSetting{Name}",
        );
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "ConfigurationTranslatedGet::$Language",
        );
    }

    return 1;
}

=head2 ModifiedSettingUpdate()

Update SysConfig modified.

    my $Success = $SysConfigDBObject->ModifiedSettingUpdate(
        ModifiedID             => 123,                           # (required)
        DefaultID              => 456,                           # (required)
        Name                   => "ProductName",                 # (required)
        IsValid                => 1,                             # (optional) 1 or 0, optional (uses the value from DefaultSetting if not defined)
        IsDirty                => 1,                             # (optional) Default 1.
        ResetToDefault         => 1,                             # (optional), default 0
        UserModificationActive => 1,                             # (optional) 1 or 0 (uses the value from DefaultSetting if not defined)
        EffectiveValue         => $SettingEffectiveValue,
        TargetUserID           => 2,                             # (optional), ID of the user for which the modified setting is meant,
                                                                 #   leave it undef for global changes.
        ExclusiveLockGUID      => $LockingString,                # the GUID used to locking the setting
        UserID                 => 1,                             # (required)
    );

Returns:

    $Success = 1;   # or false in case of an error

=cut

sub ModifiedSettingUpdate {
    my ( $Self, %Param ) = @_;

    # Store params for further usage.
    my %ModifiedVersionParams = %Param;

    for my $Key (qw(ModifiedID DefaultID Name EffectiveValue UserID)) {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # Set is dirty to 1 if not defined.
    $Param{IsDirty} //= 1;

    # Get modified setting.
    my %ModifiedSetting = $Self->ModifiedSettingGet(
        ModifiedID => $Param{ModifiedID},
    );

    # Check if we really need to update.
    my $IsDifferent = 0;
    for my $Key (qw(ModifiedID DefaultID Name IsValid EffectiveValue UserModificationActive)) {
        my $DataIsDifferent = DataIsDifferent(
            Data1 => $Param{$Key},
            Data2 => $ModifiedSetting{$Key},
        );
        if ($DataIsDifferent) {
            $IsDifferent = 1;
        }
    }

    if ( $ModifiedSetting{IsDirty} != $Param{IsDirty} ) {
        $IsDifferent = 1;
    }

    return 1 if !$IsDifferent;

    # Retrieve default setting.
    my %DefaultSetting = $Self->DefaultSettingGet(
        DefaultID => $Param{DefaultID},
    );

    if ( !%DefaultSetting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "DefaultID is invalid!",
        );

        return;
    }

    if ( $Param{Name} ne $DefaultSetting{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Name is Invalid!",
        );

        return;
    }

    # Check we have not UserModificationActive if we have TargetUserID they are exclusive
    if ( defined $Param{UserModificationActive} && $Param{TargetUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not set UserModificationActive on a user setting!",
        );
        return;
    }

    # Update params with DefaultSetting if not defined.
    for my $Attribute (qw(UserModificationActive IsValid)) {
        $Param{$Attribute} //= $DefaultSetting{$Attribute};
        $Param{$Attribute} = $Param{$Attribute} ? 1 : 0;
    }

    # Is possible to disable UserModificationActive just if it is enabled on default.
    if ( !$DefaultSetting{UserModificationPossible} && $Param{UserModificationActive} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not UserModificationActive if default setting prohibits!",
        );
        return;
    }

    # Serialize data as string.
    $Param{EffectiveValue} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Param{EffectiveValue},
    );

    $Param{ResetToDefault} = $Param{ResetToDefault} ? 1 : 0;

    # Default should be locked.
    my $LockedByUser = 1;
    if ( !$Param{UserID} ) {
        $LockedByUser = $Self->DefaultSettingIsLockedByUser(
            DefaultID           => $Param{DefaultID},
            ExclusiveLockUserID => $Param{UserID},
            ExclusiveLockGUID   => $Param{ExclusiveLockGUID},
        );
    }

    if ( !$LockedByUser ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Default setting is not locked to this user!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Insert the modified.
    return if !$DBObject->Do(
        SQL => '
            UPDATE sysconfig_modified
            SET sysconfig_default_id = ?, name = ?, is_valid = ?, user_modification_active = ?,
                effective_value = ?, is_dirty = ?, reset_to_default = ?, change_time = current_timestamp, change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{DefaultID}, \$Param{Name}, \$Param{IsValid}, \$Param{UserModificationActive},
            \$Param{EffectiveValue}, \$Param{IsDirty}, \$Param{ResetToDefault},
            \$Param{UserID}, \$Param{ModifiedID},
        ],
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'SysConfigModified',
    );
    $CacheObject->Delete(
        Type => 'SysConfigModifiedList',
        Key  => 'ModifiedSettingList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigNavigation',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigEntities',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    # Clean cache for setting translations.
    my %Languages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
    for my $Language ( sort keys %Languages ) {
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "SettingTranslatedGet::$Language" . "::$Param{Name}",
        );
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => "ConfigurationTranslatedGet::$Language",
        );
    }

    return 1;
}

=head2 ModifiedSettingDirtyCleanUp()

Removes the IsDirty flag from modified settings.

    my $Success = $SysConfigDBObject->ModifiedSettingDirtyCleanUp(
        TargetUserID => 123,        # (optional)
        ModifiedIDs     => [        # (optional) applies to only this list of settings
            123,
            456,
        ],
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub ModifiedSettingDirtyCleanUp {
    my ( $Self, %Param ) = @_;

    if ( defined $Param{TargetUserID} && !IsPositiveInteger( $Param{TargetUserID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "TargetUserID is invalid",
        );
        return;
    }

    if ( defined $Param{ModifiedIDs} && !IsArrayRefWithData( $Param{ModifiedIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ModifiedIDs is invalid",
        );
        return;
    }

    # Define common SQL.
    my $SQL = '
        UPDATE sysconfig_modified
        SET is_dirty = 0
        WHERE is_dirty = 1';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{ModifiedIDs} ) {

        my $ModifiedIDsStrg = join ',', map { $DBObject->Quote( $_, 'Integer' ) } @{ $Param{ModifiedIDs} };

        $SQL .= "
            AND id IN ($ModifiedIDsStrg)";
    }

    my @Bind;

    # Define user condition.
    my $UserCondition = '
        AND user_id IS NULL';
    if ( $Param{TargetUserID} ) {
        $UserCondition = '
            AND user_id = ?';
        push @Bind, \$Param{TargetUserID};
    }

    # Remove is dirty flag for modified settings.
    return if !$DBObject->Do(
        SQL  => $SQL . $UserCondition,
        Bind => \@Bind,
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'SysConfigModified',
    );
    $CacheObject->Delete(
        Type => 'SysConfigModifiedList',
        Key  => 'ModifiedSettingList',
    );

    $CacheObject->CleanUp(
        Type => 'SysConfigModifiedVersion',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigIsDirty',
    );

    return 1;
}

=head2 ModifiedSettingVersionAdd()

Add a new SysConfig modified version entry.

    my $ModifiedVersionID = $SysConfigDBObject->ModifiedSettingVersionAdd(
        DefaultVersionID       => 456,
        Name                   => "ProductName",
        IsValid                => 1,                             # 1 or 0, optional, optional 0
        UserModificationActive => 0,                             # 1 or 0, optional, optional 0
        TargetUserID           => 2,                             # The ID of the user for which the modified setting is meant,
                                                                 # leave it undef for global changes.
        EffectiveValue         => $SettingEffectiveValue,        # the value as will be stored in the Perl configuration file
        DeploymentTimeStamp    => '2015-12-12 12:00:00',         # unique timestamp per deployment
        ResetToDefault         => 1,                             # optional, default 0
        UserID                 => 1,
    );

Returns:

    my $ModifiedVersionID = 123;  # false in case of an error

=cut

sub ModifiedSettingVersionAdd {
    my ( $Self, %Param ) = @_;

    for my $Key (
        qw(DefaultVersionID Name EffectiveValue DeploymentTimeStamp UserID)
        )
    {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # Check boolean parameters, set 0 as default value).
    for my $Key (qw(IsValid UserModificationActive ResetToDefault)) {
        $Param{$Key} = ( defined $Param{$Key} && $Param{$Key} ? 1 : 0 );
    }

    # Serialize data as string.
    $Param{EffectiveValue} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Param{EffectiveValue},
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Insert the modified.
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO sysconfig_modified_version
                (sysconfig_default_version_id, name, user_id, is_valid, reset_to_default,
                user_modification_active, effective_value, create_time, create_by,
                change_time, change_by)
            VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Param{DefaultVersionID}, \$Param{Name}, \$Param{TargetUserID}, \$Param{IsValid},
            \$Param{ResetToDefault}, \$Param{UserModificationActive},
            \$Param{EffectiveValue}, \$Param{DeploymentTimeStamp}, \$Param{UserID},
            \$Param{DeploymentTimeStamp}, \$Param{UserID},
        ],
    );

    # Get modified ID.
    $DBObject->Prepare(
        SQL => '
            SELECT id
            FROM sysconfig_modified_version
            WHERE sysconfig_default_version_id =?
                AND name = ?
            ORDER BY id DESC',
        Bind  => [ \$Param{DefaultVersionID}, \$Param{Name} ],
        Limit => 1,
    );

    # Fetch the modified setting ID
    my $ModifiedVersionID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ModifiedVersionID = $Row[0];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'SysConfigModifiedVersion',
    );
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'SysConfigModifiedVersionList',
    );

    return $ModifiedVersionID;
}

=head2 ModifiedSettingVersionGet()

Get SysConfig modified version entry.

    my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
        ModifiedVersionID => 123,
    );

Returns:

    %ModifiedSetting = (
        ModifiedVersionID      => 123,
        DefaultVersionID       => 456,
        Name                   => "ProductName",
        TargetUserID           => 123,
        IsValid                => 1,         # 1 or 0
        ResetToDefault         => 1,         # 1 or 0
        UserModificationActive => 0,         # 1 or 0
        EffectiveValue         => "Product 6",
        CreateTime             => "2016-05-29 11:04:04",
        ChangeTime             => "2016-05-29 11:04:04",
    );

=cut

sub ModifiedSettingVersionGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ModifiedVersionID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ModifiedVersionID!',
        );
        return;
    }

    my $CacheType = "SysConfigModifiedVersion";
    my $CacheKey  = 'ModifiedSettingVersionGet::' . $Param{ModifiedVersionID};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get modified from database.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT smv.id, smv.sysconfig_default_version_id, sdv.sysconfig_default_id, sm.id,
                smv.name, smv.user_id,
                smv.is_valid, smv.reset_to_default, smv.user_modification_active, smv.effective_value,
                smv.create_time, smv.change_time
            FROM sysconfig_modified_version smv
            LEFT JOIN sysconfig_default_version sdv
                ON smv.sysconfig_default_version_id = sdv.id
            LEFT JOIN sysconfig_modified sm
                ON sdv.sysconfig_default_id = sm.sysconfig_default_id
            WHERE smv.id = ?',
        Bind => [ \$Param{ModifiedVersionID} ],
    );

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %ModifiedSettingVersion;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # De-serialize modified data.
        my $EffectiveValue = $YAMLObject->Load( Data => $Data[9] );

        %ModifiedSettingVersion = (
            ModifiedVersionID      => $Data[0],
            DefaultVersionID       => $Data[1],
            DefaultID              => $Data[2],
            ModifiedID             => $Data[3],
            Name                   => $Data[4],
            TargetUserID           => $Data[5],
            IsValid                => $Data[6],
            ResetToDefault         => $Data[7] ? 1 : 0,
            UserModificationActive => $Data[8],
            EffectiveValue         => $EffectiveValue,
            DeploymentTimeStamp    => $Data[10],
            CreateTime             => $Data[10],
            ChangeTime             => $Data[11],
        );
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%ModifiedSettingVersion,
        TTL   => $Self->{CacheTTL},
    );

    return %ModifiedSettingVersion;
}

=head2 ModifiedSettingVersionListGet()

Get version setting list with complete data.

    my @List = $SysConfigDBObject->ModifiedSettingVersionListGet(
        Name              => 1, # optional
        DefaultVersionID  => 230, # optional
    );

Returns:

    @List = (
        {
            ModifiedVersionID      => 123,
            ModifiedID             => 456,
            Name                   => "ProductName",
            TargetUserID           => 78,
            IsValid                => 1,         # 1 or 0
            ResetToDefault         => 1,         # 1 or 0
            UserModificationActive => 0,         # 1 or 0
            EffectiveValue         => "Product 6",
            CreateTime             => "2016-05-29 11:04:04",
            ChangeTime             => "2016-05-29 11:04:04",
        },
        {
            ModifiedVersionID      => 789,
            ModifiedID             => 579,
            Name                   => "ADifferentProductName",
            TargetUserID           => 909,
            IsValid                => 1,         # 1 or 0
            ResetToDefault         => 1,         # 1 or 0
            UserModificationActive => 0,         # 1 or 0
            . . .
        },
        # ...
    );

=cut

sub ModifiedSettingVersionListGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DefaultVersionID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need DefaultVersionID or Name!',
        );
        return;
    }

    my $FieldName;
    my $FieldValue;
    my $FieldCache;

    if ( $Param{DefaultVersionID} ) {

        # Set conditions for modified ID.
        $FieldName  = 'sysconfig_default_version_id';
        $FieldValue = $Param{DefaultVersionID};
        $FieldCache = 'DefaultVersionID';
    }
    elsif ( $Param{Name} ) {

        # Set conditions for name.
        $FieldName  = 'name';
        $FieldValue = $Param{Name};
        $FieldCache = 'Name';
    }

    # Loop over filters and set them on SQL and cache key.
    my $SQLFilter = "WHERE $FieldName = '$FieldValue' ";

    my $CacheType = 'SysConfigModifiedVersionList';
    my $CacheKey  = 'ModifiedSettingVersionList::' . $FieldCache . '=' . $FieldValue;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY';

    # Start SQL statement.
    my $SQL = '
        SELECT id, name
        FROM sysconfig_modified_version';

    $SQL .= ' ' . $SQLFilter . ' ORDER BY id DESC';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @Data;
    return if !$DBObject->Prepare(
        SQL => $SQL,
    );

    my @ModifiedVersionIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @ModifiedVersionIDs, $Row[0];
    }

    # Get modified settings.
    ITEMID:
    for my $ItemID (@ModifiedVersionIDs) {

        my %ModifiedSetting = $Self->ModifiedSettingVersionGet(
            ModifiedVersionID => $ItemID,
        );

        next ITEMID if !%ModifiedSetting;

        push @Data, \%ModifiedSetting;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return @Data;
}

=head2 ModifiedSettingVersionGetLast()

Get last deployment.

    my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGetLast(
        Name => 'ProductName',
    );

Returns:

    %ModifiedSettingVersion = (
        DefaultVersionID       => 123,
        ModifiedID             => 456,
        Name                   => "ProductName",
        TargetUserID           => 45,
        IsValid                => 1,         # 1 or 0
        ResetToDefault         => 1,         # 1 or 0
        UserModificationActive => 0,         # 1 or 0
        EffectiveValue         => "Product 6",
        CreateTime             => "2016-05-29 11:04:04",
        ChangeTime             => "2016-05-29 11:04:04",
    );

=cut

sub ModifiedSettingVersionGetLast {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }

    my $CacheType = 'SysConfigModifiedVersion';
    my $CacheKey  = 'ModifiedSettingVersionGetLast::' . $Param{Name};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => 'SELECT MAX(id) FROM sysconfig_modified_version WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );

    my $ModifiedVersionID;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $ModifiedVersionID = $Row[0];
    }

    return if !$ModifiedVersionID;

    my %ModifiedSetting = $Self->ModifiedSettingVersionGet(
        ModifiedVersionID => $ModifiedVersionID,
    );

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%ModifiedSetting,
        TTL   => $Self->{CacheTTL},
    );

    return %ModifiedSetting;
}

=head2 ModifiedSettingVersionListGetLast()

Get a list of the last deployed version of each modified SysConfig setting

    my @List = $SysConfigDBObject->ModifiedSettingVersionListGetLast();

Returns:

    @List = (
        {
            ModifiedVersionID      => 123,
            ModifiedID             => 456,
            Name                   => "ProductName",
            TargetUserID           => 78,
            IsValid                => 1,         # 1 or 0
            ResetToDefault         => 1,         # 1 or 0
            UserModificationActive => 0,         # 1 or 0
            EffectiveValue         => "Product 6",
            CreateTime             => "2016-05-29 11:04:04",
            ChangeTime             => "2016-05-29 11:04:04",
        },
        {
            ModifiedVersionID      => 789,
            ModifiedID             => 579,
            Name                   => "ADifferentProductName",
            TargetUserID           => 909,
            IsValid                => 1,         # 1 or 0
            ResetToDefault         => 1,         # 1 or 0
            UserModificationActive => 0,         # 1 or 0
            . . .
        },
        # ...
    );

=cut

sub ModifiedSettingVersionListGetLast {
    my ( $Self, %Param ) = @_;

    my $CacheType = 'SysConfigModifiedVersionList';
    my $CacheKey  = 'ModifiedSettingVersionListGetLast';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @Data;
    return if !$DBObject->Prepare(
        SQL => '
            SELECT MAX(id), sysconfig_default_version_id
            FROM sysconfig_modified_version
            GROUP BY sysconfig_default_version_id
            ORDER BY sysconfig_default_version_id ASC'
    );

    my @ModifiedVersionIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @ModifiedVersionIDs, $Row[0];
    }

    # Get modified settings.
    for my $ItemID (@ModifiedVersionIDs) {

        my %ModifiedSetting = $Self->ModifiedSettingVersionGet(
            ModifiedVersionID => $ItemID,
        );
        push @Data, \%ModifiedSetting;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return @Data;
}

=head2 ModifiedSettingVersionDelete()

Delete a modified setting version from list based on modified version ID or modified ID.

    my $Success = $SysConfigDBObject->ModifiedSettingVersionDelete(
        ModifiedVersionID => 123,
    );

or

    my $Success = $SysConfigDBObject->ModifiedSettingVersionDelete(
        ModifiedID => 45,
    );

or

    my $Success = $SysConfigDBObject->ModifiedSettingVersionDelete(
        Name => 'AnyName',
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub ModifiedSettingVersionDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ModifiedVersionID} && !$Param{ModifiedID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID, ModifiedID or Name!',
        );
        return;
    }

    my $FieldName;
    my $FieldValue;

    if ( $Param{ModifiedVersionID} ) {

        # Set conditions for ID.
        $FieldName  = 'id';
        $FieldValue = $Param{ModifiedVersionID};
    }
    elsif ( $Param{DefaultVersionID} ) {

        # Set conditions for default version id.
        $FieldName  = 'sysconfig_default_version_id';
        $FieldValue = $Param{DefaultVersionID};
    }
    elsif ( $Param{Name} ) {

        # Set conditions for name.
        $FieldName  = 'name';
        $FieldValue = $Param{Name};

    }

    # Delete modified from the list.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM sysconfig_modified_version WHERE ' . $FieldName . ' = ?',
        Bind => [ \$FieldValue ],
    );

    if ( $FieldName eq 'id' ) {

        my %ModifiedVersionSetting = $Self->ModifiedSettingVersionGet(
            ModifiedVersionID => $FieldValue,

        );
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigModifiedVersion',
            Key  => 'ModifiedSettingVersionGet::' . $FieldValue,
        );
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigModifiedVersion',
            Key  => 'ModifiedSettingVersionGetLast::' . $ModifiedVersionSetting{DefaultVersionID},
        );
    }
    else {

        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'SysConfigModifiedVersion',
        );
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'SysConfigModifiedVersionList',
    );

    return 1;
}

=head2 ConfigurationIsDirty()

Check if there are not deployed changes on system configuration.

    my $Result = $SysConfigDBObject->ConfigurationIsDirty(
        UserID => 123,      # optional, the user that changes a modified setting
    );

Returns:

    $Result = 1;    # or 0 if configuration is not dirty.

=cut

sub ConfigurationIsDirty {
    my ( $Self, %Param ) = @_;

    my $CacheType = 'SysConfigIsDirty';
    my $CacheKey  = 'IsDirty';

    if ( $Param{UserID} ) {
        $CacheKey .= "::UserID=$Param{UserID}";
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return ${$Cache} if ref $Cache eq 'SCALAR';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        SELECT sd.id
        FROM sysconfig_default sd
            LEFT OUTER JOIN sysconfig_modified sm ON sm.name = sd.name
        WHERE ';

    my $SQLWhere = 'sd.is_dirty = 1 OR (sm.user_id IS NULL AND sm.is_dirty = 1)';

    my @Bind;
    if ( $Param{UserID} ) {
        $SQLWhere = 'sd.is_dirty = 1 OR (sm.user_id IS NULL AND sm.is_dirty = 1 AND sm.change_by = ? )';
        push @Bind, \$Param{UserID};
    }

    $SQL .= $SQLWhere;

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my $Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = 1;
    }

    $Result //= '0';

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \$Result,
        TTL   => $Self->{CacheTTL},
    );

    return $Result;
}

=head2 DeploymentAdd()

Adds a new deployment.

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'Some Comments',              # optional
        EffectiveValueStrg  => $EffectiveValuesStrgRef,      # string reference with the value of all settings,
                                                             #   to be stored in a Perl cache file
        TargetUserID        => 123,                          # to deploy only user specific settings
        ExclusiveLockGUID   => $LockingString,               # the GUID used to locking the deployment,
                                                             #      not needed if TargetUserID is used
        DeploymentTimeStamp => '1977-12-12 12:00:00',
        UserID              => 123,
    );

Returns:

    $DeploymentID = 123;        # or false in case of an error

=cut

sub DeploymentAdd {
    my ( $Self, %Param ) = @_;

    for my $Key (qw(UserID DeploymentTimeStamp)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    if ( !defined $Param{EffectiveValueStrg} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need EffectiveValueStrg!"
        );
        return;
    }

    if ( !$Param{TargetUserID} && !$Param{ExclusiveLockGUID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ExclusiveLockGUID",
        );
    }

    if ( ref $Param{EffectiveValueStrg} ne 'SCALAR' || !IsStringWithData( ${ $Param{EffectiveValueStrg} } ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EffectiveValueStrg is invalid!",
        );
        return;
    }

    if ( exists $Param{TargetUserID} && !$Param{TargetUserID} ) {
        delete $Param{TargetUserID};
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @UserDeploymentIDs;
    if ( $Param{TargetUserID} ) {

        # Remember previous user deployments.
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id
                FROM sysconfig_deployment
                WHERE user_id = ?',
            Bind => [ \$Param{TargetUserID}, ],
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @UserDeploymentIDs, $Row[0];
        }
    }
    else {
        my $ExclusiveLockGUID = $Self->DeploymentIsLockedByUser(
            ExclusiveLockGUID => $Param{ExclusiveLockGUID},
            UserID            => $Param{UserID},
        );

        if ( !$ExclusiveLockGUID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Deployment is not locked to this user!",
            );
            return;
        }
    }

    my $UID = 'OTRSInvalid-' . $Self->_GetUID();

    # Create a deployment record without the real comments.
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO sysconfig_deployment
                (comments, effective_value, user_id, create_time, create_by)
            VALUES
                (?, ?, ?, ?, ?)',
        Bind => [
            \$UID, \${ $Param{EffectiveValueStrg} }, \$Param{TargetUserID}, \$Param{DeploymentTimeStamp},
            \$Param{UserID},
        ],
    );

    # Get deployment ID.
    my $SQL = '
        SELECT id
        FROM sysconfig_deployment
        WHERE comments = ?
            AND create_by = ?';

    my @Bind = ( \$UID, \$Param{UserID} );

    if ( $Param{TargetUserID} ) {
        $SQL .= '
            AND user_id = ?
        ';
        push @Bind, \$Param{TargetUserID};
    }
    else {
        $SQL .= '
            AND user_id IS NULL
        ';
    }

    $SQL .= '
        ORDER BY id DESC';

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    # Fetch the deployment ID.
    my $DeploymentID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DeploymentID = $Row[0];
    }

    my $CurrentDeploymentIDStr = 'CurrentDeploymentID';
    if ( $Param{TargetUserID} ) {
        $CurrentDeploymentIDStr = 'CurrentUserDeploymentID';
    }

    # Add the deployment ID to the values
    ${ $Param{EffectiveValueStrg} }
        =~ s{( \s+ my [ ] \(\$File, [ ] \$Self\) [ ] = [ ] \@_; \s+ )}{$1\$Self->{'$CurrentDeploymentIDStr'} = '$DeploymentID';\n}msx;

    # Set the real deployment value.
    return if !$DBObject->Do(
        SQL => '
            Update sysconfig_deployment
            SET comments = ?, effective_value = ?
            WHERE id = ?',
        Bind => [
            \$Param{Comments}, \${ $Param{EffectiveValueStrg} }, \$DeploymentID,
        ],
    );

    # Remove previous user deployments (if any).
    for my $DeploymentID (@UserDeploymentIDs) {
        $Self->DeploymentDelete(
            DeploymentID => $DeploymentID,
        );
    }

    if ( $Param{TargetUserID} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigDeployment',
            Key  => 'DeploymentUserList',
        );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigDeployment',
            Key  => 'DeploymentList',
        );
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigDeployment',
            Key  => 'DeploymentGetLast',
        );
    }

    return $DeploymentID;
}

=head2 DeploymentGet()

Gets deployment information.

    my %Deployment = $SysConfigDBObject->DeploymentGet(
        DeploymentID => 123,
        Valid        => 1,      # optional (this is deprecated and will be removed in next mayor release).
    );

Returns:

    %Deployment = (
        DeploymentID       => 123,
        Comments           => 'Some Comments',
        EffectiveValueStrg => $SettingEffectiveValues,      # string with the value of all settings,
                                                            #   as seen in the Perl configuration file.
        TargetUserID       => 123,                          # optional (only in case of user specific deployments).
        CreateTime         => "2016-05-29 11:04:04",
        CreateBy           => 123,
    );

=cut

sub DeploymentGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DeploymentID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DeploymentID!",
        );

        return;
    }

    my $CacheType = "SysConfigDeployment";
    my $CacheKey  = 'DeploymentGet::DeploymentID::' . $Param{DeploymentID};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get deployment from database.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, comments, effective_value, user_id, create_time, create_by
            FROM sysconfig_deployment
            WHERE id = ?',
        Bind => [ \$Param{DeploymentID} ],
    );

    my %Deployment;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        %Deployment = (
            DeploymentID       => $Data[0],
            Comments           => $Data[1],
            EffectiveValueStrg => $Data[2],
            TargetUserID       => $Data[3],
            CreateTime         => $Data[4],
            CreateBy           => $Data[5],
        );
    }

    return if !%Deployment;

    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    if ( $Deployment{EffectiveValueStrg} eq 'Invalid' && $Valid ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The Deployment $Param{DeploymentID} is invalid!",
        );
        return;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Deployment,
        TTL   => $Self->{CacheTTL},
    );

    return %Deployment;
}

=head2 DeploymentListGet()

Get global deployment list with complete data.

    my @List = $SysConfigDBObject->DeploymentListGet();

Returns:

    @List = (
        {
            DeploymentID       => 123,
            Comments           => 'Some Comments',
            EffectiveValueStrg => $SettingEffectiveValues,      # String with the value of all settings,
                                                                #   as seen in the Perl configuration file.
            CreateTime         => "2016-05-29 11:04:04",
            CreateBy           => 123,
        },
        {
            DeploymentID       => 456,
            Comments           => 'Some Comments',
            EffectiveValueStrg => $SettingEffectiveValues2,     # String with the value of all settings,
                                                                #   as seen in the Perl configuration file.
            CreateTime         => "2016-05-29 12:00:01",
            CreateBy           => 123,
        },
        # ...
    );

=cut

sub DeploymentListGet {
    my ( $Self, %Param ) = @_;

    my $CacheKey = 'DeploymentList';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => 'SysConfigDeployment',
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @Data;
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM sysconfig_deployment
            WHERE user_id IS NULL
            ORDER BY id DESC',
    );

    my @DeploymentIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @DeploymentIDs, $Row[0];
    }

    # Get deployments.
    for my $ItemID (@DeploymentIDs) {

        my %Deployment = $Self->DeploymentGet(
            DeploymentID => $ItemID,
        );
        push @Data, \%Deployment;
    }

    $CacheObject->Set(
        Type  => 'SysConfigDeployment',
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return @Data;
}

=head2 DeploymentUserList()

Get DeploymentID -> UserID list of all user deployments.

    my %List = $SysConfigDBObject->DeploymentUserList();

Returns:
    %List = {
        9876 => 123,
        5432 => 456,
        # ...
    };

=cut

sub DeploymentUserList {
    my ( $Self, %Param ) = @_;

    my $CacheKey = 'DeploymentUserList';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => 'SysConfigDeployment',
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @Data;
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, user_id
            FROM sysconfig_deployment
            WHERE user_id IS NOT NULL
            ORDER BY id DESC',
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    $CacheObject->Set(
        Type  => 'SysConfigDeployment',
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return %Data;
}

=head2 DeploymentGetLast()

Get last global deployment.

    my %Deployment = $SysConfigDBObject->DeploymentGetLast();

Returns:

    %Deployment = (
        DeploymentID       => 123,
        Comments           => 'Some Comments',
        EffectiveValueStrg => $SettingEffectiveValues,      # String with the value of all settings,
                                                            #   as seen in the Perl configuration file.
        CreateTime         => "2016-05-29 11:04:04",
        CreateBy           => 123,
    );

=cut

sub DeploymentGetLast {
    my ( $Self, %Param ) = @_;

    my $CacheKey = 'DeploymentGetLast';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => 'SysConfigDeployment',
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $DeploymentID;
    return if !$DBObject->Prepare(
        SQL => '
            SELECT MAX(id)
            FROM sysconfig_deployment
            WHERE user_id IS NULL',
    );

    my @DeploymentID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DeploymentID = $Row[0];
    }

    return if !$DeploymentID;

    my %Deployment = $Self->DeploymentGet(
        DeploymentID => $DeploymentID,
    );

    $CacheObject->Set(
        Type  => 'SysConfigDeployment',
        Key   => $CacheKey,
        Value => \%Deployment,
        TTL   => $Self->{CacheTTL},
    );

    return %Deployment;
}

=head2 DeploymentDelete()

Delete a deployment from the database.

    my $Success = $SysConfigDBObject->DeploymentDelete(
        DeploymentID => 123,
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub DeploymentDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DeploymentID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need DeploymentID!',
        );
        return;
    }

    my %Deployment = $Self->DeploymentGet(
        DeploymentID => $Param{DeploymentID},
        Valid        => 0,
    );

    return 1 if !%Deployment;

    # Delete deployment from the data base.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM sysconfig_deployment WHERE id = ?',
        Bind => [ \$Param{DeploymentID} ],
    );

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SysConfigDeployment',
        Key  => 'DeploymentGet::DeploymentID::' . $Param{DeploymentID},
    );

    if ( $Deployment{TargetUserID} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigDeployment',
            Key  => 'DeploymentUserList',
        );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigDeployment',
            Key  => 'DeploymentList',
        );
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SysConfigDeployment',
            Key  => 'DeploymentGetLast',
        );
    }

    return 1;
}

=head2 DeploymentLock()

Lock global deployment to a particular user.

    my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID            => 123,
        ExclusiveLockGUID => $LockingString,    # optional (if specific GUID is needed)
        Force             => 1,                 # Optional, locks the deployment even if is already
                                                #   locked to another user, also removes locks for
                                                #   all settings.
    );

Returns:

    $ExclusiveLockGUID = 'SomeLockingString';   # or false in case of an error or already locked

=cut

sub DeploymentLock {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # It's not possible to lock a deployment if a setting is locked on a valid time.
    my @LockedList;
    if ( $Param{Force} ) {

        my $Success = $Self->DefaultSettingUnlock(
            UnlockAll => 1,
        );
    }
    else {
        @LockedList = $Self->DefaultSettingListGet(
            Locked => 1,
        );
    }

    # Get current time.
    my $CurrentDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    if ( IsArrayRefWithData( \@LockedList ) ) {
        LOCKED:
        for my $Locked (@LockedList) {

            next LOCKED if $Locked->{ExclusiveLockUserID} ne $Param{UserID};

            my $LockedDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Locked->{ExclusiveLockExpiryTime},
                },
            );

            my $IsLocked = $LockedDateTimeObject > $CurrentDateTimeObject ? 1 : 0;

            if ($IsLocked) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "It's not possible to lock a deployment if a setting is currently locked ($Locked->{Name}).",
                );
                return;
            }
        }
    }

    if ( defined $Param{ExclusiveLockGUID} && length $Param{ExclusiveLockGUID} != 32 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ExclusiveLockGUID is invalid",
        );
        return;
    }

    if ( $Param{Force} ) {
        my $Success = $Self->DeploymentUnlock(
            All => 1,
        );
    }

    # Check if it's already locked.
    return if $Self->DeploymentIsLocked();

    # If its not locked use or create a new locking string.
    my $ExclusiveLockGUID = $Param{ExclusiveLockGUID} || $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 32,
    );

    my $DeploymentExpireTimeMinutes = 5;

    # Set expire time.
    $DateTimeObject->Add(
        Minutes => $DeploymentExpireTimeMinutes,
    );
    my $ExpiryTime = $DateTimeObject->ToString();

    my $SQL = '
        INSERT INTO sysconfig_deployment_lock
            ( exclusive_lock_guid, exclusive_lock_user_id, exclusive_lock_expiry_time )
        VALUES
            ( ?, ?, ? )';

    my @Bind = (
        \$ExclusiveLockGUID, \$Param{UserID},
        \$ExpiryTime,
    );

    # Create db record.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return $ExclusiveLockGUID;
}

=head2 DeploymentIsLocked()

Check if global deployment is locked.

    my $Locked = $SysConfigDBObject->DeploymentIsLocked();

Returns:

   $Locked = 1;     # or false if it is not locked

=cut

sub DeploymentIsLocked {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get deployment lock from the DB.
    my %DeploymentLock = $Self->_DeploymentLockGet();

    # Return no lock if there is no locking information.
    return if !%DeploymentLock;

    # Return no lock if there is no lock expiry time.
    return if !$DeploymentLock{ExclusiveLockExpiryTime};

    # Deployment was locked, check if lock has expired.

    # Get current time.
    my $CurrentDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $LockedDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $DeploymentLock{ExclusiveLockExpiryTime},
        },
    );

    my $Locked = $LockedDateTimeObject > $CurrentDateTimeObject ? 1 : 0;

    if ( !$Locked ) {
        $Self->DeploymentUnlock(
            All => 1,
        );
    }

    return $Locked;
}

=head2 DeploymentIsLockedByUser()

Check if global deployment is locked for a determined user.

    my $LockedByUser = $SysConfigDBObject->DeploymentIsLockedByUser(
        ExclusiveLockGUID => $LockingString,    # the GUID used to locking the deployment
        UserID            => 123,               # the user should have locked the deployment
    );

Returns:

    $LockedByUser = 'SomeLockingString';    # or false in case of not locked

=cut

sub DeploymentIsLockedByUser {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(UserID ExclusiveLockGUID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return if !IsStringWithData( $Param{ExclusiveLockGUID} );

    # ExclusiveLockGUID should not be 0
    return if !$Param{ExclusiveLockGUID};

    # Get deployment lock from the DB.
    my %DeploymentLock = $Self->_DeploymentLockGet();

    # Return no lock if there is no locking information.
    return if !%DeploymentLock;

    # Return no lock if there is no lock expiry time.
    return if !$DeploymentLock{ExclusiveLockExpiryTime};

    # Check ExclusiveLockUserID
    return if $DeploymentLock{ExclusiveLockUserID} ne $Param{UserID};

    # Check ExclusiveLockGUID
    return if !$DeploymentLock{ExclusiveLockGUID};
    return if $DeploymentLock{ExclusiveLockGUID} ne $Param{ExclusiveLockGUID};

    my $ExclusiveLockGUID = $DeploymentLock{ExclusiveLockGUID};

    # If deployment was locked, check if lock has expired.
    my $CurrentDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $LockedDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $DeploymentLock{ExclusiveLockExpiryTime},
        },
    );

    my $Locked = $LockedDateTimeObject > $CurrentDateTimeObject ? 1 : 0;

    # Extend the time if it was already locked for the user but time has been expired
    if ( !$Locked ) {
        $ExclusiveLockGUID = $Self->DeploymentLock(
            UserID            => $Param{UserID},
            ExclusiveLockGUID => $Param{ExclusiveLockGUID},
        );

        return if !$ExclusiveLockGUID;
    }

    return 1;
}

=head2 DeploymentModifiedVersionList()

Return a list of modified versions for a global deployment based on the deployment time. Limited
to a particular deployment or including also all previous deployments

    my %ModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
        DeploymentID => 123,        # the deployment id
        Mode         => 'Equals'    # (optional) default 'Equals'
                                    #   Equals: only the settings from the given deployment
                                    #   GreaterThan: only the settings after the given deployment
                                    #   GreaterThanEquals: includes the settings of the given deployment and after
                                    #   SmallerThan: only the settings before the given deployment
                                    #   SmallerThanEquals: includes the settings of the given deployment and before
    );

Returns:

    %ModifiedVersionIDs = (
        123 => 'Setting1',
        124 => 'Setting2',
        125 => 'Setting3'
    );

=cut

sub DeploymentModifiedVersionList {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DeploymentID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DeploymentID!",
        );
        return;
    }

    my $Mode        = $Param{Mode} // 'Equals';
    my %ModeMapping = (
        Equals            => '=',
        GreaterThan       => '>',
        GreaterThanEquals => '>=',
        SmallerThan       => '<',
        SmallerThanEquals => '<=',
    );
    if ( !$ModeMapping{$Mode} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Mode $Mode is invalid!",
        );
        return;
    }

    my %Deployment = $Self->DeploymentGet(
        DeploymentID => $Param{DeploymentID},
    );
    return if !IsHashRefWithData( \%Deployment );
    return if $Deployment{TargetUserID};

    my $CreateTime = $Deployment{CreateTime} || '';
    return if !$CreateTime;

    my $SQL = "
        SELECT max(smv.id) id, smv.name
        FROM sysconfig_modified_version smv
        WHERE smv.create_time $ModeMapping{$Mode} ?
        GROUP BY smv.name";

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => [ \$CreateTime, ]
    );

    my %ModifiedVersionList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ModifiedVersionList{ $Row[0] } = $Row[1];
    }

    return %ModifiedVersionList;

}

=head2 DeploymentUnlock()

Unlock global deployment.

    my $Success = $SysConfigDBObject->DeploymentUnlock(
        ExclusiveLockGUID => '12ad34f21b',
        UserID            => 123,
    );

or

    my $Success = $SysConfigDBObject->DeploymentUnlock(
        All  => 1,
    );

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub DeploymentUnlock {
    my ( $Self, %Param ) = @_;

    # Check needed
    if ( !$Param{ExclusiveLockGUID} && !$Param{UserID} && !$Param{All} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'All or ExclusiveLockGUID and UserID are needed!',
        );
        return;
    }

    if ( ( $Param{ExclusiveLockGUID} && !$Param{UserID} ) || ( $Param{UserID} && !$Param{ExclusiveLockGUID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ExclusiveLockGUID and UserID are needed!',
        );
        return;
    }

    my $SQL = 'DELETE FROM sysconfig_deployment_lock';
    my @Bind;

    if ( $Param{ExclusiveLockGUID} ) {
        $SQL .= '
            WHERE exclusive_lock_guid = ?
                AND exclusive_lock_user_id = ?';

        @Bind = ( \$Param{ExclusiveLockGUID}, \$Param{UserID} );
    }

    # Update db record.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return 1;
}

=head2 DeploymentListCleanup()

Removes invalid deployments from the database.

    my $Success = $SysConfigDBObject->DeploymentListCleanup( );

Returns:

    $Success = 1;       # Returns 1 if all records are valid (or all invalid was removed)
                        # Returns -1 if there is an invalid deployment that could be in adding process
                        # Returns false in case of an error

=cut

sub DeploymentListCleanup {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, create_time
            FROM sysconfig_deployment
            WHERE effective_value LIKE \'Invalid%\'
                OR comments LIKE \'OTRSInvalid-%\'
            ORDER BY id DESC',
    );

    my @Deployments;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Deployment = (
            DeploymentID => $Row[0],
            CreateTime   => $Row[1],
        );
        push @Deployments, \%Deployment;
    }

    my $Success               = 1;
    my $CurrentDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    DEPLOYMENT:
    for my $Deployment (@Deployments) {

        my $DeploymentDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Deployment->{CreateTime},
            },
        );

        my $Delta = $CurrentDateTimeObject->Delta( DateTimeObject => $DeploymentDateTimeObject );

        # Remove deployment only if it is old (more than 20 secs)
        if ( $DeploymentDateTimeObject < $CurrentDateTimeObject && $Delta >= 20 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Deployment $Deployment->{DeploymentID} is invalid and will be removed!",
            );
            my $DeleteSuccess = $Self->DeploymentDelete(
                DeploymentID => $Deployment->{DeploymentID},
            );
            if ( !$DeleteSuccess ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not delete deployment $Deployment->{DeploymentID}",
                );
                $Success = 0;
            }
            last DEPLOYMENT;
        }

        # Otherwise just log that there is something wrong with the deployment but do not remove it
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Deployment $Deployment->{DeploymentID} seams to be invalid or its not fully updated",
        );
        $Success = -1;
    }

    return $Success;
}

=head1 PRIVATE INTERFACE

=head2 _DeploymentLockGet()

Get deployment lock entry.

    my %DeploymentLock = $SysConfigDBObject->_DeploymentLockGet();

Returns:

    %DeploymentLock = (
        DeploymentLoclID        => "123",
        ExclusiveLockGUID       => $LockingString,
        ExclusiveLockUserID     => 1,
        ExclusiveLockExpiryTime => '2016-05-29 11:09:04',
        CreateTime              => "2016-05-29 11:04:04",
    );

=cut

sub _DeploymentLockGet {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get deployment lock from the DB.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, exclusive_lock_guid, exclusive_lock_user_id, exclusive_lock_expiry_time
            FROM sysconfig_deployment_lock
            ORDER BY exclusive_lock_expiry_time DESC',
        Limit => 1,
    );

    my %DeploymentLock;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $DeploymentLock{ID}                      = $Data[0];
        $DeploymentLock{ExclusiveLockGUID}       = $Data[1];
        $DeploymentLock{ExclusiveLockUserID}     = $Data[2];
        $DeploymentLock{ExclusiveLockExpiryTime} = $Data[3];
    }

    return %DeploymentLock;
}

=head2 _BulkInsert()

Add batch entries to the DB into a given table.

    my $Success = $SysConfigDBObject->_BulkInsert(
        Table   => 'table_name',    # (required) Table name
        Columns => [                # (required) Array of column names
            'column_name',
            ...
        ],
        Data    => [                # (required) AoA with data
            [
                'record 1',
                'record 2',
            ],
            [
                ...
            ],
            ...
        ],
    );

=cut

sub _BulkInsert {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Table)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    for my $Parameter (qw(Columns Data)) {
        if ( !IsArrayRefWithData( $Param{Columns} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Parameter must be not empty array!"
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get the database type.
    my $DBType = $DBObject->GetDatabaseFunction('Type');

    # Define database specific SQL for the multi-line inserts.
    my %DatabaseSQL;

    my $Columns = join( ',', @{ $Param{Columns} } );

    # Check the first array in Data and create Mask (current_timestamp is always on same place in array).
    my @Mask = map {
        ( $_ && $_ eq 'current_timestamp' )
            ? 'current_timestamp' : '?'
    } @{ $Param{Data}->[0] };

    my $MaskedValues = join( ',', @Mask );

    if ( $DBType eq 'oracle' ) {

        %DatabaseSQL = (
            Start     => 'INSERT ALL ',
            FirstLine => "
                INTO $Param{Table} ($Columns)
                VALUES ( $MaskedValues ) ",
            NextLine => "
                INTO $Param{Table} (
                    $Columns
                )
                VALUES ( $MaskedValues ) ",
            End => 'SELECT * FROM DUAL',
        );
    }
    else {
        %DatabaseSQL = (
            Start => "
                INSERT INTO $Param{Table} (
                    $Columns
                )",
            FirstLine => "VALUES ( $MaskedValues )",
            NextLine  => ", ( $MaskedValues ) ",
            End       => '',
        );
    }

    my $SQL = '';
    my @Bind;

    my $Count = 0;

    RECORD:
    for my $Entry ( @{ $Param{Data} } ) {

        $Count++;

        if ( !IsArrayRefWithData($Entry) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Data contains empty array, skipped!"
            );
            next RECORD;
        }

        if ( scalar @{$Entry} != scalar @{ $Param{Columns} } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Array size doesn't match Columns size, skipped!"
            );
            my $Col = scalar @{ $Param{Columns} };
            next RECORD;
        }

        # Now the article entry is validated and can be added to sql.
        if ( !$SQL ) {
            $SQL = $DatabaseSQL{Start} . $DatabaseSQL{FirstLine};
        }
        else {
            $SQL .= $DatabaseSQL{NextLine};
        }

        BIND:
        for my $Item ( @{$Entry} ) {

            next BIND if ( $Item && $Item eq 'current_timestamp' );    # Already included in the SQL part.

            push @Bind, \$Item;
        }

        # Check the length of the SQL string
        # (some databases only accept SQL strings up to 4k,
        # so we want to stay safe here with just 3500 bytes).
        if ( length $SQL > 3500 || $Count == scalar @{ $Param{Data} } ) {

            # Add the end line to sql string.
            $SQL .= $DatabaseSQL{End};

            # Insert multiple entries.
            return if !$DBObject->Do(
                SQL  => $SQL,
                Bind => \@Bind,
            );

            # Reset the SQL string and the Bind array.
            $SQL  = '';
            @Bind = ();
        }
    }

    return 1;
}

=head2 _GetUID()

Generates a unique identifier.

    my $UID = $TicketNumberObject->_GetUID();

Returns:

    my $UID = 14906327941360ed8455f125d0450277;

=cut

sub _GetUID {
    my ( $Self, %Param ) = @_;

    my $NodeID = $Kernel::OM->Get('Kernel::Config')->Get('NodeID') || 1;
    my ( $Seconds, $Microseconds ) = Time::HiRes::gettimeofday();
    my $ProcessID = $$;

    my $CounterUID = $ProcessID . $Seconds . $Microseconds . $NodeID;

    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length     => 32 - length $CounterUID,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],    # hexadecimal
    );

    $CounterUID .= $RandomString;

    return $CounterUID;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
