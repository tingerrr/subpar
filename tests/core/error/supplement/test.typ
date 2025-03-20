/// Synopsis:
/// - Custom kind requires explicit supplement if propagation is set to true

#import "/tests/util.typ": *
#import "/src/lib.typ" as subpar

#let error = catch(() => subpar.super(
  kind: "foo",
  propagate-supplement: true,
  supplement: auto,
  figure(fake-image),
))

#assert.eq(error, "panicked with: " + repr("Cannot infer `supplement`, must be set"))
