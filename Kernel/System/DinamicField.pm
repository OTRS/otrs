# --
# Kernel/System/DinamicField.pm - DinamicFields configuration backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DinamicField.pm,v 1.18 2011/08/09 07:13:27 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DinamicField;

use strict;
use warnings;

use YAML;
use Kernel::System::CacheInternal;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

=head1 NAME

Kernel::System::DinamicField

=head1 SYNOPSIS

DinamicFields backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a DinamicField object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::CacheInternal;
    use Kernel::System::DB;
    use Kernel::System::DinamicField;

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
    my $DinamicFieldObject = Kernel::System::DinamicField->new(
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

    # create additional objects
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %Param,
        Type => 'DinamicField',
        TTL  => 60 * 60,
    );

    return $Self;
}

=item DinamicFieldAdd()

add new Dinamic Field config

returns id of new dinamic field if successful or undef otherwise

    my $ID = $DinamicFieldObject->DinamicFieldAdd(
        Name                => 'NameForField',  # mandatory
        Type                => 'Text',          # mandatory, selects the DF backend to use for this field
                                                # 'text' 'date' 'int', 'text' as default
        Config              => $ConfigHashRef,  # it is stored on YAML format
        BelongsArticle      => '1',             # optional, 1 as default, set to 1 it belongs
                                                # to individual articles, otherwise to tickets
        ValidID         => 1,
        UserID          => 123,
    );

=cut

sub DinamicFieldAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Name Type Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    return 1;
}

=item DinamicFieldGet()

get Dinamic Field attributes

    my $DinamicField = $DinamicFieldObject->DinamicFieldGet(
        ID       => 123,             # ID or Name must be provided
        Name    => 'DinamicField',
    );

    $DinamicField = {
        ID              => 123,
        Name            => 'NameForField',
        Type            => 'Text',
        Config          => $ConfigHashRef,
        BelongsArticle  => '1',
        ValidID         => 12,
        UserID          => 123,
        CreateTime      => '2011-02-08 15:08:00',
        ChangeTime      => '2011-02-08 15:08:00',
    };

=cut

sub DinamicFieldGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or Name!' );
        return;
    }

    return 1;
}

=item DinamicFieldUpdate()

update Dinamic Field content into database

returns 1 on success or undef on error

    my $Success = $DinamicFieldObject->DinamicFieldUpdate(
        ID              => 1234,                # mandatory
        Name            => 'DiferentName',      # mandatory
        Type            => 'Text',              # mandatory, selects the DF backend to use for this field
                                                # 'text' 'date' 'int', 'text' as default
        Config          => $NewConfigHashRef,   # it is stored on YAML format
        BelongsArticle  => '1',                 # optional, 1 as default, set to 1 it belongs
                                                # to individual articles, otherwise to tickets
        ValidID         => 1,
        UserID          => 123,
    );

=cut

sub DinamicFieldUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID Name Type Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    return 1;
}

=item DinamicFieldDelete()

delete a dinamic field entry

returns 1 if successful or undef otherwise

    my $Success = $DinamicFieldObject->DinamicFieldDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub DinamicFieldDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    return 1;
}

=begin Internal:

=end Internal:

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.18 $ $Date: 2011/08/09 07:13:27 $

=cut
