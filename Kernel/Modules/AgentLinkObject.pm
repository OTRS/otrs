# --
# Kernel/Modules/AgentLinkObject.pm - to link objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentLinkObject.pm,v 1.25 2008-06-13 07:44:28 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentLinkObject;

use strict;
use warnings;

use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.25 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{LinkObject} = Kernel::System::LinkObject->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %Source;
    $Source{Object} = $Self->{ParamObject}->GetParam( Param => 'SourceObject' );
    $Source{Key}    = $Self->{ParamObject}->GetParam( Param => 'SourceKey' );

    # check needed stuff
    if ( !$Source{Object} || !$Source{Key} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need SourceObject and SourceKey!",
            Comment => 'Please contact the admin.',
        );
    }

    # get source item description
    my %SourceItemDescription = $Self->{LinkObject}->ItemDescriptionGet(
        %Source,
        UserID => $Self->{UserID},
    );

    # check item description
    if ( !%SourceItemDescription ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Object '$Source{Object}' with Key '$Source{Key}' not found!",
            Comment => 'Please contact the admin.',
        );
    }

    # get type list
    my %TypeList = $Self->{LinkObject}->TypeList(
        UserID => $Self->{UserID},
    );

    # ------------------------------------------------------------ #
    # link delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'LinkDelete' ) {

        if ( $Self->{ParamObject}->GetParam( Param => 'SubmitDelete' ) ) {

            # get the link delete keys and target object
            my @LinkDeleteIdentifier = $Self->{ParamObject}->GetArray(
                Param => 'LinkDeleteIdentifier',
            );
            my $TargetObject = $Self->{ParamObject}->GetParam( Param => 'TargetObject' );

            # delete links from database
            IDENTIFIER:
            for my $Identifier (@LinkDeleteIdentifier) {

                my ( $TargetKey, $Type ) = $Identifier =~ m{ \A (.+?) :: (.+) \z }xms;

                next IDENTIFIER if !$TargetKey;
                next IDENTIFIER if !$Type;

                # delete link from database
                $Self->{LinkObject}->LinkDelete(
                    Object1 => $Source{Object},
                    Key1    => $Source{Key},
                    Object2 => $TargetObject,
                    Key2    => $TargetKey,
                    Type    => $Type,
                    UserID  => $Self->{UserID},
                );
            }
        }

        # output link block
        $Self->{LayoutObject}->Block(
            Name => 'Delete',
            Data => {
                SourceObject                => $Source{Object},
                SourceKey                   => $Source{Key},
                SourceItemDescriptionNormal => $SourceItemDescription{Description}->{Normal},
            },
        );

        # get all links of this object
        my $ExistingLinks = $Self->{LinkObject}->LinksGet(
            Object => $Source{Object},
            Key    => $Source{Key},
            State  => 'Valid',
            UserID => $Self->{UserID},
        );

        # investigate the object key list
        my %ObjectKeyList;
        for my $Object ( keys %{$ExistingLinks} ) {

            my %ObjectKeys;
            for my $Type ( keys %{ $ExistingLinks->{$Object} } ) {

                for my $Direction ( keys %{ $ExistingLinks->{$Object}->{$Type} } ) {

                    for my $ItemKey ( @{ $ExistingLinks->{$Object}->{$Type}->{$Direction} } ) {
                        $ObjectKeys{$ItemKey} = 1;
                    }
                }
            }

            for my $ItemKey ( keys %ObjectKeys ) {

                # get item description
                my %ItemDescription = $Self->{LinkObject}->ItemDescriptionGet(
                    Object => $Object,
                    Key    => $ItemKey,
                    UserID => $Self->{UserID},
                );

                my ($Subobject) = $ItemDescription{Identifier} =~ m{ \A .+? :: (.+) \z }xms;
                $Subobject ||= '';

                $ObjectKeyList{$Object}->{$Subobject}->{$ItemKey} = \%ItemDescription;
            }
        }

        # create the object realname list
        my %ObjectRealnameList;
        for my $Object ( keys %ObjectKeyList ) {

            # get the object description
            my %ObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
                Object => $Object,
                UserID => 1,
            );

            $ObjectRealnameList{$Object} = $ObjectDescription{Realname} || '';
        }

        for my $Object (
            sort { lc $ObjectRealnameList{a} cmp lc $ObjectRealnameList{b} }
            keys %ObjectRealnameList
            )
        {

            # get object description
            my %ObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
                Object => $Object,
                UserID => $Self->{UserID},
            );

            # prepare overview columns
            my @OverviewColumns = (
                {
                    Key   => 'LinkDeleteIdentifier',
                    Value => '',
                    Type  => 'Checkbox',
                },
            );
            my $OverviewColumns2 = $ObjectDescription{Overview}->{Complex} || [];
            push @OverviewColumns, @{$OverviewColumns2};

            for my $Subobject ( keys %{ $ObjectKeyList{$Object} } ) {

                # output result row block
                $Self->{LayoutObject}->Block(
                    Name => 'DeleteObject',
                    Data => {
                        SourceObject         => $Source{Object},
                        SourceKey            => $Source{Key},
                        TargetObject         => $Object,
                        TargetObjectRealname => $ObjectRealnameList{$Object},
                        TargetSubobject      => $Subobject,
                        LinkColspan          => scalar @OverviewColumns,
                    },
                );

                # output result columns
                for my $Column (@OverviewColumns) {

                    # output result column block
                    $Self->{LayoutObject}->Block(
                        Name => 'DeleteObjectLinkColumn',
                        Data => {
                            ColumnDescription => $Column->{Value},
                        },
                    );
                }

                # output the search result
                my $CssClass = '';
                for my $ItemKey (
                    sort { $a <=> $b }
                    keys %{ $ObjectKeyList{$Object}->{$Subobject} }
                    )
                {

                    # set css
                    $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

                    # output result row block
                    $Self->{LayoutObject}->Block(
                        Name => 'DeleteObjectLinkRow',
                    );

                    # output the columns
                    for my $ColumnData (@OverviewColumns) {

                        # extract cell value
                        my $Content = $ObjectKeyList{$Object}->{$Subobject}->{$ItemKey}->{ItemData}
                            ->{ $ColumnData->{Key} } || '';

                        # prepare cell data
                        my $CellString = $Self->{LayoutObject}->LinkObjectContentStringCreate(
                            SourceObject          => \%Source,
                            SourceItemDescription => \%SourceItemDescription,
                            TargetObject          => \%ObjectDescription,
                            TargetItemDescription =>
                                $ObjectKeyList{$Object}->{$Subobject}->{$ItemKey},
                            TypeList   => \%TypeList,
                            ColumnData => $ColumnData,
                            Content    => $Content,
                        );

                        # use original content as fallback
                        if ( !defined $CellString ) {
                            $CellString = $Content;
                        }

                        # output result row column block
                        $Self->{LayoutObject}->Block(
                            Name => 'DeleteObjectLinkRowColumn',
                            Data => {
                                CellData => $CellString,
                                CssClass => $CssClass,
                            },
                        );
                    }
                }
            }
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentLinkObject',
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get params
        my %Target;
        $Target{Identifier} = $Self->{ParamObject}->GetParam( Param => 'TargetIdentifier' );

        # set default identifier
        $Target{Identifier} ||= $SourceItemDescription{Identifier};

        # investigate the target object
        if ( $Target{Identifier} =~ m{ \A ( .+? ) :: ( .+ ) \z }xms ) {
            $Target{Object}    = $1;
            $Target{SubObject} = $2;
        }
        else {
            $Target{Object} = $Target{Identifier};
        }

        # add target object description
        my %TargetObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
            %Target,
            UserID => $Self->{UserID},
        );
        %Target = ( %Target, %TargetObjectDescription );

        # add new links
        if ( $Target{Object} && $Self->{ParamObject}->GetParam( Param => 'SubmitLink' ) ) {

            # get the link target keys
            my @LinkTargetKeys = $Self->{ParamObject}->GetArray( Param => 'LinkTargetKeys' );

            if (@LinkTargetKeys) {

                # get the type
                my $TypeIdentifier = $Self->{ParamObject}->GetParam( Param => 'TypeIdentifier' );

                # split the identifier
                my ( $Type, $Direction ) = $TypeIdentifier =~ m{ \A (.+?) :: (.+) \z }xms;

                if ( $Type && ( $Direction eq 'Source' || $Direction eq 'Target' ) ) {

                    # add links
                    for my $TargetKeyOrg (@LinkTargetKeys) {

                        my $SourceObject = $Target{Object};
                        my $SourceKey    = $TargetKeyOrg;
                        my $TargetObject = $Source{Object};
                        my $TargetKey    = $Source{Key};

                        if ( $Direction eq 'Target' ) {
                            $SourceObject = $Source{Object};
                            $SourceKey    = $Source{Key};
                            $TargetObject = $Target{Object};
                            $TargetKey    = $TargetKeyOrg;
                        }

                        # add links to database
                        $Self->{LinkObject}->LinkAdd(
                            SourceObject => $SourceObject,
                            SourceKey    => $SourceKey,
                            TargetObject => $TargetObject,
                            TargetKey    => $TargetKey,
                            Type         => $Type,
                            State        => 'Valid',
                            UserID       => $Self->{UserID},
                        );
                    }
                }
            }
        }

        # get possible object select list
        my @PossibleObjectsSelectList = $Self->{LinkObject}->PossibleObjectsSelectList(
            %Source,
            UserID => $Self->{UserID},
        );

        # select the object
        ROW:
        for my $Row (@PossibleObjectsSelectList) {

            next ROW if $Row->{Key} ne $Target{Identifier};
            $Row->{Selected} = 1;
            last ROW;
        }

        # create target object string
        my $TargetObjectStrg = $Self->{LayoutObject}->BuildSelection(
            Data     => \@PossibleObjectsSelectList,
            Name     => 'TargetIdentifier',
            TreeView => 1,
            OnChange => 'document.compose.submit(); return false;',
        );

        # output link block
        $Self->{LayoutObject}->Block(
            Name => 'Link',
            Data => {
                SourceObject                => $Source{Object},
                SourceKey                   => $Source{Key},
                SourceItemDescriptionNormal => $SourceItemDescription{Description}->{Normal},
                SourceItemDescriptionLong   => $SourceItemDescription{Description}->{Long},
                TargetObject                => $Target{Object},
                TargetRealname              => $Target{Realname},
                TargetIdentifier            => $Target{Identifier},
                TargetObjectStrg            => $TargetObjectStrg,
            },
        );

        # get target options
        my @SearchOptions = $Self->{LinkObject}->ObjectSearchOptionsGet(%Target);

        my %SearchParams;
        if (@SearchOptions) {

            for my $Row (@SearchOptions) {

                # get the search params
                $SearchParams{ $Row->{Key} } = $Self->{ParamObject}->GetParam(
                    Param => $Row->{Key},
                );

                # output search option block
                $Self->{LayoutObject}->Block(
                    Name => 'LinkSearchRow',
                    Data => {
                        %{$Row},
                        SearchParam => $SearchParams{ $Row->{Key} },
                    },
                );
            }
        }

        # prepare overview columns
        my @OverviewColumns = (
            {
                Key   => 'LinkTargetKeys',
                Value => '',
                Type  => 'Checkbox',
            },
        );
        my $OverviewColumns2 = $Target{Overview}->{Complex} || [];
        push @OverviewColumns, @{$OverviewColumns2};

        # get possible types list
        my @PossibleTypesList = $Self->{LinkObject}->PossibleTypesList(
            Object1 => $Source{Object},
            Object2 => $Target{Object},
            UserID  => $Self->{UserID},
        );

        # create the selectable type list
        my @SelectableTypesList;
        POSSIBLETYPE:
        for my $PossibleType (@PossibleTypesList) {

            # lookup type id
            my $TypeID = $Self->{LinkObject}->TypeLookup(
                Name   => $PossibleType,
                UserID => $Self->{UserID},
            );

            # get type
            my %Type = $Self->{LinkObject}->TypeGet(
                TypeID => $TypeID,
                UserID => $Self->{UserID},
            );

            # create the source name
            my %SourceName;
            $SourceName{Key}   = $PossibleType . '::Source';
            $SourceName{Value} = $Type{SourceName};

            push @SelectableTypesList, \%SourceName;

            next POSSIBLETYPE if !$Type{Pointed};

            # create the source name
            my %TargetName;
            $TargetName{Key}   = $PossibleType . '::Target';
            $TargetName{Value} = $Type{TargetName};

            push @SelectableTypesList, \%TargetName;
        }
        continue {
            my %BlankLine;
            $BlankLine{Key}   = '-';
            $BlankLine{Value} = '';

            push @SelectableTypesList, \%BlankLine;
        }

        # removed last (empty) entry
        pop @SelectableTypesList;

        # create link type string
        my $LinkTypeStrg = $Self->{LayoutObject}->BuildSelection(
            Data => \@SelectableTypesList,
            Name => 'TypeIdentifier',
        );

        # output result row block
        $Self->{LayoutObject}->Block(
            Name => 'LinkResult',
            Data => {
                LinkColspan  => scalar @OverviewColumns,
                LinkTypeStrg => $LinkTypeStrg,
            },
        );

        # output result columns
        for my $Column (@OverviewColumns) {

            # output result column block
            $Self->{LayoutObject}->Block(
                Name => 'LinkResultColumn',
                Data => {
                    ColumnDescription => $Column->{Value},
                },
            );
        }

        # add needed search params
        $SearchParams{Limit}  = 100;
        $SearchParams{UserID} = $Self->{UserID};

        # search the target items
        my @ResultList = $Self->{LinkObject}->ItemSearch(
            %Target,
            SearchParams => \%SearchParams,
        );

        # remove the own key from result list
        if ( $Source{Object} eq $Target{Object} ) {
            @ResultList = grep { $_ != $Source{Key} } @ResultList;
        }

        # output the search result
        my $CssClass = '';
        for my $ItemKey (@ResultList) {

            # set css
            $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

            # output result row block
            $Self->{LayoutObject}->Block(
                Name => 'LinkResultRow',
            );

            # get the item description
            my %TargetItemDescription = $Self->{LinkObject}->ItemDescriptionGet(
                Object => $Target{Object},
                Key    => $ItemKey,
                UserID => $Self->{UserID},
            );

            # output the columns
            for my $ColumnData (@OverviewColumns) {

                # extract cell value
                my $Content = $TargetItemDescription{ItemData}->{ $ColumnData->{Key} } || '';

                # prepare cell data
                my $CellString = $Self->{LayoutObject}->LinkObjectContentStringCreate(
                    SourceObject          => \%Source,
                    SourceItemDescription => \%SourceItemDescription,
                    TargetObject          => \%Target,
                    TargetItemDescription => \%TargetItemDescription,
                    TypeList              => \%TypeList,
                    ColumnData            => $ColumnData,
                    Content               => $Content,
                );

                # use original content as fallback
                if ( !defined $CellString ) {
                    $CellString = $Content;
                }

                # output result row column block
                $Self->{LayoutObject}->Block(
                    Name => 'LinkResultRowColumn',
                    Data => {
                        CellData => $CellString,
                        CssClass => $CssClass,
                    },
                );
            }
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentLinkObject',
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
