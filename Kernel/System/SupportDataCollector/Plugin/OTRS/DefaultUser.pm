# --
# Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::DefaultUser;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::System::Auth;
use Kernel::System::User;
use Kernel::System::Group;

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my $UserObject  = Kernel::System::User->new( %{$Self} );
    my $GroupObject = Kernel::System::Group->new( %{$Self} );
    my %UserList    = $UserObject->UserList(
        Type  => 'Short',
        Valid => '1',
    );

    my $DefaultPassword;

    my $SuperUserID;
    USER:
    for my $UserID ( sort keys %UserList ) {
        if ( $UserList{$UserID} eq 'root@localhost' ) {
            $SuperUserID = 1;
            last USER;
        }
    }

    if ($SuperUserID) {
        my $AuthObject = Kernel::System::Auth->new(
            %{$Self},
            UserObject  => $UserObject,
            GroupObject => $GroupObject,
        );

        $DefaultPassword = $AuthObject->Auth(
            User => 'root@localhost',
            Pw   => 'root',
        );
    }

    if ($DefaultPassword) {
        $Self->AddResultProblem(
            Label => 'Default Admin Password',
            Value => '',
            Message =>
                'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'Default Admin Password',
            Value => '',
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
