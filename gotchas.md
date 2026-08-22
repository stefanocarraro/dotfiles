# gotchas

Hard-won facts about this $HOME / dotfiles setup. Add entries; don't regenerate the file.

- **Fish config is fleet-shared; target fish 3.7.** yadm syncs `~/.config/fish` to the exe.dev VM (`harper.exe.xyz`), which runs fish 3.7.0 from Ubuntu 24.04 — the Mac's Homebrew fish (4.7+) accepts flags 3.7 doesn't (e.g. `argparse -S/--strict-longopts`, added in fish 4.1). Check `/opt/homebrew/Cellar/fish/<ver>/CHANGELOG.rst` before using shiny argparse/string features in shared functions.
- **Skills audit 2026-08-22: don't re-copy plugin skills into `~/.claude/skills/`.** 45 stale duplicate dirs (superpowers, simmer, review-squad, test-kitchen, binary-re, thrifty) were deleted — the plugins are the source of truth. Everything deleted is in `~/.claude/skills-commands-backup-2026-08-22.tgz`, which also holds the ONLY copy (besides `~/.agents/skills/`) of Harper's thrifty fork improvements; live `/thrifty` is plugin 0.5.0 again. `~/.claude/skills/using-grove` is a symlink into the grove repo — `find -type d` skips it, so dir counts differ by one depending on method.
