# --
# Kernel/System/ProcessManagement/Transition.pm - all ticket functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::Transition;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

=head1 NAME

Kernel::System::ProcessManagement::Transition - Transition lib

=head1 SYNOPSIS

All Process Management Transition functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::ProcessManagement::Transition;

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
    my $TransitionObject = Kernel::System::ProcessManagement::Transition->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        MainObject         => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject LogObject MainObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item TransitionGet()

    Get Transition info

    my $Transition = $TransitionObject->TransitionGet(
        TransitionEntityID => 'T1',
    );

    Returns:

    $Transition = {
        Name       => 'Transition 1',
        CreateTime => '08-02-2012 13:37:00',
        ChangeBy   => '2',
        ChangeTime => '09-02-2012 13:37:00',
        CreateBy   => '3',
        Condition  => {
            Type   => 'and',
            Cond1  => {
                Type   => 'and',
                Fields => {
                    DynamicField_Make    => [ '2' ],
                    DynamicField_VWModel => {
                        Type  => 'String',
                        Match => 'Golf',
                    },
                    DynamicField_A => {
                        Type  => 'Hash',
                        Match => {
                            Value  => 1,
                        },
                    },
                    DynamicField_B => {
                        Type  => 'Regexp',
                        Match => qr{ [\n\r\f] }xms
                    },
                    DynamicField_C => {
                        Type  => 'Module',
                        Match =>
                            'Kernel::System::ProcessManagement::TransitionValidation::MyModule',
                    },
                    Queue =>  {
                        Type  => 'Array',
                        Match => [ 'Raw' ],
                    },
                    # ...
                }
            }
            # ...
        },
    };
=cut

sub TransitionGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TransitionEntityID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my $Transition = $Self->{ConfigObject}->Get('Process::Transition');

    if ( !IsHashRefWithData($Transition) ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Transition config!' );
        return;
    }

    if ( !IsHashRefWithData( $Transition->{ $Param{TransitionEntityID} } ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No data for Transition '$Param{TransitionEntityID}' found!"
        );
        return;
    }
    return $Transition->{ $Param{TransitionEntityID} };
}

=item TransitionCheck()

    Checks if one or more Transition Conditions are true

    my $TransitionCheck = $TransitionObject->TransitionCheck(
        TransitionEntityID => 'T1',
        or
        TransitionEntityID => ['T1', 'T2', 'T3'],
        Data       => {
            Queue         => 'Raw',
            DynamicField1 => 'Value',
            Subject       => 'Testsubject',
            ...
        },
    );

    If called on a single TransitionEntityID
    Returns:
    $Checked = 1; # 0

    If called on an array of TransitionEntityIDs
    Returns:
    $Checked = 'T1' # 0 if no Transition was true

=cut

sub TransitionCheck {
    my ( $Self, %Param ) = @_;

    # Check if we have TransitionEntityID and Data
    for my $Needed (qw(TransitionEntityID Data)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!", );
            return;
        }
    }

    # Check if TransitionEntityID is not empty (eighter Array or String with length)
    if ( !length $Param{TransitionEntityID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need TransitionEntityID or TransitionEntityID array!",
        );
        return;
    }

    # If we got just a string, make $Param{TransitionEntityID} an Array
    # with the string on position 0 to facilitate handling
    if ( !IsArrayRefWithData( $Param{TransitionEntityID} ) ) {
        $Param{TransitionEntityID} = [ $Param{TransitionEntityID} ];
    }

    # Check if we have Data to check against transitions conditions
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );
        return;
    }

    # Get all transitions
    my $Transitions = $Self->{ConfigObject}->Get('Process::Transition');

    # Check if there are Transitions
    if ( !IsHashRefWithData($Transitions) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need transition config!',
        );
        return;
    }

    # Loop through all submitted TransitionEntityID's
    TRANSITIONLOOP:
    for my $TransitionEntityID ( @{ $Param{TransitionEntityID} } ) {

        # Check if the submitted TransitionEntityID has a config
        if ( !IsHashRefWithData( $Transitions->{$TransitionEntityID} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No config data for transition $TransitionEntityID found!",
            );
            return;
        }

        # Check if we have TransitionConditions
        if ( !IsHashRefWithData( $Transitions->{$TransitionEntityID}{Condition} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No conditions for transition $TransitionEntityID found!",
            );
            return;
        }

        # If we don't have a Condition->Type
        # set it to 'and' by default
        my $ConditionType = $Transitions->{$TransitionEntityID}{Condition}{Type} || 'and';

        # If there is something else than 'and', 'or', 'xor'
        # log defect Transition Config
        if ( $ConditionType ne 'and' && $ConditionType ne 'or' && $ConditionType ne 'xor' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Invalid Condition->Type in $TransitionEntityID!",
            );
            return;
        }
        my ( $ConditionSuccess, $ConditionFail ) = ( 0, 0 );

        CONDITIONLOOP:
        for my $Cond ( sort { $a cmp $b } keys %{ $Transitions->{$TransitionEntityID}{Condition} } )
        {

            next CONDITIONLOOP if $Cond eq 'Type';

            # get the condition
            my $ActualCondition = $Transitions->{$TransitionEntityID}{Condition}{$Cond};

            # Check if we have Fields in our Cond
            if ( !IsHashRefWithData( $ActualCondition->{Fields} ) )
            {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "No Fields in Transition $TransitionEntityID->Condition->$Cond"
                        . " found!",
                );
                return;
            }

            # If we don't have a Condition->$Cond->Type, set it to 'and' by default
            my $CondType = $ActualCondition->{Type} || 'and';

            # If there is something else than 'and', 'or', 'xor'
            # log defect Transition Config
            if ( $CondType ne 'and' && $CondType ne 'or' && $CondType ne 'xor' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Invalid Condition->$Cond->Type in $TransitionEntityID!",
                );
                return;
            }

            my ( $FieldSuccess, $FieldFail ) = ( 0, 0 );

            FIELDLOOP:
            for my $Field ( sort keys %{ $ActualCondition->{Fields} } ) {

                # If we have just a String transform it into stringcheck condition
                if ( ref $ActualCondition->{Fields}{$Field} eq '' ) {
                    $ActualCondition->{Fields}{$Field} = {
                        Type  => 'String',
                        Match => $ActualCondition->{Fields}{$Field},
                    };
                }

                # If we have an Arrayref in "Fields" we deal with just values
                # -> transform it into a { Type => 'Array', Match => [1,2,3,4] } struct
                # to unify testing later on
                if ( ref $ActualCondition->{Fields}{$Field} eq 'ARRAY' ) {
                    $ActualCondition->{Fields}{$Field} = {
                        Type  => 'Array',
                        Match => $ActualCondition->{Fields}{$Field},
                    };
                }

                # If we don't have a Condition->$Cond->Fields->Field->Type
                # set it to 'String' by default
                my $FieldType = $ActualCondition->{Fields}{$Field}{Type} || 'String';

                # If there is something else than 'String', 'Regexp', 'Hash', 'Array', 'Module'
                # log defect Transition Config
                if (
                    $FieldType ne 'String'
                    && $FieldType ne 'Hash'
                    && $FieldType ne 'Array'
                    && $FieldType ne 'Regexp'
                    && $FieldType ne 'Module'
                    )
                {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "Invalid Condition->Type in $TransitionEntityID!",
                    );
                    return;
                }

                if ( $ActualCondition->{Fields}{$Field}{Type} eq 'String' ) {

                    # if our Check contains anything else than a string we can't check
                    # Special Condition: if Match contains '0' we can check
                    #
                    if (
                        (
                            !$ActualCondition->{Fields}{$Field}{Match}
                            && $ActualCondition->{Fields}{$Field}{Match} ne '0'
                        )
                        || ref $ActualCondition->{Fields}{$Field}{Match}
                        )
                    {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message =>
                                "$TransitionEntityID->Condition->$Cond->Fields->$Field Match must"
                                . " be a String if Type is set to String!",
                        );
                        return;
                    }

                    # make sure the data string is here
                    # and it isn't a ref (array or whatsoever)
                    # then compare it to our Config
                    if (
                        defined $Param{Data}->{$Field}
                        && defined $ActualCondition->{Fields}{$Field}{Match}
                        && ( $Param{Data}->{$Field} || $Param{Data}->{$Field} eq '0' )
                        && ref $Param{Data}->{$Field} eq ''
                        && $ActualCondition->{Fields}{$Field}{Match} eq $Param{Data}->{$Field}
                        )
                    {
                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition
                        # to make this Transition valid
                        return $TransitionEntityID
                            if $ConditionType eq 'or' && $CondType eq 'or';

                        next CONDITIONLOOP if $ConditionType ne 'or' && $CondType eq 'or';
                    }
                    else {
                        $FieldFail++;

                        # Failed check if we have all 'and' conditions
                        next TRANSITIONLOOP if $ConditionType eq 'and' && $CondType eq 'and';

                        # Try next Cond if all Cond Fields have to be true
                        next CONDITIONLOOP if $CondType eq 'and';
                    }
                    next FIELDLOOP;
                }
                elsif ( $ActualCondition->{Fields}{$Field}{Type} eq 'Array' ) {

                    # 1. go through each Condition->$Cond->Fields->$Field->Value (map)
                    # 2. assign the value to $CheckValue
                    # 3. grep through $Data->{$Field}
                    #   to find the "toCheck" value inside the Data->{$Field} Array
                    # 4. Assign all found Values to @CheckResults
                    my $CheckValue;
                    my @CheckResults = map {
                        $CheckValue = $_;
                        grep { $CheckValue eq $_ } @{ $Param{Data}->{$Field} }
                        }
                        @{ $ActualCondition->{Fields}{$Field}{Match} };

                    # if the found amount is the same as the "toCheck" amount we succeeded
                    if (
                        scalar @CheckResults
                        == scalar @{ $ActualCondition->{Fields}{$Field}{Match} }
                        )
                    {
                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition
                        # to make this Transition valid
                        return $TransitionEntityID
                            if $ConditionType eq 'or' && $CondType eq 'or';

                        next CONDITIONLOOP if $ConditionType ne 'or' && $CondType eq 'or';
                    }
                    else {
                        $FieldFail++;

                        # Failed check if we have all 'and' conditions
                        next TRANSITIONLOOP if $ConditionType eq 'and' && $CondType eq 'and';

                        # Try next Cond if all Cond Fields have to be true
                        next CONDITIONLOOP if $CondType eq 'and';
                    }
                    next FIELDLOOP;
                }
                elsif ( $ActualCondition->{Fields}{$Field}{Type} eq 'Hash' ) {

                    # if our Check doesn't contain a hash
                    if ( ref $ActualCondition->{Fields}{$Field}{Match} ne 'HASH' ) {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message =>
                                "$TransitionEntityID->Condition->$Cond->Fields->$Field Match must"
                                . " be a Hash!",
                        );
                        return;
                    }

                    # If we have no data or Data isn't a hash, test failed
                    if (
                        !$Param{Data}->{$Field}
                        || ref $Param{Data}->{$Field} ne 'HASH'
                        )
                    {
                        $FieldFail++;
                        next FIELDLOOP;
                    }

                    # Find all Data Hashvalues that equal to the Condition Match Values
                    my @CheckResults = grep {
                        $Param{Data}->{$Field}{$_} eq $ActualCondition->{Fields}{$Field}{Match}{$_}
                    } keys %{ $ActualCondition->{Fields}{$Field}{Match} };

                    # If the amount of Results equals the amount of Keys in our hash
                    # this part matched
                    if (
                        scalar @CheckResults
                        == scalar keys %{ $ActualCondition->{Fields}{$Field}{Match} }
                        )
                    {

                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition
                        # to make this Transition valid
                        return $TransitionEntityID
                            if $ConditionType eq 'or' && $CondType eq 'or';

                        next CONDITIONLOOP if $ConditionType ne 'or' && $CondType eq 'or';

                    }
                    else {
                        $FieldFail++;

                        # Failed check if we have all 'and' conditions
                        next TRANSITIONLOOP if $ConditionType eq 'and' && $CondType eq 'and';

                        # Try next Cond if all Cond Fields have to be true
                        next CONDITIONLOOP if $CondType eq 'and';
                    }
                    next FIELDLOOP;
                }
                elsif ( $ActualCondition->{Fields}{$Field}{Type} eq 'Regexp' )
                {

                    # if our Check contains anything else then a string we can't check
                    if (
                        !$ActualCondition->{Fields}{$Field}{Match}
                        ||
                        (
                            ref $ActualCondition->{Fields}{$Field}{Match} ne 'Regexp'
                            && ref $ActualCondition->{Fields}{$Field}{Match} ne ''
                        )
                        )
                    {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message =>
                                "$TransitionEntityID->Condition->$Cond->Fields->$Field Match must"
                                . " be a Regular expression if Type is set to Regexp!",
                        );
                        return;
                    }

                    # precompile Regexp if is a string
                    if ( ref $ActualCondition->{Fields}{$Field}{Match} eq '' ) {
                        my $Match = $ActualCondition->{Fields}{$Field}{Match};

                        eval {
                            $ActualCondition->{Fields}{$Field}{Match} = qr{$Match};
                        };
                        if ($@) {
                            $Self->{LogObject}->Log(
                                Priority => 'error',
                                Message  => $@,
                            );
                            return;
                        }
                    }

                    # make sure the data string is here
                    # and it is of ref Regexp
                    # then compare validate it
                    if (
                        $Param{Data}->{$Field}
                        && ref $Param{Data}->{$Field} eq ''
                        && $Param{Data}->{$Field} =~ $ActualCondition->{Fields}{$Field}{Match}
                        )
                    {
                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition
                        # to make this Transition valid
                        return $TransitionEntityID
                            if $ConditionType eq 'or' && $CondType eq 'or';

                        next CONDITIONLOOP if $ConditionType ne 'or' && $CondType eq 'or';
                    }
                    else {
                        $FieldFail++;

                        # Failed check if we have all 'and' conditions
                        next TRANSITIONLOOP if $ConditionType eq 'and' && $CondType eq 'and';

                        # Try next Cond if all Cond Fields have to be true
                        next CONDITIONLOOP if $CondType eq 'and';
                    }
                    next FIELDLOOP;
                }
                elsif ( $ActualCondition->{Fields}{$Field}{Type} eq 'Module' ) {

                    # Load Validation Modules
                    # Default location for validation modules:
                    # Kernel/System/ProcessManagement/TransitionValidation/
                    if (
                        !$Self->{MainObject}->Require( $ActualCondition->{Fields}{$Field}{Match} )
                        )
                    {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Can't load "
                                . $ActualCondition->{Fields}{$Field}{Type}
                                . "Module for Transition->$TransitionEntityID->Condition->$Cond->"
                                . "Fields->$Field validation!",
                        );
                        return;
                    }
                    push @ISA, $ActualCondition->{Fields}{$Field}{Match};

                    # create new ValidateModuleObject
                    my $ValidateModuleObject =
                        $ActualCondition->{Fields}{$Field}{Match}->new(
                        ConfigObject => $Self->{ConfigObject},
                        LogObject    => $Self->{LogObject},
                        );

                    # handle "Data" Param to ValidateModule's "Validate" subroutine
                    if ( $ValidateModuleObject->Validate( Data => $Param{Data} ) ) {
                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition
                        # to make this Transition valid
                        return $TransitionEntityID
                            if $ConditionType eq 'or' && $CondType eq 'or';

                        next CONDITIONLOOP if $ConditionType ne 'or' && $CondType eq 'or';
                    }
                    else {
                        $FieldFail++;

                        # Failed check if we have all 'and' conditions
                        next TRANSITIONLOOP if $ConditionType eq 'and' && $CondType eq 'and';

                        # Try next Cond if all Cond Fields have to be true
                        next CONDITIONLOOP if $CondType eq 'and';
                    }
                    next FIELDLOOP;
                }
            }

            # FIELDLOOP END
            if ( $CondType eq 'and' ) {

                # if we had no failing check this condition matched
                if ( !$FieldFail ) {

                    # Successful check if we just need one matching Condition
                    # to make this Transition valid
                    return $TransitionEntityID if $ConditionType eq 'or';
                    $ConditionSuccess++;
                }
                else {
                    $ConditionFail++;

                    # Failed check if we have all 'and' conditions
                    next TRANSITIONLOOP if $ConditionType eq 'and';
                }
            }
            elsif ( $CondType eq 'or' )
            {

                # if we had at least one successful check, this condition matched
                if ( $FieldSuccess > 0 ) {

                    # Successful check if we just need one matching Condition
                    # to make this Transition valid
                    return $TransitionEntityID if $ConditionType eq 'or';
                    $ConditionSuccess++;
                }
                else {
                    $ConditionFail++;

                    # Failed check if we have all 'and' conditions
                    next TRANSITIONLOOP if $ConditionType eq 'and';
                }
            }
            elsif ( $CondType eq 'xor' )
            {

                # if we had exactly one successful check, this condition matched
                if ( $FieldSuccess == 1 ) {

                    # Successful check if we just need one matching Condition
                    # to make this Transition valid
                    return $TransitionEntityID if $ConditionType eq 'or';
                    $ConditionSuccess++;
                }
                else {
                    $ConditionFail++;
                }
            }
        }

        # CONDITIONLOOP END
        if ( $ConditionType eq 'and' ) {

            # if we had no failing conditions this transition matched
            if ( !$ConditionFail ) {
                return $TransitionEntityID;
            }
        }
        elsif ( $ConditionType eq 'or' )
        {

            # if we had at least one successful condition, this transition matched
            if ( $ConditionSuccess > 0 ) {
                return $TransitionEntityID;
            }
        }
        elsif ( $ConditionType eq 'xor' )
        {

            # if we had exactly one successful condition, this transition matched
            if ( $ConditionSuccess == 1 ) {
                return $TransitionEntityID;
            }
        }
    }

    # TRANSITIONLOOP END
    # If no transition matched till here, we failed
    return;

}
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=head1 VERSION

$Revision: 1.9 $ $Date: 2013-01-11 18:51:08 $

=cut
