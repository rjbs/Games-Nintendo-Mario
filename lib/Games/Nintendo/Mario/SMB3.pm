use 5.20.0;
use warnings;
package Games::Nintendo::Mario::SMB3;
# ABSTRACT: a class for fuzzy-tailed Italian plumbers

use parent qw(Games::Nintendo::Mario);

=head1 SYNOPSIS

  use Games::Nintendo::Mario::SMB3;

  my $hero = Games::Nintendo::Mario::SMB->new(
    name  => 'Mario',
    state => 'hammer',
  );
  
  $hero->powerup('mushroom'); # Nothing happens.
  $hero->damage;              # back to super

  print "It's-a me!  ", $hero->name, "!\n"; # 'Super Mario'

  $hero->powerup('frogsuit'); # Nothing happens.

  $hero->damage for (1 .. 2); # cue the Mario Death Music

=head1 DESCRIPTION

This class subclasses Games::Nintendo::Mario, providing a model of the behavior
of the Mario Brothers in Super Mario Brothers 3.  All of the methods described
in the Mario interface exist as documented.

=head2 NAMES

The plumber may be named Mario or Luigi.

=head2 STATES

The plumber's state may be any of: C<normal>, C<super>, C<fire>, C<raccoon>,
C<tanooki>, C<hammer>, C<frog>, or C<pwing>

=head2 POWERUPS

Valid powerups are: C<mushroom>, C<flower>, C<leaf>, C<tanookisuit>,
C<hammersuit>, C<frogsuit>, or C<pwing>

=method games

This ruleset reflects Mario in Super Mario Bros. 3.

=cut

sub _names  { qw[Mario Luigi] }
sub _states { qw[normal super fire raccoon tanooki frog hammer pwing] }
sub _items  { qw[mushroom flower leaf tanookisuit frogsuit hammersuit pwing] }

sub _goto_hash {
  {
    damage    => {
      normal  => 'dead',
      super  => 'normal',
      _else  => 'super'
    },
    mushroom   => {
      normal  => 'super'
    },
    flower    => 'fire',
    leaf    => 'raccoon',
    tanookisuit  => 'tanooki',
    hammersuit  => 'hammer',
    frogsuit  => 'frog',
    pwing    => 'pwing'
  }
}

sub games {
  return ('Super Mario Bros. 3');
}

"It's-a me!  Mario!";
