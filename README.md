# subpar
**NOTE: This package is not yet released and undocumented as I hash out the exact API and work out the kinks.**

Subpar is a [Typst] package allowing you to create easily referencable subfigures.

```typst
#import "@preview/subpar:0.0.1": subpar, super-figure
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
```
![ex]

[ex]: /examples/example.png

[Typst]: https://typst.app/
