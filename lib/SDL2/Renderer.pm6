
use v6;

unit class SDL2::Renderer;

use NativeCall;
use SDL2::Raw:ver(0.2);
use SDL2::Window;
  
has $.renderer;

method new(
  SDL2::Window $window,
  int32 :$index = -1,
  int32 :$flags = ACCELERATED +| PRESENTVSYNC) {

  my $renderer = SDL_CreateRenderer($window.window, $index, $flags);
  return self.bless(:renderer($renderer));
}

method draw-color(int8 $r, int8 $g, int8 $b, int8 $a) {
  SDL_SetRenderDrawColor($!renderer, $r, $g, $b, $a);
}

method clear {
  SDL_RenderClear($!renderer);
}

method present {
  SDL_RenderPresent($!renderer);
}

method fill-rect(SDL_Rect $rect) {
  SDL_RenderFillRect($!renderer,  $rect);
}

method renderer-info returns SDL_RendererInfo {
  my SDL_RendererInfo $renderer-info .= new;
  SDL_GetRendererInfo($!renderer, $renderer-info);
  return $renderer-info
}

method draw-points(@points) {
  my $points = CArray[int32].new;
  my $index = 0;
  for @points -> $point {
    $points[$index++] = $point<x>;
    $points[$index++] = $point<y>;
  }
  my $num-points = ($index - 1) div 2;
  SDL_RenderDrawPoints($!renderer, $points, $num-points);
}

method destroy {
  SDL_DestroyRenderer($!renderer) if $!renderer.defined;
}
