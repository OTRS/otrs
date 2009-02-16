# --
# Kernel/Output/HTML/CustomerUserGeneric.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CustomerUserGeneric.pm,v 1.3 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::CustomerUserGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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
        $URL .= $Self->{LayoutObject}->LinkQuote(
            Text => $Param{Data}->{$Key},
        );
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
