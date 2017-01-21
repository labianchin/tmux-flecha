#!/bin/sh

# start index numbering at 1
tmux set-option -g base-index 1
tmux set-window-option -g pane-base-index 1

tmux set-option -g set-titles on
# host:session:window number.pane number program name, active(or not)
tmux set-option -g set-titles-string '#H:#S:#I.#P #W #T'

tmux set-option -g status on              # turn the status bar on
tmux set-option -g status-utf8 on         # set utf-8 for the status bar
tmux set-option -g status-interval 10     # set update frequencey (default 15 seconds)

tmux set-window-optio -g monitor-activity on
tmux set-option -g visual-activity off

apply_theme() {
  powerline_enabled=$1
  if $powerline_enabled ; then
    separator_right_bold=""
    separator_left_bold=""
  else
    separator_right_bold="<"
    separator_left_bold=">"
  fi

  # ========== status line
  default_fg=colour${TMUX_FLECHA_FG_COLOR:-'254'} # white
  default_bg=colour${TMUX_FLECHA_BG_COLOR:-'232'} # dark gray
  tmux set-option -g status-style "fg=$default_fg,bg=$default_bg"

  # ========== status left
  session_fg="$default_bg" # inverted colors
  session_bg="$default_fg"
  session_info="#[fg=$session_fg,bg=$session_bg,bold] #S:#I.#P #[fg=$session_bg,bg=$session_fg]${separator_left_bold}"
  sufix_left=""
  status_left="${session_info}${sufix_left}"
  tmux set-option -g status-left-length 60
  tmux set-option -g status-left "$status_left"

  # prefix highlight
  short_prefix=$( tmux show-option -gqv prefix | tr "[:lower:]" "[:upper:]" | sed 's/C-/\^/')
  prefix_highlight="#[fg=$default_bg,bg=yellow,bold]#{?client_prefix, $short_prefix ,}"

  # ========== status right
  prefix_right=""
  sufix_right=""
  # add current weather if wathermajig available
  if hash weathermajig 2>/dev/null; then
    prefix_right+="#(weathermajig boulder --short)$separator_left_bold"
  fi
  # add tmux-mem-cpu-load if it exists
  if hash tmux-mem-cpu-load 2>/dev/null; then
    sufix_right="#(tmux-mem-cpu-load --graph-lines 0 --mem-mode 1 --colors --interval 5 --averages-count 2)#[default]"
  fi
  if hash rainbarf 2>/dev/null; then
    sufix_right+="#(rainbarf --battery --remaining --rgb --bright --skip 5 --bolt)"
  fi

  # show host name and IP address on right side of status bar
  external_ip_fg="brightblue"
  local_ip_fg="red"
  latency_fg="green"
  external_ip_config="#[fg=$external_ip_fg]#(curl -m 1 icanhazip.com) "
  latency_config="#[fg=$latency_fg]#(ping -c 1 -t 2 8.8.8.8 2>/dev/null | awk 'FNR == 2 { print \$(NF-1) }' | cut -d'=' -f2) "
  ip_en0_config="#[fg=$local_ip_fg]#(ifconfig en0 2>/dev/null | awk '\$1 == \"inet\" { print \$2 }')"
  ip_en1_config="#[fg=$local_ip_fg]#(ifconfig en1 2>/dev/null | awk '\$1 == \"inet\" { print \$2 }')"
  net_info="${latency_config}${external_ip_config}" #${ip_en0_config}${ip_en1_config} "

  status_right="${separator_right_bold}#[fg=$session_fg,bg=$session_bg,nobold] ${prefix_right}${net_info}${sufix_right}${prefix_highlight}"
  tmux set-option -g status-right-length 150
  tmux set-option -g status-right "$status_right"

  # ========== window list
  window_info=" #I #W "

  # unfocused windows
  window_status_fg=colour245 # light gray
  window_status_bg="$default_bg"
  tmux set-window-option -g window-status-style "fg=$window_status_fg,bg=$window_status_bg"
  tmux set-window-option -g window-status-format "$window_info"

  # current window
  window_status_current_fg=colour16 # black
  window_status_current_bg=colour39 # light blue
  window_status_current_format="#[fg=$window_status_bg,bg=$window_status_current_bg]$separator_left_bold#[fg=$window_status_current_fg,bg=$window_status_current_bg,bold]$window_info#[fg=$window_status_current_bg,bg=$window_status_bg]$separator_left_bold"
  tmux set-window-option -g window-status-current-format "$window_status_current_format"

  tmux set-option -g status-justify left

  # window with activiy
  window_status_activity_fg=colour254 # white
  window_status_activity_bg=default
  window_status_activity_attr=underscore,bold
  tmux set-window-option -g window-status-activity-style "fg=$window_status_activity_fg,bg=$window_status_activity_bg,$window_status_activity_attr"

  window_status_bell_fg=colour226 # yellow
  window_status_bell_bg=default
  window_status_bell_attr=blink,bold
  tmux setw -g window-status-bell-style "fg=$window_status_bell_fg,bg=$window_status_bell_bg,$window_status_bell_attr"

  # =========== messages
  message_fg=colour16           # black
  message_bg=colour226          # yellow
  message_attr=bold
  tmux set-option -g message-style "fg=$message_fg,bg=$message_bg,$message_attr"

  message_command_fg=colour16   # black
  message_command_bg=colour160  # light yellow
  tmux set-option -g message-command-style "fg=$message_command_fg,bg=$message_command_bg,$message_attr"

  # =========== panes
  pane_border_fg=colour238        # light gray
  pane_active_border_fg=colour39  # light blue
  tmux set-option -g pane-border-style "fg=$pane_border_fg"
  tmux set-option -g pane-active-border-style "fg=$pane_active_border_fg"

  display_panes_active_colour=colour39 # light blue
  display_panes_colour=colour39        # light blue
  tmux set-option -g display-panes-active-colour "$display_panes_active_colour" 
  tmux set-option -g display-panes-colour "$display_panes_colour"
}

apply_theme true