session_root "~/projects/muskhub/muskhub"

if initialize_session "muskhub"; then

  tmuxifier load-window muskhub-publisher
  tmuxifier load-window muskhub-fetcher

  #load_window "muskhub-publisher"
  #load_window "muskhub-fetcher"

  #tmuxifier-tmux select-window -t "twitter"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
