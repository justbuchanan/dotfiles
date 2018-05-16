# Cheatsheet

## Fonts

Run `fc-cache` (add `-v` for verbose) to update font caches. The package manager should run this for you as appropriate through font package post-install scripts. This should only be needed to apply any font edits or potentially dev work.

## XResources

The ~/.Xresources file needs to be updated to #include anything in ~/.Xresources.d/ that you want to activate.

Whenever XResources change, run `xrdb ~/.Xresources` to re-load the database. Some applications will pick this up automatically, others will have to be restarted to see the effects.

The i3bar setup watches the Xresources files and automatically updates when the config changes.
