/// Synopsis:
/// - default supplement is figure
/// - supplement is inferred from kind
/// - set supplement is used and propagated by default
/// - propagation works as expected

#import "/tests/util.typ": *
#import "/src/lib.typ" as subpar

// default supplement is figure
#subpar.grid(
  figure(fake-image, caption: [Inner Caption]), <1a>,
  figure(fake-image, caption: [Inner Caption]), <1b>,
  columns: (1fr, 1fr),
  caption: [Super],
  label: <1>,
)

// supplement is inferred from kind
#subpar.grid(
  figure(fake-image, caption: [Inner Caption]), <2a>,
  figure(fake-image, caption: [Inner Caption]), <2b>,
  columns: (1fr, 1fr),
  caption: [Super],
  kind: raw,
  label: <2>,
)

// set supplement is used and propagated
#subpar.grid(
  figure(fake-image, caption: [Inner Caption]), <3a>,
  figure(fake-image, caption: [Inner Caption]), <3b>,
  columns: (1fr, 1fr),
  caption: [Super],
  supplement: "Image",
  label: <3>,
)

// set supplement is used and not propagated
#subpar.grid(
  figure(fake-image, caption: [Inner Caption]), <4a>,
  figure(fake-image, caption: [Inner Caption]), <4b>,
  columns: (1fr, 1fr),
  caption: [Super],
  supplement: "Image",
  propagate-supplement: false,
  label: <4>,
)

@1, @1a, @1b

@2, @2a, @2b

@3, @3a, @3b

@4, @4a, @4b
