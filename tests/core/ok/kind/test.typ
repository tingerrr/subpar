/// Synopsis:
/// - default kind is figure and is not inferred from content
/// - the super supplement is propagated down by default
/// - same kind correctly usese same counter

#import "/tests/util.typ": *
#import "/src/lib.typ" as subpar

// figure by default regardless of inner content
#subpar.grid(
  figure(```typst = Hello World```, caption: [Inner Caption]), <1a>,
  figure(```typst = Hello World```, caption: [Inner Caption]), <1b>,
  columns: (1fr, 1fr),
  caption: [Super],
  label: <1>,
)

// setting it propagates the inferred supplement down
#subpar.grid(
  figure(```typst = Hello World```, caption: [Inner Caption]), <2a>,
  figure(```typst = Hello World```, caption: [Inner Caption]), <2b>,
  columns: (1fr, 1fr),
  caption: [Super],
  kind: raw,
  label: <2>,
)

// turning off propagation causes different supplements for super and sub figures
#subpar.grid(
  figure(table[A], caption: [Inner Caption]), <3a>,
  figure(table[A], caption: [Inner Caption]), <3b>,
  columns: (1fr, 1fr),
  caption: [Super],
  propagate-supplement: false,
  label: <3>,
)

@1, @1a, @1b

@2, @2a, @2b

@3, @3a, @3b
