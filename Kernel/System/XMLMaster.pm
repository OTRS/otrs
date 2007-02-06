# --
# Kernel/System/XMLMaster.pm - the global XMLMaster module for OTRS
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: XMLMaster.pm,v 1.6 2007-02-06 21:54:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::XMLMaster;

use strict;
use Kernel::System::XML;
use Kernel::System::Main;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::XMLMaster - xml master handle

=head1 SYNOPSIS

This module is managing xml master handle.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a xml master object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;

    my $ConfigObject = Kernel::Config->new();

    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );

    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );

    my $TimeObject = Kernel::System::Time->new(
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );

    my $DBObject = Kernel::System::DB->new(
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );

    my $XMLMasterObject = Kernel::System::XMLMaster->new(
        DBObject => $DBObject,
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed objects
    foreach (qw(DBObject LogObject ConfigObject TimeObject MainObject)) {
        die "Got no $_" if (!$Param{$_});
    }

    # for debug
    $Self->{Debug} = $Param{Debug} || 0;

    # create common objects
    $Self->{XMLObject} = Kernel::System::XML->new(%Param);

    return $Self;
}

=item Run()

to execute the run process

    my $XML = '<SomeXMLString>Test<SomeXMLString>';

    $XMLMasterObject->Run(
        XML => \$XML,
    );

=cut

sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(XML)) {
        if (!defined $Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_ !");
            return;
        }
    }

    my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => ${$Param{XML}});

    # run all XMLMasterModules
    if (ref($Self->{ConfigObject}->Get('XMLMaster::Module')) eq 'HASH') {
        my %Jobs = %{$Self->{ConfigObject}->Get('XMLMaster::Module')};
        foreach my $Job (sort keys %Jobs) {
            if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                my $FilterObject = $Jobs{$Job}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    TimeObject => $Self->{TimeObject},
                    Debug => $Self->{Debug},
                );
                # modify params
                if (!$FilterObject->Run(
                    XMLHash => \@XMLHash,
                    JobConfig => $Jobs{$Job},
                )) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Execute Run() of XMLModule $Jobs{$Job}->{Module} not successfully!",
                    );
                }
            }
        }
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.6 $ $Date: 2007-02-06 21:54:36 $

=cut
