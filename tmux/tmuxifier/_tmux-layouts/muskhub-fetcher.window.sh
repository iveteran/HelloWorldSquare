window_root "~/projects/muskhub/muskhub/twitter-fetcher/playwright-py"
new_window "twitter"
split_h
select_pane 2
run_cmd "source ../../.venv/bin/activate"
run_cmd "proxy_on"
#run_cmd "./main_v2.py"
