use 5.20.0;
use warnings;
package Games::Nintendo::Mario;
# ABSTRACT: a class for jumping Italian plumbers

=head1 SYNOPSIS

  use Games::Nintendo::Mario;

  my $hero = Games::Nintendo::Mario->new(name => 'Luigi');

  $hero->damage; # cue the Mario Death Music

=head1 DESCRIPTION

This module provides a base class for representing the Mario Brothers from
Nintendo's long-running Mario franchise of games.  Each Mario object keeps
track of the plumber's current state and can be damaged or given powerups to
change his state.

=cut

use Carp qw(cluck);

sub _names  { qw[Mario Luigi] }
sub _states { qw[normal] }
sub _items  { () }
sub _other_defaults { () }

sub _goto_hash   {
  { damage => 'dead' }
}

sub _goto {
  my $self = shift;
  my ($state, $item) = @_;
  my $goto = $self->_goto_hash;

  return unless exists $goto->{$item};
  return $goto->{$item} unless ref $goto->{$item} eq 'HASH';
  return $goto->{$item}{_else} unless $goto->{$item}{$state};
  return $goto->{$item}{$state};
}

=method new

  my $hero = Games::Nintendo::Mario->new(name => 'Luigi');

The constructor for Mario objects takes two named parameters, C<name> and
C<state>.  C<name> must be either "Mario" or "Luigi" and C<state> must be
"normal"

If left undefined, C<name> and C<state> will default to "Mario" and "normal"
respectively.

=cut

sub new {
  my $class = shift;
  my %args  = (name => 'Mario', state => 'normal', @_);

  unless (grep { $_ eq $args{name} } $class->_names) {
    cluck "bad name for plumber";
    return;
  }
  unless (grep { $_ eq $args{state} } $class->_states) {
    cluck "bad starting state for plumber";
    return;
  }

  my $plumber = {
    state => $args{state},
    name  => $args{name},
    $class->_other_defaults
  };

  bless $plumber => $class;
}

=method powerup

  $hero->powerup('hammer'); # this won't work

As the base Games::Nintendo::Mario class represents Mario from the original
Mario Bros., there is no valid way to call this method.  Subclasses
representing Mario in other games may allow various powerup names to be passed.

=cut

sub powerup {
  my $plumber = shift;
  my $item    = shift;

  if ($plumber->state eq 'dead') {
    cluck "$plumber->{name} can't power up when dead";
    return $plumber;
  }

  unless (grep { $_ eq $item } $plumber->_items) {
    cluck "$plumber->{name} can't power up with that!";
    return $plumber;
  }

  my $goto = $plumber->_goto($plumber->state,$item);

  $plumber->{state} = $goto if $goto;

  return $plumber;
}

=method damage

  $hero->damage;

This method causes the object to react as if Mario has been attacked or
damaged.  In the base Games::Nintendo::Mario class, this will always result in
his death.

=cut

sub damage {
  my $plumber = shift;

  my $goto = $plumber->_goto($plumber->state,'damage');

  $plumber->{state} = $goto if $goto;

  return $plumber;
}

=method state

  print $hero->state;

This method accesses the name of Mario's current state.

=cut

sub state { ## no critic Homonym
  my $plumber = shift;

  return $plumber->{state};
}

=method name

  print $hero->name;

This method returns the name of the plumber's current form.  (In the base
class, this is always the same as the name passed to the constructor.)

=cut

sub name {
  my $plumber = shift;

  return $plumber->{name} if $plumber->state eq 'normal';

  my $name = $plumber->state . q{ } . $plumber->{name};
  $name =~ s/(^.)/\u$1/;
  return $name;
}

=method games

  if (grep /World/, $hero->games) { ... }

This returns a list of the games in which Mario behaved according to the model
provided by this class.

=cut

sub games {
  return ('Mario Bros.');
}

=head1 TODO

Wario, SMW.

=cut

"It's-a me!  Mario!";
