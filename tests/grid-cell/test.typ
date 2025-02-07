// Synopsis:
// - passing a grid sub element works as expected

#import "/tests/util.typ": *
#import "/src/lib.typ" as subpar

#subpar.grid(
  grid.cell([#figure(fake-image, caption: [Inner Caption]) <1a>], colspan: 2),
  figure(fake-image, caption: [Inner Caption]), <1b>,
  grid.vline(),
  figure(fake-image, caption: [Inner Caption]), <1c>,
  grid.hline(),
  columns: (1fr, 1fr),
  caption: [Super],
  label: <1>,
)
