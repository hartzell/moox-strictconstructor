package Method::Generate::Constructor::Role::StrictConstructor;

# ABSTRACT: a role to make Moo constructos strict.

=head1 DESCRIPTION

This role wraps L<Method::Generate::Constructor/_assign_new> with a bit of code
that ensures that all arguments passed to the constructor are valid init_args
for the class.

=head2 STANDING ON THE SHOULDERS OF ...

This code would not exist without the examples in L<MooX::InsideOut> and
L<MooseX::StrictConstructor>.

=cut

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

=head1 SEE ALSO

=for :list
* L<MooX::InsideOut>
* L<MooseX::StrictConstructor>

=cut

1;
