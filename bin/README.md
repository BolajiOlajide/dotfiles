# bin

Personal shell scripts, symlinked to `~/bin` by `scripts/sync.sh` and picked up
by the `$HOME/bin` entry already at the front of the PATH in
`config/zsh/zshrc`.

To add a script: drop it in this directory, `chmod +x` it, and open a new shell
(or `rehash`). No sync step needed for new files — the whole directory is one
symlink. Name scripts without a `.sh` extension so they read as commands.
