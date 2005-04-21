# --
# Kernel/System/Config.pm - all system config tool functions
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.13 2005-04-21 17:29:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Config;

use strict;
use Kernel::System::XML;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.13 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Config - to manage config settings

=head1 SYNOPSIS

All functions to manage config settings.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::Config;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $ConfigToolObject = Kernel::System::Config->new(
      LogObject => $LogObject,
      ConfigObject => $ConfigObject,
      DBObject => $DBObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create xml object
    $Self->{XMLObject} = Kernel::System::XML->new(%Param);

    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # read all config files
    $Self->_Init();
    # reorga of old config
    $Self->CreateConfig();

    return $Self;
}

sub _Init {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # load xml config files
    if (-e "$Self->{Home}/Kernel/Config/Files/") {
        my %Data = ();
        my @Files = glob("$Self->{Home}/Kernel/Config/Files/*.xml");
        foreach my $File (@Files) {
            my $ConfigFile = '';
            if (open (IN, "< $File")) {
                while (<IN>) {
                    $ConfigFile .= $_;
                }
                close (IN);
            }
            else {
                print STDERR "ERROR: $!: $File\n";
            }
            if ($ConfigFile) {
                my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash(String => $ConfigFile);
                $Data{$File} = \@XMLHash;
            }
        }
        $Self->{XMLConfig} = [];
        # load framework, application, config, changes
        foreach my $Init (qw(Framework Application Config Changes)) {
            foreach my $Set (sort keys %Data) {
                if ($Data{$Set}->[1]->{otrs_config}->[1]->{init} eq $Init) {
#$Self->{LogObject}->Dumper($Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem});
                    push (@{$Self->{XMLConfig}}, @{$Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem}});
                    delete $Data{$Set};
                }
            }
        }
        # load misc
        foreach my $Set (sort keys %Data) {
#$Self->{LogObject}->Dumper($Data{$Set}->[1]->{otrs_config}->[1]->{init});
            push (@{$Self->{XMLConfig}}, @{$Data{$Set}->[1]->{otrs_config}->[1]->{ConfigItem}});
            delete $Data{$Set};
        }
#$Self->{LogObject}->Dumper($Self->{XMLConfig});
    }
}

=item CreateConfig()

submit config settings to application

    $ConfigToolObject->CreateConfig();

=cut

sub CreateConfig {
    my $Self = shift;
    my %Param = @_;
    my %UsedKeys = ();
    my $Home = $Self->{ConfigObject}->Get('Home');
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!open(OUT, "> $Home/Kernel/Config/Files/ZZZAuto.pm")) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write $Home/Kernel/Config/Files/ZZZAuto.pm!");
        return;
    }
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Name} && !$UsedKeys{$ConfigItem->{Name}}) {
            $UsedKeys{$ConfigItem->{Name}} = 1;
            my %Config = $Self->ConfigItemGet(
                Name => $ConfigItem->{Name},
            );
            my $Name = $ConfigItem->{Name};
            $Name =~ s/\\/\\\\/g;
            $Name =~ s/'/\'/g;
            $Name =~ s/###/'}->{'/g;
            if ($ConfigItem->{Valid}) {
                if ($ConfigItem->{Setting}->[1]->{String}) {
                    print OUT "    \$Self->{'$Name'} = '$ConfigItem->{Setting}->[1]->{String}->[1]->{Content}';\n";
                }
                if ($ConfigItem->{Setting}->[1]->{Option}) {
                    print OUT "    \$Self->{'$Name'} = '$ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID}';\n";
                }
                if ($ConfigItem->{Setting}->[1]->{Hash}) {
                    my %Hash = ();
                    my @Array = @{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}};
#                    foreach my $Item (1..$#Array) {
                    foreach my $Item (0..$#Array) {
                        $Hash{$Array[$Item]->{Key}} = $Array[$Item]->{Content};
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(\%Hash);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                if ($ConfigItem->{Setting}->[1]->{Array}) {
                    my @ArrayNew = ();
                    my @Array = @{$ConfigItem->{Setting}->[1]->{Array}->[1]->{Item}};
#                    foreach my $Item (1..$#Array) {
                    foreach my $Item (0..$#Array) {
                        push (@ArrayNew, $Array[$Item]->{Content});
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(@ArrayNew);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                print OUT "    \$Self->{'Valid'}->{'$Name'} = '$ConfigItem->{Valid}';\n";
            }
        }
    }

    close(OUT);

}

=item ConfigItemUpdate()

submit config settings and save it

    $ConfigToolObject->ConfigItemUpdate(
        Valid => 1,
        Key => 'WebUploadCacheModule',
        Value => 'Kernel::System::Web::UploadCache::DB',
    );

=cut

sub ConfigItemUpdate {
    my $Self = shift;
    my %Param = @_;
    my %UsedKeys = ();
    my $Home = $Self->{ConfigObject}->Get('Home');
    # check needed stuff
    foreach (qw(Valid Key Value)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!open(OUT, ">> $Home/Kernel/Config/Files/ZZZAuto.pm")) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write $Home/Kernel/Config/Files/ZZZAuto.pm: $!");
        return;
    }
    else {
        $Param{Key} =~ s/\\/\\\\/g;
        $Param{Key} =~ s/'/\'/g;
        $Param{Key} =~ s/###/'}->{'/g;
        # store in config
        require Data::Dumper;
        if (!$Param{Valid}) {
            my $Dump = "delete \$Self->{'$Param{Key}'};";
            $Dump .= "\$Self->{'Valid'}->{'$Param{Key}'} = '$Param{Valid}';\n1;\n";
            print OUT $Dump;
            close(OUT);
            # set in runtime
            $Dump =~ s/\$Self->/\$Self->{ConfigObject}->/gm;
            eval $Dump || die "ERROR: Syntax error in $Dump\n";
            return 1;
        }
        else {
            my $Dump = Data::Dumper::Dumper($Param{Value});
            $Dump =~ s/\$VAR1/\$Self->{'$Param{Key}'}/;
            $Dump .= "\$Self->{'Valid'}->{'$Param{Key}'} = '$Param{Valid}';\n1;\n";
            print OUT $Dump;
            close(OUT);
            # set in runtime
            $Dump =~ s/^\$Self->/\$Self->{ConfigObject}->/gm;
            eval $Dump || die "ERROR: Syntax error in $Dump\n";
            return 1;
        }
    }
}

=item ConfigItemGet()

get a config setting

    my %Config = $ConfigToolObject->ConfigItemGet(
        Name => 'Ticket::NumberGenerator',
    );

=cut

sub ConfigItemGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    foreach my $ConfigItem (reverse @{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Name} && $ConfigItem->{Name} eq $Param{Name}) {
#            $ConfigItem->{Name} =~ s/\\/\\\\/g;
#            $ConfigItem->{Name} =~ s/'/\'/g;
#            $ConfigItem->{Name} =~ s/###/'}->{'/g;
            # add current valid state
            if ($Self->{ConfigObject}->Get('Valid') && defined($Self->{ConfigObject}->Get('Valid')->{$ConfigItem->{Name}})) {
                $ConfigItem->{Valid} = $Self->{ConfigObject}->Get('Valid')->{$ConfigItem->{Name}}; 
            }
            # update xml with current config setting
            if ($ConfigItem->{Setting}->[1]->{String}) {
                # fill default
                $ConfigItem->{Setting}->[1]->{String}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{String}->[1]->{Content};
                if (defined($Self->{ConfigObject}->Get($ConfigItem->{Name}))) {
                    $ConfigItem->{Setting}->[1]->{String}->[1]->{Content} = $Self->{ConfigObject}->Get($ConfigItem->{Name});
                }
            }
            if ($ConfigItem->{Setting}->[1]->{Option}) {
                # fill default
                $ConfigItem->{Setting}->[1]->{Option}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID};
                if (defined($Self->{ConfigObject}->Get($ConfigItem->{Name}))) {
                    $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID} = $Self->{ConfigObject}->Get($ConfigItem->{Name});
                }
            }
            if ($ConfigItem->{Setting}->[1]->{Hash}) {
                if (defined($Self->{ConfigObject}->Get($ConfigItem->{Name}))) {
                    @{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}} = ();
                    my %Hash = %{$Self->{ConfigObject}->Get($ConfigItem->{Name})};
                    foreach my $Key (sort keys %Hash) {
                        if (!$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}) {
                            push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, undef);
                        }
                        push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                Key => $Key,
                                Content => $Hash{$Key},
                            },
                        );
                    }
#$Self->{LogObject}->Dumper($ConfigItem);
                }
            }
            if ($ConfigItem->{Setting}->[1]->{Option} && $ConfigItem->{Setting}->[1]->{Option}->[1]->{Location}) {
                my $Home = $Self->{ConfigObject}->Get('Home');
                my @List = glob($Home."/$ConfigItem->{Setting}->[1]->{Option}->[1]->{Location}");
                foreach my $Item (@List) {
                    $Item =~ s/$Home//g;
                    $Item =~ s/\/\//\//g;
                    $Item =~ s/^\///g;
                    $Item =~ s/^(.*)\.pm/$1/g;
                    $Item =~ s/\//::/g;
                    $Item =~ s/\//::/g;
                    my $Value = $Item;
                    my $Key = $Item;
                    $Value =~ s/^.*::(.+?)$/$1/g;
                    if (!$ConfigItem->{Setting}->[1]->{Option}->[1]->{Item}) {
                        push (@{$ConfigItem->{Setting}->[1]->{Option}->[1]->{Item}}, undef);
                    }
                    push (@{$ConfigItem->{Setting}->[1]->{Option}->[1]->{Item}}, {
                            Key => $Key,
                            Content => $Value,
                        },
                    );
#                    print STDERR "$Key $Value-----\n";
                }
            }
#$Self->{LogObject}->Dumper($ConfigItem);
            return %{$ConfigItem};
        }
    }
}

=item ConfigGroupList()

get a list of config groups

    my %ConfigGroupList = $ConfigToolObject->ConfigGroupList();

=cut

sub ConfigGroupList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
        if (!$Param{$_}) { 
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %List = ();
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Group} && ref($ConfigItem->{Group}) eq 'ARRAY') {
            foreach my $Group (@{$ConfigItem->{Group}}) {
                if ($Group->{Content}) {
                    $List{$Group->{Content}} = $Group->{Content};
                }
            }
        }
    }
    return %List;
}

=item ConfigSubGroupList()

get a list of config sub groups

    my %ConfigGroupList = $ConfigToolObject->ConfigSubGroupList(Name => 'Framework');
    
=cut

sub ConfigSubGroupList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
        if (!$Param{$_}) { 
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %List = ();
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Group} && ref($ConfigItem->{Group}) eq 'ARRAY') {
            my $Hit = 0;
            foreach my $Group (@{$ConfigItem->{Group}}) {
                if ($Group->{Content} && $Group->{Content} eq $Param{Name}) {
                    $Hit = 1;
                }
            }
            if ($Hit) {
                foreach my $SubGroup (@{$ConfigItem->{SubGroup}}) {
                    if ($SubGroup->{Content}) {
                        $List{$SubGroup->{Content}} = $SubGroup->{Content};
                    }
                }
            }
        }
    }
    return %List;
}

=item ConfigSubGroupConfigItemList()

get a list of config items of a sub group

    my %ConfigItemList = $ConfigToolObject->ConfigSubGroupConfigItemList(
        Group => 'Framework',
        SubGroup => 'Web',
    );
    
=cut

sub ConfigSubGroupConfigItemList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Group SubGroup)) {
        if (!$Param{$_}) { 
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my @List = ();
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        if ($ConfigItem->{Group} && ref($ConfigItem->{Group}) eq 'ARRAY') {
            my $Hit = 0;
            foreach my $Group (@{$ConfigItem->{Group}}) {
                if ($Group->{Content} && $Group->{Content} eq $Param{Group}) {
                    $Hit = 1;
                }
            }
            if ($Hit) {
                if ($ConfigItem->{SubGroup} && ref($ConfigItem->{SubGroup}) eq 'ARRAY') {
                    foreach my $SubGroup (@{$ConfigItem->{SubGroup}}) {
                        if ($SubGroup->{Content} && $SubGroup->{Content} eq $Param{SubGroup}) {
                            push (@List, $ConfigItem->{Name});
                        }
                    }
                }
            }
        }
    }
    return @List;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.13 $ $Date: 2005-04-21 17:29:38 $

=cut
