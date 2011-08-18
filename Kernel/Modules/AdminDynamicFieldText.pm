# --
# Kernel/Modules/AdminDynamicFieldText.pm - provides a dynamic fields text config view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminDynamicFieldText.pm,v 1.1 2011-08-18 03:41:36 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFieldText;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CheckItem;
use Kernel::System::DynamicField;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create addtional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # header
    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );

    my %ValidList = $Self->{ValidObject}->ValidList();

    # create the Validty select
    my $ValidityStrg = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => 1,

        #        SelectedID   => $DynamicFieldData->{ValidID} || 1,
        PossibleNone => 0,
        Translate    => 1,
    );

    # create the Validty select
    my $TranslatableDescriptionStrg = $Self->{LayoutObject}->BuildSelection(
        Data => [ 'Yes', 'No' ],
        Name => 'ValidID',
        SelectedValue => 'Yes',

        #        SelecteValue   => $DynamicFieldData->{TranslatableDescription} || Yes,
        PossibleNone => 0,
        Translate    => 1,
    );

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminDynamicFieldText',
        Data         => {
            %Param,
            ValidityStrg                => $ValidityStrg,
            TranslatableDescriptionStrg => $TranslatableDescriptionStrg,
            }
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
