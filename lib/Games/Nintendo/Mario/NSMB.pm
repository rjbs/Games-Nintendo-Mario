use 5.20.0;
use warnings;
package Games::Nintendo::Mario::NSMB;
# ABSTRACT: a class for stylus-enabled Italian plumbers

use parent qw(Games::Nintendo::Mario);

use Carp ();

=head1 SYNOPSIS

  use Games::Nintendo::Mario::NSMB;

  my $hero = Games::Nintendo::Mario::SMB->new(
   name  => 'Luigi',
   state => 'normal',
  );

  $hero->powerup('mushroom'); # doop doop doop!
  $hero->powerup('flower');   # change clothes

  $hero->damage for (1 .. 2); # cue the Mario Death Music

=head1 DESCRIPTION

This class subclasses Games::Nintendo::Mario, providing a model of the behavior
of the Mario Brothers in New Super Mario Brothers.  All of the methods
described in the Mario interface exist as documented.

=head2 NAMES

The plumber may be named Mario or Luigi.

=head2 STATES

The plumber's state may be any of: normal super fire shell mini mega

=head2 POWERUPS

Valid powerups are: mushroom flower shell mega_mushroom mini_mushroom

=method games

This ruleset reflects Mario in New Super Mario Bros., the first SMB game for
Nintendo DS.

=cut

sub _names  { qw[Mario Luigi] }
sub _states { qw[normal super fire shell mini mega] }
sub _items  { qw[mushroom flower shell mega_mushroom mini_mushroom] }

my %__default_behavior = (
  damage   => 'dead',
  mushroom => 'super',
  flower   => 'fire',
  shell    => 'shell',
  mega_mushroom => 'mega',
  mini_mushroom => 'mini',
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
);

sub games {
  return ('New Super Mario Bros.');
}

sub _set_state {
  my ($self, $state, $item) = @_;

  if ($state eq 'save') {
    $self->{saved_item} = $item;
  } else {
    $self->{state} = $state;
  }
  return $self;
}

sub powerup {
  my ($self, $item) = @_;

  my $state = $self->state;
  Carp::confess "current state unknown"
    unless my $state_info = $state{ $state };

  Carp::confess "behavior for $item in $state unknown"
    unless my $new_state = $state_info->{$item};
  $self->_set_state($new_state, $item);
}

sub damage {
  my ($self) = @_;
  $self->powerup('damage');
}

"Go Wigi!";
