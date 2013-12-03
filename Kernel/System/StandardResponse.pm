# --
# Kernel/System/StandardResponse.pm - lib for std responses
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::StandardResponse;

use strict;
use warnings;

use base qw(Kernel::System::StandardTemplate);
use Kernel::System::CacheInternal;
use Kernel::System::Valid;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::StandardResponse - auto response lib

=head1 SYNOPSIS

All std response functions. E. g. to add std response or other functions.

StandardResponse is now DEPRECATED and it will be removed in further versions of otrs
Pleae use StandardTemplate instead

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::StandardResponse;

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
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $StandardResponseObject = Kernel::System::StandardResponse->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject EncodeObject MainObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    # create additional objects
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'StandardTemplate',
        TTL  => 60 * 60 * 24 * 20,
    );
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item StandardResponseAdd()

DEPRECATED. This function will be removed in firther versions of otrs.

add new std response

    my $ID = $StandardResponseObject->StandardResponseAdd(
        Name         => 'New Standard Response',
        Response     => 'Thank you for your email.',
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',                     # or 'Forward' or 'Create'
        ValidID      => 1,
        UserID       => 123,
    );

=cut

sub StandardResponseAdd {
    my ( $Self, %Param ) = @_;

    # compat
    if ( !defined $Param{TemplateType} || !$Param{TemplateType} ) {
        $Param{TemplateType} = 'Answer';
    }
    if ( !defined $Param{Template} || !$Param{Template} ) {
        $Param{Template} = $Param{Response} || '';
    }

    return $Self->StandardTemplateAdd(%Param);
}

=item StandardResponseGet()

DEPRECATED. This function will be removed in firther versions of otrs.

get std response attributes

    my %StandardResponse = $StandardResponseObject->StandardResponseGet(
        ID => 123,
    );

Returns:

    %StandardResponse = (
        ID                  => '123',
        Name                => 'Simple response',
        Comment             => 'Some comment',
        Response            => 'Response content',
        ContentType         => 'text/plain',
        TemplateType        => 'Answer',
        ValidID             => '1',
        CreateTime          => '2010-04-07 15:41:15',
        CreateBy            => '321',
        ChangeTime          => '2010-04-07 15:59:45',
        ChangeBy            => '223',
    );

=cut

sub StandardResponseGet {
    my ( $Self, %Param ) = @_;

    my %Response = $Self->StandardTemplateGet(%Param);

    if ( IsHashRefWithData( \%Response ) ) {
        $Response{Response} = $Response{Template};
        return %Response;
    }

    return;
}

=item StandardResponseDelete()

DEPRECATED. This function will be removed in firther versions of otrs.

delete a standard response

    $StandardResponseObject->StandardResponseDelete(
        ID => 123,
    );

=cut

sub StandardResponseDelete {
    my ( $Self, %Param ) = @_;

    return $Self->StandardTemplateDelete(%Param);
}

=item StandardResponseUpdate()

DEPRECATED. This function will be removed in firther versions of otrs.

update std response attributes

    $StandardResponseObject->StandardResponseUpdate(
        ID           => 123,
        Name         => 'New Standard Response',
        Response     => 'Thank you for your email.',
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',
        ValidID      => 1,
        UserID       => 123,
    );

=cut

sub StandardResponseUpdate {
    my ( $Self, %Param ) = @_;

    # compat
    if ( !defined $Param{TemplateType} || !$Param{TemplateType} ) {
        $Param{TemplateType} = 'Answer';
    }
    if ( !defined $Param{Template} || !$Param{Template} ) {
        $Param{Template} = $Param{Response} || '';
    }

    return $Self->StandardTemplateUpdate(%Param);
}

=item StandardResponseLookup()

DEPRECATED. This function will be removed in firther versions of otrs.

return the name or the std response id

    my $StandardResponseName = $StandardResponseObject->StandardResponseLookup(
        StandardResponseID => 123,
    );

    or

    my $StandardResponseID = $StandardResponseObject->StandardResponseLookup(
        StandardResponse => 'Std Response Name',
    );

=cut

sub StandardResponseLookup {
    my ( $Self, %Param ) = @_;

    # compat
    if (
        ( !defined $Param{StandardTemplateID} || !$Param{StandardTemplateID} )
        && $Param{StandardResponseID}
        )
    {
        $Param{StandardTemplateID} = $Param{StandardResponseID}
    }
    if (
        ( !defined $Param{StandardTemplate} || !$Param{StandardTemplate} )
        && $Param{StandardResponse}
        )
    {
        $Param{StandardTemplate} = $Param{StandardResponse}
    }

    return $Self->StandardTemplateLookup(%Param);
}

=item StandardResponseList()

DEPRECATED. This function will be removed in firther versions of otrs.

get all valid std responses

    my %StandardResponses = $StandardResponseObject->StandardResponseList();

Returns:
    %StandardResponses = (
        1 => 'Some Name',
        2 => 'Some Name2',
        3 => 'Some Name3',
    );

get all std responses

    my %StandardResponses = $StandardResponseObject->StandardResponseList(
        Valid => 0,
    );

Returns:
    %StandardResponses = (
        1 => 'Some Name',
        2 => 'Some Name2',
    );

=cut

sub StandardResponseList {
    my ( $Self, %Param ) = @_;

    return $Self->StandardTemplateList(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
