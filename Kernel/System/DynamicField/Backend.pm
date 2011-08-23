# --
# Kernel/System/DynamicField/Backend.pm - Interface for DynamicField backends
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Backend.pm,v 1.3 2011-08-23 11:21:15 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend;

use strict;
use warnings;

#use Kernel::System::CacheInternal;
#use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend

=head1 SYNOPSIS

DynamicFields backend interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a DynamicField backend object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::CacheInternal;
    use Kernel::System::DB;
    use Kernel::System::DynamicField::Backend;

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
    my $CacheInternalObject = Kernel::System::CacheInternal->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DynamicFieldObject = Kernel::System::DynamicField::Backend->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        CacheInternalObject => $CacheInternalObject,
        DBObject            => $DBObject,
    );

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

    return $Self;
}

=item EditLabelRender()

creates the label HTML to be used in edit masks.

    my $LabelHTML = $BackendObject->EditLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub EditLabelRender { }

=item EditFieldRender()

creates the field HTML to be used in edit masks.

    my $FieldHTML = $BackendObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        PossibleValuesFilter => ['value1', 'value2'],     # Optional. Some backends may support this.
                                                          #     This may be needed to realize ACL support for ticket masks,
                                                          #     where the possible values can be limited with and ACL.
        Mandatory          => 1,                          # 0 or 1,
    );

=cut

sub EditFieldRender { }

=item DisplayLabelRender()

creates the label HTML to be used in display masks.

    my $LabelHTML = $BackendObject->DisplayLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub DisplayLabelRender { }

=item DisplayFieldRender()

creates the field HTML to be used in display masks.

    my $FieldHTML = $BackendObject->DisplayFieldRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub DisplayFieldRender { }

=item HandleEditRequest()

when a form with dynamic fields was submitted, this function will handle the request by
extracting the request parameter(s) for the current dynamic field and storing the value in the database.

    my $Success = $BackendObject->HandleEditRequest(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
        ParamObject        => $ParamObject,             # the current request data
    );

=cut

sub HandleEditRequest { }

=item ValueSet()

sets a dynamic field value.

    my $Success = $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
        Value              => 'some text',              # Value to store, depends on backend type
    );

=cut

sub ValueSet {

=cut
    Notes
        This must be implemented by the different backends, but they may share some code.

        Special case:
        If the object type is 'Ticket' or 'Article', a history entry must be written to that ticket (task for later)
=cut

}

=item ValueGet()

get a dynamic field value.

    my $Value = $BackendObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
    );

=cut

sub ValueGet {

=cut
    Notes
        This must be implemented by the different backends, but they may share some code.
=cut

}

=item IsSearchable()

returns if the current field backend is searchable or not.

    my $Searchable = $BackendObject->IsSearchable();   # 1 or 0

=cut

sub IsSearchable { }

=item FieldRequestedInSearch()

determines if the current search request

    my $SQL = $BackendObject->FieldRequestedInSearch(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        SearchParams       => $SearchParams,            # current search parameters
    );

=cut

# TODO: search SQL may need operator for free time fields (older/newer), depends on HTML structure
sub FieldRequestedInSearch { }

=item SearchSQLGet()

returns the SQL WHERE part that needs to be used to search in a particular
dynamic field. The table must already be joined.

    my $SQL = $BackendObject->SearchSQLGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        SearchParams       => $SearchParams,            # current search parameters
        TableAlias         => $TableAlias,              # the alias of the already joined dynamic_field_value table to use
    );

=cut

sub SearchSQLGet { }

=item SearchLabelRender()

creates the label HTML to be used in edit masks.

    my $FieldHTML = $BackendObject->SearchLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        SearchTemplate     => $TemplateDate,            # optional, search template data to load
    );

=cut

sub SearchLabelRender { }

=item SearchFieldRender()

creates the field HTML to be used in search masks.

    my $FieldHTML = $BackendObject->SearchFieldRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        SearchTemplate     => $TemplateDate,            # optional, search template data to load
    );

=cut

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.3 $ $Date: 2011-08-23 11:21:15 $

=cut
