#import "/src/lib.typ": subpar

#set page(height: auto)
#set par(justify: true)

#subpar(
  grid(columns: (1fr, 1fr), gutter: 1em,
    [#figure(image("/assets/andromeda.jpg"), caption: [
      An image of the andromeda galaxy.
    ]) <a>],
    [#figure(image("/assets/mountains.jpg"), caption: [
      A sunset illuminating the sky above a mountain range.
    ]) <b>],
  ),
  caption: [A figure composed of two subfigures.],
  label: <full>,
)

Above in @full, we see a figure which is composed of 2 other figures, namely @a and @b.
