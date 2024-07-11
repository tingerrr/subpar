// Synopsis:
// - adding contextual numbering like chapter-relative numbering preserves the correct subfigure
//   numbering and supplements

#import "/test/util.typ": *
#import "/src/lib.typ" as subpar

#let sub-figure-numbering = (super, sub) => numbering("1.1a", counter(heading).get().first(), super, sub)
#let figure-numbering = super => numbering("1.1", counter(heading).get().first(), super)

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => counter(figure.where(kind: image)).update(0) + it
#show figure.where(kind: image): set figure(numbering: figure-numbering)

#let subpar-grid = subpar.grid.with(
  numbering: figure-numbering,
  numbering-sub-ref: sub-figure-numbering,
)

#outline(target: figure.where(kind: image))

= Chapter

#figure(fake-image, caption: [aaa])

#subpar-grid(
  figure(fake-image, caption: [Inner caption]), <1a>,
  figure(fake-image, caption: [Inner caption]), <1b>,
  columns: (1fr, 1fr),
  caption: [Outer caption],
  label: <1>,
)

#figure(fake-image, caption: [aaa])

#subpar-grid(
  figure(`adas`, caption: [Inner caption]), <2a>,
  figure(fake-image, caption: [Inner caption]), <2b>,
  columns: (1fr, 1fr),
  caption: [Outer caption],
  label: <2>,
)

= Another Chapter

#figure(fake-image, caption: [aaa])

See @1, @1a and @1b.

See also @2, @2a and @2b.

#subpar-grid(
  figure(`adas`, caption: [Inner caption]), <3a>,
  figure(fake-image, caption: [Inner caption]), <3b>,
  columns: (1fr, 1fr),
  // See: https://github.com/typst/typst/issues/4536
  caption: [Referencing self (#ref(<3>), @3a and @3b) and others (#ref(<1>), @1a and @1b) (#ref(<2>), @2a and @2b)],
  label: <3>,
)
