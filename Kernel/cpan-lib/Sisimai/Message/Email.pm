package Sisimai::Message::Email;
use parent 'Sisimai::Message';
use feature ':5.10';
use strict;
use warnings;
use Sisimai::ARF;
use Sisimai::MIME;
use Sisimai::RFC3834;
use Sisimai::Order::Email;

my $BorderLine = '__MIME_ENCODED_BOUNDARY__';
my $EndOfEmail = Sisimai::String->EOM;
my $DefaultSet = Sisimai::Order::Email->another;
my $SubjectTab = Sisimai::Order::Email->by('subject');
my $ExtHeaders = Sisimai::Order::Email->headers;
my $ToBeLoaded = [];
my $TryOnFirst = [];
my $RFC822Head = Sisimai::RFC5322->HEADERFIELDS;
my @RFC3834Set = (map { lc $_ } @{ Sisimai::RFC3834->headerlist });
my @HeaderList = (qw|from to date subject content-type reply-to message-id
                     received content-transfer-encoding return-path x-mailer|);
my $MultiHeads = { 'received' => 1 };
my $IgnoreList = { 'dkim-signature' => 1 };
my $Indicators = { 
    'begin' => (1 << 1),
    'endof' => (1 << 2),
};

sub make {
    # Make data structure from the email message(a body part and headers)
    # @param         [Hash] argvs   Email data
    # @options argvs [String] data  Entire email message
    # @options argvs [Array]  load  User defined MTA module list
    # @options argvs [Array]  order The order of MTA modules
    # @options argvs [Array]  field Email header names to be captured
    # @options argvs [Code]   hook  Reference to callback method
    # @return        [Hash]         Resolved data structure
    my $class = shift;
    my $argvs = { @_ };
    my $email = $argvs->{'data'};

    my $methodargv = {};
    my $hookmethod = $argvs->{'hook'}  || undef;
    my $headerlist = $argvs->{'field'} || [];
    my $processing = {
        'from'   => '',     # From_ line
        'header' => {},     # Email header
        'rfc822' => '',     # Original message part
        'ds'     => [],     # Parsed data, Delivery Status
        'catch'  => undef,  # Data parsed by callback method
    };

    $methodargv = {
        'load'  => $argvs->{'load'}  || [],
        'order' => $argvs->{'order'} || [],
    };
    $ToBeLoaded = __PACKAGE__->load(%$methodargv);

    # 1. Split email data to headers and a body part.
    my $aftersplit = __PACKAGE__->divideup(\$email);
    return undef unless keys %$aftersplit;

    # 2. Convert email headers from text to hash reference
    $TryOnFirst = [];
    $processing->{'from'}   = $aftersplit->{'from'};
    $processing->{'header'} = __PACKAGE__->headers(\$aftersplit->{'header'}, $headerlist);

    # 3. Check headers for detecting MTA module
    unless( scalar @$TryOnFirst ) {
        push @$TryOnFirst, @{ __PACKAGE__->makeorder($processing->{'header'}) };
    }

    # 4. Rewrite message body for detecting the bounce reason
    $methodargv = { 
        'hook' => $hookmethod,
        'mail' => $processing, 
        'body' => \$aftersplit->{'body'},
    };
    my $bouncedata = __PACKAGE__->parse(%$methodargv);

    return undef unless $bouncedata;
    return undef unless keys %$bouncedata;
    $processing->{'ds'}    = $bouncedata->{'ds'};
    $processing->{'catch'} = $bouncedata->{'catch'};

    # 5. Rewrite headers of the original message in the body part
    my $rfc822part = $bouncedata->{'rfc822'} || $aftersplit->{'body'};
    if( ref $rfc822part eq '' ) {
        # Returned value from Sisimai::Bite::Email::* module
        $processing->{'rfc822'} = __PACKAGE__->takeapart(\$rfc822part);

    } else {
        # Returned from Sisimai::Bite::JSON::* modules
        $processing->{'rfc822'} = $rfc822part;
    }
    return $processing;
}

sub load {
    # Load MTA modules which specified at 'order' and 'load' in the argument
    # @param         [Hash] argvs       Module information to be loaded
    # @options argvs [Array]  load      User defined MTA module list
    # @options argvs [Array]  order     The order of MTA modules
    # @return        [Array]            Module list
    # @since v4.20.0
    my $class = shift;
    my $argvs = { @_ };

    my @modulelist = ();
    my $tobeloaded = [];
    my $modulepath = '';

    for my $e ('load', 'order') {
        # The order of MTA modules specified by user
        next unless exists $argvs->{ $e };
        next unless ref $argvs->{ $e } eq 'ARRAY';
        next unless scalar @{ $argvs->{ $e } };

        push @modulelist, @{ $argvs->{'order'} } if $e eq 'order';
        next unless $e eq 'load';

        # Load user defined MTA module
        for my $v ( @{ $argvs->{'load'} } ) {
            # Load user defined MTA module
            eval {
                ($modulepath = $v) =~ s|::|/|g; 
                require $modulepath.'.pm';
            };
            next if $@;

            for my $w ( @{ $v->headerlist } ) {
                # Get header name which required user defined MTA module
                $ExtHeaders->{ lc $w }->{ $v } = 1;
            }
            push @$tobeloaded, $v;
        }
    }

    for my $e ( @modulelist ) {
        # Append the custom order of MTA modules
        next if grep { $e eq $_ } @$tobeloaded;
        push @$tobeloaded, $e;
    }
    return $tobeloaded;
}

sub divideup {
    # Divide email data up headers and a body part.
    # @param         [String] email  Email data
    # @return        [Hash]          Email data after split
    # @since v4.14.0
    my $class = shift;
    my $email = shift // return {};

    my @hasdivided = undef;
    my $readcursor = 0;
    my $aftersplit = { 'from' => '', 'header' => '', 'body' => '' };

    $$email =~ s/\r\n/\n/gm  if rindex($$email, "\r\n") > -1;
    $$email =~ s/[ \t]+$//gm if $$email =~ /[ \t]+$/;
    @hasdivided = split("\n", $$email);
    return {} unless scalar @hasdivided;

    if( substr($hasdivided[0], 0, 5) eq 'From ' ) {
        # From MAILER-DAEMON Tue Feb 11 00:00:00 2014
        $aftersplit->{'from'} =  shift @hasdivided;
        $aftersplit->{'from'} =~ y/\r\n//d;
    }

    SPLIT_EMAIL: for my $e ( @hasdivided ) {
        # Split email data to headers and a body part.
        if( $readcursor & $Indicators->{'endof'} ) {
            # The body part of the email
            $aftersplit->{'body'} .= $e."\n";

        } else {
            # The boundary for splitting headers and a body part does not
            # appeare yet.
            if( not $e ) {
                # Blank line, it is a boundary of headers and a body part
                $readcursor |= $Indicators->{'endof'} if $readcursor & $Indicators->{'begin'};

            } else {
                # The header part of the email
                $aftersplit->{'header'} .= $e."\n";
                $readcursor |= $Indicators->{'begin'};
            }
        }
    }
    return {} unless $aftersplit->{'header'};
    return {} unless $aftersplit->{'body'};

    $aftersplit->{'from'} ||= 'MAILER-DAEMON Tue Feb 11 00:00:00 2014';
    return $aftersplit;
}

sub headers {
    # Convert email headers from text to hash reference
    # @param         [String] heads  Email header data
    # @return        [Hash]          Structured email header data
    my $class = shift;
    my $heads = shift || return undef;
    my $field = shift || [];

    my $currheader = '';
    my $allheaders = {};
    my $structured = {};
    my @hasdivided = split("\n", $$heads);

    map { $allheaders->{ $_ } = 1 } (@HeaderList, @RFC3834Set, keys %$ExtHeaders);
    map { $allheaders->{ lc $_ } = 1 } @$field if scalar @$field;
    map { $structured->{ $_ } = undef } @HeaderList;
    map { $structured->{ lc $_ } = [] } keys %$MultiHeads;

    SPLIT_HEADERS: while( my $e = shift @hasdivided ) {
        # Convert email headers to hash
        if( $e =~ /\A([^ ]+?)[:][ ]*(.+?)\z/ ) {
            # split the line into a header name and a header content
            my $lhs = $1;
            my $rhs = $2;
            $currheader = lc $lhs;
            next unless exists $allheaders->{ $currheader };

            if( exists $MultiHeads->{ $currheader } ) {
                # Such as 'Received' header, there are multiple headers in a single
                # email message.
                $rhs =~ y/\t/ /;
                $rhs =~ y/ //s;
                push @{ $structured->{ $currheader } }, $rhs;

            } else {
                # Other headers except "Received" and so on
                if( $ExtHeaders->{ $currheader } ) {
                    # MTA specific header
                    push @$TryOnFirst, keys %{ $ExtHeaders->{ $currheader } };
                }
                $structured->{ $currheader } = $rhs;
            }
        } elsif( $e =~ /\A[ \t]+(.+?)\z/ ) {
            # Ignore header?
            next if exists $IgnoreList->{ $currheader };

            # Header line continued from the previous line
            if( ref $structured->{ $currheader } eq 'ARRAY' ) {
                # Concatenate a header which have multi-lines such as 'Received'
                $structured->{ $currheader }->[-1] .= ' '.$1;

            } else {
                $structured->{ $currheader } .= ' '.$1;
            }
        }
    }
    return $structured;
}

sub makeorder {
    # Check headers for detecting MTA module and returns the order of modules
    # @param         [Hash] heads   Email header data
    # @return        [Array]        Order of MTA modules
    my $class = shift;
    my $heads = shift || return [];
    my $order = [];

    return [] unless exists $heads->{'subject'};
    return [] unless $heads->{'subject'};

    # Try to match the value of "Subject" with patterns generated by
    # Sisimai::Order::Email->by('subject') method
    my $title = lc $heads->{'subject'};
    for my $e ( keys %$SubjectTab ) {
        # Get MTA list from the subject header
        next if index($title, $e) == -1;

        # Matched and push MTA list
        push @$order, @{ $SubjectTab->{ $e } };
        last;
    }
    return $order;
}

sub takeapart {
    # Take each email header in the original message apart
    # @param         [String] heads The original message header
    # @return        [Hash]         Structured message headers
    my $class = shift;
    my $heads = shift || return {};
    $$heads =~ s/^[>]+[ ]//mg;  # Remove '>' indent symbol of forwarded message

    my $takenapart = {};
    my @hasdivided = split("\n", $$heads);
    my $previousfn = ''; # Previous field name
    my $mimeborder = {};

    for my $e ( @hasdivided ) {
        # Header name as a key, The value of header as a value
        if( $e =~ /\A([-0-9A-Za-z]+?)[:][ ]*(.*)\z/ ) {
            # Header
            my $lhs = lc $1;
            my $rhs = $2;
            $previousfn = '';

            next unless exists $RFC822Head->{ $lhs };
            $previousfn = $lhs;
            $takenapart->{ $previousfn } //= $rhs;

        } else {
            # Continued line from the previous line
            next unless $e =~ /\A[ \t]+/;
            next unless $previousfn;

            # Concatenate the line if it is the value of required header
            if( Sisimai::MIME->is_mimeencoded(\$e) ) {
                # The line is MIME-Encoded test
                if( $previousfn eq 'subject' ) {
                    # Subject: header
                    $takenapart->{ $previousfn } .= $BorderLine.$e;

                } else {
                    # Is not Subject header
                    $takenapart->{ $previousfn } .= $e;
                }
                $mimeborder->{ $previousfn } = 1;

            } else {
                # ASCII Characters only: Not MIME-Encoded
                $e =~ s/\A[ \t]+//; # unfolding
                $takenapart->{ $previousfn }  .= $e;
                $mimeborder->{ $previousfn } //= 0;
            }
        }
    }

    if( $takenapart->{'subject'} ) {
        # Convert MIME-Encoded subject
        my $v = $takenapart->{'subject'};

        if( Sisimai::String->is_8bit(\$v) ) {
            # The value of ``Subject'' header is including multibyte character,
            # is not MIME-Encoded text.
            $v = 'MULTIBYTE CHARACTERS HAVE BEEN REMOVED';

        } else {
            # MIME-Encoded subject field or ASCII characters only
            my $r = [];

            if( $mimeborder->{'subject'} ) {
                # split the value of Subject by $borderline
                for my $m ( split($BorderLine, $v) ) {
                    # Insert value to the array if the string is MIME
                    # encoded text
                    push @$r, $m if Sisimai::MIME->is_mimeencoded(\$m);
                }
            } else {
                # Subject line is not MIME encoded
                $r = [$v];
            }
            $v = Sisimai::MIME->mimedecode($r);
        }
        $takenapart->{'subject'} = $v;
    } 
    return $takenapart;
}

sub parse {
    # Parse bounce mail with each MTA module
    # @param               [Hash] argvs    Processing message entity.
    # @param options argvs [Hash] mail     Email message entity
    # @param options mail  [String] from   From line of mbox
    # @param options mail  [Hash]   header Email header data
    # @param options mail  [String] rfc822 Original message part
    # @param options mail  [Array]  ds     Delivery status list(parsed data)
    # @param options argvs [String] body   Email message body
    # @param options argvs [Code]   hook   Hook method to be called
    # @return              [Hash]          Parsed and structured bounce mails
    my $class = shift;
    my $argvs = { @_ };

    my $mesgentity = $argvs->{'mail'} || return '';
    my $bodystring = $argvs->{'body'} || return '';
    my $hookmethod = $argvs->{'hook'} || undef;
    my $havecaught = undef;
    my $mailheader = $mesgentity->{'header'};

    # PRECHECK_EACH_HEADER:
    # Set empty string if the value is undefined
    $mailheader->{'from'}         //= '';
    $mailheader->{'subject'}      //= '';
    $mailheader->{'content-type'} //= '';

    if( ref $hookmethod eq 'CODE' ) {
        # Call hook method
        my $p = { 
            'datasrc' => 'email',
            'headers' => $mailheader, 
            'message' => $$bodystring,
            'bounces' => undef,
        };
        eval { $havecaught = $hookmethod->($p) };
        warn sprintf(" ***warning: Something is wrong in hook method:%s", $@) if $@;
    }

    # Decode BASE64 Encoded message body
    my $mesgformat = lc($mailheader->{'content-type'} || '');
    my $ctencoding = lc($mailheader->{'content-transfer-encoding'} || '');

    if( index($mesgformat, 'text/plain') == 0 || index($mesgformat, 'text/html') == 0 ) {
        # Content-Type: text/plain; charset=UTF-8
        if( $ctencoding eq 'base64' ) {
            # Content-Transfer-Encoding: base64
            $bodystring = Sisimai::MIME->base64d($bodystring);

        } elsif( $ctencoding eq 'quoted-printable' ) {
            # Content-Transfer-Encoding: quoted-printable
            $bodystring = Sisimai::MIME->qprintd($bodystring);
        }

        # Content-Type: text/html;...
        $bodystring = Sisimai::String->to_plain($bodystring, 1) if $mesgformat =~ m|text/html;?|;
    } else {
        # NOT text/plain
        if( index($mesgformat, 'multipart/') == 0 ) {
            # In case of Content-Type: multipart/*
            my $p = Sisimai::MIME->makeflat($mailheader->{'content-type'}, $bodystring);
            $bodystring = $p if length $$p;
        }
    }

    # EXPAND_FORWARDED_MESSAGE:
    # Check whether or not the message is a bounce mail.
    # Pre-Process email body if it is a forwarded bounce message.
    # Get the original text when the subject begins from 'fwd:' or 'fw:'
    if( lc($mailheader->{'subject'}) =~ /\A[ \t]*fwd?:/ ) {
        # Delete quoted strings, quote symbols(>)
        $$bodystring =~ s/^[>]+[ ]//gm;
        $$bodystring =~ s/^[>]$//gm;
    }
    $$bodystring .= $EndOfEmail;

    my $haveloaded = {};
    my $hasscanned = undef;
    my $modulepath = '';

    SCANNER: while(1) {
        # 1. Sisimai::ARF 
        # 2. User-Defined Module
        # 3. MTA Module Candidates to be tried on first
        # 4. Sisimai::Bite::Email::*
        # 5. Sisimai::RFC3464
        # 6. Sisimai::RFC3834
        #
        if( Sisimai::ARF->is_arf($mailheader) ) {
            # Feedback Loop message
            $hasscanned = Sisimai::ARF->scan($mailheader, $bodystring);
            last(SCANNER) if $hasscanned;
        }

        USER_DEFINED: for my $r ( @$ToBeLoaded ) {
            # Call user defined MTA modules
            next if exists $haveloaded->{ $r };
            $hasscanned = $r->scan($mailheader, $bodystring);
            $haveloaded->{ $r } = 1;
            last(SCANNER) if $hasscanned;
        }

        TRY_ON_FIRST: while( my $r = shift @$TryOnFirst ) {
            # Try MTA module candidates which are detected from MTA specific
            # mail headers on first
            next if exists $haveloaded->{ $r };
            ($modulepath = $r) =~ s|::|/|g; 
            require $modulepath.'.pm';
            $hasscanned = $r->scan($mailheader, $bodystring);
            $haveloaded->{ $r } = 1;
            last(SCANNER) if $hasscanned;
        }

        DEFAULT_LIST: for my $r ( @$DefaultSet ) {
            # MTA modules which does not have MTA specific header and did not
            # match with any regular expressions of Subject header.
            next if exists $haveloaded->{ $r };
            ($modulepath = $r) =~ s|::|/|g; 
            require $modulepath.'.pm';
            $hasscanned = $r->scan($mailheader, $bodystring);
            $haveloaded->{ $r } = 1;
            last(SCANNER) if $hasscanned;
        }

        # When the all of Sisimai::Bite::Email::* modules did not return bounce
        # data, call Sisimai::RFC3464;
        require Sisimai::RFC3464;
        $hasscanned = Sisimai::RFC3464->scan($mailheader, $bodystring);
        last(SCANNER) if $hasscanned;

        # Try to parse the message as auto reply message defined in RFC3834
        $hasscanned = Sisimai::RFC3834->scan($mailheader, $bodystring);
        last(SCANNER) if $hasscanned;

        # as of now, we have no sample email for coding this block
        last;
    } # End of while(SCANNER)

    $hasscanned->{'catch'} = $havecaught if $hasscanned;
    return $hasscanned;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Message::Email - Convert bounce email text to data structure.

=head1 SYNOPSIS

    use Sisimai::Mail;
    use Sisimai::Message;

    my $mailbox = Sisimai::Mail->new('/var/mail/root');
    while( my $r = $mailbox->read ) {
        my $p = Sisimai::Message->new('data' => $r, 'input' => 'email');
    }

    my $notmail = '/home/neko/Maildir/cur/22222';   # is not a bounce email
    my $mailobj = Sisimai::Mail->new($notmail);
    while( my $r = $mailobj->read ) {
        my $p = Sisimai::Message->new('data' => $r, 'input' => 'email');
        # $p is "undef"
    }

=head1 DESCRIPTION

Sisimai::Message::Email convert bounce email text to data structure. It resolve
email text into an UNIX From line, the header part of the mail, delivery status,
and RFC822 header part. When the email given as a argument of "new()" method is
not a bounce email, the method returns "undef".

=head1 CLASS METHODS

=head2 C<B<new(I<Hash reference>)>>

C<new()> is a constructor of Sisimai::Message

    my $mailtxt = 'Entire email text';
    my $message = Sisimai::Message->new('data' => $mailtxt);

If you have implemented a custom MTA module and use it, set the value of "load"
in the argument of this method as an array reference like following code:

    my $message = Sisimai::Message->new(
                        'data' => $mailtxt,
                        'load' => ['Your::Custom::MTA::Module']
                  );

Beginning from v4.19.0, `hook` argument is available to callback user defined
method like the following codes:

    my $cmethod = sub {
        my $argv = shift;
        my $data = {
            'queue-id' => '',
            'x-mailer' => '',
            'precedence' => '',
        };

        # Header part of the bounced mail
        for my $e ( 'x-mailer', 'precedence' ) {
            next unless exists $argv->{'headers'}->{ $e };
            $data->{ $e } = $argv->{'headers'}->{ $e };
        }

        # Message body of the bounced email
        if( $argv->{'message'} =~ /^X-Postfix-Queue-ID:\s*(.+)$/m ) {
            $data->{'queue-id'} = $1;
        }

        return $data;
    };

    my $message = Sisimai::Message->new(
        'data' => $mailtxt, 
        'hook' => $cmethod,
        'field' => ['X-Mailer', 'Precedence']
    );
    print $message->catch->{'x-mailer'};    # Apple Mail (2.1283)
    print $message->catch->{'queue-id'};    # 2DAEB222022E
    print $message->catch->{'precedence'};  # bulk

=head1 INSTANCE METHODS

=head2 C<B<(from)>>

C<from()> returns the UNIX From line of the email.

    print $message->from;

=head2 C<B<header()>>

C<header()> returns the header part of the email.

    print $message->header->{'subject'};    # Returned mail: see transcript for details

=head2 C<B<ds()>>

C<ds()> returns an array reference which include contents of delivery status.

    for my $e ( @{ $message->ds } ) {
        print $e->{'status'};   # 5.1.1
        print $e->{'recipient'};# neko@example.jp
    }

=head2 C<B<rfc822()>>

C<rfc822()> returns a hash reference which include the header part of the original
message.

    print $message->rfc822->{'from'};   # cat@example.com
    print $message->rfc822->{'to'};     # neko@example.jp

=head2 C<B<catch()>>

C<catch()> returns any data generated by user-defined method passed at the `hook`
argument of new() constructor.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

