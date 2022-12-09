use 5.20.0;
use warnings;
package Games::Nintendo::Mario::Hearts 0.208;
# ABSTRACT: a superclass for Italian plubmers who can take a beating

use parent qw(Games::Nintendo::Mario);
use Hash::Util::FieldHash qw(fieldhash);

=head1 SYNOPSIS

  use Games::Nintendo::Mario::Hearts;

  my $noone = Games::Nintendo::Mario::Hearts->new;

  print $hero->hearts . '/' . $hero->max_hearts; # at 1/3 health
  $hero->powerup('heart');                       # up to 2/3!
  $hero->powerup('heart');                       # full health!

  print "It's-a me!  ", $hero->name, "!\n";      # 'Mario'

  $hero->powerup('heart');                       # Nothing happens.

  $hero->damage for (1 .. 3);                    # cue the Mario Death Music

=head1 DESCRIPTION

This class subclasses Games::Nintendo::Mario, providing a class for further
subclassing.  It adds the C<hearts> and C<max_hearts> methods, described below,
and it causes Mario to die when his hearts count reaches zero.  This behavior
is found in SMB2 and the Wario games.

All of the methods described in the Mario interface exist as documented, but
the only powerup in this class is 'heart' and the only state is 'normal'

=method hearts

This method returns the number of hearts the plumber currently has.  It
defaults to 1 at creation.

=method max_hearts

This method returns the number of heart containers currently in the plumber's
heart meter.  It defaults to 3 at creation.

=method damage

=method powerup

These methods are defined in Games::Nintendo::Mario.

=method games

This is an abstract subclass for Mario classes, and does not represent any one
game.

=cut


sub _states { qw[normal] }
sub _items  { qw[heart] }
sub _other_defaults  { ( max_hearts => 3 ) }
sub __default_hearts { 1 };

sub _goto_hash { {} } # not used by base Hearts class

sub max_hearts {
  return $_[0]->{max_hearts}
}

fieldhash my %hearts;
sub hearts {
  my ($self) = @_;
  $hearts{ $self } //= $self->__default_hearts;
  return $hearts{ $self };
}

sub powerup {
  my $plumber  = shift;
  my $item     = shift;

  if (($item eq 'heart') and ($plumber->hearts) and ($plumber->hearts < $plumber->max_hearts)) {
    $hearts{ $plumber }++;
  }
  $plumber->SUPER::powerup($item);
}

sub damage {
  my $self = shift;
  my $item = shift;

  if ($self->hearts) {
    $self->{state} = 'dead' unless --$hearts{ $self };
  }

  $self->SUPER::damage;
}

sub games {
  return ();
}

"It's-a me!  Mario!";
