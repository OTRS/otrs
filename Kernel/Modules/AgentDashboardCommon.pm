# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentDashboardCommon;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $BackendConfigKey  = 'DashboardBackend';
    my $MainMenuConfigKey = 'AgentDashboard::MainMenu';
    my $UserSettingsKey   = 'UserDashboard';

    if ( $Self->{Action} eq 'AgentCustomerInformationCenter' ) {
        $BackendConfigKey  = 'AgentCustomerInformationCenter::Backend';
        $MainMenuConfigKey = 'AgentCustomerInformationCenter::MainMenu';
        $UserSettingsKey   = 'UserCustomerInformationCenter';
    }

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # load backends
    my $Config = $ConfigObject->Get($BackendConfigKey);
    if ( !$Config ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No such config for ' . $BackendConfigKey,
        );
    }

    # Get all configured statistics from the system that should be shown as a dashboard widget
    #   and register them dynamically in the configuration.
    if ( $Self->{Action} eq 'AgentDashboard' ) {

        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::Stats' => {
                UserID => $Self->{UserID},
                }
        );

        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');
        my $StatsHash   = $StatsObject->StatsListGet();

        if ( IsHashRefWithData($StatsHash) ) {
            STATID:
            for my $StatID ( sort keys %{$StatsHash} ) {
                next STATID if !$StatsHash->{$StatID}->{ShowAsDashboardWidget};

                # check permissions
                next STATID if !$StatsHash->{$StatID}->{Permission};
                next STATID if !IsArrayRefWithData( $StatsHash->{$StatID}->{Permission} );

                my @StatsPermissionGroupNames;
                for my $GroupID ( @{ $StatsHash->{$StatID}->{Permission} } ) {
                    push @StatsPermissionGroupNames,
                        $Kernel::OM->Get('Kernel::System::Group')->GroupLookup( GroupID => $GroupID );
                }
                my $StatsPermissionGroups = join( ';', @StatsPermissionGroupNames );

                # replace all line breaks with spaces (otherwise Translate() will not work correctly)
                $StatsHash->{$StatID}->{Description} =~ s{\r?\n|\r}{ }msxg;

                my $Description = $LayoutObject->{LanguageObject}->Get( $StatsHash->{$StatID}->{Description} );

                my $Title = $LayoutObject->{LanguageObject}->Get( $StatsHash->{$StatID}->{Title} );
                $Title = $LayoutObject->{LanguageObject}->Translate('Statistic') . ': '
                    . $Title . ' ('
                    . $ConfigObject->Get('Stats::StatsHook')
                    . $StatsHash->{$StatID}->{StatNumber} . ')';

                $Config->{ ( $StatID + 1000 ) . '-Stats' } = {
                    'Block'       => 'ContentLarge',
                    'Default'     => 0,
                    'Module'      => 'Kernel::Output::HTML::Dashboard::Stats',
                    'Title'       => $Title,
                    'StatID'      => $StatID,
                    'Description' => $Description,
                    'Group'       => $StatsPermissionGroups,
                };
            }
        }
    }

    # get needed objects
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    if ( $Self->{Action} eq 'AgentCustomerInformationCenter' ) {

        $Self->{CustomerID} = $ParamObject->GetParam( Param => 'CustomerID' );

        # check CustomerID presence for all subactions that need it
        if ( $Self->{Subaction} ne 'UpdatePosition' ) {
            if ( !$Self->{CustomerID} ) {
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AgentCustomerInformationCenterBlank',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }
    }

    # get needed objects
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $SessionObject      = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject         = $Kernel::OM->Get('Kernel::System::User');

    # update/close item
    if ( $Self->{Subaction} eq 'UpdateRemove' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Name = $ParamObject->GetParam( Param => 'Name' );
        my $Key = $UserSettingsKey . $Name;

        # update ssession
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Key,
            Value     => 0,
        );

        # update preferences
        if ( !$ConfigObject->Get('DemoSystem') ) {
            $UserObject->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $Key,
                Value  => 0,
            );
        }

        my $URL = "Action=$Self->{Action}";
        if ( $Self->{CustomerID} ) {
            $URL .= ";CustomerID=" . $LayoutObject->LinkEncode( $Self->{CustomerID} );
        }

        return $LayoutObject->Redirect(
            OP => $URL,
        );
    }

    # update preferences
    elsif ( $Self->{Subaction} eq 'UpdatePreferences' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Name = $ParamObject->GetParam( Param => 'Name' );

        # get preferences settings
        my @PreferencesOnly = $Self->_Element(
            Name            => $Name,
            Configs         => $Config,
            PreferencesOnly => 1,
        );
        if ( !@PreferencesOnly ) {
            $LayoutObject->FatalError(
                Message => "No preferences for $Name!",
            );
        }

        # remember preferences
        for my $Param (@PreferencesOnly) {

            # get params
            my $Value = $ParamObject->GetParam( Param => $Param->{Name} );

            # update runtime vars
            $LayoutObject->{ $Param->{Name} } = $Value;

            # update ssession
            $SessionObject->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Param->{Name},
                Value     => $Value,
            );

            # update preferences
            if ( !$ConfigObject->Get('DemoSystem') ) {
                $UserObject->SetPreferences(
                    UserID => $Self->{UserID},
                    Key    => $Param->{Name},
                    Value  => $Value,
                );
            }
        }

        # deliver new content page
        my %ElementReload = $Self->_Element(
            Name    => $Name,
            Configs => $Config,
            AJAX    => 1
        );
        if ( !%ElementReload ) {
            $LayoutObject->FatalError(
                Message => "Can't get element data of $Name!",
            );
        }
        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => ${ $ElementReload{Content} },
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # update settings
    elsif ( $Self->{Subaction} eq 'UpdateSettings' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @Backends = $ParamObject->GetArray( Param => 'Backend' );
        for my $Name ( sort keys %{$Config} ) {
            my $Active = 0;
            BACKEND:
            for my $Backend (@Backends) {
                next BACKEND if $Backend ne $Name;
                $Active = 1;
                last BACKEND;
            }
            my $Key = $UserSettingsKey . $Name;

            # update ssession
            $SessionObject->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Key,
                Value     => $Active,
            );

            # update preferences
            if ( !$ConfigObject->Get('DemoSystem') ) {
                $UserObject->SetPreferences(
                    UserID => $Self->{UserID},
                    Key    => $Key,
                    Value  => $Active,
                );
            }
        }

        my $URL = "Action=$Self->{Action}";
        if ( $Self->{CustomerID} ) {
            $URL .= ";CustomerID=" . $LayoutObject->LinkEncode( $Self->{CustomerID} );
        }

        return $LayoutObject->Redirect(
            OP => $URL,
        );
    }

    # update position
    elsif ( $Self->{Subaction} eq 'UpdatePosition' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @Backends = $ParamObject->GetArray( Param => 'Backend' );

        # get new order
        my $Key  = $UserSettingsKey . 'Position';
        my $Data = '';
        for my $Backend (@Backends) {
            $Backend =~ s{ \A Dashboard (.+?) -box \z }{$1}gxms;
            $Data .= $Backend . ';';
        }

        # update ssession
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Key,
            Value     => $Data,
        );

        # update preferences
        if ( !$ConfigObject->Get('DemoSystem') ) {
            $UserObject->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $Key,
                Value  => $Data,
            );
        }

        # send successful response
        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => '1',
        );
    }

    # deliver element
    elsif ( $Self->{Subaction} eq 'Element' ) {

        my $Name = $ParamObject->GetParam( Param => 'Name' );

        # get the column filters from the web request
        my %ColumnFilter;
        my %GetColumnFilter;
        my %GetColumnFilterSelect;

        COLUMNNAME:
        for my $ColumnName (
            qw(Owner Responsible State Queue Priority Type Lock Service SLA CustomerID CustomerUserID)
            )
        {
            my $FilterValue = $ParamObject->GetParam( Param => 'ColumnFilter' . $ColumnName . $Name )
                || '';
            next COLUMNNAME if $FilterValue eq '';

            if ( $ColumnName eq 'CustomerID' ) {
                push @{ $ColumnFilter{$ColumnName} }, $FilterValue;
            }
            elsif ( $ColumnName eq 'CustomerUserID' ) {
                push @{ $ColumnFilter{CustomerUserLogin} }, $FilterValue;
            }
            else {
                push @{ $ColumnFilter{ $ColumnName . 'IDs' } }, $FilterValue;
            }

            $GetColumnFilter{ $ColumnName . $Name } = $FilterValue;
            $GetColumnFilterSelect{$ColumnName} = $FilterValue;
        }

        # get all dynamic fields
        my $DynamicField = $DynamicFieldObject->DynamicFieldListGet(
            Valid      => 1,
            ObjectType => ['Ticket'],
        );

        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

            my $FilterValue = $ParamObject->GetParam(
                Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name} . $Name
            );

            next DYNAMICFIELD if !defined $FilterValue;
            next DYNAMICFIELD if $FilterValue eq '';

            $ColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = {
                Equals => $FilterValue,
            };
            $GetColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} . $Name } = $FilterValue;
            $GetColumnFilterSelect{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $FilterValue;
        }

        my $SortBy  = $ParamObject->GetParam( Param => 'SortBy' );
        my $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' );

        my %Element = $Self->_Element(
            Name                  => $Name,
            Configs               => $Config,
            AJAX                  => 1,
            SortBy                => $SortBy,
            OrderBy               => $OrderBy,
            ColumnFilter          => \%ColumnFilter,
            GetColumnFilter       => \%GetColumnFilter,
            GetColumnFilterSelect => \%GetColumnFilterSelect,
        );

        if ( !%Element ) {
            $LayoutObject->FatalError(
                Message => "Can't get element data of $Name!",
            );
        }
        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => ${ $Element{Content} },
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # deliver element
    elsif ( $Self->{Subaction} eq 'AJAXFilterUpdate' ) {

        my $ElementChanged = $ParamObject->GetParam( Param => 'ElementChanged' );
        my ($Name)         = $ElementChanged =~ m{ ( \d{4} - .*? ) \z }gxms;
        my $Column         = $ElementChanged;
        $Column =~ s{ \A ColumnFilter }{}gxms;
        $Column =~ s{ $Name }{}gxms;

        my $FilterContent = $Self->_Element(
            Name              => $Name,
            FilterContentOnly => 1,
            FilterColumn      => $Column,
            ElementChanged    => $ElementChanged,
            Configs           => $Config,
        );

        if ( !$FilterContent ) {
            $LayoutObject->FatalError(
                Message => "Can't get filter content data of $Name!",
            );
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $FilterContent,
            Type        => 'inline',
            NoCache     => 1,
        );

    }

    # store last queue screen
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    my %ContentBlockData;

    if ( $Self->{Action} eq 'AgentCustomerInformationCenter' ) {

        $ContentBlockData{CustomerID} = $Self->{CustomerID};

        # H1 title
        $ContentBlockData{CustomerIDTitle} = $Self->{CustomerID};

        my %CustomerCompanyData = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
            CustomerID => $Self->{CustomerID},
        );

        if ( $CustomerCompanyData{CustomerCompanyName} ) {
            $ContentBlockData{CustomerIDTitle} = "$CustomerCompanyData{CustomerCompanyName} ($Self->{CustomerID})";
        }
    }

    # show dashboard
    $LayoutObject->Block(
        Name => 'Content',
        Data => \%ContentBlockData,
    );

    # get shown backends
    my %Backends;
    BACKEND:
    for my $Name ( sort keys %{$Config} ) {

        # check permissions
        if ( $Config->{$Name}->{Group} ) {
            my $PermissionOK = 0;
            my @Groups = split /;/, $Config->{$Name}->{Group};
            GROUP:
            for my $Group (@Groups) {
                my $Permission = 'UserIsGroupRo[' . $Group . ']';
                if ( defined $Self->{$Permission} && $Self->{$Permission} eq 'Yes' ) {
                    $PermissionOK = 1;
                    last GROUP;
                }
            }
            next BACKEND if !$PermissionOK;
        }

        my $Key = $UserSettingsKey . $Name;
        if ( defined $Self->{$Key} ) {
            $Backends{$Name} = $Self->{$Key};
        }
        else {
            $Backends{$Name} = $Config->{$Name}->{Default};
        }
    }

    # set order of plugins
    my $Key = $UserSettingsKey . 'Position';
    my @Order;
    my $Value = $Self->{$Key};

    if ($Value) {
        @Order = split /;/, $Value;

        # only use active backends
        @Order = grep { $Config->{$_} } @Order;
    }
    if ( !@Order ) {
        for my $Name ( sort keys %Backends ) {
            push @Order, $Name;
        }
    }

    # add not ordered plugins (e. g. new active)
    NAME:
    for my $Name ( sort keys %Backends ) {
        my $Included = 0;
        ITEM:
        for my $Item (@Order) {
            next ITEM if $Item ne $Name;
            $Included = 1;
        }
        next NAME if $Included;
        push @Order, $Name;
    }

    # try every backend to load and execute it
    NAME:
    for my $Name (@Order) {

        # get element data
        my %Element = $Self->_Element(
            Name     => $Name,
            Configs  => $Config,
            Backends => \%Backends,
        );
        next NAME if !%Element;

        # NameForm (to support IE, is not working with "-" in form names)
        my $NameForm = $Name;
        $NameForm =~ s{-}{}g;

        # rendering
        $LayoutObject->Block(
            Name => $Element{Config}->{Block},
            Data => {
                %{ $Element{Config} },
                Name       => $Name,
                NameForm   => $NameForm,
                Content    => ${ $Element{Content} },
                CustomerID => $Self->{CustomerID} || '',
            },
        );

        # show settings link if preferences are available
        if ( $Element{Preferences} && @{ $Element{Preferences} } ) {
            $LayoutObject->Block(
                Name => $Element{Config}->{Block} . 'Preferences',
                Data => {
                    %{ $Element{Config} },
                    Name     => $Name,
                    NameForm => $NameForm,
                },
            );
            PARAM:
            for my $Param ( @{ $Element{Preferences} } ) {

                # special parameters are added, which do not have a tt block,
                # because the displayed fields are added with the output filter,
                # so there is no need to call any block here
                next PARAM if !$Param->{Block};

                $LayoutObject->Block(
                    Name => $Element{Config}->{Block} . 'PreferencesItem',
                    Data => {
                        %{ $Element{Config} },
                        Name     => $Name,
                        NameForm => $NameForm,
                    },
                );
                if ( $Param->{Block} eq 'Option' ) {
                    $Param->{Option} = $LayoutObject->BuildSelection(
                        Data        => $Param->{Data},
                        Name        => $Param->{Name},
                        SelectedID  => $Param->{SelectedID},
                        Translation => $Param->{Translation},
                    );
                }
                $LayoutObject->Block(
                    Name => $Element{Config}->{Block} . 'PreferencesItem' . $Param->{Block},
                    Data => {
                        %{ $Element{Config} },
                        %{$Param},
                        Data     => $Self->{ $Param->{Name} },
                        NamePref => $Param->{Name},
                        Name     => $Name,
                        NameForm => $NameForm,
                    },
                );
            }
        }

        # more link
        if ( $Element{Config}->{Link} ) {
            $LayoutObject->Block(
                Name => $Element{Config}->{Block} . 'More',
                Data => {
                    %{ $Element{Config} },
                },
            );
        }
    }

    # build main menu
    my $MainMenuConfig = $ConfigObject->Get($MainMenuConfigKey);
    if ( IsHashRefWithData($MainMenuConfig) ) {
        $LayoutObject->Block( Name => 'MainMenu' );

        for my $MainMenuItem ( sort keys %{$MainMenuConfig} ) {

            $LayoutObject->Block(
                Name => 'MainMenuItem',
                Data => {
                    %{ $MainMenuConfig->{$MainMenuItem} },
                    CustomerID => $Self->{CustomerID},
                },
            );
        }
    }

    # add translations for the allocation lists for regular columns
    my $Columns = $Self->{Config}->{DefaultColumns} || $ConfigObject->Get('DefaultOverviewColumns') || {};
    if ( $Columns && IsHashRefWithData($Columns) ) {

        COLUMN:
        for my $Column ( sort keys %{$Columns} ) {

            # dynamic fields will be translated in the next block
            next COLUMN if $Column =~ m{ \A DynamicField_ }xms;

            my $TranslatedWord = $Column;
            if ( $Column eq 'EscalationTime' ) {
                $TranslatedWord = 'Service Time';
            }
            elsif ( $Column eq 'EscalationResponseTime' ) {
                $TranslatedWord = 'First Response Time';
            }
            elsif ( $Column eq 'EscalationSolutionTime' ) {
                $TranslatedWord = 'Solution Time';
            }
            elsif ( $Column eq 'EscalationUpdateTime' ) {
                $TranslatedWord = 'Update Time';
            }
            elsif ( $Column eq 'PendingTime' ) {
                $TranslatedWord = 'Pending till';
            }

            $LayoutObject->Block(
                Name => 'ColumnTranslation',
                Data => {
                    ColumnName      => $Column,
                    TranslateString => $TranslatedWord,
                },
            );
            $LayoutObject->Block(
                Name => 'ColumnTranslationSeparator',
            );
        }
    }

    # add translations for the allocation lists for dynamic field columns
    my $ColumnsDynamicField = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => ['Ticket'],
    );

    if ( $ColumnsDynamicField && IsArrayRefWithData($ColumnsDynamicField) ) {

        my $Counter = 0;

        DYNAMICFIELD:
        for my $DynamicField ( sort @{$ColumnsDynamicField} ) {

            next DYNAMICFIELD if !$DynamicField;

            $Counter++;

            $LayoutObject->Block(
                Name => 'ColumnTranslation',
                Data => {
                    ColumnName      => 'DynamicField_' . $DynamicField->{Name},
                    TranslateString => $DynamicField->{Label},
                },
            );

            if ( $Counter < scalar @{$ColumnsDynamicField} ) {
                $LayoutObject->Block(
                    Name => 'ColumnTranslationSeparator',
                );
            }
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => \%Param
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Element {
    my ( $Self, %Param ) = @_;

    my $Name                  = $Param{Name};
    my $Configs               = $Param{Configs};
    my $Backends              = $Param{Backends};
    my $SortBy                = $Param{SortBy};
    my $OrderBy               = $Param{OrderBy};
    my $ColumnFilter          = $Param{ColumnFilter};
    my $GetColumnFilter       = $Param{GetColumnFilter};
    my $GetColumnFilterSelect = $Param{GetColumnFilterSelect};

    # check permissions
    if ( $Configs->{$Name}->{Group} ) {
        my $PermissionOK = 0;
        my @Groups = split /;/, $Configs->{$Name}->{Group};
        GROUP:
        for my $Group (@Groups) {
            my $Permission = 'UserIsGroupRo[' . $Group . ']';
            if ( defined $Self->{$Permission} && $Self->{$Permission} eq 'Yes' ) {
                $PermissionOK = 1;
                last GROUP;
            }
        }
        return if !$PermissionOK;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load backends
    my $Module = $Configs->{$Name}->{Module};
    return if !$Kernel::OM->Get('Kernel::System::Main')->Require($Module);
    my $Object = $Module->new(
        %{$Self},
        Config                => $Configs->{$Name},
        Name                  => $Name,
        CustomerID            => $Self->{CustomerID} || '',
        SortBy                => $SortBy,
        OrderBy               => $OrderBy,
        ColumnFilter          => $ColumnFilter,
        GetColumnFilter       => $GetColumnFilter,
        GetColumnFilterSelect => $GetColumnFilterSelect,

    );

    # get module config
    my %Config = $Object->Config();

    # Perform the actual data fetching and computation on the slave db, if configured
    local $Kernel::System::DB::UseSlaveDB = 1;

    # get module preferences
    my @Preferences = $Object->Preferences();
    return @Preferences if $Param{PreferencesOnly};

    # Perform the actual data fetching and computation on the slave db, if configured
    local $Kernel::System::DB::UseSlaveDB = 1;

    if ( $Param{FilterContentOnly} ) {
        my $FilterContent = $Object->FilterContent(
            FilterColumn => $Param{FilterColumn},
            Config       => $Configs->{$Name},
            Name         => $Name,
            CustomerID   => $Self->{CustomerID} || '',
        );
        return $FilterContent;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # add backend to settings selection
    if ($Backends) {
        my $Checked = '';
        if ( $Backends->{$Name} ) {
            $Checked = 'checked="checked"';
        }
        $LayoutObject->Block(
            Name => 'ContentSettings',
            Data => {
                %Config,
                Name    => $Name,
                Checked => $Checked,
            },
        );
        return if !$Backends->{$Name};
    }

    # check backends cache (html page cache)
    my $Content;
    my $CacheKey = $Config{CacheKey};
    $Self->{CacheObject} = $Kernel::OM->Get('Kernel::System::Cache');

    if ( !$CacheKey ) {
        $CacheKey = $Name . '-'
            . ( $Self->{CustomerID} || '' ) . '-'
            . $LayoutObject->{UserLanguage};
    }
    if ( $Config{CacheTTL} ) {
        $Content = $Self->{CacheObject}->Get(
            Type => 'Dashboard',
            Key  => $CacheKey,
        );
    }

    # execute backends
    my $CacheUsed = 1;
    if ( !defined $Content || $SortBy ) {
        $CacheUsed = 0;
        $Content   = $Object->Run(
            AJAX       => $Param{AJAX},
            CustomerID => $Self->{CustomerID} || '',
        );
    }

    # check if content should be shown
    return if !$Content;

    # set cache (html page cache)
    if ( !$CacheUsed && $Config{CacheTTL} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey,
            Value => $Content,
            TTL   => $Config{CacheTTL} * 60,
        );
    }

    # return result
    return (
        Content     => \$Content,
        Config      => \%Config,
        Preferences => \@Preferences,
    );
}

1;
