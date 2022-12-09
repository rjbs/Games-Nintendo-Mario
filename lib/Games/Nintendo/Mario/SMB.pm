use 5.20.0;
use warnings;
package Games::Nintendo::Mario::SMB;
# ABSTRACT: a class for mushroom-eating Italian plumbers

use parent qw(Games::Nintendo::Mario);

=head1 SYNOPSIS

  use Games::Nintendo::Mario::SMB;

  my $hero = Games::Nintendo::Mario::SMB->new(
    name  => 'Luigi',
    state => 'normal',
  );

  $hero->powerup('mushroom'); # doop doop doop!
  $hero->powerup('flower');   # change clothes

  $hero->damage for (1 .. 2); # cue the Mario Death Music

=head1 DESCRIPTION

This class subclasses Games::Nintendo::Mario, providing a model of the behavior
of the Mario Brothers in Super Mario Brothers.  All of the methods described in
the Mario interface exist as documented.

=head2 NAMES

The plumber may be named Mario or Luigi.

=head2 STATES

The plumber's state may be any of: C<normal>, C<super>, or C<fire>

=head2 POWERUPS

Valid powerups are: C<mushroom> and C<flower>

=method games

This ruleset reflects Mario in Super Mario Bros., the original SMB game.

=cut

sub _names  { qw[Mario Luigi] }
sub _states { qw[normal super fire] }
sub _items  { qw[mushroom flower] }

sub _goto_hash {
  {
    damage => {
      normal => 'dead',
      _else  => 'normal'
    },
    mushroom => {
      fire  => 'fire',
      _else => 'super',
    },
    flower => {
      normal => 'super',
      _else  => 'fire'
    }
  }
}

sub games {
  return ('Super Mario Bros.');
}

"It's-a me!  Mario!";
