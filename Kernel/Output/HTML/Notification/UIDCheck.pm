# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::UIDCheck;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout'
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # return if it's not root@localhost
    return '' if $Self->{UserID} != 1;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # show error notfy, don't work with user id 1
    return $LayoutObject->Notify(
        Priority => 'Error',
        Link     => $LayoutObject->{Baselink} . 'Action=AdminUser',
        Info     => Translatable(
            'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.'
        ),
    );
}

1;
