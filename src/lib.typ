#import "packages.typ": *
#import "core.typ"

/// Enables subpar in your document.
///
/// This is required to be able to reference inner figures and outer figures
/// directly.
///
/// -> function
#let subpar() = body => {
  show ref: it => if core.is-ref-subpar(it) {
    if "outer" in it.element.value.__subpar {
      core.ref-inner(it.target)
    } else {
      core.ref-outer(it.target)
    }
  } else {
    it
  }

  body
}

/// Creates figure containing a grid of sub figures.
///
/// - columns (int):
///   The amount of columns to use for the inner figures.
///
/// - gutter (length):
///   The gutter to use between the inner figures.
///
/// - numbering (function, str):
///   The outer figure numbering, this is used for references to the outer
///   figure and the outer caption directly.
///
/// - inner-caption-numbering (function, str):
///   The inner figure numbering, this is used directly in the inner caption to
///   label the inner figure.
///
/// - inner-cross-ref-numbering (function, str):
///   The inner figure cross reference numbering, this is used for cross
///   references to inner figures from within the same outer figure.
///
/// - inner-ref-numbering (function, str):
///   The inner figure reference numbering, this is used for references to inner
///   figures from the outside the outer figure.
///
/// - supplement (content, str, auto):
///   The supplement for the outer and inner figures.
///
/// - caption (content, str, none):
///   The caption of the outer figure.
///
/// - label (label):
///   The label of the outer figure.
///
/// - inner (arguments):
///   The arguments for the inner figures.
///
/// -> content
#let sub-figures(
  columns: 2,
  gutter: 1em,
  numbering: "1",
  inner-caption-numbering: "(a)",
  inner-cross-ref-numbering: "(a)",
  inner-ref-numbering: "1a)",
  supplement: auto,
  caption: none,
  label: none,
  ..inner,
) = {
  assert.eq(inner.named().len(), 0, message: _oxifmt.strfmt(
    "Expected no extra arguments, found `{}`",
    inner.named(),
  ))

  let inner = inner.pos()

  let outer = core.create-outer-metadata(
    inner-caption-numbering: inner-caption-numbering,
    inner-cross-ref-numbering: inner-cross-ref-numbering,
    inner-ref-numbering: inner-ref-numbering,
    supplement: supplement,
    caption: caption,
    label: label,
  )

  let inner = inner.map(args => core.create-inner-metadata(outer: outer, ..args))

  core.display-outer(
    columns: columns,
    gutter: gutter,
    ..inner,
  )
}
