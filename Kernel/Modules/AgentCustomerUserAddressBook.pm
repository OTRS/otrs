# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentCustomerUserAddressBook;

use strict;
use warnings;

use List::Util qw(first);

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    # Define some customer company values, to use the values later for the output.
    $Self->{CustomerCompanySearchFieldPrefix} = 'CustomerCompany_';
    $Self->{CustomerCompanyLabelIdentifier}   = Translatable('Customer');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $Self->{RecipientType} = $ParamObject->GetParam( Param => 'RecipientType' ) || 'Email';

    $Self->{Config} = $ConfigObject->Get("CustomerUser::Frontend::$Self->{Action}");

    # Check if the config settings exsists for the given recipient type.
    for my $ConfigKey (qw(SearchParameters DefaultFields ShowColumns)) {
        if ( !grep { $_ eq $Self->{RecipientType} } sort keys %{ $Self->{Config}->{$ConfigKey} } ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable("No config setting '$ConfigKey' for the given RecipientType!"),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
    }

    # Get the diffrent values from the params or the config to set the default values.
    $Self->{StartHit}    = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{SearchLimit} = $Self->{Config}->{SearchParameters}->{ $Self->{RecipientType} }->{SearchLimit} || 500;
    $Self->{SortBy}      = $ParamObject->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{SearchParameters}->{ $Self->{RecipientType} }->{'SortBy::Default'}
        || 'UserLogin';
    $Self->{OrderBy} = $ParamObject->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{SearchParameters}->{ $Self->{RecipientType} }->{'Order::Default'}
        || 'Up';
    $Self->{Profile}        = $ParamObject->GetParam( Param => 'Profile' )        || '';
    $Self->{SaveProfile}    = $ParamObject->GetParam( Param => 'SaveProfile' )    || '';
    $Self->{TakeLastSearch} = $ParamObject->GetParam( Param => 'TakeLastSearch' ) || '';
    $Self->{SelectTemplate} = $ParamObject->GetParam( Param => 'SelectTemplate' ) || '';
    $Self->{EraseTemplate}  = $ParamObject->GetParam( Param => 'EraseTemplate' )  || '';
    $Self->{RecipientField} = $ParamObject->GetParam( Param => 'RecipientField' );
    $Self->{RecipientFieldLabel} = $ParamObject->GetParam( Param => 'RecipientFieldLabel' ) || $Self->{RecipientField};

    if ( !$Self->{RecipientField} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No RecipientField is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    if ( $ParamObject->GetParam( Param => 'SearchTemplate' ) && $Self->{Profile} ) {
        return $LayoutObject->Redirect(
            OP =>
                "Action=AgentCustomerUserAddressBook;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Self->{Profile}"
        );
    }

    my %GetParam;

    # Get the dynamic fields from the customer user and company search fields.
    my @CustomerUserDynamicFields = $Self->_GetCustomerUserSearchFields(
        Types => ['DynamicField'],
    );
    my @CustomerCompanyDynamicFields = $Self->_GetCustomerCompanySearchFields(
        Types         => ['DynamicField'],
        WithoutPrefix => 1,
    );

    my %LookupCustomerUserDynamicFields    = map { $_->{DatabaseField} => 1 } @CustomerUserDynamicFields;
    my %LookupCustomerCompanyDynamicFields = map { $_->{DatabaseField} => 1 } @CustomerCompanyDynamicFields;

    # Get the dynamic fields for this screen.
    $Self->{DynamicFieldCustomerUser} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'CustomerUser', ],
        FieldFilter => \%LookupCustomerUserDynamicFields,
    );
    $Self->{DynamicFieldCustomerCompany} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'CustomerCompany', ],
        FieldFilter => \%LookupCustomerCompanyDynamicFields,
    );

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $SearchProfileObject       = $Kernel::OM->Get('Kernel::System::SearchProfile');

    # Get the diffrent search fields for the customer user search.
    my @CustomerUserInputSearchFields = $Self->_GetCustomerUserSearchFields(
        Types => ['Input'],
    );
    my @CustomerUserSelectionSearchFields = $Self->_GetCustomerUserSearchFields(
        Types => ['Selection'],
    );

    # Get the diffrent search fields for the customer company search.
    my @CustomerCompanyInputSearchFields = $Self->_GetCustomerCompanySearchFields(
        Types => ['Input'],
    );
    my @CustomerCompanySelectionSearchFields = $Self->_GetCustomerCompanySearchFields(
        Types => ['Selection'],
    );

    # Load parameters from search profile,
    # this happens when the next result page should be shown, or when the results are reordered.
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Self->{Profile} ) || $Self->{TakeLastSearch} ) {
        %GetParam = $SearchProfileObject->SearchProfileGet(
            Base      => 'CustomerUserAddressBook',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );

        if ( $GetParam{ShownAttributes} && ref $GetParam{ShownAttributes} eq 'ARRAY' ) {
            $GetParam{ShownAttributes} = join ';', @{ $GetParam{ShownAttributes} };
        }

        # Use param ExcludeUserLogins only for the last-search profile (otherwise ignore the parameter).
        if ( $Self->{Profile} ne 'last-search' ) {
            delete $GetParam{ExcludeUserLogins};
        }
    }
    elsif ( $Self->{Subaction} eq 'DeleteProfile' ) {

        $SearchProfileObject->SearchProfileDelete(
            Base      => 'CustomerUserAddressBook',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
        $Self->{Profile} = '';
    }
    else {

        # Get some general search params.
        for my $ParamName (qw(ShownAttributes)) {
            $GetParam{$ParamName} = $ParamObject->GetParam( Param => $ParamName );
        }

        # Get the scalar search params for the customer user and customer company fields.
        for my $Field ( @CustomerUserInputSearchFields, @CustomerCompanyInputSearchFields ) {
            $GetParam{ $Field->{Name} } = $ParamObject->GetParam( Param => $Field->{Name} );

            # Remove the whitespace on the start and end of the given string.
            if ( $GetParam{ $Field->{Name} } ) {
                $GetParam{ $Field->{Name} } =~ s{ \A \s+ }{}xms;
                $GetParam{ $Field->{Name} } =~ s{ \s+ \z }{}xms;
            }
        }

        # Get the array search params for the customer user and customer company fields.
        for my $Field ( @CustomerUserSelectionSearchFields, @CustomerCompanySelectionSearchFields ) {
            my @Array = $ParamObject->GetArray( Param => $Field->{Name} );
            if (@Array) {
                $GetParam{ $Field->{Name} } = \@Array;
            }
        }

        # Get the excluded user logins, which were already selected in a recipient field.
        my $ExcludeUserLoginsJSONString = $ParamObject->GetParam( Param => 'ExcludeUserLoginsJSON' ) || '';

        if ($ExcludeUserLoginsJSONString) {
            $GetParam{ExcludeUserLogins} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $ExcludeUserLoginsJSONString,
            );
        }

        # Get Dynamic fields from param object and cycle trough the activated Dynamic Fields for this screen.
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicFieldCustomerUser} }, @{ $Self->{DynamicFieldCustomerCompany} } )
        {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # Extract the dynamic field value from the web request.
                my $DynamicFieldValue = $DynamicFieldBackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    ReturnProfileStructure => 1,
                    LayoutObject           => $LayoutObject,
                    Type                   => $Preference->{Type},
                );

                # Set the complete value structure in GetParam to store it later in the search profile.
                if ( IsHashRefWithData($DynamicFieldValue) ) {
                    %GetParam = ( %GetParam, %{$DynamicFieldValue} );
                }
            }
        }
    }

    # Show result site or perform other actions.
    if ( $Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate} ) {

        # Generate a lookup hash for the exluce user logins and delete the entry from the 'GetParam', because
        #   we disable the entries in the result.
        my %LookupExcludeUserLogins;
        if ( IsArrayRefWithData( $GetParam{ExcludeUserLogins} ) ) {
            %LookupExcludeUserLogins = map { $_ => 1 } @{ $GetParam{ExcludeUserLogins} };
            delete $GetParam{ExcludeUserLogins};
        }

        # Fill up profile name (e.g. with last-search).
        if ( !$Self->{Profile} || !$Self->{SaveProfile} ) {
            $Self->{Profile} = 'last-search';
        }

        # Save search profile (under last-search or real profile name).
        $Self->{SaveProfile} = 1;

        # Remember the last search values, e.g. for sorting.
        if ( $Self->{SaveProfile} && $Self->{Profile} ) {

            # Remove old profile stuff, before the new stuff will be saved.
            $SearchProfileObject->SearchProfileDelete(
                Base      => 'CustomerUserAddressBook',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );

            if ( $GetParam{ShownAttributes} && ref $GetParam{ShownAttributes} eq '' ) {
                $GetParam{ShownAttributes} = [ split /;/, $GetParam{ShownAttributes} ];
            }

            KEY:
            for my $Key ( sort keys %GetParam ) {
                next KEY if !defined $GetParam{$Key};

                $SearchProfileObject->SearchProfileAdd(
                    Base      => 'CustomerUserAddressBook',
                    Name      => $Self->{Profile},
                    Key       => $Key,
                    Value     => $GetParam{$Key},
                    UserLogin => $Self->{UserLogin},
                );
            }
        }

        my %AttributeLookup;

        for my $Attribute ( @{ $GetParam{ShownAttributes} || [] } ) {
            $AttributeLookup{$Attribute} = 1;
        }

        my %DynamicFieldSearchParameters;

        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicFieldCustomerUser} }, @{ $Self->{DynamicFieldCustomerCompany} } )
        {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                if (
                    !$AttributeLookup{ 'LabelSearch_DynamicField_' . $DynamicFieldConfig->{Name} . $Preference->{Type} }
                    )
                {
                    next PREFERENCE;
                }

                # Extract the dynamic field value from the profile.
                my $SearchParameter = $DynamicFieldBackendObject->SearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Profile            => \%GetParam,
                    LayoutObject       => $LayoutObject,
                    Type               => $Preference->{Type},
                );

                if ( defined $SearchParameter ) {
                    $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Parameter};
                }
            }
        }

        # Get only the customer company search params.
        my %CustomerCompanyGetParam;

        CUSTOMERCOMPANYFIELD:
        for my $CustomerCompanyField ( @CustomerCompanySelectionSearchFields, @CustomerCompanyInputSearchFields ) {

            next CUSTOMERCOMPANYFIELD if !$GetParam{ $CustomerCompanyField->{Name} };

            # Get the real field name.
            my $RealFieldName = $CustomerCompanyField->{Name};
            $RealFieldName =~ s{ \A $Self->{CustomerCompanySearchFieldPrefix} }{}xms;

            $CustomerCompanyGetParam{$RealFieldName} = $GetParam{ $CustomerCompanyField->{Name} };
        }

        # Check if a dynamic field search param exists.
        my $CustomerCompanyDynamicFieldExists;

        CUSTOMERCOMPANYDYNAMICFIELD:
        for my $CustomerCompanyDynamicField (@CustomerCompanyDynamicFields) {
            next CUSTOMERCOMPANYDYNAMICFIELD if !$DynamicFieldSearchParameters{ $CustomerCompanyDynamicField->{Name} };

            $CustomerCompanyDynamicFieldExists = 1;

            last CUSTOMERCOMPANYDYNAMICFIELD;
        }

        my $CustomerCompanyIDs;

        # Search first for customer companies, if some customer company search params exists.
        if ( %CustomerCompanyGetParam || $CustomerCompanyDynamicFieldExists ) {

            $CustomerCompanyIDs = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanySearchDetail(
                Result => 'ARRAY',
                %CustomerCompanyGetParam,
                %DynamicFieldSearchParameters,
            ) || [];
        }

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        my $ViewableCustomerUserLogins = [];

        # Do the search only if no customer company get params are given or some customer company ids for the given
        # customer company search params were found.
        if (
            ( !%CustomerCompanyGetParam && !$CustomerCompanyDynamicFieldExists )
            || IsArrayRefWithData($CustomerCompanyIDs)
            )
        {

            $ViewableCustomerUserLogins = $CustomerUserObject->CustomerSearchDetail(
                Result                           => 'ARRAY',
                OrderBy                          => [ $Self->{SortBy} ],
                OrderByDirection                 => [ $Self->{OrderBy} ],
                Limit                            => $Self->{SearchLimit},
                CustomerCompanySearchCustomerIDs => $CustomerCompanyIDs,
                %GetParam,
                %DynamicFieldSearchParameters,
            ) || [];
        }

        if ( $Self->{RecipientSelectionAJAX} ) {

            my @CustomerUserLoginList;

            if ( IsArrayRefWithData($ViewableCustomerUserLogins) ) {

                CUSTOMERUSERLOGIN:
                for my $CustomerUserLogin ( @{$ViewableCustomerUserLogins} ) {

                    my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                        User => $CustomerUserLogin,
                    );

                    push @CustomerUserLoginList, {
                        UserLogin      => $CustomerUser{UserLogin},
                        UserMailString => $CustomerUser{UserMailString},
                    };
                }
            }

            my $Output = $LayoutObject->JSONEncode(
                Data => \@CustomerUserLoginList,
            );
            return $LayoutObject->Attachment(
                NoCache     => 1,
                ContentType => 'text/html',
                Content     => $Output,
                Type        => 'inline'
            );
        }
        else {

            my $Output = $LayoutObject->Header(
                Type => 'Small',
            );
            $LayoutObject->Print( Output => \$Output );
            $Output = '';

            $Self->{Filter} = $ParamObject->GetParam( Param => 'Filter' ) || '';
            $Self->{View}   = $ParamObject->GetParam( Param => 'View' )   || '';

            my %LinkEncoded;
            for my $Attribute (qw(RecipientField RecipientFieldLabel RecipientType Profile)) {
                $LinkEncoded{$Attribute} = $LayoutObject->LinkEncode( $Self->{$Attribute} );
            }

            my $LinkPage = 'RecipientField=' . $LinkEncoded{RecipientField}
                . ';RecipientFieldLabel=' . $LinkEncoded{RecipientFieldLabel}
                . ';RecipientType=' . $LinkEncoded{RecipientType}
                . ';Filter=' . $LayoutObject->Ascii2Html( Text => $Self->{Filter} )
                . ';View=' . $LayoutObject->Ascii2Html( Text => $Self->{View} )
                . ';SortBy=' . $LayoutObject->Ascii2Html( Text => $Self->{SortBy} )
                . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $Self->{OrderBy} )
                . ';Profile=' . $LinkEncoded{Profile}
                . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkSort = 'RecipientField=' . $LinkEncoded{RecipientField}
                . ';RecipientFieldLabel=' . $LinkEncoded{RecipientFieldLabel}
                . ';RecipientType=' . $LinkEncoded{RecipientType}
                . ';Filter=' . $LayoutObject->Ascii2Html( Text => $Self->{Filter} )
                . ';View=' . $LayoutObject->Ascii2Html( Text => $Self->{View} )
                . ';Profile=' . $LinkEncoded{Profile}
                . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkFilter = 'RecipientField=' . $LinkEncoded{RecipientField}
                . ';RecipientFieldLabel=' . $LinkEncoded{RecipientFieldLabel}
                . ';RecipientType=' . $LinkEncoded{RecipientType}
                . ';Profile=' . $LayoutObject->Ascii2Html( Text => $Self->{Profile} )
                . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkBack = 'RecipientField=' . $LinkEncoded{RecipientField}
                . ';RecipientFieldLabel=' . $LinkEncoded{RecipientFieldLabel}
                . ';RecipientType=' . $LinkEncoded{RecipientType}
                . ';Profile=' . $LayoutObject->Ascii2Html( Text => $Self->{Profile} )
                . ';TakeLastSearch=1;Subaction=LoadProfile'
                . ';';

            # Find out which columns should be shown.
            my @ShowColumns;
            if ( IsArrayRefWithData( $Self->{Config}->{ShowColumns}->{ $Self->{RecipientType} } ) ) {
                @ShowColumns = @{ $Self->{Config}->{ShowColumns}->{ $Self->{RecipientType} } };
            }

            # Get the already selected recipients, to remember the selected recipients for the diffrent pages.
            my $RecipientsJSONString = $ParamObject->GetParam( Param => 'RecipientsJSON' ) || '';

            my $Recipients;
            if ($RecipientsJSONString) {
                $Recipients = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                    Data => $RecipientsJSONString,
                );
            }

            $Output .= $LayoutObject->CustomerUserAddressBookListShow(
                CustomerUserIDs     => $ViewableCustomerUserLogins,
                Total               => scalar @{$ViewableCustomerUserLogins},
                View                => $Self->{View},
                Env                 => $Self,
                LinkPage            => $LinkPage,
                LinkSort            => $LinkSort,
                LinkFilter          => $LinkFilter,
                LinkBack            => $LinkBack,
                Profile             => $Self->{Profile},
                TitleName           => Translatable('Customer User Address Book'),
                ShowColumns         => \@ShowColumns,
                SortBy              => $LayoutObject->Ascii2Html( Text => $Self->{SortBy} ),
                OrderBy             => $LayoutObject->Ascii2Html( Text => $Self->{OrderBy} ),
                RequestedURL        => 'Action=' . $Self->{Action} . ';' . $LinkPage,
                Recipients          => $Recipients || {},
                RecipientType       => $Self->{RecipientType},
                RecipientField      => $Self->{RecipientField},
                RecipientFieldLabel => $Self->{RecipientFieldLabel},
                CustomerTicketTextField =>
                    $Self->{Config}->{SearchParameters}->{ $Self->{RecipientType} }->{CustomerTicketTextField}
                    || 'UserMailString',
                LookupExcludeUserLogins => \%LookupExcludeUserLogins,
            );

            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );

            return $Output;
        }
    }

    # There was no 'SubAction', or there were validation errors, or an user or customer was searched
    #   generate search mask.
    my $Output = $LayoutObject->Header(
        Type => 'Small',
    );

    $Output .= $Self->_MaskForm(
        RecipientType       => $Self->{RecipientType},
        RecipientField      => $Self->{RecipientField},
        RecipientFieldLabel => $Self->{RecipientFieldLabel},
        %GetParam,
    );

    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );

    return $Output;
}

sub _MaskForm {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $EmptySearch = $ParamObject->GetParam( Param => 'EmptySearch' );
    if ( !$Self->{Profile} ) {
        $EmptySearch = 1;
    }

    my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');

    my %GetParam = $SearchProfileObject->SearchProfileGet(
        Base      => 'CustomerUserAddressBook',
        Name      => $Self->{Profile},
        UserLogin => $Self->{UserLogin},
    );

    # Allow profile overwrite the contents of %Param.
    %Param = (
        %Param,
        %GetParam,
    );

    # Get the search fields for the customer user search.
    my @CustomerUserSearchFields = $Self->_GetCustomerUserSearchFields(
        Types => [ 'Input', 'Selection' ],
    );

    # Get the search fields for the customer user search.
    my @CustomerCompanySearchFields = $Self->_GetCustomerCompanySearchFields(
        Types => [ 'Input', 'Selection' ],
    );

    # Translate the customer company label identifier to add this to the labels.
    my $TranslatedCustomerCompanyLabelIdentifier
        = $LayoutObject->{LanguageObject}->Translate( $Self->{CustomerCompanyLabelIdentifier} );

    my @Attributes;

    for my $Field (@CustomerUserSearchFields) {

        push @Attributes, {
            Key   => $Field->{Name},
            Value => $Field->{Label},
        };
    }

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    if ( IsArrayRefWithData( $Self->{DynamicFieldCustomerUser} ) ) {

        # Create dynamic fields search options for attribute select
        #   cycle trough the activated Dynamic Fields for this screen.
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicFieldCustomerUser} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
            next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            my $TranslatedDynamicFieldLabel = $LayoutObject->{LanguageObject}->Translate(
                $DynamicFieldConfig->{Label},
            );

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                my $TranslatedSuffix = $LayoutObject->{LanguageObject}->Translate(
                    $Preference->{LabelSuffix},
                ) || '';

                if ($TranslatedSuffix) {
                    $TranslatedSuffix = ' (' . $TranslatedSuffix . ')';
                }

                push @Attributes, (
                    {
                        Key   => 'Search_DynamicField_' . $DynamicFieldConfig->{Name} . $Preference->{Type},
                        Value => $TranslatedDynamicFieldLabel . $TranslatedSuffix,
                    },
                );
            }
        }
    }

    if (@CustomerCompanySearchFields) {

        push @Attributes, {
            Key      => '',
            Value    => '-',
            Disabled => 1,
        };

        for my $Field (@CustomerCompanySearchFields) {

            my $TranslatedFieldLabel = $LayoutObject->{LanguageObject}->Translate(
                $Field->{Label},
            );

            if (
                $TranslatedCustomerCompanyLabelIdentifier
                && $TranslatedFieldLabel ne $TranslatedCustomerCompanyLabelIdentifier
                )
            {
                $TranslatedFieldLabel .= " ($TranslatedCustomerCompanyLabelIdentifier)";
            }

            push @Attributes, {
                Key   => $Field->{Name},
                Value => $TranslatedFieldLabel,
            };
        }
    }

    if ( IsArrayRefWithData( $Self->{DynamicFieldCustomerCompany} ) ) {

        # Create dynamic fields search options for attribute select
        #   cycle trough the activated Dynamic Fields for this screen.
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicFieldCustomerCompany} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
            next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            my $TranslatedDynamicFieldLabel = $LayoutObject->{LanguageObject}->Translate(
                $DynamicFieldConfig->{Label},
            );

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                my $TranslatedSuffix = $LayoutObject->{LanguageObject}->Translate(
                    $Preference->{LabelSuffix},
                ) || '';

                if ($TranslatedSuffix) {
                    $TranslatedSuffix = ' (' . $TranslatedSuffix . ')';
                }

                my $DynamicFieldLabel = $TranslatedDynamicFieldLabel . $TranslatedSuffix;

                if (
                    $TranslatedCustomerCompanyLabelIdentifier
                    && $TranslatedDynamicFieldLabel ne $TranslatedCustomerCompanyLabelIdentifier
                    )
                {
                    $DynamicFieldLabel
                        .= ( $TranslatedSuffix ? " - " : " " ) . "($TranslatedCustomerCompanyLabelIdentifier)";
                }

                push @Attributes, (
                    {
                        Key   => 'Search_DynamicField_' . $DynamicFieldConfig->{Name} . $Preference->{Type},
                        Value => $DynamicFieldLabel,
                    },
                );
            }
        }
    }

    # Create HTML strings for all dynamic fields.
    my %DynamicFieldHTML;

    # Cycle trough the activated Dynamic Fields for this screen.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicFieldCustomerUser} }, @{ $Self->{DynamicFieldCustomerCompany} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
            DynamicFieldConfig   => $DynamicFieldConfig,
            OverridePossibleNone => 0,
        );

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                = $DynamicFieldBackendObject->SearchFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                Profile              => \%GetParam,
                PossibleValuesFilter => $PossibleValues,
                LayoutObject         => $LayoutObject,
                Type                 => $Preference->{Type},
                );
        }
    }

    $Param{AttributesStrg} = $LayoutObject->BuildSelection(
        PossibleNone => 1,
        Data         => \@Attributes,
        Name         => 'Attribute',
        Multiple     => 0,
        Class        => 'Modernize',
    );
    $Param{AttributesOrigStrg} = $LayoutObject->BuildSelection(
        PossibleNone => 1,
        Data         => \@Attributes,
        Name         => 'AttributeOrig',
        Multiple     => 0,
        Class        => 'Modernize',
    );

    my @OutputSearchFields;

    # Build the output for the input search fields.
    for my $Field (@CustomerUserSearchFields) {

        my %FieldData = (
            CustomerUserField => 1,
            Name              => $Field->{Name},
            Label             => $Field->{Label},
        );

        if ( $Field->{Type} eq 'Selection' ) {

            my $SelectionString = $LayoutObject->BuildSelection(
                Data        => $Field->{SelectionsData},
                Name        => $Field->{Name},
                Translation => 1,
                Multiple    => 1,
                Size        => 5,
                SelectedID  => $Param{ $Field->{Name} },
                Class       => 'Modernize',
            );
            $FieldData{SelectionString} = $SelectionString;
        }
        else {
            $FieldData{Value} = $Param{ $Field->{Name} };
        }

        push @OutputSearchFields, \%FieldData;
    }

    # Build the output for the input search fields.
    for my $Field (@CustomerCompanySearchFields) {

        my $TranslatedFieldLabel = $LayoutObject->{LanguageObject}->Translate(
            $Field->{Label},
        );

        if (
            $TranslatedCustomerCompanyLabelIdentifier
            && $TranslatedFieldLabel ne $TranslatedCustomerCompanyLabelIdentifier
            )
        {
            $TranslatedFieldLabel .= " ($TranslatedCustomerCompanyLabelIdentifier)";
        }

        my %FieldData = (
            CustomerCompanyField => 1,
            Name                 => $Field->{Name},
            Label                => $TranslatedFieldLabel,
        );

        if ( $Field->{Type} eq 'Selection' ) {

            my $SelectionString = $LayoutObject->BuildSelection(
                Data        => $Field->{SelectionsData},
                Name        => $Field->{Name},
                Translation => 1,
                Multiple    => 1,
                Size        => 5,
                SelectedID  => $Param{ $Field->{Name} },
                Class       => 'Modernize',
            );
            $FieldData{SelectionString} = $SelectionString;
        }
        else {
            $FieldData{Value} = $Param{ $Field->{Name} };
        }

        push @OutputSearchFields, \%FieldData;
    }

    $Param{OutputSearchFields} = \@OutputSearchFields;

    my %Profiles = $SearchProfileObject->SearchProfileList(
        Base      => 'CustomerUserAddressBook',
        UserLogin => $Self->{UserLogin},
    );
    delete $Profiles{''};
    delete $Profiles{'last-search'};
    if ($EmptySearch) {
        $Profiles{''} = '-';
    }
    else {
        $Profiles{'last-search'} = '-';
    }
    $Param{ProfilesStrg} = $LayoutObject->BuildSelection(
        Data       => \%Profiles,
        Name       => 'Profile',
        ID         => 'SearchProfile',
        SelectedID => $Self->{Profile},
        Class      => 'Modernize',

        # Do not modernize this field as this causes problems with the automatic focussing of the first element.
    );

    # Output the dynamic fields blocks, cycle trough the activated Dynamic Fields for this screen.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicFieldCustomerUser} }, @{ $Self->{DynamicFieldCustomerCompany} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            # Skip fields that HTML could not be retrieved.
            next PREFERENCE if !IsHashRefWithData(
                $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
            );

            my $DynamicFieldLabel = $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }->{Label};

            # Add a identifier for the object type 'CustomerCompany' and if a identifier exists.
            if ( $DynamicFieldConfig->{ObjectType} eq 'CustomerCompany' && $TranslatedCustomerCompanyLabelIdentifier ) {
                my $LabelCustomerCompanyLabelIdentifier
                    = ( $Preference->{LabelSuffix} ? " - " : " " ) . "($TranslatedCustomerCompanyLabelIdentifier)";
                $DynamicFieldLabel =~ s{(<label.*>)(.*)(</label>)}{$1$2$LabelCustomerCompanyLabelIdentifier$3}xmsg;
            }

            $LayoutObject->Block(
                Name => 'DynamicField',
                Data => {
                    Label => $DynamicFieldLabel,
                    Field => $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }->{Field},
                },
            );
        }
    }

    my @SearchAttributes;

    if ( $Self->{Profile} ) {

        my %AlreadyShown;

        ITEM:
        for my $Item (@Attributes) {
            my $Key = $Item->{Key};
            next ITEM if !$Key;
            next ITEM if !defined $Param{$Key};
            next ITEM if $AlreadyShown{$Key};

            if ( ref $Param{$Key} eq 'ARRAY' && !@{ $Param{$Key} } ) {
                next ITEM;
            }

            $AlreadyShown{$Key} = 1;

            push @SearchAttributes, $Key;
        }
    }

    # No profile, then show default screen.
    else {

        my %LookupDefaultFields = map { $_ => 1 } @{ $Self->{Config}->{DefaultFields}->{ $Self->{RecipientType} } };

        ITEM:
        for my $Item (@Attributes) {
            my $Key = $Item->{Key};

            next ITEM if !$LookupDefaultFields{$Key};

            push @SearchAttributes, $Key;
        }
    }

    $LayoutObject->AddJSData(
        Key   => 'ShowSearchDialog',
        Value => 1,
    );

    $LayoutObject->AddJSData(
        Key   => 'SearchAttributes',
        Value => \@SearchAttributes,
    );

    # build output
    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentCustomerUserAddressBook',
        Data         => {
            %Param,
            ShowSearchDialog => 1,
        },
    );

    return $Output;
}

=head2 _GetCustomerUserSearchFields()

Get the search fields from the customer user map config for the given types (otherwise all search fields).

    my @SearchFields = $AgentCustomerUserAddressBookObject->_GetCustomerUserSearchFields(
        Types => ['Input', 'Selection', 'DynamicField'], # optional
    );

=cut

sub _GetCustomerUserSearchFields {
    my ( $Self, %Param ) = @_;

    my @AllSearchFields = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserSearchFields();

    return @AllSearchFields if !IsArrayRefWithData( $Param{Types} ) || !@AllSearchFields;

    my @SearchFields;

    TYPE:
    for my $Type ( @{ $Param{Types} } ) {

        my @TypeSearchFields = grep { $Type eq $_->{Type} } @AllSearchFields;

        next TYPE if !@TypeSearchFields;

        @SearchFields = ( @SearchFields, @TypeSearchFields );
    }
    return @SearchFields;
}

=head2 _GetCustomerCompanySearchFields()

Get the search fields from the customer user map config for the given type (otherwise all search fields)
with a special prefix.

    my @SearchFields = $AgentCustomerUserAddressBookObject->_GetCustomerCompanySearchFields(
        Types         => ['Input', 'Selection', 'DynamicField'], # optional
        WithoutPrefix => 1, # optional
    );

=cut

sub _GetCustomerCompanySearchFields {
    my ( $Self, %Param ) = @_;

    my @AllSearchFields = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanySearchFields();

    # add a prefix for the customer company fields
    if ( !$Param{WithoutPrefix} ) {
        for my $Field (@AllSearchFields) {
            $Field->{Name} = $Self->{CustomerCompanySearchFieldPrefix} . $Field->{Name};
        }
    }

    return @AllSearchFields if !IsArrayRefWithData( $Param{Types} ) || !@AllSearchFields;

    my @SearchFields;

    TYPE:
    for my $Type ( @{ $Param{Types} } ) {

        my @TypeSearchFields = grep { $Type eq $_->{Type} } @AllSearchFields;

        next TYPE if !@TypeSearchFields;

        @SearchFields = ( @SearchFields, @TypeSearchFields );
    }
    return @SearchFields;
}

1;
