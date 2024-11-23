#!/bin/sh

# Source: https://git.codemadness.org/stagit/file/example_create.sh.html

reposdir="/var/git"
curdir="$(pwd)"

stagit-index "${reposdir}/"*/ > "${curdir}/index.html"

for dir in "${reposdir}/"*/; do
        r=$(basename "${dir}")
        d=$(basename "${dir}" ".git")
        printf "%s... " "${d}"

        mkdir -p "${curdir}/${d}"
        cd "${curdir}/${d}" || continue
        stagit -c ".cache" "${reposdir}/${r}"

        ln -sf log.html index.html
        ln -sf ../style.css style.css
        ln -sf ../logo.png logo.png
        ln -sf ../favicon.png favicon.png

        echo "done"
done
