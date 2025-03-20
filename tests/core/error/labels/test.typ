/// Synopsis:
/// - Double labels cause a panic
/// - Leading labels cause a panic

#import "/tests/util.typ": *
#import "/src/lib.typ" as subpar

#let error = catch(() => subpar.grid(
  <foo>,
  figure(fake-image),
))

#assert.eq(error, "panicked with: " + repr("`label` must follow a content argument"))

#let error = catch(() => subpar.grid(
  figure(fake-image), <foo>, <bar>,
))

#assert.eq(error, "panicked with: " + repr("`label` must follow a content argument"))

#let error = catch(() => subpar.grid(
  grid.cell(figure(fake-image)), <bar>,
))

#assert.eq(error, "panicked with: " + repr("`label` must not follow a `grid` sub element directly, place it after a figure or inside a `grid.cell`"))

