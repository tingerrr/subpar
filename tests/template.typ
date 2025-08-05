/// Synopsis:
///

#import "/tests/util.typ": *
#import "/src/lib.typ": subpar, sub-figures

#show: subpar()

#sub-figures(
  figure(fake-image, caption: [Inner Caption]), <1a>,
  figure(fake-image, caption: [Inner Caption]), <1b>,
  caption: [Super],
  label: <1>,
)
