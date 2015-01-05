# --
# Kernel/Output/HTML/CustomerUserGeneric.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: CustomerUserGeneric.pm,v 1.5 2009-07-01 07:31:38 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::CustomerUserGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check required params
    my @Params = split /;/, $Param{Config}->{Required};
    for my $Key (@Params) {
        return if !$Key;
        return if !$Param{Data}->{$Key};
    }

    # get all attributes
    @Params = split /;/, $Param{Config}->{Attributes};

    # build url
    my $URL = '';
    for my $Key (@Params) {
        next if !$Param{Data}->{$Key};
        if ($URL) {
            $URL .= ', ';
        }
        $URL .= $Self->{LayoutObject}->LinkEncode( $Param{Data}->{$Key} );
    }
    $URL = $Param{Config}->{URL} . $URL;

    # generate block
    $Self->{LayoutObject}->Block(
        Name => 'CustomerItemRow',
        Data => {
            %{ $Param{Config} },
            URL => $URL,
        },
    );

    return 1;
}

1;
