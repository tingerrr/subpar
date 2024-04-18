#let is-element(value, func) = {
  type(value) == content and value.func() == func
}

#let extract-payload(body) = {
  if not body.has("children") { return }
  if body.children.len() == 0 { return }

  let first = body.children.first()

  if not is-element(first, metadata) { return }
  first.value
}

#let embed-payload(body, ..payload) = {
  metadata(payload.named()) + body
}

#let apply-for-all(
  values,
  rule,
) = outer => {
  show: inner => {
    values.map(rule).fold(inner, (acc, f) => f(acc))
  }

  outer
}
