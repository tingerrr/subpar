#import "/src/lib.typ": subpar, super-figure
#show: subpar

#set page(height: auto)
#set par(justify: true)

#super-figure(
  grid(columns: (1fr, 1fr), gutter: 1em,
    [#figure(image("/assets/andromeda.jpg"), caption: [
      An image of the andromeda galaxy.
    ]) <a>],
    [#figure(image("/assets/mountains.jpg"), caption: [
      A sunset illuminating the sky above a mountain range.
    ]) <b>],
  ),
  caption: [A figure composed of two subfigures.],
) <full>

Above in @full, we see a a figure which is composed of 2 other figures, namely @a and @b.
