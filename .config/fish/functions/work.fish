# ~/.config/fish/functions/work.fish
function work --description "ssh -t or --mosh to <host> and run utm (default), herdr, or boo ui"
  # Usage: work [--mosh] [--herdr|--boo] [host]
  # h/help keeps -h meaning help: argparse never matches -h to --herdr while a
  # short h exists. (-S/--strict-longopts would too, but needs fish 4.1+ and the
  # exe.dev boxes run 3.7.)
  argparse -x 'herdr,boo' --max-args 1 'h/help' 'mosh' 'herdr' 'boo' -- $argv
  or return

  if set -q _flag_help
    echo 'Usage: work [--mosh] [--herdr | --boo] [host]'
    echo
    echo 'Connect to host (default: disaster) and launch a ui.'
    echo
    echo '  --mosh      connect with mosh instead of ssh -t'
    echo '  --herdr     run herdr (uhm) instead of utm'
    echo '  --boo       run boo ui (ubm) instead of utm'
    echo '  -h, --help  show this help and connect to nothing'
    return 0
  end

  set -l host disaster
  if test (count $argv) -ge 1
    set host $argv[1]
  end

  set -l remote_cmd utm
  if set -q _flag_herdr
    set remote_cmd uhm
  else if set -q _flag_boo
    set remote_cmd ubm
  end

  set -l transport ssh
  if set -q _flag_mosh
    set transport mosh
  end

  # Fresh screen so the banner owns the terminal
  clear

  # Random art splash from ~/.config/prompt-art, sized to the terminal width
  if type -q chafa
    set -l art_files ~/.config/prompt-art/*
    if test (count $art_files) -gt 0
      set -l art $art_files[(random 1 (count $art_files))]
      set -l art_cols (tput cols)
      chafa -f symbols -c full -s {$art_cols}x{$art_cols} --symbols block+half+space --dither ordered $art
    end
  end

  # Phrases and matching emojis for random selection
  # set -l phrases 'G O B L I N   M O D E   E N G A G E D' 'F E R A L   K E Y B O A R D   H O U R' 'S U M M O N I N G   T H E   D A E M O N S' 'T H E   K E R N E L   P A N I C S   F I R S T' 'C E R T I F I E D   C U R S E D   E N E R G Y' 'B O N E L E S S   D E P L O Y   T O   P R O D' 'N E C R O M A N C I N G   A   D E A D   B R A N C H' 'B I G F O O T   S T O M P S   T H E   S E R V E R' 'C O M M I T T I N G   C R I M E S   I N   M A I N' 'R E L E A S E   T H E   D O O M S L U G' 'C R A C K E D   O U T   O N   S E M I C O L O N S' 'P R A Y I N G   T O   T H E   L I N K E R' 'N O   G O D S   N O   T E S T S' 'L I C E N S E   T O   K E R N E L' 'B A B Y G I R L   I T S   R E F A C T O R   O C L O C K' 'F O U R   L O K O   F U E L E D   M E R G E' 'R A C C O O N   I N   T H E   S E R V E R   R O O M' 'F R E A K Y   F R I D A Y   M E R G E   C O N F L I C T' 'T H E   L O G S   K N O W   W H A T   Y O U   D I D' 'H E A R S E   R O L L I N G   T O   P R O D'
  # set -l emojis '👹' '🐺' '😈' '💥' '🔮' '🍗' '🪦' '🦶' '🔪' '🐉' '💊' '🙏' '⚰️' '🔑' '💅' '🧃' '🦝' '🎭' '👁️' '🏴'
  # set -l pick (random 1 (count $phrases))
  # set -l bar_colors brred bryellow brgreen brcyan brblue brmagenta

  # Top rainbow bar
  # for _r in (seq 1 6)
  #   for c in $bar_colors
  #     set_color $c
  #     printf '▓▒'
  #   end
  # end
  # printf '\n'

  # Phrase line
  # echo
  # set_color --bold $bar_colors[(random 1 (count $bar_colors))]
  # echo "      $emojis[$pick]  $phrases[$pick]  $emojis[$pick]"
  # echo
  # set_color normal

  # Bottom rainbow bar
  # for _r in (seq 1 6)
  #   for c in $bar_colors
  #     set_color $c
  #     printf '▒▓'
  #   end
  # end
  # printf '\n'
  echo

  # Connection info
  set_color --bold bryellow
  echo "      ⮕  $host ($transport)"
  set_color normal
  echo

  if set -q _flag_mosh
    mosh $host -- fish -lc "$remote_cmd"
  else
    ssh -t $host "fish -lc '$remote_cmd'"
  end
  set -l conn_status $status

  # A dropped connection or a remote TUI that didn't clean up can leave our local
  # terminal with mouse/scroll reporting stuck on -- scrolling then spews ^[[B.
  # Reset it before we draw anything.
  fixmouse

  if test $conn_status -eq 0
    # Clean hangup: the remote ui exited on its own
    set -l bye_phrases 'V A N I S H I N G   I N T O   T H E   M I S T' 'S K I L L   I S S U E   R E S O L V E D' 'G R E M L I N   G O E S   N I G H T   N I G H T' 'R E T U R N I N G   T O   T H E   S W A M P' 'D A E M O N S   E X O R C I S E D' 'B U R Y I N G   T H E   L A P T O P   I N   T H E   Y A R D' 'M Y   B O N E S   H U R T' 'A B A N D O N I N G   T H E   B O D Y' 'B U R Y I N G   T H E   M E R G E   C O N F L I C T' 'A B S O L U T E L Y   C O O K E D' 'B R B   B E C O M I N G   A   T R E E' 'C R A W L I N G   B A C K   I N T O   T H E   E G G' 'L O G S   R O T A T E D   B R A I N   R O T A T E D' 'P O W E R I N G   D O W N   T H E   M E A T   S U I T' 'C R A W L I N G   I N T O   T H E   S O I L' 'L E A V I N G   I N   A   B O D Y   B A G' 'T H E   R I T U A L   I S   C O M P L E T E' 'D I S S O L V I N G   I N T O   S T A T I C' 'T E R M I N A L   V E L O C I T Y   A C H I E V E D' 'L A S T   R I T E S   F O R   T H E   S E S S I O N'
    set -l bye_emojis '🌫️' '🩹' '😴' '🐊' '⛪' '⚰️' '💀' '👻' '🪦' '🔥' '🌳' '🥚' '🧠' '🥩' '🪱' '🚑' '🕯️' '📺' '⌨️' '⚱️'
    set -l bye_pick (random 1 (count $bye_phrases))
    __work_no_carrier brcyan \
      "$bye_emojis[$bye_pick]  $bye_phrases[$bye_pick]  $bye_emojis[$bye_pick]" \
      "disconnected from $host"
  else
    # The connection or remote command died with a nonzero status
    set -l doom_phrases 'C O N N E C T I O N   F L A T L I N E D' 'T H E   V O I D   H U N G   U P   F I R S T' 'D I E D   O F   D Y S E N T E R Y' 'E X I T   W O U N D   D E T E C T E D' 'T H E   C A B L E   G O B L I N   W O N' 'S W A L L O W E D   B Y   T H E   S T A T I C'
    set -l doom_emojis '📉' '🕳️' '🦴' '🩸' '🧌' '📺'
    set -l doom_pick (random 1 (count $doom_phrases))
    __work_no_carrier brred \
      "$doom_emojis[$doom_pick]  $doom_phrases[$doom_pick]  $doom_emojis[$doom_pick]" \
      "$host: exit status $conn_status"
  end

  return $conn_status
end

function __work_no_carrier --description 'clear, giant glitching NO CARRIER banner, then a status line'
  # __work_no_carrier THEME SUBTITLE TAIL
  #   THEME    base colour for the banner + subtitle (e.g. brred, brcyan)
  #   SUBTITLE flavour line shown under the banner
  #   TAIL     closing status line (e.g. "disconnected from disaster")
  set -l theme $argv[1]
  set -l subtitle $argv[2]
  set -l tail $argv[3]

  clear

  # Giant NO CARRIER (figlet -f banner), padded to one fixed width so every row
  # is the same length for the glitch overlay.
  set -l W 70
  set -l banner \
    (string pad -r -w $W -- '#     # #######     #####     #    ######  ######  ### ####### ######') \
    (string pad -r -w $W -- '##    # #     #    #     #   # #   #     # #     #  #  #       #     #') \
    (string pad -r -w $W -- '# #   # #     #    #        #   #  #     # #     #  #  #       #     #') \
    (string pad -r -w $W -- '#  #  # #     #    #       #     # ######  ######   #  #####   ######') \
    (string pad -r -w $W -- '#   # # #     #    #       ####### #   #   #   #    #  #       #   #') \
    (string pad -r -w $W -- '#    ## #     #    #     # #     # #    #  #    #   #  #       #    #') \
    (string pad -r -w $W -- '#     # #######     #####  #     # #     # #     # ### ####### #     #')

  # Terminal width; fall back to a compact static line if the giant banner won't
  # fit or we're not on a real terminal.
  set -l cols (tput cols 2>/dev/null)
  string match -qr '^\d+$' -- "$cols"; or set cols 80

  if not isatty stdout; or test $cols -lt (math "$W + 2")
    echo
    set_color -o $theme
    if test $cols -ge (math "$W + 2")
      for ln in $banner
        echo $ln
      end
    else
      echo '  »»  N O   C A R R I E R  ««'
    end
    echo
    echo "      $subtitle"
    echo
    set_color -o brred
    echo "      ⮕  $tail"
    set_color normal
    echo
    return
  end

  # --- animated path -------------------------------------------------------
  set -l base (set_color $theme)
  set -l reset (set_color normal)
  set -l glitch_c (set_color -o brred) (set_color -o brwhite) (set_color -o brcyan) (set_color -o brmagenta) (set_color -o bryellow) (set_color -o brgreen)
  set -l glyphs ▓ ▒ ░ █ ▚ ▞ ▛ ▜ ▙ ▟ ▄ ▀ ▌ ▐ ╳ ╱ ╲ ¦ @ % \? =
  set -l ng (count $glyphs)
  set -l ncol (count $glitch_c)

  printf '\e[?25l'      # hide cursor
  printf '\n'           # top margin
  printf '\e7'          # save banner top

  # intensity per frame: unstable surges, settling to 0 (clean) at the end
  set -l schedule 6 16 34 12 48 74 22 58 92 38 18 64 30 8 0

  for intensity in $schedule
    printf '\e8'        # back to banner top
    for ln in $banner
      # whole-row static dropout on heavy frames
      if test $intensity -ge 55; and test (random 1 100) -le 38
        set -l g $glitch_c[(random 1 $ncol)]
        set -l bar ''
        for i in (seq $W)
          set bar $bar$glyphs[(random 1 $ng)]
        end
        printf '%s%s%s\e[K\n' $g $bar $reset
        continue
      end
      # per-char salt-and-pepper corruption
      set -l out ''
      set -l n (string length -- $ln)
      for i in (seq $n)
        set -l ch (string sub -s $i -l 1 -- $ln)
        if test (random 1 100) -le $intensity
          set out $out$glitch_c[(random 1 $ncol)]$glyphs[(random 1 $ng)]
        else
          set out $out$base$ch
        end
      end
      printf '%s%s\e[K\n' $out $reset
    end
    sleep (random choice 0.03 0.05 0.07)
  end

  # settle: clean banner in the theme colour
  printf '\e8'
  set_color -o $theme
  for ln in $banner
    printf '%s\e[K\n' $ln
  end
  set_color normal
  printf '\e[?25h'     # show cursor

  # subtitle + closing status line
  echo
  set_color -o $theme
  echo "      $subtitle"
  echo
  set_color -o brred
  echo "      ⮕  $tail"
  set_color normal
  echo
end
