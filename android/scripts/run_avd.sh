# Refers: https://developer.android.com/studio/run/emulator-commandline?hl=zh-cn
#         https://developer.android.com/studio/run/emulator-acceleration?hl=zh-cn
#
# XXX: the proxy server on host MUST listen all IP: *:PORT
#
# emulator -list-avds
#
#emulator @Medium_Phone_API_33
#emulator -gpu swiftshader_indirect @Medium_Phone_API_33
#emulator -dns-server "8.8.8.8,8.8.4.4" @Medium_Phone_API_33
emulator -no-snapshot -dns-server "8.8.8.8" -http-proxy "http://127.0.0.1:7890" @Medium_Phone_API_33
#emulator -no-snapshot -dns-server "127.0.0.53" -http-proxy "http://127.0.0.1:7890" @Medium_Phone_API_33
#emulator -gpu host -http-proxy "http://127.0.0.1:7890" @Medium_Phone_API_33
#emulator -gpu host -http-proxy "http://127.0.0.1:7890" -debug-proxy @Medium_Phone_API_33
