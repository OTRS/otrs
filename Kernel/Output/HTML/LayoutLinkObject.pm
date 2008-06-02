# --
# Kernel/Output/HTML/LayoutLinkObject.pm - provides generic HTML output for LinkObject
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLinkObject.pm,v 1.1 2008-06-02 11:56:29 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LayoutLinkObject;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=item LinkObjectContentStringCreate()

return a output string

    my $String = $LayoutObject->LinkObjectContentStringCreate(
        TargetObject          => 'Ticket',
        TargetItemDescription => $Hashref,
        ColumnData            => $Hashref,
    );

=cut

sub LinkObjectContentStringCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TargetObject TargetItemDescription ColumnData)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # load backend
    my $BackendObject = $Self->_LoadLinkObjectLayoutBackend(
        Object => $Param{TargetObject}->{Object},
    );

    return if !$BackendObject;

    # fill up column params (framework)
    $Self->_OutputParamsFillUp(%Param);

    # fill up column params (backend)
    $BackendObject->OutputParamsFillUp(%Param);

    # output block
    $Self->{LayoutObject}->Block(
        Name => $Param{ColumnData}->{Output}->{TemplateBlock},
        Data => {
            %{ $Param{ColumnData}->{Output} },
            Content => $Param{ColumnData}->{Output}->{Content} || '',
        },
    );

    # create output content
    my $OutputContent = $Self->{LayoutObject}->Output(
        TemplateFile => $Param{ColumnData}->{Output}->{TemplateFile},
    );

    return $OutputContent;
}

=item _OutputParamsFillUp()

fill up output params

    $LayoutObject->_OutputParamsFillUp(
        ColumnData => $Hashref,
    );

=cut

sub _OutputParamsFillUp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TargetObject TargetItemDescription ColumnData)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set default type
    $Param{ColumnData}->{Type} ||= 'Text';

    my $OutputParams = {};
    $Param{ColumnData}->{Output} = $OutputParams;

    # set default options
    $OutputParams->{Content}       = $Param{Content};
    $OutputParams->{TemplateFile}  = 'LinkObject';
    $OutputParams->{TemplateBlock} = 'Text';
    $OutputParams->{MaxLength}     = 20;

    # edit text params
    if ( $Param{ColumnData}->{Type} eq 'Text' ) {

        return 1;
    }

    # edit link params
    if ( $Param{ColumnData}->{Type} eq 'Link' ) {

        $OutputParams->{TemplateBlock} = 'Link';
        $OutputParams->{Link}          = '$Env{"Baselink"}';

        return 1;
    }

    # edit checkbox params
    if ( $Param{ColumnData}->{Type} eq 'Checkbox' ) {

        $OutputParams->{TemplateBlock} = 'Checkbox';

        return 1;
    }

    # edit age params
    if ( $Param{ColumnData}->{Type} eq 'Age' ) {

        $OutputParams->{TemplateBlock} = 'Text';

        return if !$OutputParams->{Content};

        # prepare the age string
        $OutputParams->{Content} = $Self->{LayoutObject}->CustomerAge(
            Age   => $OutputParams->{Content},
            Space => ' ',
        );

        return 1;
    }

    # edit age params
    if ( $Param{ColumnData}->{Type} eq 'LinkType' ) {

        # check needed stuff
        for my $Argument (qw(TypeList SourceObject)) {
            if ( !$Param{$Argument} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Need $Argument!",
                );
                return;
            }
        }

        # check needed stuff
        if ( !$Param{TypeList} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need TypeList!',
            );
            return;
        }

        $OutputParams->{TemplateBlock} = 'Plain';
        $OutputParams->{Content}       = '-';

        return 1 if !$Param{TargetItemDescription}->{LinkData};

        # extract the link data and object id
        my $LinkData = $Param{TargetItemDescription}->{LinkData};
        my $Object = $Param{TargetObject}->{Object} || '';

        return 1 if ref $LinkData            ne 'HASH';
        return 1 if !%{$LinkData};
        return 1 if !$LinkData->{$Object};
        return 1 if ref $LinkData->{$Object} ne 'HASH';
        return 1 if !%{ $LinkData->{$Object} };

        # create the type list
        my %AlreadyLinkedTypeList;
        LINKTYPEID:
        for my $Type ( keys %{ $LinkData->{$Object} } ) {

            DIRECTION:
            for my $Direction (qw(Source Target)) {

                # extract data
                my $Data = $LinkData->{$Object}->{$Type}->{$Direction} || [];

                # investigate matched keys
                my $MatchedKeys = scalar grep { $_ == $Param{SourceObject}->{Key} } @{$Data};

                next DIRECTION if !$MatchedKeys;

                my $Name = $Direction eq 'Source' ? 'TargetName' : 'SourceName';

                $AlreadyLinkedTypeList{ $Param{TypeList}->{$Type}->{$Name} } = 1;
            }
        }

        # sort link name list
        my @LinkNameList;
        for my $LinkName ( sort { lc $a cmp lc $b } keys %AlreadyLinkedTypeList ) {

            # translate
            my $LinkNameTranslated = $Self->{LayoutObject}->{LanguageObject}->Get($LinkName);

            push @LinkNameList, $LinkNameTranslated;
        }

        return 1 if !@LinkNameList;

        # create the content string
        $OutputParams->{Content} = join '<br>', @LinkNameList;

        return 1;
    }

    return 1;
}

=item _LoadLinkObjectLayoutBackend()

load a linkobject layout backend module

    $BackendObject = $LayoutObject->_LoadLinkObjectLayoutBackend(
        Object => 'Ticket',
    );

=cut

sub _LoadLinkObjectLayoutBackend {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Object} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Object!',
        );
        return;
    }

    # check if object is already cached
    return $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} }
        if $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} };

    my $GenericModule = "Kernel::Output::HTML::LinkObject$Param{Object}";

    # load the backend module
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load backend module $Param{Object}!"
        );
        return;
    }

    # create new instance
    my $BackendObject = $GenericModule->new(
        %{$Self},
        %Param,
        LayoutObject => $Self,
    );

    if ( !$BackendObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't create a new instance of backend module $Param{Object}!",
        );
        return;
    }

    # cache the object
    $Self->{Cache}->{LoadLinkObjectLayoutBackend}->{ $Param{Object} } = $BackendObject;

    return $BackendObject;
}

1;
