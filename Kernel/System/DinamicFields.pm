# --
# Kernel/System/DinamicFields.pm - DinamicFields interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DinamicFields.pm,v 1.1 2011-08-16 04:33:17 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DinamicFields;

use strict;
use warnings;

use Kernel::System::CacheInternal;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::DinamicFields - DinamicFields interface

=head1 SYNOPSIS

All DinamicFields functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a debug DinamicFields object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::CacheInternal;
    use Kernel::System::DB;
    use Kernel::System::DinamicFields;

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
    my $DinamicFieldsObject = Kernel::System::DinamicFields->new(
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
        Type => 'DinamicFields',
        TTL  => 60 * 60,
    );

    return $Self;
}

=item DinamicFieldAdd()

add Dinamic Field content to database

returns 1 on success or undef on error

    my $Success = $DinamicFieldsObject->DinamicFieldAdd(
        TicketID       => '12',        # mandatory
        ArticleID      => '14',        # mandatory
        FieldID        => '17',        # mandatory
        ValueType      => 'text',      # optional, 'text' 'date' 'int', 'text' as default
        ValueContent   => 'a string',  # the real value to store
    );

=cut

sub DinamicFieldAdd {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(TicketID ArticleID FieldID))
    {
        next NEEDED if !IsPositiveInteger( $Param{$Needed} );

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Needed is not a positive integer!",
        );
        return;
    }

    return 1;
}

=item DinamicFieldGet()

get communication chain data

    my $DinamicFieldData = $DinamicFieldsObject->DinamicFieldGet(
        TicketID       => '12',        # mandatory
        ArticleID      => '14',        # mandatory
        FieldID        => '17',        # mandatory
#        ValueType      => 'text',      # optional, 'text' 'date' 'int', 'text' as default
    );

    $DinamicFieldData = {
        TicketID       => '12',
        ArticleID      => '14',
        FieldID        => '17',
        ValueType      => 'text',
        ValueContent   => 'the retrive content for the field',
    };

=cut

sub DinamicFieldGet {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(TicketID ArticleID FieldID))
    {
        next NEEDED if !IsPositiveInteger( $Param{$Needed} );

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Needed is not a positive integer!",
        );
        return;
    }

    return 1;
}

=item DinamicFieldDelete()

delete a dinamic field entry

returns 1 if successful or undef otherwise

    my $Success = $DinamicFieldsObject->DinamicFieldDelete(
        TicketID       => '12',        # mandatory
        ArticleID      => '14',        # mandatory
        FieldID        => '17',        # mandatory
    );

=cut

sub DinamicFieldDelete {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(TicketID ArticleID FieldID))
    {
        next NEEDED if !IsPositiveInteger( $Param{$Needed} );

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Needed is not a positive integer!",
        );
        return;
    }

    return 1;
}

=item DinamicFieldsUpdate()

update Dinamic Field content into database

returns 1 on success or undef on error

    my $Success = $DinamicFieldsObject->DinamicFieldsUpdate(
        TicketID       => '12',        # mandatory
        ArticleID      => '14',        # mandatory
        FieldID        => '17',        # mandatory
        ValueType      => 'text',      # optional, 'text' 'date' 'int', 'text' as default
        ValueContent   => 'a string',  # the real value to store
    );

=cut

sub DinamicFieldsUpdate {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(TicketID ArticleID FieldID))
    {
        next NEEDED if !IsPositiveInteger( $Param{$Needed} );

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Needed is not a positive integer!",
        );
        return;
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

$Revision: 1.1 $ $Date: 2011-08-16 04:33:17 $

=cut
