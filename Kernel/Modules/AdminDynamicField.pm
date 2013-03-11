# --
# Kernel/Modules/AdminDynamicField.pm - provides a dynamic fields view for admins
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicField;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Valid;
use Kernel::System::CheckItem;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create additional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    $Self->{DynamicFieldObject}        = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{DynamicFieldBackendObject} = Kernel::System::DynamicField::Backend->new( %{$Self} );

    # get configured object types
    $Self->{ObjectTypeConfig} = $Self->{ConfigObject}->Get('DynamicFields::ObjectType');

    # get configured field types
    $Self->{FieldTypeConfig} = $Self->{ConfigObject}->Get('DynamicFields::Backend');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Subaction} eq 'DynamicFieldDelete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        return $Self->_DynamicFieldDelete(
            %Param,
        );
    }

    return $Self->_ShowOverview(
        %Param,
        Action => 'Overview',
    );
}

# AJAX subaction
sub _DynamicFieldDelete {
    my ( $Self, %Param ) = @_;

    my $Confirmed = $Self->{ParamObject}->GetParam( Param => 'Confirmed' );

    if ( !$Confirmed ) {
        $Self->{'LogObject'}->Log(
            'Priority' => 'error',
            'Message'  => "Need 'Confirmed'!",
        );
        return;
    }

    my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

    my $DynamicFieldConfig = $Self->{DynamicFieldObject}->DynamicFieldGet(
        ID => $ID,
    );

    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
        $Self->{'LogObject'}->Log(
            'Priority' => 'error',
            'Message'  => "Could not find DynamicField $ID!",
        );
        return;
    }

    if ( $DynamicFieldConfig->{InternalField} ) {
        $Self->{'LogObject'}->Log(
            'Priority' => 'error',
            'Message'  => "Could not delete internal DynamicField $ID!",
        );
        return;
    }

    my $ValuesDeleteSuccess = $Self->{DynamicFieldBackendObject}->AllValuesDelete(
        DynamicFieldConfig => $DynamicFieldConfig,
        UserID             => $Self->{UserID},
    );

    my $Success;

    if ($ValuesDeleteSuccess) {
        $Success = $Self->{DynamicFieldObject}->DynamicFieldDelete(
            ID     => $ID,
            UserID => $Self->{UserID},
        );
    }

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/html',
        Content     => $Success,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # check for posible order collisions or gaps
    my $OrderSuccess = $Self->{DynamicFieldObject}->DynamicFieldOrderCheck();
    if ( !$OrderSuccess ) {
        return $Self->_DynamicFieldOrderReset(
            %Param,
        );
    }

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Main',
        Data => \%Param,
    );

    my %FieldTypes;
    my %FieldDialogs;

    if ( !IsHashRefWithData( $Self->{FieldTypeConfig} ) ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Fields configuration is not valid",
        );
    }

    # get the field types (backends) and its config dialogs
    FIELDTYPE:
    for my $FieldType ( sort keys %{ $Self->{FieldTypeConfig} } ) {
        next FIELDTYPE if !$Self->{FieldTypeConfig}->{$FieldType};

        # add the field type to the list
        $FieldTypes{$FieldType} = $Self->{FieldTypeConfig}->{$FieldType}->{DisplayName};

        # get the config dialog
        $FieldDialogs{$FieldType} =
            $Self->{FieldTypeConfig}->{$FieldType}->{ConfigDialog};
    }

    if ( !IsHashRefWithData( $Self->{ObjectTypeConfig} ) ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Objects configuration is not valid",
        );
    }

    # cycle thought all objects to create the select add field selects
    OBJECTTYPE:
    for my $ObjectType ( sort keys %{ $Self->{ObjectTypeConfig} } ) {
        next OBJECTTYPE if !$Self->{ObjectTypeConfig}->{$ObjectType};

        my $SelectName = $ObjectType . 'DynamicField';

        # create the Add Dynamic Field select
        my $AddDynamicFieldStrg = $Self->{LayoutObject}->BuildSelection(
            Data          => \%FieldTypes,
            Name          => $SelectName,
            PossibleNone  => 1,
            Translation   => 1,
            Sort          => 'AlphanumericValue',
            SelectedValue => '-',
            Class         => 'W75pc',
        );

        # call ActionAddDynamicField block
        $Self->{LayoutObject}->Block(
            Name => 'ActionAddDynamicField',
            Data => {
                %Param,
                AddDynamicFieldStrg => $AddDynamicFieldStrg,
                ObjectType          => $ObjectType,
                SelectName          => $SelectName,
            },
        );
    }

    # parse the fields dialogs as JSON structure
    my $FieldDialogsConfig = $Self->{LayoutObject}->JSONEncode(
        Data => \%FieldDialogs,
    );

    # set JS configuration
    $Self->{LayoutObject}->Block(
        Name => 'ConfigSet',
        Data => {
            FieldDialogsConfig => $FieldDialogsConfig,
        },
    );

    # call hint block
    $Self->{LayoutObject}->Block(
        Name => 'Hint',
        Data => \%Param,
    );

    # get dynamic fields list
    my $DynamicFieldsList = $Self->{DynamicFieldObject}->DynamicFieldList(
        Valid => 0,
    );

    # print the list of dynamic fields
    $Self->_DynamicFieldsListShow(
        DynamicFields => $DynamicFieldsList,
        Total         => scalar @{$DynamicFieldsList},
    );

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminDynamicField',
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _DynamicFieldsListShow {
    my ( $Self, %Param ) = @_;

    # check start option, if higher than fields available, set
    # it to the last field page
    my $StartHit = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;

    # get personal page shown count
    my $PageShownPreferencesKey = 'AdminDynamicFieldsOverviewPageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 35;
    my $Group                   = 'DynamicFieldsOverviewPageShown';

    # get data selection
    my %Data;
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # calculate max. shown per page
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # build nav bar
    my $Limit = $Param{Limit} || 20_000;
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Self->{LayoutObject}->{Action},
        Link      => $Param{LinkPage},
        IDPrefix  => $Self->{LayoutObject}->{Action},
    );

    # build shown dynamic fields per page
    $Param{RequestedURL}    = "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $Self->{LayoutObject}->BuildSelection(
        Name        => $PageShownPreferencesKey,
        SelectedID  => $PageShown,
        Translation => 0,
        Data        => \%Data,
    );

    if (%PageNav) {
        $Self->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContextSettings',
            Data => { %PageNav, %Param, },
        );
    }

    my $MaxFieldOrder = 0;

    # check if at least 1 dynamic field is registered in the system
    if ( $Param{Total} ) {

        # get dynamic fields details
        my $Counter = 0;

        DYNAMICFIELDID:
        for my $DynamicFieldID ( @{ $Param{DynamicFields} } ) {
            $Counter++;
            if ( $Counter >= $StartHit && $Counter < ( $PageShown + $StartHit ) ) {

                my $DynamicFieldData = $Self->{DynamicFieldObject}->DynamicFieldGet(
                    ID => $DynamicFieldID,
                );
                next DYNAMICFIELDID if !IsHashRefWithData($DynamicFieldData);

                # convert ValidID to Validity string
                my $Valid = $Self->{ValidObject}->ValidLookup(
                    ValidID => $DynamicFieldData->{ValidID},
                );

                # get the object type display name
                my $ObjectTypeName
                    = $Self->{ObjectTypeConfig}->{ $DynamicFieldData->{ObjectType} }->{DisplayName}
                    || $DynamicFieldData->{ObjectType};

                # get the field type display name
                my $FieldTypeName
                    = $Self->{FieldTypeConfig}->{ $DynamicFieldData->{FieldType} }->{DisplayName}
                    || $DynamicFieldData->{FieldType};

                # get the field backend dialog
                my $ConfigDialog
                    = $Self->{FieldTypeConfig}->{ $DynamicFieldData->{FieldType} }->{ConfigDialog}
                    || '';

                # print each dynamic field row
                $Self->{LayoutObject}->Block(
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
                    $Self->{LayoutObject}->Block(
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

                # set MaxFieldOrder
                if ( int $DynamicFieldData->{FieldOrder} > int $MaxFieldOrder ) {
                    $MaxFieldOrder = $DynamicFieldData->{FieldOrder}
                }
            }
        }
    }

    # otherwise show a no data found message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFound',
            Data => \%Param,
        );
    }

    $Self->{LayoutObject}->Block(
        Name => 'MaxFieldOrder',
        Data => {
            MaxFieldOrder => $MaxFieldOrder,
        },
    );

    return;
}

sub _DynamicFieldOrderReset {
    my ( $Self, %Param ) = @_;

    my $ResetSuccess = $Self->{DynamicFieldObject}->DynamicFieldOrderReset();

    # show error message if the order reset was not successful
    if ( !$ResetSuccess ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not reset Dynamic Field order propertly, please check the error log"
                . " for more details",
        );
    }

    # redirect to main screen
    return $Self->{LayoutObject}->Redirect(
        OP => "Action=AdminDynamicField",
    );
}

1;
