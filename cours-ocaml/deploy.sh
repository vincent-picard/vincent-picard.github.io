#!/bin/sh

mdbook build
rm -f book/.nojekyll
cp highlight/highlight.js book/

