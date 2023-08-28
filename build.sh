#!/bin/bash

# pushd ~/ || exit 1

# tar cvf nvim-local.tar .local/share/nvim

# popd || exit 2

# mv ~/nvim-local.tar .

hostIP() {
	nslookup "$1" | grep "^Name:" -A1 | grep "^Address" | sed 's/Address:\s//g'
}

PROGRESS_NO_TRUNC=1 docker build \
	--progress=plain \
	--add-host github.com:"$(hostIP github.com)" \
	--add-host gitlab.com:"$(hostIP gitlab.com)" \
	--add-host gitlab.com:"$(hostIP gitlab.com)" \
	--add-host git.sr.ht:"$(hostIP git.sr.ht)" \
	"$@" \
	.
