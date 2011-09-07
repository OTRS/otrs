# --
# Kernel/System/DynamicField/BackendCommon.pm - Dynamic field backend functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: BackendCommon.pm,v 1.1 2011-09-07 17:51:41 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::BackendCommon;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::DynamicField::BackendCommon - common fields backend functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DynamicField::BackendCommon;

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
    );
    my $BackendCommonObject = Kernel::System::DynamicField::BackendCommon->new(
        LogObject          => $LogObject,
        MainObject         => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(
        MainObject LogObject
        )
        )
    {

        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

}

=item EditLabelRender()

creates the label HTML to be used in edit masks.

    my $LabelHTML = $BackendObject->EditLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        FieldName          => 'TheField',               # the value to be set on the 'for' attribute
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub EditLabelRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig FieldName)) {
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
    for my $Needed (qw(Label)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    my $HTMLString = '';
    if ( $Param{Mandatory} ) {

        # for DynamicFreeFields
        $HTMLString =
            '<label id="Label_' . $Param{DynamicFieldConfig}->{Name} . '" '
            . 'for="' . $Param{FieldName} . '" class="Mandatory">'
            . '<span class="Marker">*</span> '
            . $Param{DynamicFieldConfig}->{Label}
            . ':</label>';
    }
    else {

        # for DynamicFreeFields
        $HTMLString =
            '<label id="Label_' . $Param{DynamicFieldConfig}->{Name} . '">'
            . $Param{DynamicFieldConfig}->{Label}
            . ':</label>';
    }

    return $HTMLString;
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

$Revision: 1.1 $ $Date: 2011-09-07 17:51:41 $

=cut
