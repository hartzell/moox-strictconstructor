package MooX::StrictConstructor;

# ABSTRACT: Make your Moo-based object constructors blow up on unknown attributes.

=head1 SYNOPSIS

    package My::Class;

    use Moo;
    use Moo::StrictConstructor;

    has 'size' => ( is => 'rw');

    # then somewhere else, when constructing a new instance
    # of My::Class ...

    # this blows up because color is not a known attribute
    My::Class->new( size => 5, color => 'blue' );

=head1 DESCRIPTION

Simply loading this module makes your constructors "strict". If your
constructor is called with an attribute init argument that your class does not
declare, then it dies. This is a great way to catch small typos.

=head2 STANDING ON THE SHOULDERS OF ...

Most of this package was lifted from L<MooX::InsideOut> and most of the Role
that implements the strictness was lifed from L<MooseX::StrictConstructor>.

=cut

use strictures 1;

use Moo ();
use Moo::Role ();

sub import {
    my $class  = shift;
    my $target = caller;
    unless ( $Moo::MAKERS{$target} && $Moo::MAKERS{$target}{is_class} ) {
        die "MooX::StrictConstructor can only be used on Moo classes.";
    }

    Moo::Role->apply_roles_to_object(
        Moo->_constructor_maker_for($target),
        'Method::Generate::Constructor::Role::StrictConstructor',
    );

    # make sure we have our own constructor
#    Moo->_constructor_maker_for($target);
}

=head1 SEE ALSO

=for :list
* L<MooX::InsideOut>
* L<MooseX::StrictConstructor>

=cut

1;
