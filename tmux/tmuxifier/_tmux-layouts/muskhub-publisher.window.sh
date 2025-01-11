window_root "~/projects/muskhub/muskhub/publisher"
new_window "publish"
split_h
select_pane 2
run_cmd "source ../.venv/bin/activate"
run_cmd "proxy_off"
#run_cmd "./main_weibo.py"
