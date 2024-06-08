#!/usr/bin/env bash
set -eo pipefail

echo "# Dumped using \`brew tap | xargs -I{} echo tap '\"{}\"'\`"
brew tap | xargs -I{} echo tap '"{}"'
echo "# Dumped using \`brew list --formula -1 | xargs -I{} echo brew '\"{}\"'\`"
brew list --formula -1 | xargs -I{} echo brew '"{}"'
echo "# Dumped using \`mas list | awk '{print \"mas\",\"\\\"\" \$2 \"\\\", id:\", \$1}'\`"
mas list | awk '{print "mas","\"" $2 "\", id:", $1}'
