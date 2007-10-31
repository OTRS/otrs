# NOTE: Derived from blib/lib/Mail/Util.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Util;

#line 97 "blib/lib/Mail/Util.pm (autosplit into blib/lib/auto/Mail/Util/read_mbox.al)"
sub read_mbox {
    my $file  = shift;
    my @mail  = ();
    my $mail  = [];
    my $blank = 1;
    local *FH;
    local $_;

    open(FH,"< $file") or
	do {
	    require Carp;
	    Carp::croak("cannot open '$file': $!\n");
	};

    while(<FH>) {
	if($blank && /\AFrom .*\d{4}/) {
	    push(@mail, $mail) if scalar(@{$mail});
	    $mail = [ $_ ];
	    $blank = 0;
	}
	else {
	    $blank = m#\A\Z#o ? 1 : 0;
	    push(@{$mail}, $_);
	}
    }

    push(@mail, $mail) if scalar(@{$mail});

    close(FH);

    return wantarray ? @mail : \@mail;
}

# end of Mail::Util::read_mbox
1;
