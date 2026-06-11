set -l CARGO_HOME "SHOME/.cargo"

test -f $CARGO_HOME/env.fish
and source "$CARGO_HOME/env.fish"
