# --
# Kernel/GenericInterface/Mapping/SolMan.pm - GenericInterface SolMan mapping backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SolMan.pm,v 1.3 2011-05-02 16:44:07 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping::SolMan;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::GenericInterface::Mapping::SolMan - GenericInterface SolMan mapping backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Mapping->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DebuggerObject MainObject MappingConfig)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    # check mapping config
    if ( !IsHashRefWithData( $Param{MappingConfig} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no MappingConfig as hash ref with content!',
        );
    }

    # check config - if we have a map config, it has to be a non-empty hash ref
    if (
        defined $Param{MappingConfig}->{Config}
        && !IsHashRefWithData( $Param{MappingConfig}->{Config} )
        )
    {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got MappingConfig with Data, but Data is no hash ref with content!',
        );
    }

    return $Self;
}

=item Map()

perform data mapping

if no config option is provided, the original data will be returned

    my $Result = $MappingObject->Map(
        Data => {              # data payload before mapping
            ...
        },
    );

    $Result = {
        Success         => 1,  # 0 or 1
        ErrorMessage    => '', # in case of error
        Data            => {   # data payload of after mapping
            ...
        },
    };

=cut

sub Map {
    my ( $Self, %Param ) = @_;

    # check data - only accept undef or hash ref
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return $Self->{DebuggerObject}
            ->Error( Summary => 'Got Data but it is not a hash ref in Mapping SolMan backend!' );
    }

    # return if data is empty
    if ( !defined $Param{Data} || !%{ $Param{Data} } ) {
        return {
            Success => 1,
            Data    => {},
        };
    }

    # no config means that we just return input data
    if ( !defined $Self->{MappingConfig}->{Config} ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # map article types
    if (
        IsHashRefWithData( $Param{Data}->{IctStatements} )
        && $Param{Data}->{IctStatements}->{item}
        )
    {
        $Self->_ArticleTypeMap(
            Articles => $Param{Data}->{IctStatements}->{item},
            Map     => $Self->{MappingConfig}->{Config}->{ArticleTypeMap}        || {},
            Default => $Self->{MappingConfig}->{Config}->{ArticleTypeMapDefault} || 'note-internal',
        );
    }

    # map priority
    if ( IsHashRefWithData( $Param{Data}->{IctHead} ) ) {
        $Param{Data}->{IctHead}->{Priority} = $Self->_PriorityMap(
            Priority => $Param{Data}->{IctHead}->{Priority},
            Map     => $Self->{MappingConfig}->{Config}->{PriorityMap}        || {},
            Default => $Self->{MappingConfig}->{Config}->{PriorityMapDefault} || '3 normal',
        );
    }

    # map state
    if (
        IsHashRefWithData( $Param{Data}->{IctAdditionalInfos} )
        && $Param{Data}->{IctAdditionalInfos}->{item}
        )
    {
        $Param{Data}->{IctAdditionalInfos}->{item} = $Self->_StateMap(
            AdditionalInfos => $Param{Data}->{IctAdditionalInfos}->{item},
            Map     => $Self->{MappingConfig}->{Config}->{StateMap}        || {},
            Default => $Self->{MappingConfig}->{Config}->{StateMapDefault} || 'open',
        );
    }

    # return result
    return {
        Success => 1,
        Data    => $Param{Data},
    };
}

=begin Internal:

=item _ArticleTypeMap()

map type of all passed articles by using a predefined list
if there is no current type for an article or no mapping value exists, the default is used

    my $Articles => $MappingObject->_ArticleTypeMap(
        Articles =>[                 # list of passed articles
            ...
        ],
        Map      => {                # optional, mapping list
            ...
        },
        Default  => 'note-internal', # default value if no mapping is found
    );

    $Articles = [                    # list of passed articles with mapped type
        ...
    ];

=cut

sub _ArticleTypeMap {
    my ( $Self, %Param ) = @_;

    # if only one article is passed
    if ( IsHashRefWithData( $Param{Articles} ) ) {
        $Param{Articles}->{TextType} = $Param{Map}->{ $Param{Articles}->{TextType} }
            || $Param{Default};
        return;
    }

    # loop through articles and map their types
    for my $Article ( @{ $Param{Articles} } ) {
        $Article->{TextType} = $Param{Map}->{ $Article->{TextType} } || $Param{Default};
    }

    # just return
    return;
}

=item _PriorityMap()

map priority value by using a predefined list
if we have no current priority or no mapping value exists, the default is used

    my $MappedPriority => $MappingObject->_PriorityMap(
        Priority => '3',        # optional, prioritity value before mapping
        Map      => {           # optional, mapping list
            ...
        },
        Default  => '3 normal', # default value if no mapping is found
    );

=cut

sub _PriorityMap {
    my ( $Self, %Param ) = @_;

    my $MappedPriority;

    if ( $Param{Priority} ) {
        $MappedPriority = $Param{Map}->{ $Param{Priority} };
    }

    if ( !$MappedPriority ) {
        $MappedPriority = $Param{Default};
    }

    return $MappedPriority;
}

=item _StateMap()

map state value by using a predefined list
if we have no current state or no mapping value exists, the default is used
other additional infos are just passed back

    my $AdditionalInfos => $MappingObject->_StateMap(
        AdditionalInfos =>[ # list of additional infos
            ...
        ],
        Map      => {       # optional, mapping list
            ...
        },
        Default  => 'open', # default value if no mapping is found
    );

    $AdditionalInfos = [    # original additional infos plus mapped state
        ...
    ];

=cut

sub _StateMap {
    my ( $Self, %Param ) = @_;

    my @AdditionalInfos = ();
    my %StatePart;

    # if only attribute is passed and it contains the state, replace directly
    if ( IsHashRefWithData( $Param{AdditionalInfos} ) ) {
        my %StateHash = %{ $Param{AdditionalInfos} };
        if (
            $StateHash{AddInfoAttribute} eq 'SAPUserStatus'
            || $StateHash{AddInfoAttribute} eq 'SAPUserStatusInbound'
            )
        {
            $StateHash{AddInfoValue} =
                $Param{Map}->{ $StateHash{AddInfoValue} } || $Param{Default};
        }
        return \%StateHash;
    }

    # get current state value if existing and remember all other add info fields
    ADDINFO:
    for my $AddInfo ( @{ $Param{AdditionalInfos} } ) {
        if (
            $AddInfo->{AddInfoAttribute} eq 'SAPUserStatus'
            || $AddInfo->{AddInfoAttribute} eq 'SAPUserStatusInbound'
            )
        {
            %StatePart = %{$AddInfo};
            next ADDINFO;
        }
        push @AdditionalInfos, $AddInfo;
    }

    if (%StatePart) {

        # map state
        $StatePart{AddInfoValue} =
            $Param{Map}->{ $StatePart{AddInfoValue} } || $Param{Default};
    }
    else {

        # add state part with default value
        %StatePart = (
            AddInfoAttribute => 'SAPUserStatus',
            AddInfoValue     => $Param{Default},
            Guid             => '',
            ParentGuid       => '',
        );
    }

    # add mapped state to add info
    push @AdditionalInfos, \%StatePart;

    return \@AdditionalInfos;
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

=head1 VERSION

$Revision: 1.3 $ $Date: 2011-05-02 16:44:07 $

=cut
