#!/usr/bin/expect

#set sender_domain "matrix.works"
#set sender_name "yu"
#set sender "$sender_name@$sender_domain"
#set receiver "yusen@goe.works"
#spawn openssl s_client -quiet -starttls smtp -connect mail.goe.works:587

set sender_domain "goe.works"
set sender_name "yu"
set sender "$sender_name@$sender_domain"
set receiver "yu@matrix.works"
spawn openssl s_client -quiet -starttls smtp -connect mail.matrix.works:587

expect "250*"
send "helo $sender_domain\n"
expect "250*"
send "mail from:$sender\n"
expect "250*"
send "rcpt to:$receiver\n"
expect {
  "250*" {
    send "data\n"
    expect "354*"
    send "From: $sender\n"
    send "To: $receiver\n"
    send "Subject: test sending mail by Expect\n"
    send "hello world, this is content.\n"
    send ".\n"
    expect "250*"
    send "quit\n"
  }
  "450*" { send "quit\n" }
}
