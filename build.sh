#!/bin/bash

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
