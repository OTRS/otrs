# --
# Kernel/System/DynamicField/Backend/DateTime.pm - Delegate for DynamicField DateTime backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DateTime.pm,v 1.28 2011-09-22 16:56:34 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend::DateTime;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicFieldValue;
use Kernel::System::Time;
use Kernel::System::DynamicField::Backend::BackendCommon;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::DateTime

=head1 SYNOPSIS

DynamicFields DateTime backend delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject MainObject DBObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{DynamicFieldValueObject} = Kernel::System::DynamicFieldValue->new( %{$Self} );
    $Self->{TimeObject}              = Kernel::System::Time->new( %{$Self} );
    $Self->{BackendCommonObject}
        = Kernel::System::DynamicField::Backend::BackendCommon->new( %{$Self} );

    return $Self;
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Self->{DynamicFieldValueObject}->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$DFValue;
    return if !IsArrayRefWithData($DFValue);
    return if !IsHashRefWithData( $DFValue->[0] );

    return $DFValue->[0]->{ValueDateTime};
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->{DynamicFieldValueObject}->ValueSet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        Value    => [
            {
                ValueDateTime => $Param{Value},
            },
        ],
        UserID => $Param{UserID},
    );

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{Operator} eq 'Equals' ) {
        my $SQL = " $Param{TableAlias}.value_date = '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThan' ) {
        my $SQL = " $Param{TableAlias}.value_date > '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_date >= '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThan' ) {
        my $SQL = " $Param{TableAlias}.value_date < '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_date <= '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    $Self->{'LogObject'}->Log(
        'Priority' => 'error',
        'Message'  => "Unsupported Operator $Param{Operator}",
    );

    return;
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    return "$Param{TableAlias}.value_date";
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig LayoutObject ParamObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID Config Name )) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    # set the field value or default
    my $Value = $FieldConfig->{DefaultValue} || '';

    my %SplitedFieldValues;
    if ( defined $Param{Value} ) {
        $Value = $Param{Value};
        my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $Value =~
            m{ \A ( \d{4} ) - ( \d{2} ) - ( \d{2} ) \s ( \d{2} ) : ( \d{2} ) : ( \d{2} ) \z }xms;

        %SplitedFieldValues = (
            $FieldName . 'Year'   => $Year,
            $FieldName . 'Month'  => $Month,
            $FieldName . 'Day'    => $Day,
            $FieldName . 'Hour'   => $Hour,
            $FieldName . 'Minute' => $Minute,
        );
    }

    # extract the dynamic field value form the web request
    my $FieldValues = $Self->EditFieldValueGet(
        ReturnValueStructure => 1,
        %Param,
    );

    # set values from ParamObject if present
    if ( defined $FieldValues && IsHashRefWithData($FieldValues) ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $FieldConfig->{ $FieldName . $Type } = $FieldValues->{ $FieldName . $Type };
        }
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    $FieldClass .= ' Validate_Required' if $Param{Mandatory};

    # set error css class
    $FieldClass .= ' ServerError' if $Param{ServerError};

    my $HTMLString = $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName,
        Format               => 'DateInputFormatLong',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => $FieldConfig->{DefaultValue} || '',
        $FieldName . Required => $Param{Mandatory} || 0,
        $FieldName . Optional => 1,
        Validate              => 1,
        %{$FieldConfig},
        %SplitedFieldValues,
    );

    if ( $Param{Mandatory} ) {
        my $DivID = $FieldName . 'UsedError';

        # for client side validation
        $HTMLString .= <<"EOF";

    <div id="$DivID" class="TooltipErrorMessage">
        <p>
            \$Text{"This field is required."}
        </p>
    </div>
EOF
    }

    if ( $Param{ServerError} ) {

        my $ErrorMessage = $Param{ErrorMessage} || 'This field is required.';
        my $DivID = $FieldName . 'UsedServerError';

        # for server side validation
        $HTMLString .= <<"EOF";
    <div id="$DivID" class="TooltipErrorMessage">
        <p>
            \$Text{"$ErrorMessage"}
        </p>
    </div>
EOF
    }

    # call EditLabelRender on the common backend
    my $LabelString = $Self->{BackendCommonObject}->EditLabelRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Mandatory          => $Param{Mandatory} || '0',
        FieldName          => $FieldName . 'Used',
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ParamObject LayoutObject)) {
        if ( !$Param{DynamicFieldConfig} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw( ID Config Name )) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the Prefix as the dynamic field name
    my $Prefix = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # get dynamic field value form param
    my %DynamicFieldValues;
    for my $Type (qw(Used Year Month Day Hour Minute)) {
        $DynamicFieldValues{ $Prefix . $Type } = $Param{ParamObject}->GetParam(
            Param => $Prefix . $Type,
        );
    }

    # return if the field is empty (e.g. initial screen)
    return if !$DynamicFieldValues{ $Prefix . 'Used' }
            && !$DynamicFieldValues{ $Prefix . 'Year' }
            && !$DynamicFieldValues{ $Prefix . 'Month' }
            && !$DynamicFieldValues{ $Prefix . 'Day' }
            && !$DynamicFieldValues{ $Prefix . 'Hour' }
            && !$DynamicFieldValues{ $Prefix . 'Minute' };

    # check if return value structure is nedded
    if ( defined $Param{ReturnValueStructure} && $Param{ReturnValueStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    my $ManualTimeStamp = '';

    if ( $DynamicFieldValues{ $Prefix . 'Used' } ) {

        # transform time stamp based on user time zone
        %DynamicFieldValues = $Param{LayoutObject}->TransformDateSelection(
            %DynamicFieldValues,
            Prefix => $Prefix,
        );

        # add a leading zero for date parts that could be les than ten to generate a correct
        # time stamp
        for my $Type (qw(Month Day Hour Minute Second)) {
            if (
                $DynamicFieldValues{ $Prefix . $Type }
                && $DynamicFieldValues{ $Prefix . $Type } < 10
                )
            {
                $DynamicFieldValues{ $Prefix . $Type }
                    = '0' . $DynamicFieldValues{ $Prefix . $Type };
            }
        }

        my $Year   = $DynamicFieldValues{ $Prefix . 'Year' }   || '0000';
        my $Month  = $DynamicFieldValues{ $Prefix . 'Month' }  || '00';
        my $Day    = $DynamicFieldValues{ $Prefix . 'Day' }    || '00';
        my $Hour   = $DynamicFieldValues{ $Prefix . 'Hour' }   || '00';
        my $Minute = $DynamicFieldValues{ $Prefix . 'Minute' } || '00';
        my $Second = $DynamicFieldValues{ $Prefix . 'Second' } || '00';

        $ManualTimeStamp =
            $Year . '-' . $Month . '-' . $Day . ' '
            . $Hour . ':' . $Minute . ':' . $Second;
    }

    return $ManualTimeStamp;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ParamObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID Config Name )) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig   => $Param{DynamicFieldConfig},
        ParamObject          => $Param{ParamObject},
        ReturnValueStructure => 1,
    );

    # on normal basis Used field could be empty but if there was no value from EditFieldValueGet()
    # it must be an error
    if ( !defined $Value ) {
        return {
            ServerError  => 1,
            ErrorMessage => 'Invalid Date!'
            }
    }

    my $ServerError;
    my $ErrorMessage;

    # set the date time prefix as field name
    my $Prefix = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # perform necessary validations
    if ( $Param{Mandatory} && !$Value->{ $Prefix . 'Used' } ) {
        $ServerError = 1;
    }

    # create resulting structure
    my $Result = {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };

    return $Result;
}

sub PrintFieldRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig Value LayoutObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    my $LabelString
        = $Param{LayoutObject}->{LanguageObject}->Get( $Param{DynamicFieldConfig}->{Label} );

    my $FieldString = $Param{LayoutObject}->Output(
        Template => '$TimeLong{"$Data{"Value"}"}',
        Data => { Value => $Param{Value}, },
    );

    my $Data = {
        Field => $FieldString,
        Label => $LabelString,
    };

    return $Data;
}

sub DisplayLabelRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig LayoutObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    return $Param{LayoutObject}->{LanguageObject}->Get( $Param{DynamicFieldConfig}->{Label} ) || '';
}

sub DisplayFieldRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig LayoutObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    my $FieldString = '';

    # convert date to localized string
    if ( defined $Param{Value} ) {
        $FieldString = $Param{LayoutObject}->Output(
            Template => '$TimeLong{"$Data{"Value"}"}',
            Data => { Value => $Param{Value}, },
        );
    }

    # set title as localized value
    my $TitleString = $FieldString;

    my $Data = {
        Value => $FieldString,
        Title => $TitleString,
    };

    return $Data;
}

sub IsSortable {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$$

=cut
