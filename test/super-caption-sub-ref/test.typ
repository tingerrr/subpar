// Synopsis:
// - references to sub figures within the caption of their own super super only
//   display their numbering

#import "/test/util.typ": *
#import "/src/lib.typ" as subpar

#outline(target: figure)

#subpar.grid(
  figure(fake-image, caption: [Inner Caption]), <1a>,
  figure(fake-image, caption: [Inner Caption]), <1b>,
  columns: (1fr, 1fr),
  caption: [Super, consisting of @1a and @1b.],
  label: <1>,
)

#subpar.grid(
  figure(fake-image, caption: [Inner Caption]),
  figure(fake-image, caption: [Inner Caption]),
  columns: (1fr, 1fr),
  caption: [Another super, referencing @1a and @1b, as well as @2a and @2b.],
)

#subpar.grid(
  kind: raw,
  figure(```typst = Hello World```, caption: [Inner Caption]), <2a>,
  figure(```typst = Hello World```, caption: [Inner Caption]), <2b>,
  columns: (1fr, 1fr),
  caption: [Another super, consiting of @2a and @2b and referencing @1a and @1b.],
  label: <2>,
)
