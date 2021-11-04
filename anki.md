# Anki

## mathbf fix on Ubuntu

Anki defaults to CommonHTML for MathJax, which doesn't work when
using mathbf fonts (e.g. $\mathbf R$) -- they show up as mathrm
instead. To fix this on Linux, edit
`/usr/share/anki/web/mathjax/conf.js` and change
`jax: ["input/TeX", "output/CommonHTML"],` to
`jax: ["input/TeX", "output/HTML-CSS"],`.

This will be overridden whenever Ubuntu upgrades to the next version, so you
will have to edit this again at that time (unless the bug in MathJax is fixed).

## Japanese kanji fonts on AnkiDroid

On older versions of Android, the default fonts for kanji use the Chinese
variants. To correct this, you can change the templates to have
`<span lang="ja">...</span>` around the kanji parts.
