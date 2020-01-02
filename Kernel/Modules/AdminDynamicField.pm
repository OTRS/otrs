# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminDynamicField;

use strict;
use warnings;
use utf8;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);
use Kernel::System::CheckItem;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Subaction} eq 'DynamicFieldDelete' ) {

        # challenge token check for write action
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->ChallengeTokenCheck();

        return $Self->_DynamicFieldDelete(
            %Param,
        );
    }

    return $Self->_ShowOverview(
        %Param,
        Action => 'Overview',
    );
}

# AJAX sub-action
sub _DynamicFieldDelete {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LogObject   = $Kernel::OM->Get('Kernel::System::Log');

    my $Confirmed = $ParamObject->GetParam( Param => 'Confirmed' );

    if ( !$Confirmed ) {
        $LogObject->Log(
            'Priority' => 'error',
            'Message'  => "Need 'Confirmed'!",
        );
        return;
    }

    my $ID = $ParamObject->GetParam( Param => 'ID' );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $ID,
    );

    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
        $LogObject->Log(
            'Priority' => 'error',
            'Message'  => "Could not find DynamicField $ID!",
        );
        return;
    }

    if ( $DynamicFieldConfig->{InternalField} ) {
        $LogObject->Log(
            'Priority' => 'error',
            'Message'  => "Could not delete internal DynamicField $ID!",
        );
        return;
    }

    my $ValuesDeleteSuccess = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->AllValuesDelete(
        DynamicFieldConfig => $DynamicFieldConfig,
        UserID             => $Self->{UserID},
    );

    my $Success;

    if ($ValuesDeleteSuccess) {
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $ID,
            UserID => $Self->{UserID},
        );
    }

    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
        ContentType => 'text/html',
        Content     => $Success,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $FieldTypeConfig    = $ConfigObject->Get('DynamicFields::Driver');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # check for possible order collisions or gaps
    my $OrderSuccess = $DynamicFieldObject->DynamicFieldOrderCheck();
    if ( !$OrderSuccess ) {
        return $Self->_DynamicFieldOrderReset(
            %Param,
        );
    }

    my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();

    # call all needed template blocks
    $LayoutObject->Block(
        Name => 'Main',
        Data => {
            %Param,
            OTRSBusinessIsInstalled => $OTRSBusinessIsInstalled,
        }
    );

    my %FieldTypes;
    my %FieldDialogs;

    if ( !IsHashRefWithData($FieldTypeConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Fields configuration is not valid'),
        );
    }

    # get the field types (backends) and its config dialogs
    FIELDTYPE:
    for my $FieldType ( sort keys %{$FieldTypeConfig} ) {

        next FIELDTYPE if !$FieldTypeConfig->{$FieldType};
        next FIELDTYPE if $FieldTypeConfig->{$FieldType}->{DisabledAdd};

        # add the field type to the list
        $FieldTypes{$FieldType} = $FieldTypeConfig->{$FieldType}->{DisplayName};

        # get the config dialog
        $FieldDialogs{$FieldType} =
            $FieldTypeConfig->{$FieldType}->{ConfigDialog};
    }

    my $ObjectTypeConfig = $ConfigObject->Get('DynamicFields::ObjectType');

    if ( !IsHashRefWithData($ObjectTypeConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Objects configuration is not valid'),
        );
    }

    # make ObjectTypeConfig local variable to proper sorting
    my %ObjectTypeConfig = %{$ObjectTypeConfig};

    # cycle thought all objects to create the select add field selects
    my @ObjectTypes;
    OBJECTTYPE:
    for my $ObjectType (
        sort {
            ( int $ObjectTypeConfig{$a}->{Prio} || 0 )
                <=> ( int $ObjectTypeConfig{$b}->{Prio} || 0 )
        } keys %ObjectTypeConfig
        )
    {
        next OBJECTTYPE if !$ObjectTypeConfig->{$ObjectType};

        my $SelectName = $ObjectType . 'DynamicField';

        my @FieldList = map { { Key => $_, Value => $FieldTypes{$_} } } sort keys %FieldTypes;

        for my $Field (@FieldList) {

            if ( !$ConfigObject->Get("Frontend::Module")->{ $FieldDialogs{ $Field->{Key} } } ) {
                $Field->{Disabled} = 1;
            }
        }

        # Add disabled teaser options for OTRSBusiness dynamic fields.
        if ( !$OTRSBusinessIsInstalled ) {
            push @FieldList, {
                Key      => 'Database',
                Value    => $LayoutObject->{LanguageObject}->Translate( 'Database (%s)', 'OTRS Business Solution™' ),
                Disabled => 1,
            };
            push @FieldList, {
                Key   => 'Webservice',
                Value => $LayoutObject->{LanguageObject}->Translate( 'Web service (%s)', 'OTRS Business Solution™' ),
                Disabled => 1,
            };
            push @FieldList, {
                Key => 'ContactWithData',
                Value =>
                    $LayoutObject->{LanguageObject}->Translate( 'Contact with data (%s)', 'OTRS Business Solution™' ),
                Disabled => 1,
            };
        }

        # create the Add Dynamic Field select
        my $AddDynamicFieldStrg = $LayoutObject->BuildSelection(
            Data          => \@FieldList,
            Name          => $SelectName,
            PossibleNone  => 1,
            Translation   => 1,
            Sort          => 'AlphanumericValue',
            SelectedValue => '-',
            Class         => 'Modernize W75pc',
        );

        my $ObjectTypeName = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::ObjectType')
            ->{$ObjectType}->{DisplayName} || $ObjectType;

        push @ObjectTypes, $ObjectType;

        # call ActionAddDynamicField block
        $LayoutObject->Block(
            Name => 'ActionAddDynamicField',
            Data => {
                %Param,
                AddDynamicFieldStrg => $AddDynamicFieldStrg,
                ObjectType          => $ObjectType,
                ObjectTypeName      => $ObjectTypeName,
                SelectName          => $SelectName,
            },
        );
    }

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'ObjectTypes',
        Value => \@ObjectTypes
    );

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'DynamicFields',
        Value => \%FieldDialogs
    );

    # call hint block
    $LayoutObject->Block(
        Name => 'Hint',
        Data => \%Param,
    );

    # get dynamic fields list
    my $DynamicFieldsList = $DynamicFieldObject->DynamicFieldList(
        Valid => 0,
    );

    # print the list of dynamic fields
    $Self->_DynamicFieldsListShow(
        DynamicFields => $DynamicFieldsList,
        Total         => scalar @{$DynamicFieldsList},
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicField',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _DynamicFieldsListShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $FieldTypeConfig = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Driver');

    # check start option, if higher than fields available, set
    # it to the last field page
    my $StartHit = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'StartHit' ) || 1;

    # get personal page shown count
    my $PageShownPreferencesKey = 'AdminDynamicFieldsOverviewPageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 35;
    my $Group                   = 'DynamicFieldsOverviewPageShown';

    # get data selection
    my %Data;
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # calculate max. shown per page
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # build nav bar
    my $Limit   = $Param{Limit} || 20_000;
    my %PageNav = $LayoutObject->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $LayoutObject->{Action},
        Link      => $Param{LinkPage},
        IDPrefix  => $LayoutObject->{Action},
    );

    # build shown dynamic fields per page
    $Param{RequestedURL}    = "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $LayoutObject->BuildSelection(
        Name        => $PageShownPreferencesKey,
        SelectedID  => $PageShown,
        Translation => 0,
        Data        => \%Data,
        Sort        => 'NumericValue',
        Class       => 'Modernize',
    );

    if (%PageNav) {
        $LayoutObject->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        $LayoutObject->Block(
            Name => 'ContextSettings',
            Data => { %PageNav, %Param, },
        );
    }

    # check if at least 1 dynamic field is registered in the system
    if ( $Param{Total} ) {

        # get dynamic fields details
        my $Counter = 0;

        DYNAMICFIELDID:
        for my $DynamicFieldID ( @{ $Param{DynamicFields} } ) {
            $Counter++;
            if ( $Counter >= $StartHit && $Counter < ( $PageShown + $StartHit ) ) {

                my $DynamicFieldData = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                    ID => $DynamicFieldID,
                );
                next DYNAMICFIELDID if !IsHashRefWithData($DynamicFieldData);

                # convert ValidID to Validity string
                my $Valid = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
                    ValidID => $DynamicFieldData->{ValidID},
                );

                # get the object type display name
                my $ObjectTypeName = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::ObjectType')
                    ->{ $DynamicFieldData->{ObjectType} }->{DisplayName}
                    || $DynamicFieldData->{ObjectType};

                # get the field type display name
                my $FieldTypeName = $FieldTypeConfig->{ $DynamicFieldData->{FieldType} }->{DisplayName}
                    || $DynamicFieldData->{FieldType};

                # get the field backend dialog
                my $ConfigDialog = $FieldTypeConfig->{ $DynamicFieldData->{FieldType} }->{ConfigDialog}
                    || '';

                # print each dynamic field row
                $LayoutObject->Block(
                    Name => 'DynamicFieldsRow',
                    Data => {
                        %{$DynamicFieldData},
                        Valid          => $Valid,
                        ConfigDialog   => $ConfigDialog,
                        FieldTypeName  => $FieldTypeName,
                        ObjectTypeName => $ObjectTypeName,
                    },
                );

                # Internal fields can not be deleted.
                if ( !$DynamicFieldData->{InternalField} ) {
                    $LayoutObject->Block(
                        Name => 'DeleteLink',
                        Data => {
                            %{$DynamicFieldData},
                            Valid          => $Valid,
                            ConfigDialog   => $ConfigDialog,
                            FieldTypeName  => $FieldTypeName,
                            ObjectTypeName => $ObjectTypeName,
                        },
                    );
                }
            }
        }
    }

    # otherwise show a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoDataFound',
            Data => \%Param,
        );
    }

    $LayoutObject->Block(
        Name => 'MaxFieldOrder',
        Data => {
            MaxFieldOrder => scalar @{ $Param{DynamicFields} },
        },
    );

    return;
}

sub _DynamicFieldOrderReset {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ResetSuccess = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldOrderReset();

    # show error message if the order reset was not successful
    if ( !$ResetSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable(
                'Could not reset Dynamic Field order properly, please check the error log for more details.'
            ),
        );
    }

    # redirect to main screen
    return $LayoutObject->Redirect(
        OP => "Action=AdminDynamicField",
    );
}

1;
