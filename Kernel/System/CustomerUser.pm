# --
# Kernel/System/CustomerUser.pm - some customer user functions
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerUser.pm,v 1.9 2003-01-03 00:30:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # --
    # check needed objects
    # --
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # --
    # load generator customer preferences module
    # --
    my $GeneratorModule = $Self->{ConfigObject}->Get('Customer::PrefernecesModule')
      || 'Kernel::System::CustomerUser::Preferences::DB';
    eval "require $GeneratorModule";
    $Self->{PrefernecesObject} = $GeneratorModule->new(%Param);
    # --
    # load generator customer user module
    # --
    $GeneratorModule = $Self->{ConfigObject}->Get('CustomerUser')->{Module}
      || 'Kernel::System::CustomerUser::DB';
    eval "require $GeneratorModule";
    $Self->{CustomerUserObject} = $GeneratorModule->new(
        %Param,  
        PreferencesObject => $Self->{PrefernecesObject},
    );

    return $Self;
}
# --
sub CustomerList {
    my $Self = shift;
    return $Self->{CustomerUserObject}->CustomerList(@_); 
}
# --
sub CustomerUserList {
    my $Self = shift;
    return $Self->{CustomerUserObject}->CustomerUserList(@_); 
}
# --
sub CustomerUserDataGet {
    my $Self = shift;
    return $Self->{CustomerUserObject}->CustomerUserDataGet(@_); 
}
# --
sub CustomerUserAdd {
    my $Self = shift;
    return $Self->{CustomerUserObject}->CustomerUserAdd(@_);
}
# --
sub CustomerUserUpdate {
    my $Self = shift;
    return $Self->{CustomerUserObject}->CustomerUserUpdate(@_);
}   
# --
sub SetPassword {
    my $Self = shift;
    return $Self->{CustomerUserObject}->SetPassword(@_);
}
# --
sub GetGroups {
    my $Self = shift;
    return $Self->{CustomerUserObject}->GetGroups(@_);
}
# --
sub GenerateRandomPassword {
    my $Self = shift;
    return $Self->{CustomerUserObject}->GenerateRandomPassword(@_);
}
# --
sub GetPreferences {
    my $Self = shift;
    return $Self->{PrefernecesObject}->GetPreferences(@_);
}
# --
sub SetPreferences {
    my $Self = shift;
    return $Self->{PrefernecesObject}->SetPreferences(@_);
}
# --

1;
