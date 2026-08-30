# ~/.config/fish/functions/fixmouse.fish
function fixmouse --description 'turn off stuck mouse/scroll reporting modes (fixes scrolling that spews ^[[B)'
  # A full-screen program (pager, editor, TUI, or a remote one over ssh) turns on
  # mouse + alternate-scroll reporting and is supposed to switch it back off when
  # it exits. When it dies abnormally -- killed, crashed, dropped ssh -- it skips
  # the cleanup, so the terminal keeps translating wheel scrolls into arrow-key
  # and mouse-report escapes. Switch those private modes back off:
  #   1000 click tracking   1002 button-motion   1003 any-motion
  #   1004 focus events     1006 SGR coords      1007 alternate scroll
  isatty stdout; or return
  printf '\e[?1000l\e[?1002l\e[?1003l\e[?1004l\e[?1006l\e[?1007l'
end
