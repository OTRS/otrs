# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::EnvironmentVariables;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Webserver/Environment Variables';
}

sub Run {
    my $Self = shift;

    my %Environment = %ENV;

    for my $NotNeededString (
        qw(
        HTTP_REFERER HTTP_CACHE_CONTROL HTTP_COOKIE HTTP_USER_AGENT
        HTTP_ACCEPT_LANGUAGE HTTP_ACCEPT_ENCODING HTTP_ACCEPT
        QUERY_STRING REQUEST_METHOD REQUEST_URI SCRIPT_NAME
        ALLUSERSPROFILE      APPDATA              LOCALAPPDATA   COMMONPROGRAMFILES
        PROGRAMDATA          PROGRAMFILES         PSMODULEPATH   PUBLIC
        SYSTEMDRIVE          SYSTEMROOT           TEMP           WINDIR
        USERPROFILE          REMOTE_PORT
        )
        )
    {
        delete $Environment{$NotNeededString};
    }

    my @Result;

    for my $Variable ( sort { $a cmp $b } keys %Environment ) {
        $Self->AddResultInformation(
            Identifier => $Variable,
            Label      => $Variable,
            Value      => $Environment{$Variable},
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
