# --
# Kernel/Output/HTML/NotificationUIDCheck.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NotificationUIDCheck.pm,v 1.8 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationUIDCheck;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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

    if ( $Self->{UserID} == 1 ) {
        return $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Link     => '$Env{"Baselink"}Action=AdminUser',
            Data     => '$Text{"Don\'t work with UserID 1 (System account)! Create new users!"}',
        );
    }
    return '';
}

1;
