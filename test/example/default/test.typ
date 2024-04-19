#import "/test/util.typ": *

#import "/src/lib.typ": subpar, subpar-grid

#outline(target: figure.where(kind: image))

#figure(fake-image, caption: [aaa])

#subpar(
  grid(columns: (1fr, 1fr), gutter: 1em, align: horizon,
    [#figure(fake-image, caption: [Inner caption]) <a>],
    [#figure(fake-image, caption: [Inner caption]) <b>],
  ),
  caption: [Outer caption],
  label: <full1>,
)

#figure(
  fake-image,
  caption: [aaa],
)

#subpar-grid(columns: (1fr, 1fr),
  (figure(`adas`, caption: [Inner caption]), <c>),
  (figure(fake-image, caption: [Inner caption]), <d>),
  caption: [Outer caption],
  label: <full2>,
)

#figure(
  fake-image,
  caption: [aaa],
)

See @full1, @a and @b.

See also @full2, @c and @d.
