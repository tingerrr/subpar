// Synopsis:
// - adding contextual numbering like chapter-relative numbering preserves the correct subfigure
//   numbering and supplements

#import "/test/util.typ": *
#import "/src/lib.typ": subpar

#let sub-figure-numbering = (super, sub) => numbering("1.1a", counter(heading).get().first(), super, sub)
#let figure-numbering = super => numbering("1.1", counter(heading).get().first(), super)

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => counter(figure.where(kind: image)).update(0) + it
#show figure.where(kind: image): set figure(numbering: figure-numbering)

#let subpar = subpar.with(
  numbering: figure-numbering,
  numbering-sub-ref: sub-figure-numbering,
)

#outline(target: figure.where(kind: image))

= Chapter

#figure(fake-image, caption: [aaa])

#subpar(
  grid(columns: (1fr, 1fr),
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

#subpar(
  grid(columns: (1fr, 1fr),
    [#figure(`adas`, caption: [Inner caption]) <c>],
    [#figure(fake-image, caption: [Inner caption]) <d>],
  ),
  caption: [Outer caption],
  label: <full2>,
)

= Another Chapter

#figure(
  fake-image,
  caption: [aaa],
)

See @full1, @a and @b.

See also @full2, @c and @d.
