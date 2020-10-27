# Enhanced Git Log

*Enhanced Git Log* adds useful key commands to your existing `git log` pager on the command line.

It is done by configuring a custom `lesskey` file to be loaded by the `git log` pager. This can be removed at any time by deleting the `pager.log` configuration value from the global `.gitconfig` file. The uninstall command below does this also. See the `Makefile` for details.

## Installation

> ***Warning**: as of right now, the install script sets the `pager.log` configuration property, but does not back up or restore any existing configuration. Please back up your `pager.log` configuration before installing.*

```shell
git clone git@github.com:drewbrokke/enhanced-git-log.git
cd enhanced-git-log
make install
```

## Uninstall

```shell
cd enhanced-git-log
make uninstall
```

## Usage

### How it works

All key commands act on the commit found at the top line of the `git log` pager, or the first line from the top that contains a commit hash.

Commands that **do not** accept a second commit are executed immediately.

Commands that **do** accept a second commit will prompt for it, and can be executed by pressing the `return` key.

If a command accepts a second commit, it is *always* optional.

If a second commit is given to a command, the command will instead act on a range of commits in the commit range format: `{parent}^..{child}`.

For example, pressing `d` then `return` will execute: `git diff {commit from top line}`

Pressing `d`, then pasting in commit hash, then `return` will execute: `git diff {parent}^..{child}`.

### Key Commands

| Key | Command | Accepts Second Commit? |
| ----- | ----- | ----- |
| `spacebar` | `git show {commit}` | no |
| `x` or `y` | Copy current commit hash to the clipboard (*macOS only*) | no |
| `d` | `git diff {commit}` | yes |
| `l` | List files changed in commit | yes |
| `o` | Open files changed in commit | yes |
| `t` | `git difftool {commit}` | yes |
| `C` | `git cherry-pick {commit}` | yes |
| `F` | `git commit --fixup={commit}` | no |
| `I` | `git rebase --autosquash --interactive {commit}^` | no |
| `R` | `git revert {commit}` | yes |
| `P` | `git format-patch {commit}` | yes |
