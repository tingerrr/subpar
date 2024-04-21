#import "/src/lib.typ": subpar-grid

#set page(height: auto)
#set par(justify: true)

#subpar-grid(
  (figure(image("/assets/andromeda.jpg"), caption: [
    An image of the andromeda galaxy.
  ]), <a>),
  (figure(image("/assets/mountains.jpg"), caption: [
    A sunset illuminating the sky above a mountain range.
  ]), <b>),
  columns: (1fr, 1fr),
  align: top,
  caption: [A figure composed of two sub figures.],
  label: <full>,
)

Above in @full, we see a figure which is composed of two other figures, namely @a and @b.
