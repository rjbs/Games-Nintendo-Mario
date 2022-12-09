use 5.20.0;
use warnings;
package Games::Nintendo::Mario::NSMB::Wii;
# ABSTRACT: a class for Italian plumbers who wave their hands around

use parent qw(Games::Nintendo::Mario::NSMB);

=head1 WARNING!!

Nobody has given RJBS a copy of NSMB Wii yet, so he hasn't played it, so this
class may not be an accurate reflection of its behavior.

=head1 SYNOPSIS

  use Games::Nintendo::Mario::NSMB::Wii;

  my $hero = Games::Nintendo::Mario::SMB->new(
    name  => 'Blue Toad',
    state => 'normal',
  );

  $hero->powerup('mushroom'); # doop doop doop!
  $hero->powerup('flower');   # change clothes

  $hero->damage for (1 .. 2); # cue the Mario Death Music

=head1 DESCRIPTION

This class subclasses Games::Nintendo::Mario, providing a model of the behavior
of the Mario Brothers in New Super Mario Bros. for Wii.  All of the methods
described in the Mario interface exist as documented.

=head2 NAMES

The plumber may be named Mario or Luigi, or can be "Blue Toad" or "Yellow
Toad."

=head2 STATES

The plumber's state may be any of: normal super fire shell mini mega ice
penguin propeller

=head2 POWERUPS

Valid powerups are: mushroom flower shell mega_mushroom mini_mushroom
ice_flower penguinsuit propeller_mushroom

=method games

This ruleset reflects Mario in New Super Mario Bros. Wii, the first SMB game
for Nintendo Wii.

=cut

use Carp ();

sub _names  { ('Mario', 'Luigi', 'Blue Toad', 'Yellow Toad') }
sub _states { qw[normal super fire shell mini mega propeller ice penguin] }
sub _items  { qw[mushroom flower shell mega_mushroom mini_mushroom propeller_mushroom ice_flower penguinsuit] }

my %__default_behavior = (
  damage   => 'dead',
  mushroom => 'super',
  flower   => 'fire',
  shell    => 'shell',
  mega_mushroom => 'mega',
  mini_mushroom => 'mini',
  propeller_mushroom => 'propeller',
  ice_flower         => 'ice',
  penguinsuit        => 'penguin',
);

my %state = (
  normal => { %__default_behavior },
  super  => {
    %__default_behavior,
    damage   => 'normal',
    mushroom => 'save',
  },
  fire   => {
    %__default_behavior,
    damage   => 'normal',
    flower   => 'save',
    mushroom => 'save',
  },
  shell  => {
    %__default_behavior,
    damage   => 'super',
    mushroom => 'save',
    flower   => 'save',
  },
  mega   => { map { $_ => 'ignore' } keys %__default_behavior },
  mini   => { %__default_behavior, mini => 'save' },

  propeller  => {
    %__default_behavior,
    damage   => 'normal',
    mushroom => 'save',
  },
  ice  => {
    %__default_behavior,
    damage   => 'normal',
    mushroom => 'save',
  },
  penguin  => {
    %__default_behavior,
    damage   => 'normal',
    mushroom => 'save',
  },
);

sub games {
  return ('New Super Mario Bros. Wii');
}

"Go Wigi!";
