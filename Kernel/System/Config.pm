# --
# Kernel/System/Config.pm - all system config tool functions
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.28 2005-05-27 16:09:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Config;

use strict;
use Kernel::System::XML;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.28 $';
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
            my $Name = $Config{Name};
            $Name =~ s/\\/\\\\/g;
            $Name =~ s/'/\'/g;
            $Name =~ s/###/'}->{'/g;
            if ($Config{Valid}) {
                if ($Config{Setting}->[1]->{String}) {
                    print OUT "    \$Self->{'$Name'} = '$Config{Setting}->[1]->{String}->[1]->{Content}';\n";
                }
                if ($Config{Setting}->[1]->{Option}) {
                    print OUT "    \$Self->{'$Name'} = '$Config{Setting}->[1]->{Option}->[1]->{SelectedID}'; ###\n";
                }
                if ($Config{Setting}->[1]->{TextArea}) {
                    print OUT "    \$Self->{'$Name'} = '$Config{Setting}->[1]->{TextArea}->[1]->{Content}';\n";
                }
                if ($Config{Setting}->[1]->{Hash}) {
                    my %Hash = ();
                    my @Array = ();
                    if (ref($Config{Setting}->[1]->{Hash}->[1]->{Item}) eq 'ARRAY') {
                        @Array = @{$Config{Setting}->[1]->{Hash}->[1]->{Item}};
                    }
                    foreach my $Item (1..$#Array) {
                        if (defined($Array[$Item]->{Hash})) {
                            my %SubHash = ();
                            foreach my $Index (1...$#{$Config{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}}) {
                                $SubHash{$Config{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}->[$Index]->{Key}} = $Config{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Hash}->[1]->{Item}->[$Index]->{Content};
                            }
                            $Hash{$Array[$Item]->{Key}} = \%SubHash;
                        }
                        elsif (defined($Array[$Item]->{Array})) {
                            my @SubArray = ();
                            foreach my $Index (1...$#{$Config{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Array}->[1]->{Item}}) {
                                push (@SubArray, $Config{Setting}->[1]->{Hash}->[1]->{Item}->[$Item]->{Array}->[1]->{Item}->[$Index]->{Content});
                            }
                            $Hash{$Array[$Item]->{Key}} = \@SubArray;
                        }
                        else {
                            $Hash{$Array[$Item]->{Key}} = $Array[$Item]->{Content};
                        };
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(\%Hash);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                if ($Config{Setting}->[1]->{Array}) {
                    my @ArrayNew = ();
                    my @Array = ();
                    if (ref($Config{Setting}->[1]->{Array}->[1]->{Item}) eq 'ARRAY') {
                        @Array = @{$Config{Setting}->[1]->{Array}->[1]->{Item}};
                    }
                    foreach my $Item (1..$#Array) {
                        push (@ArrayNew, $Array[$Item]->{Content});
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(\@ArrayNew);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                if ($Config{Setting}->[1]->{FrontendModuleReg}) {
                    my %Hash = ();
                    foreach my $Key (sort keys %{$Config{Setting}->[1]->{FrontendModuleReg}->[1]}) {
                        if ($Key eq 'Group' || $Key eq 'GroupRo') {
                            my @Array = ();
                            foreach my $Index (1...$#{$Config{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}}) {
                                push(@Array, $Config{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}->[1]->{Content});
                            }
                            $Hash{$Key} = \@Array;
                        }
                        elsif ($Key eq 'NavBar' || $Key eq 'NavBarModule') {
                            if (ref($Config{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}) eq 'ARRAY') {
                                foreach my $Index (1...$#{$Config{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}}) {
                                    my $Content = $Config{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}->[$Index];
                                    my %NavBar = ();
                                    foreach $Key (sort keys %{$Content}) {
                                        if ($Key eq 'Group' || $Key eq 'GroupRo') {
                                            my @Array = ();
                                            foreach my $Index (1...$#{$Content->{$Key}}) {
                                                push(@Array, $Content->{$Key}->[1]->{Content});
                                            }
                                            $NavBar{$Key} = \@Array;
                                        }
                                        else {
                                            if ($Key ne 'Content') {
                                                $NavBar{$Key} = $Content->{$Key}->[1]->{Content};
                                            }
                                        }
                                    }
                                    if ($Key eq 'NavBar') {
                                        push (@{$Hash{$Key}}, \%NavBar);
                                    }
                                    else {
                                        $Hash{$Key} = \%NavBar;
                                    }
                                }
                            }
                            else {
                                my $Content = $Config{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key};
                                my %NavBar = ();
                                foreach $Key (sort keys %{$Content}) {
                                    if ($Key eq 'Group' || $Key eq 'GroupRo') {
                                        my @Array = ();
                                        foreach my $Index (1...$#{$Content->{$Key}}) {
                                            push(@Array, $Content->{$Key}->[1]->{Content});
                                        }
                                        $NavBar{$Key} = \@Array;
                                    }
                                    else {
                                        if ($Key ne 'Content') {
                                            $NavBar{$Key} = $Content->{$Key}->[1]->{Content};
                                        }
                                    }
                                }
                                $Hash{$Key} = \%NavBar;
                            }
                        }
                        else {
                            if ($Key ne 'Content') {
                                $Hash{$Key} = $Config{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}->[1]->{Content};
                            }
                        }
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(\%Hash);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                if ($Config{Setting}->[1]->{TimeWorkingHours}) {
                    my %Days = ();
                    my @Array = @{$Config{Setting}->[1]->{TimeWorkingHours}->[1]->{Day}};
                    foreach my $Day (1..$#Array) {
                        my @Array2 = ();
                        if ($Array[$Day]->{Hour}) {
                            my @Hours = @{$Array[$Day]->{Hour}};
                            foreach my $Hour (1..$#Hours) {
                                push (@Array2, $Hours[$Hour]->{Content});
                            }
                        }
                        $Days{$Array[$Day]->{Name}} = \@Array2;
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(\%Days);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                if ($Config{Setting}->[1]->{TimeVacationDays}) {
                    my %Hash = ();
                    my @Array = @{$Config{Setting}->[1]->{TimeVacationDays}->[1]->{Item}};
                    foreach my $Item (1..$#Array) {
                        $Hash{$Array[$Item]->{Month}}->{$Array[$Item]->{Day}} = $Array[$Item]->{Content};
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(\%Hash);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                if ($Config{Setting}->[1]->{TimeVacationDaysOneTime}) {
                    my %Hash = ();
                    my @Array = @{$Config{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item}};
                    foreach my $Item (1..$#Array) {
                        $Hash{$Array[$Item]->{Year}}->{$Array[$Item]->{Month}}->{$Array[$Item]->{Day}} = $Array[$Item]->{Content};
                    }
                    # store in config
                    require Data::Dumper;
                    my $Dump = Data::Dumper::Dumper(\%Hash);
                    $Dump =~ s/\$VAR1/\$Self->{'$Name'}/;
                    print OUT $Dump;
                }
                print OUT "    \$Self->{'Valid'}->{'$Name'} = '$Config{Valid}';\n";
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
            if ($Self->{ConfigObject}->Get('Valid') && defined($Self->ModGet(ConfigName => 'Valid###'.$ConfigItem->{Name}))) {
                $ConfigItem->{Valid} = $Self->ModGet(ConfigName => 'Valid###'.$ConfigItem->{Name});
            }
            # update xml with current config setting
            if ($ConfigItem->{Setting}->[1]->{String}) {
                # fill default
                $ConfigItem->{Setting}->[1]->{String}->[1]->{Content} =~ s/&lt;/</g;
                $ConfigItem->{Setting}->[1]->{String}->[1]->{Content} =~ s/&gt;/>/g;
                $ConfigItem->{Setting}->[1]->{String}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{String}->[1]->{Content};
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    $ConfigItem->{Setting}->[1]->{String}->[1]->{Content} = $Self->ModGet(ConfigName => $ConfigItem->{Name});
                }
            }
            if ($ConfigItem->{Setting}->[1]->{TextArea}) {
                # fill default
                $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content} =~ s/&lt;/</g;
                $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content} =~ s/&gt;/>/g;
                $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content};
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    $ConfigItem->{Setting}->[1]->{TextArea}->[1]->{Content} = $Self->ModGet(ConfigName => $ConfigItem->{Name});
                }
            }
            if ($ConfigItem->{Setting}->[1]->{Option}) {
                # fill default
                $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID} =~ s/&lt;/</g;
                $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID} =~ s/&gt;/>/g;
                $ConfigItem->{Setting}->[1]->{Option}->[1]->{Default} = $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID};
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    $ConfigItem->{Setting}->[1]->{Option}->[1]->{SelectedID} = $Self->ModGet(ConfigName => $ConfigItem->{Name});
                }
            }
            if ($ConfigItem->{Setting}->[1]->{Hash}) {
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    my @Array = ();
                    if (ref($ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}) eq 'ARRAY') {
                        @Array = @{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}};
                    }
                    @{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}} = (undef);
                    my %Hash = %{$Self->ModGet(ConfigName => $ConfigItem->{Name})};
                    foreach my $Key (sort keys %Hash) {
                        if (ref($Hash{$Key}) eq 'ARRAY') {
                            my @Array = (undef,{Content => '',});
                            @{$Array[1]{Item}} = (undef);
                            foreach my $Content (@{$Hash{$Key}}) {
                                push (@{$Array[1]{Item}}, {Content => $Content});
                            }
                            push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                    Key     => $Key,
                                    Content => '',
                                    Array   => \@Array,
                                },
                            );
                        }
                        elsif (ref($Hash{$Key}) eq 'HASH') {
                            my @Array = (undef,{Content => '',});
                            @{$Array[1]{Item}} = (undef);
                            foreach my $Key2 (keys %{$Hash{$Key}}) {
                                push (@{$Array[1]{Item}}, {Content => $Hash{$Key}{$Key2}, Key => $Key2});
                            }
                            push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                    Key     => $Key,
                                    Content => '',
                                    Hash    => \@Array,
                                },
                            );
                        }
                        else {
                            my $Option = 0;
                            foreach my $Index (1...$#Array) {
                                if (defined ($Array[$Index]{Key}) && $Array[$Index]{Key} eq $Key && defined ($Array[$Index]{Option})) {
                                    $Option = 1;
                                    $Array[$Index]{Option}[1]{SelectedID} = $Hash{$Key};
                                    push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                            Key     => $Key,
                                            Content => '',
                                            Option  => $Array[$Index]{Option},
                                        },
                                    );
                                }
                            }
                            if ($Option == 0) {
                                push (@{$ConfigItem->{Setting}->[1]->{Hash}->[1]->{Item}}, {
                                        Key     => $Key,
                                        Content => $Hash{$Key},
                                    },
                                );
                            }
                        }
                    }
#$Self->{LogObject}->Dumper($ConfigItem);
                }
            }
            if ($ConfigItem->{Setting}->[1]->{Array}) {
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    @{$ConfigItem->{Setting}->[1]->{Array}->[1]->{Item}} = (undef);
                    my @Array = @{$Self->ModGet(ConfigName => $ConfigItem->{Name})};
                    foreach my $Key (@Array) {
                        push (@{$ConfigItem->{Setting}->[1]->{Array}->[1]->{Item}}, {
                                Content => $Key,
                            },
                        );
                    }
#$Self->{LogObject}->Dumper($ConfigItem);
                }
            }
            if ($ConfigItem->{Setting}->[1]->{FrontendModuleReg}) {
                 if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    @{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}} = (undef);
                    my %Hash = %{$Self->ModGet(ConfigName => $ConfigItem->{Name})};
#                   $Self->{LogObject}->Dumper(jkl => %Hash);
                    foreach my $Key (sort keys %Hash) {
                        @{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}} = (undef);
                        if ($Key eq 'Group' || $Key eq 'GroupRo') {
                            my @Array = (undef);
                                foreach my $Content (@{$Hash{$Key}}) {
                                    push (@{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}},
                                        {Content => $Content}
                                );
                            }
                        }
                        elsif ($Key eq 'NavBar' || $Key eq 'NavBarModule') {
#                         $Self->{LogObject}->Dumper($Key => \%Hash);
                            if (ref($Hash{$Key}) eq 'ARRAY') {
                                foreach my $Content (@{$Hash{$Key}}) {
                                    my %NavBar;
                                    foreach (sort keys %{$Content}) {
                                        if ($_ eq 'Group' || $_ eq 'GroupRo') {
                                            @{$NavBar{$_}} = (undef);
                                            foreach my $Group (@{$Content->{$_}}) {
                                            push (@{$NavBar{$_}}, {Content => $Group});
                                            }
                                        }
                                        else {
                                            push (@{$NavBar{$_}}, (undef, {Content => $Content->{$_}}));
                                        }
                                    }
                                    push (@{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}}, \%NavBar);
                                }
                            }
                            else {
                                my %NavBar;
                                my $Content = $Hash{$Key};
                                foreach (sort keys %{$Content}) {
                                    if ($_ eq 'Group' || $_ eq 'GroupRo') {
                                        @{$NavBar{$_}} = (undef);
                                        foreach my $Group (@{$Content->{$_}}) {
                                        push (@{$NavBar{$_}}, {Content => $Group});
                                        }
                                    }
                                    else {
                                        push (@{$NavBar{$_}}, (undef, {Content => $Content->{$_}}));
                                    }
                                }
                                $ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key} = \%NavBar;
                            }
                        }
                        else {
                            push (@{$ConfigItem->{Setting}->[1]->{FrontendModuleReg}->[1]->{$Key}},
                                {Content => $Hash{$Key}}
                            );
                        }
                    }
                }
#  $Self->{LogObject}->Dumper(jkl => $ConfigItem);
            }
            if ($ConfigItem->{Setting}->[1]->{TimeWorkingHours}) {
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    @{$ConfigItem->{Setting}->[1]->{TimeWorkingHours}->[1]->{Day}} = (undef);
                    my %Days = %{$Self->ModGet(ConfigName => $ConfigItem->{Name})};
                    foreach my $Day (keys %Days) {
                        my @Array = (undef);
                        foreach my $Hour (@{$Days{$Day}}) {
                            push (@Array, { Content => $Hour, });
                        }
                        push (@{$ConfigItem->{Setting}->[1]->{TimeWorkingHours}->[1]->{Day}}, {
                                Name => $Day,
                                Hour => \@Array,
                            },
                        );
                    }
#$Self->{LogObject}->Dumper($ConfigItem);
                }
            }
            if ($ConfigItem->{Setting}->[1]->{TimeVacationDays}) {
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    @{$ConfigItem->{Setting}->[1]->{TimeVacationDays}->[1]->{Item}} = (undef);
                    my %Hash = %{$Self->ModGet(ConfigName => $ConfigItem->{Name})};
                    foreach my $Month (sort keys %Hash) {
                        foreach my $Day (sort keys %{$Hash{$Month}}) {
                            push (@{$ConfigItem->{Setting}->[1]->{TimeVacationDays}->[1]->{Item}}, {
                                    Month => $Month,
                                    Day => $Day,
                                    Content => $Hash{$Month}->{$Day},
                                },
                            );
                        }
                    }
#$Self->{LogObject}->Dumper($ConfigItem);
                }
            }
            if ($ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}) {
                if (defined($Self->ModGet(ConfigName => $ConfigItem->{Name}))) {
                    @{$ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item}} = (undef);
                    my %Hash = %{$Self->ModGet(ConfigName => $ConfigItem->{Name})};
                    foreach my $Year (sort keys %Hash) {
                        foreach my $Month (sort keys %{$Hash{$Year}}) {
                            foreach my $Day (sort keys %{$Hash{$Year}->{$Month}}) {
                                push (@{$ConfigItem->{Setting}->[1]->{TimeVacationDaysOneTime}->[1]->{Item}}, {
                                        Year => $Year,
                                        Month => $Month,
                                        Day => $Day,
                                        Content => $Hash{$Year}->{$Month}->{$Day},
                                    },
                                );
                            }
                        }
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
                        # get sub count
                        my @List = $Self->ConfigSubGroupConfigItemList(
                            Group => $Param{Name},
                            SubGroup => $SubGroup->{Content},
                        );
                        $List{$SubGroup->{Content}} = ($#List+1);
                    }
                }
            }
        }
    }
    return %List;
}

=item ConfigSubGroupConfigItemList()

get a list of config items of a sub group

    my @ConfigItemList = $ConfigToolObject->ConfigSubGroupConfigItemList(
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
    my %Used = ();
    foreach my $ConfigItem (@{$Self->{XMLConfig}}) {
        my $Name = $ConfigItem->{Name};
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
                        if (!$Used{$ConfigItem->{Name}} && $SubGroup->{Content} && $SubGroup->{Content} eq $Param{SubGroup}) {
                            $Used{$ConfigItem->{Name}} = 1;
                            push (@List, $ConfigItem->{Name});
                        }
                    }
                }
            }
        }
    }
    return @List;
}

sub ModGet {
    my $Self = shift;
    my %Param = @_;
    my $Content;
    if ($Param{ConfigName} =~ /^(.*)###(.*)###(.*)$/) {
        if (defined($Self->{ConfigObject}->Get($1))) {
            $Content = $Self->{ConfigObject}->Get($1)->{$2}->{$3};
        }
    }
    elsif ($Param{ConfigName} =~ /^(.*)###(.*)$/) {
        if (defined($Self->{ConfigObject}->Get($1))) {
            $Content = $Self->{ConfigObject}->Get($1)->{$2};
        }
    }
    else {
        if (defined($Self->{ConfigObject}->Get($Param{ConfigName}))) {
            $Content = $Self->{ConfigObject}->Get($Param{ConfigName});
        }
    }
    return $Content;
}
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.28 $ $Date: 2005-05-27 16:09:55 $

=cut
