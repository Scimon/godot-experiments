#!/usr/bin/env raku

use v6;
use GD;

constant MIN_VAL = 0;
constant FULL = "#";
constant EMPTY = " ";
constant ALPHA = "ffffff";
constant GREY = "595652";

sub MAIN(
    UInt :sz(:$image-size) = 32,
    Int :rd(:$radius) where { MIN_VAL < $_ <= ($image-size / 2) } = floor(($image-size / 2) - 1),
    Int :er(:$erosion-size) where { 0 < $_ < 5 } = 1,
    Int :rp(:$repitions) where { $_ > 0 } = 1,
    Int :hd(:$hardness) = 0,
    Str :in(:$image-name) = "",
) {   
    my @grid = [ [|(EMPTY xx $image-size)] xx $image-size ];
    @grid = circle( @grid, $radius, $image-size );
    say grid-to-string( @grid ) if ! $image-name;
    for 0..^$repitions {
        @grid = erode(@grid, $erosion-size, $hardness, $image-size);
        say grid-to-string( @grid ) if ! $image-name;
    }
    if ( $image-name ) {
        grid-to-image( @grid, $image-size, $image-name );
    }
}

sub circle( @grid, $radius, $image-size ) {
    my $half = $image-size / 2;
    for 0..^$image-size -> $y {
        for 0..^$image-size -> $x {
            if ($y - $half + 0.5)**2 + ($x - $half + 0.5)**2 <= $radius ** 2 {
                @grid[$y][$x] = FULL;
            }
        }
    }
    return @grid;
}

sub erode( @grid, $e-size, $hardness, $i-size ) {
    my @new-grid = @grid;
    my $max = (($e-size*2)+1) ** 2;
    for 0..^$i-size -> $y {
        for 0..^$i-size -> $x {
            next if @grid[$y][$x] ~~ " ";
            my $count = [+] sub-grid( @grid, $x, $y, $e-size, $i-size-1 ).map( { [+] $_.map( -> $v { $v ~~ FULL } ) } );
            if (0..$max).pick > $count + $hardness {
                @new-grid[$y][$x] = " ";
            }
        }
    }
    for 0..^$i-size -> $y {
        for 0..^$i-size -> $x {
            my $count = [+] sub-grid( @new-grid, $x, $y, 1, $i-size-1 ).map( { [+] $_.map( -> $v { $v ~~ FULL } ) } );
            if @new-grid[$y][$x] ~~ FULL && $count == 1 {
                @new-grid[$y][$x] = " ";
            }
        }
    }
    return @new-grid;
}

sub clamped-range($start, $end, $min, $max) {
    my $s = $start < $min ?? $min !! $start;
    my $e = $end > $max ?? $max !! $end;
    return $s..$e;
}

sub sub-grid( @grid, $x, $y, $size, $max ) {
    @grid[clamped-range($y-$size,$y+$size,MIN_VAL,$max)].map( *[clamped-range($x-$size,$x+$size,MIN_VAL,$max)] );
}

sub grid-to-string( @grid ) {
    @grid.map( *.join("") ).join("\n");
}

sub grid-to-image( @grid, $image-size, $image-name ) {
    my $image = GD::Image.new($image-size, $image-size);
    die "Unable to setup image" unless $image;

    my $alpha = $image.colorAllocate("#{ALPHA}");
    my $grey = $image.colorAllocate("#{GREY}");

    for 0..^$image-size -> $y {
        for 0..^$image-size -> $x {
            if @grid[$y][$x] ~~ FULL {
                $image.pixel( $x, $y, $grey );
            }
        }
    }

    my $png_fh = $image.open("{$image-name}.png", "wb");

    $image.output($png_fh, GD_PNG);

    $png_fh.close;

    $image.destroy();
}
