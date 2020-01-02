# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::UIDCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # return if it's not root@localhost
    return '' if $Self->{UserID} != 1;

    # get the product name
    my $ProductName = $Kernel::OM->Get('Kernel::Config')->Get('ProductName') || 'OTRS';

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # show error notfy, don't work with user id 1
    return $LayoutObject->Notify(
        Priority => 'Error',
        Link     => $LayoutObject->{Baselink} . 'Action=AdminUser',
        Info     => $LayoutObject->{LanguageObject}->Translate(
            'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.',
            $ProductName
        ),
    );
}

1;
