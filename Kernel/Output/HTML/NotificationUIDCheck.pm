# --
# Kernel/Output/HTML/NotificationUIDCheck.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationUIDCheck.pm,v 1.4 2006-08-27 22:27:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationUIDCheck;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;


sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    if ($Self->{UserID} == 1) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Link => '$Env{"Baselink"}Action=AdminUser',
            Data => '$Text{"Don\'t work with UserID 1 (System account)! Create new users!"}',
        );
    }
    return $Output;
}

1;
