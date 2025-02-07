/// Synopsis:
///

#import "/tests/util.typ": *
#import "/src/lib.typ" as subpar

#subpar.grid(
  figure(fake-image, caption: [Inner Caption]), <1a>,
  figure(fake-image, caption: [Inner Caption]), <1b>,
  columns: (1fr, 1fr),
  caption: [Super],
  label: <1>,
)
