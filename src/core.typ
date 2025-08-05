#import "packages.typ": *

/// Whether the given ref element is targeting a subpar metadata.
///
/// - it (ref):
///   The ref element to check, this should be fully synthesized, i.e. this
///   function should be called with an instance given to a ref show rule.
///
/// -> bool
#let is-ref-subpar(it) = (
  it.element != none
    and it.element.func() == metadata
    and type(it.element.value) == dictionary
    and "__subpar" in it.element.value
)

/// #property(requires-context: true)
/// Returns a metadata element pointed to by a unique label.
///
/// - label (label):
///   The unique label pointing to the inner or outer figure metadata.
///
/// -> dictionary
#let get-unique-subpar-metadata(label) = {
  let candidates = query(label)

  assert.eq(candidates.len(), 1, message: _oxifmt.strfmt(
    "Expected exactly one element, found `{}` with label `<{}>`",
    candidates.len(),
    label,
  ))

  let element = candidates.first()

  assert.eq(element.func(), metadata, message: _oxifmt.strfmt(
    "Expected `metadata` element pointed to by `<{}>`",
    label,
  ))
  assert.eq(type(element.value), dictionary, message: _oxifmt.strfmt(
    "Expected dictionary in metadata element pointed to by `<{}>`",
    label,
  ))
  assert("__subpar" in element.value, message: _oxifmt.strfmt(
    "Expected subpar dictionary in metadata element pointed to by `<{}>`",
    label,
  ))

  element.value.__subpar
}

/// Creates the metadata that is embedded for outer figures.
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
/// - supplement (content, str):
///   The supplement used in the outer caption and references to inner or outer
///   figures from outside the outer figure.
///
/// - caption (content, str, none):
///   The outer caption body.
///
/// - label (label):
///   The outer figure label.
///
/// -> dictionary
#let create-outer-metadata(
  numbering: "1",
  inner-caption-numbering: "(a)",
  inner-cross-ref-numbering: "(a)",
  inner-ref-numbering: "1a)",
  counter: counter("__subpar:counter"),
  supplement: [Figure],
  caption: none,
  label: none,
) = (
  numbering: numbering,
  inner-caption-numbering: inner-caption-numbering,
  inner-cross-ref-numbering: inner-cross-ref-numbering,
  inner-ref-numbering: inner-ref-numbering,
  counter: counter,
  supplement: supplement,
  caption: caption,
  label: label,
)

/// Creates the metadata that is embedded for inner figures.
///
/// - outer: (dictionary):
///   The outer figure metadata.
///
/// - caption (content, str, none),
///   The caption body.
///
/// - label (label):
///   The inner figure label.
///
/// - body (content, str):
///   The figure content.
///
/// -> dictionary
#let create-inner-metadata(
  outer: (:),
  caption: none,
  label: none,
  body,
) = (
  outer: outer,
  caption: caption,
  label: label,
  body: body,
)

/// The state tracking the currently active outer figure.
///
/// This is used in reference checks to detect inner cross references.
#let active-outer-state = state("__subpar:active-outer-state", none)

/// Embeds the inner figure metadata dictionary in an actual metadata element
/// and steps the counter.
///
/// - inner (dictionary):
///   The inner figure metadata dictionary.
///
/// -> content
#let embed-inner(inner) = {
  inner.outer.counter.step(level: 2)
  [#metadata((__subpar: inner))#inner.label]
}

/// Embeds the outer figure metadata dictionary in an actual metadata element
/// and steps the counter.
///
/// - inner (dictionary):
///   The inner figure metadata dictionary.
///
/// -> content
#let embed-outer(outer) = {
  outer.counter.step(level: 1)
  [#metadata((__subpar: outer))#outer.label]
}

/// Displays the given inner figure body.
///
/// - inner (dictionary):
///   The inner figure metadata dictionary.
///
/// -> content
#let display-inner-body(inner) = inner.body

/// #property(requires-context: true)
/// Displays the given inner figure caption.
///
/// - inner (dictionary):
///   The inner figure metadata dictionary.
///
/// -> content
#let display-inner-caption(inner) = grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  align: (left, left),
  numbering(inner.outer.inner-caption-numbering, inner.outer.counter.get().at(1)),
  inner.caption,
)

/// #property(requires-context: true)
/// Displays the given outer figure caption.
///
/// - outer (dictionary):
///   The outer figure metadata dictionary.
///
/// -> content
#let display-outer-caption(outer) = grid(
  columns: 2,
  column-gutter: 1em,
  align: (left, left),
  {
    outer.supplement
    [ ]
    numbering(outer.numbering, outer.counter.get().at(0))
    [: ]
  },
  outer.caption,
)

/// #property(requires-context: true)
/// Displays the given inner figures as outer figure containing the inne figures
/// as a grid.
///
/// - columns (int):
///   The amount of columns to use for the inner figures.
///
/// - gutter (length):
///   The gutter to use between the inner figures.
///
/// - inner (dictionary):
///   The inner figure metadata dictionaries, these should all have the same
///   outer metadata.
///
/// -> content
#let display-outer(
  columns: 2,
  gutter: 1em,
  ..inner,
) = {
  assert.eq(inner.named().len(), 0, message: _oxifmt.strfmt(
    "Expected no extra arguments, found `{}`",
    inner.named(),
  ))

  let inner = inner.pos()

  assert(inner.len() >= 1, message: "Expected at least one inner figure")

  // fill the figures with `none` at the end to make figure-caption
  // balancing simpler
  while calc.rem(inner.len(), columns) != 0 {
    inner.push(none)
  }

  let outer = inner.first().outer

  let bodies = inner.map(f => if f != none {
    embed-inner(f)
    display-inner-body(f)
  }).chunks(columns)

  let captions = inner.map(f => if f != none {
    context display-inner-caption(f)
  }).chunks(columns)

  let cells = array.zip(bodies, captions).flatten()

  block({
    active-outer-state.update(outer)

    set align(center)
    embed-outer(outer)
    grid(
      columns: columns,
      gutter: 1em,
      align: (_, y) => if calc.rem(y, 2) == 0 { bottom } else { top },
      ..cells
    )

    if outer.caption != none {
      context display-outer-caption(outer)
    }

    active-outer-state.update(none)
  })
}

/// #property(requires-context: true)
/// Reference an inner figure with the given label.
///
/// If this is called inside the same outer figure the inner figure the label
/// points to is contained in, then it uses the secondary display.
///
/// - label (label):
///   The unique label pointing to the inner figure to reference.
///
/// -> content
#let ref-inner(label) = {
  let inner = get-unique-subpar-metadata(label)
  let loc = locate(label)

  let outer = active-outer-state.get()
  let counter = inner.outer.counter.at(loc)

  if outer == inner.outer {
    numbering(inner.outer.inner-cross-ref-numbering, counter.at(1))
  } else {
    inner.outer.supplement
    [ ]
    numbering(inner.outer.inner-ref-numbering, ..counter)
  }
}

/// #property(requires-context: true)
/// Reference an outer figure with the given label.
///
/// - label (label):
///   The unique label pointing to the outer figure to reference.
///
/// -> content
#let ref-outer(label) = {
  let outer = get-unique-subpar-metadata(label)
  let loc = locate(label)

  let counter = outer.counter.at(loc)

  outer.supplement
  [ ]
  numbering(outer.numbering, counter.at(0))
}
