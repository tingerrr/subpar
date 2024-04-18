# subpar
**NOTE: This package is not yet released and undocumented as I hash out the exact API and work out the kinks. You can help by trying it out locally and reporting issues as you encounter them.**

Subpar is a [Typst] package allowing you to create easily referencable subfigures.

```typst
#import "@preview/subpar:0.0.1": subpar, super-figure
#show: subpar

#set page(height: auto)
#set par(justify: true)

#super-figure(
  grid(columns: (1fr, 1fr), gutter: 1em,
    [#figure(image("/assets/andromeda.jpg"), caption: [
      An image of the andromeda galaxy.
    ]) <a>],
    [#figure(image("/assets/mountains.jpg"), caption: [
      A sunset illuminating the sky above a mountain range.
    ]) <b>],
  ),
  caption: [A figure composed of two subfigures.],
) <full>

Above in @full, we see a figure which is composed of 2 other figures, namely @a and @b.
```
![ex]

## Known Issues
- Relative numbering is incorrect for super-figures, see [#1]
- Supplement is always "Figure", regardless of `text.lang`, see: [#2]
- Figure show rule cannot be easily reconfigured

## TODO
The following tasks remain before the first version of subpar is released:
- [ ] documentation
- [ ] allow more control over figure layout
- [ ] allow show subfigures in outline with indentation
- [ ] add convenient warppers for common types of super figures
- [ ] add input validation
- [ ] add a more comprehensive test suite

[ex]: /examples/example.png

[Typst]: https://typst.app/

[#1]: https://github.com/tingerrr/subpar/issues/1
[#2]: https://github.com/tingerrr/subpar/issues/2
