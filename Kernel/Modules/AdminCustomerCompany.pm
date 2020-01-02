# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminCustomerCompany;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerCompany',
    );

    $Self->{DynamicFieldLookup} = { map { $_->{Name} => $_ } @{$DynamicFieldConfigs} };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Nav               = $ParamObject->GetParam( Param => 'Nav' ) || 0;
    my $NavigationBarType = $Nav eq 'Agent' ? 'Customers' : 'Admin';
    my $Search            = $ParamObject->GetParam( Param => 'Search' );
    $Search
        ||= $ConfigObject->Get('AdminCustomerCompany::RunInitialWildcardSearch') ? '*' : '';
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    my %GetParam;
    $GetParam{Source} = $ParamObject->GetParam( Param => 'Source' ) || 'CustomerCompany';

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $CustomerID
            = $ParamObject->GetParam( Param => 'CustomerID' ) || $ParamObject->GetParam( Param => 'ID' ) || '';
        my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';
        my %Data         = $CustomerCompanyObject->CustomerCompanyGet(
            CustomerID => $CustomerID,
        );
        $Data{CustomerCompanyID} = $CustomerID;
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );
        $Output .= $LayoutObject->Notify( Info => Translatable('Customer company updated!') )
            if ( $Notification && $Notification eq 'Update' );
        $Self->_Edit(
            Action => 'Change',
            Nav    => $Nav,
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my %Errors;
        $GetParam{CustomerCompanyID} = $ParamObject->GetParam( Param => 'CustomerCompanyID' );

        # Get dynamic field backend object.
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        ENTRY:
        for my $Entry ( @{ $ConfigObject->Get( $GetParam{Source} )->{Map} } ) {

            # check dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "DynamicField $Entry->[2] not found!",
                    );
                    next ENTRY;
                }

                my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $ParamObject,
                    Mandatory          => $Entry->[4],
                );

                if ( $ValidationResult->{ServerError} ) {
                    $Errors{ $Entry->[0] } = $ValidationResult;
                }
                else {

                    # generate storable value of dynamic field edit field
                    $GetParam{ $Entry->[0] } = $DynamicFieldBackendObject->EditFieldValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ParamObject        => $ParamObject,
                        LayoutObject       => $LayoutObject,
                    );
                }
            }

            # check remaining non-dynamic-field mandatory fields
            else {
                $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) // '';
                if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                    $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
                }
            }
        }

        if ( !defined $GetParam{CustomerID} ) {
            $GetParam{CustomerID} = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
        }

        # check for duplicate entries
        if ( $GetParam{CustomerCompanyID} ne $GetParam{CustomerID} ) {

            # get CustomerCompany list
            my %List = $CustomerCompanyObject->CustomerCompanyList(
                Search => $Param{Search},
                Valid  => 0,
            );

            # check duplicate field
            if ( %List && $List{ $GetParam{CustomerID} } ) {
                $Errors{Duplicate} = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            my $Update = $CustomerCompanyObject->CustomerCompanyUpdate( %GetParam, UserID => $Self->{UserID} );

            if ($Update) {

                my $SetDFError;

                # set dynamic field values
                my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

                ENTRY:
                for my $Entry ( @{ $ConfigObject->Get( $GetParam{Source} )->{Map} } ) {
                    next ENTRY if $Entry->[5] ne 'dynamic_field';

                    my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                        $SetDFError .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Dynamic field %s not found!',
                                $Entry->[2],
                            )
                        );
                        next ENTRY;
                    }

                    my $ValueSet = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectName         => $GetParam{CustomerID},
                        Value              => $GetParam{ $Entry->[0] },
                        UserID             => $Self->{UserID},
                    );

                    if ( !$ValueSet ) {
                        $SetDFError
                            .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Unable to set value for dynamic field %s!',
                                $Entry->[2],
                            ),
                            );
                        next ENTRY;
                    }
                }

                my $ContinueAfterSave = $ParamObject->GetParam( Param => 'ContinueAfterSave' ) || 0;

                # if set DF error exists, create notification
                if ($SetDFError) {

                    # if the user would like to continue editing the customer company, just redirect to the edit screen
                    if ( $ContinueAfterSave eq '1' ) {
                        $Self->_Edit(
                            Action => 'Change',
                            Nav    => $Nav,
                            Errors => \%Errors,
                            %GetParam,
                        );
                    }
                    else {
                        $Self->_Overview(
                            Nav    => $Nav,
                            Search => $Search,
                            %GetParam,
                        );
                    }
                    my $Output = $LayoutObject->Header();
                    $Output .= $LayoutObject->NavigationBar(
                        Type => $NavigationBarType,
                    );
                    $Output .= $LayoutObject->Notify( Info => Translatable('Customer company updated!') );
                    $Output .= $SetDFError;
                    $Output .= $LayoutObject->Output(
                        TemplateFile => 'AdminCustomerCompany',
                        Data         => \%Param,
                    );
                    $Output .= $LayoutObject->Footer();
                    return $Output;
                }

                # if the user would like to continue editing the customer company, just redirect to the edit screen
                if ( $ContinueAfterSave eq '1' ) {
                    my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
                    return $LayoutObject->Redirect(
                        OP =>
                            "Action=$Self->{Action};Subaction=Change;CustomerID=$CustomerID;Nav=$Nav;Notification=Update"
                    );
                }
                else {

                    # otherwise return to overview
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
                }
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );

        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        # set notification for duplicate entry
        if ( $Errors{Duplicate} ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Info     => $LayoutObject->{LanguageObject}->Translate(
                    'Customer Company %s already exists!',
                    $GetParam{CustomerID},
                ),
            );
        }

        $Self->_Edit(
            Action => 'Change',
            Nav    => $Nav,
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );
        $Self->_Edit(
            Action => 'Add',
            Nav    => $Nav,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my %Errors;

        my $CustomerCompanyKey = $ConfigObject->Get( $GetParam{Source} )->{CustomerCompanyKey};
        my $CustomerCompanyID;

        # Get dynamic field backend object.
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        ENTRY:
        for my $Entry ( @{ $ConfigObject->Get( $GetParam{Source} )->{Map} } ) {

            # check dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "DynamicField $Entry->[2] not found!",
                    );
                    next ENTRY;
                }

                my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $ParamObject,
                    Mandatory          => $Entry->[4],
                );

                if ( $ValidationResult->{ServerError} ) {
                    $Errors{ $Entry->[0] } = $ValidationResult;
                }
                else {

                    # generate storable value of dynamic field edit field
                    $GetParam{ $Entry->[0] } = $DynamicFieldBackendObject->EditFieldValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ParamObject        => $ParamObject,
                        LayoutObject       => $LayoutObject,
                    );
                }
            }

            # check remaining non-dynamic-field mandatory fields
            else {
                $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) // '';
                if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                    $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
                }
            }

            # save customer company key for checking duplicate
            if ( $Entry->[2] eq $CustomerCompanyKey ) {
                $CustomerCompanyID = $GetParam{ $Entry->[0] };
            }
        }

        # get CustomerCompany list
        my %List = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{Search},
            Valid  => 0,
        );

        # check duplicate field
        if ( %List && $List{$CustomerCompanyID} ) {
            $Errors{Duplicate} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add company
            if (
                $CustomerCompanyObject->CustomerCompanyAdd(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {

                $Self->_Overview(
                    Nav    => $Nav,
                    Search => $Search,
                    %GetParam,
                );
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar(
                    Type => $NavigationBarType,
                );
                $Output .= $LayoutObject->Notify(
                    Info => Translatable('Customer company added!'),
                );

                # set dynamic field values
                my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

                ENTRY:
                for my $Entry ( @{ $ConfigObject->Get( $GetParam{Source} )->{Map} } ) {
                    next ENTRY if $Entry->[5] ne 'dynamic_field';

                    my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                        $Output .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Dynamic field %s not found!',
                                $Entry->[2],
                            ),
                        );
                        next ENTRY;
                    }

                    my $ValueSet = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectName         => $GetParam{CustomerID},
                        Value              => $GetParam{ $Entry->[0] },
                        UserID             => $Self->{UserID},
                    );

                    if ( !$ValueSet ) {
                        $Output
                            .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Unable to set value for dynamic field %s!',
                                $Entry->[2],
                            ),
                            );
                        next ENTRY;
                    }
                }

                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminCustomerCompany',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );

        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        # set notification for duplicate entry
        if ( $Errors{Duplicate} ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Info     => $LayoutObject->{LanguageObject}->Translate(
                    'Customer Company %s already exists!',
                    $CustomerCompanyID,
                ),
            );
        }

        $Self->_Edit(
            Action => 'Add',
            Nav    => $Nav,
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
            %GetParam,
        );
        my $Output       = $LayoutObject->Header();
        my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );
        $Output .= $LayoutObject->Notify( Info => Translatable('Customer company updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # send parameter ReadOnly to JS object
    $LayoutObject->AddJSData(
        Key   => 'ReadOnly',
        Value => $ConfigObject->{ $Param{Source} }->{ReadOnly},
    );

    # Get valid object.
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    $Param{'ValidOption'} = $LayoutObject->BuildSelection(
        Data       => { $ValidObject->ValidList(), },
        Name       => 'ValidID',
        Class      => 'Modernize',
        SelectedID => $Param{ValidID},
    );

    # Get needed objects.
    my $ParamObject               = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    ENTRY:
    for my $Entry ( @{ $ConfigObject->Get( $Param{Source} )->{Map} } ) {
        if ( $Entry->[0] ) {

            # Handle dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                next ENTRY if !IsHashRefWithData($DynamicFieldConfig);

                # Get HTML for dynamic field
                my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Param{ $Entry->[0] } ? $Param{ $Entry->[0] } : undef,
                    Mandatory          => $Entry->[4],
                    LayoutObject       => $LayoutObject,
                    ParamObject        => $ParamObject,

                    # Server error, if any
                    %{ $Param{Errors}->{ $Entry->[0] } },
                );

                # skip fields for which HTML could not be retrieved
                next ENTRY if !IsHashRefWithData($DynamicFieldHTML);

                $LayoutObject->Block(
                    Name => 'PreferencesGeneric',
                    Data => {},
                );

                $LayoutObject->Block(
                    Name => 'DynamicField',
                    Data => {
                        Name  => $DynamicFieldConfig->{Name},
                        Label => $DynamicFieldHTML->{Label},
                        Field => $DynamicFieldHTML->{Field},
                    },
                );

                next ENTRY;
            }

            my $Block = 'Input';

            # build selections or input fields
            if ( $ConfigObject->Get( $Param{Source} )->{Selections}->{ $Entry->[0] } ) {
                my $OptionRequired = '';
                if ( $Entry->[4] ) {
                    $OptionRequired = 'Validate_Required';
                }

                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $LayoutObject->BuildSelection(
                    Data =>
                        $ConfigObject->Get( $Param{Source} )->{Selections}
                        ->{ $Entry->[0] },
                    Name  => $Entry->[0],
                    Class => "$OptionRequired Modernize " .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    Translation => 0,
                    SelectedID  => $Param{ $Entry->[0] },
                    Max         => 35,
                );

            }
            elsif ( $Entry->[0] =~ /^CustomerCompanyCountry/i ) {
                my $OptionRequired = '';
                if ( $Entry->[4] ) {
                    $OptionRequired = 'Validate_Required';
                }

                # build Country string
                my $CountryList = $Kernel::OM->Get('Kernel::System::ReferenceData')->CountryList();

                $Block = 'Option';
                $Param{Option} = $LayoutObject->BuildSelection(
                    Data         => $CountryList,
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                    Name         => $Entry->[0],
                    Class        => "$OptionRequired Modernize " .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    SelectedID => defined( $Param{ $Entry->[0] } ) ? $Param{ $Entry->[0] } : 1,
                );
            }
            elsif ( $Entry->[0] =~ /^ValidID/i ) {
                my $OptionRequired = '';
                if ( $Entry->[4] ) {
                    $OptionRequired = 'Validate_Required';
                }

                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $LayoutObject->BuildSelection(
                    Data  => { $ValidObject->ValidList(), },
                    Name  => $Entry->[0],
                    Class => "$OptionRequired Modernize " .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    SelectedID => defined( $Param{ $Entry->[0] } ) ? $Param{ $Entry->[0] } : 1,
                );
            }
            else {
                $Param{Value} = $Param{ $Entry->[0] } || '';
            }

            # show required flag
            if ( $Entry->[4] ) {
                $Param{MandatoryClass} = 'class="Mandatory"';
                $Param{StarLabel}      = '<span class="Marker">*</span>';
                $Param{RequiredClass}  = 'Validate_Required';
            }
            else {
                $Param{MandatoryClass} = '';
                $Param{StarLabel}      = '';
                $Param{RequiredClass}  = '';
            }

            # show required flag
            if ( $Entry->[7] ) {
                $Param{ReadOnlyType} = 'readonly="readonly"';
            }
            else {
                $Param{ReadOnlyType} = '';
            }

            # add form option
            if ( $Param{Type} && $Param{Type} eq 'hidden' ) {
                $Param{Preferences} .= $Param{Value};
            }
            else {
                $LayoutObject->Block(
                    Name => 'PreferencesGeneric',
                    Data => {
                        Item => $Entry->[1],
                        %Param
                    },
                );
                $LayoutObject->Block(
                    Name => "PreferencesGeneric$Block",
                    Data => {
                        %Param,
                        Item         => $Entry->[1],
                        Name         => $Entry->[0],
                        Value        => $Param{ $Entry->[0] },
                        InvalidField => $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '',
                    },
                );
                if ( $Entry->[4] ) {
                    $LayoutObject->Block(
                        Name => "PreferencesGeneric${Block}Required",
                        Data => {
                            Name => $Entry->[0],
                        },
                    );
                }
            }
        }
    }
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionSearch',
        Data => \%Param,
    );

    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    # get writable data sources
    my %CustomerCompanySource = $CustomerCompanyObject->CustomerCompanySourceList(
        ReadOnly => 0,
    );

    # only show Add option if we have at least one writable backend
    if ( scalar keys %CustomerCompanySource ) {
        $Param{SourceOption} = $LayoutObject->BuildSelection(
            Data       => { %CustomerCompanySource, },
            Name       => 'Source',
            SelectedID => $Param{Source} || '',
            Class      => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'ActionAdd',
            Data => \%Param,
        );
    }

    # if there are any registries to search, the table is filled and shown
    if ( $Param{Search} ) {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # same Limit as $Self->{CustomerCompanyMap}->{'CustomerCompanySearchListLimit'}
        # smallest Limit from all sources
        my $Limit = 400;
        SOURCE:
        for my $Count ( '', 1 .. 10 ) {
            next SOURCE if !$ConfigObject->Get("CustomerCompany$Count");
            my $CustomerUserMap = $ConfigObject->Get("CustomerCompany$Count");
            next SOURCE if !$CustomerUserMap->{CustomerCompanySearchListLimit};
            if ( $CustomerUserMap->{CustomerCompanySearchListLimit} < $Limit ) {
                $Limit = $CustomerUserMap->{CustomerCompanySearchListLimit};
            }
        }

        my %ListAllItems = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{Search},
            Limit  => $Limit + 1,
            Valid  => 0,
        );

        if ( keys %ListAllItems <= $Limit ) {
            my $ListAllItems = keys %ListAllItems;
            $LayoutObject->Block(
                Name => 'OverviewHeader',
                Data => {
                    ListAll => $ListAllItems,
                    Limit   => $Limit,
                },
            );
        }

        my %List = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{Search},
            Valid  => 0,
        );

        if ( keys %ListAllItems > $Limit ) {
            my $ListAllItems   = keys %ListAllItems;
            my $SearchListSize = keys %List;

            $LayoutObject->Block(
                Name => 'OverviewHeader',
                Data => {
                    SearchListSize => $SearchListSize,
                    ListAll        => $ListAllItems,
                    Limit          => $Limit,
                },
            );
        }

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        if ( !$ConfigObject->Get( $Param{Source} )->{Params}->{ForeignDB} ) {
            $LayoutObject->Block( Name => 'LocalDB' );
        }

        # if there are results to show
        if (%List) {
            for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {

                my %Data = $CustomerCompanyObject->CustomerCompanyGet( CustomerID => $ListKey );
                $LayoutObject->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        %Data,
                        Search => $Param{Search},
                        Nav    => $Param{Nav},
                    },
                );

                if ( !$ConfigObject->Get( $Param{Source} )->{Params}->{ForeignDB} ) {
                    $LayoutObject->Block(
                        Name => 'LocalDBRow',
                        Data => {
                            Valid => $ValidList{ $Data{ValidID} },
                            %Data,
                        },
                    );
                }

            }
        }

        # otherwise it displays a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }
    }

    # if there is nothing to search it shows a message
    else
    {
        $LayoutObject->Block(
            Name => 'NoSearchTerms',
            Data => {},
        );
    }
    return 1;
}

1;
