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

`tab-*` commands will receive a second commit to create and act on a commit range. The **contents of the clipboard** will be passed in as the second commit. The two commits are automatically sorted by ancestry, parent first.

For example, pressing `d` will execute: `git diff {commit from top line}`

Pressing `tab-d` will execute: `git diff {parent}^..{child}`.

### Key Commands

All tab commands receive the top-line commit as the first argument, and the clipboard contents as the second argument.

| Key | Command |
| ----- | ----- |
| `spacebar` | `git show {commit}` |
| `x` or `y` | Copy current commit hash to the clipboard |
| `C` | `git cherry-pick {commit}` |
| `d` | `git diff {commit}` |
| `F` | `git commit --fixup={commit}` |
| `I` | `git rebase --autosquash --interactive {commit}^` |
| `l` | List files changed in commit |
| `o` | Open files changed in commit |
| `P` | `git format-patch {commit}` |
| `R` | `git revert {commit}` |
| `t` | `git difftool {commit}` |
| `tab-C` | `git cherry-pick {parent}..{child}` |
| `tab-d` | `git diff {parent}..{child}` |
| `tab-l` | List files changed in commit range |
| `tab-o` | Open files changed in commit range |
| `tab-P` | `git format-patch {parent}..{child}` |
| `tab-R` | `git revert {parent}..{child}` |
| `tab-t` | `git difftool {parent}..{child}` |
