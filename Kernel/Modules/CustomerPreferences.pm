# --
# Kernel/Modules/CustomerPreferences.pm - provides agent preferences
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerPreferences.pm,v 1.7 2004-12-28 01:03:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerPreferences;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject SessionObject UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    # get params
    $Self->{Want} = $Self->{ParamObject}->GetParam(Param => 'Want') || '';

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Group = $Self->{ParamObject}->GetParam(Param => 'Group') || '';

    if ($Self->{Subaction} eq 'Update') {
        # check group param
        if (!$Group) {
            return $Self->{LayoutObject}->ErrorScreen(Message => "Param Group is required!");
        }
        # check preferences setting
        my %Preferences = %{$Self->{ConfigObject}->Get('CustomerPreferencesGroups')};
        if (!$Preferences{$Group}) {
            return $Self->{LayoutObject}->ErrorScreen(Message => "No such config for $Group");
        }
        # get user data
        my %UserData = $Self->{UserObject}->CustomerUserDataGet(User => $Self->{UserLogin});
        my $Module = $Preferences{$Group}->{Module};
        if (eval "require $Module") {
            my $Object = $Module->new(
                %{$Self},
                Debug => $Self->{Debug},
            );
            # log loaded module
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Module: $Module loaded!",
                );
            }
            my @Params = $Object->Param(%{$Preferences{$Group}}, UserData => \%UserData);
            my %GetParam = ();
            foreach my $ParamItem (@Params) {
                my @Array = $Self->{ParamObject}->GetArray(Param => $ParamItem->{Name});
                $GetParam{$ParamItem->{Name}} = \@Array;
            }
            my $Message = '';
            if ($Object->Run(GetParam => \%GetParam, UserData => \%UserData)) {
                $Message = $Object->Message();
            }
            else {
                $Message = $Object->Error();
            }
            # mk rediect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=CustomerPreferences&What=$Message",
            );
        }
    }
    else {
        # get user data
        my %UserData = $Self->{UserObject}->CustomerUserDataGet(User => $Self->{UserLogin});
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Preferences');
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        # --
        # get param
        # --
        my $What = $Self->{ParamObject}->GetParam(Param => 'What') || '';
        # --
        # get notification
        # --
        if ($What) {
            $Output .= $Self->{LayoutObject}->Notify(Info => $What);
        }

        $Output .= $Self->CustomerPreferencesForm(UserData => \%UserData);
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}
# --
sub UpdatePw {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Pw = $Self->{ParamObject}->GetParam(Param => 'NewPw') || '';
    my $Pw1 = $Self->{ParamObject}->GetParam(Param => 'NewPw1') || '';
    my $UserID = $Self->{UserID};

    if ($Pw eq $Pw1 && $Pw) {
        $Self->{UserObject}->SetPassword(UserLogin => $Self->{UserLogin}, PW => $Pw);
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "Action=CustomerPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerWarning(
            Message => 'Passwords dosn\'t match! Please try it again!',
            Comment => 'Passwords dosn\'t match! Please try it again!',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
    }

    return $Output;
}
# --
sub CustomerPreferencesForm {
    my $Self = shift;
    my %Param = @_;

   $Self->{LayoutObject}->Block(
        Name => 'Body',
        Data => {
            %Param,
        },
    );

    my @Groups = @{$Self->{ConfigObject}->Get('CustomerPreferencesView')};
    foreach my $Colum (@Groups) {
        my %Data = ();
        my %Preferences = %{$Self->{ConfigObject}->Get('CustomerPreferencesGroups')};
        foreach my $Group (keys %Preferences) {
            if ($Preferences{$Group}->{Colum} eq $Colum) {
                if ($Data{$Preferences{$Group}->{Prio}}) {
                    foreach (1..151) {
                        $Preferences{$Group}->{Prio}++;
                        if (!$Data{$Preferences{$Group}->{Prio}}) {
                            $Data{$Preferences{$Group}->{Prio}} = $Group;
                            last;
                        }
                    }
                }
                $Data{$Preferences{$Group}->{Prio}} = $Group;
            }
        }
        $Self->{LayoutObject}->Block(
            Name => 'Head',
            Data => {
                Header => $Colum,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'Colum',
            Data => {
                Header => $Colum,
                %Param,
            },
        );
        # sort
        foreach my $Key (keys %Data) {
            $Data{sprintf("%07d", $Key)} = $Data{$Key};
            delete $Data{$Key};
        }
        # show each preferences setting
        foreach my $Prio (sort keys %Data) {
            my $Group = $Data{$Prio};
            if (!$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}) {
                next;
            }
            my %Preference = %{$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}};
            if (!$Preference{Activ}) {
                next;
            }
            # log try of load module
            my $Module = $Preference{Module} || 'Kernel::Output::HTML::CustomerPreferencesGeneric';
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Try to load module: $Module!",
                );
            }
            if (eval "require $Module") {
                my $Object = $Module->new(
                    %{$Self},
                    Debug => $Self->{Debug},
                );
                # log loaded module
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Module: $Module loaded!",
                    );
                }
                my @Params = $Object->Param(%Preference, UserData => $Param{UserData});
                if (@Params) {
                    $Self->{LayoutObject}->Block(
                        Name => 'Item',
                        Data => {
                            Group => $Group,
                            %Preference,
                        },
                    );
                    foreach my $ParamItem (@Params) {
                        if (ref($ParamItem->{Data}) eq 'HASH') {
                            $ParamItem->{'Option'} = $Self->{LayoutObject}->OptionStrgHashRef(
                                %{$ParamItem},
                            );
                        }
                        $Self->{LayoutObject}->Block(
                            Name => $ParamItem->{Block} || 'Option',
                            Data => {
                                %{$ParamItem},
                            },
                        );
                    }
                }
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Can't load module $Module!",
                );
            }
        }
    }

    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'CustomerPreferencesForm', Data => \%Param);
}

1;
