package Method::Generate::Constructor::Role::StrictConstructor;

use Moo::Role;
use B ();

around _assign_new => sub {
    my $orig = shift;
    my $self = shift;
    my $spec = $_[0];

    my @attrs = map { B::perlstring($_) . ' => 1,' }
        grep {defined}
        map  { $_->{init_arg} } values(%$spec);

    my $body .= <<"EOF";

    # MooX::StrictConstructor
    my \%attrs = (@attrs);
    my \@bad = sort grep { ! \$attrs{\$_} }  keys \%{ \$args };
    if (\@bad) {
       die("Found unknown attribute(s) passed to the constructor: " .
           join ", ", \@bad);
    }

EOF

    $body .= $self->$orig(@_);

    return $body;
};

1;
