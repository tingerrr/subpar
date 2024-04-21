// Synopsis:
// - references in text and outlines and figures themselves are correctly numbered
// - the super figure supplement is propagated down to sub figures

#import "/test/util.typ": *
#import "/src/lib.typ": subpar-grid

#outline(target: figure.where(kind: image))

#figure(fake-image, caption: [aaa])

#subpar-grid(
  (figure(fake-image, caption: [Inner caption]),<a>),
  (figure(fake-image, caption: [Inner caption]),<b>),
  columns: (1fr, 1fr),
  caption: [Outer caption],
  label: <full1>,
)

#figure(fake-image, caption: [aaa])

#subpar-grid(
  (figure(`adas`, caption: [Inner caption]), <c>),
  (figure(fake-image, caption: [Inner caption]), <d>),
  columns: (1fr, 1fr),
  caption: [Outer caption],
  label: <full2>,
)

#figure(fake-image, caption: [aaa])

See @full1, @a and @b.

See also @full2, @c and @d.
