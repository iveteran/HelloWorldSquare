# Ref: 1) http://server1.sharewiz.net/doku.php?id=curl:perform_imap_queries_using_curl
#      2) https://curl.se/mail/archive-2014-04/0071.html

# Listing Folders
curl --insecure imaps://mail.iveteran.me -u yu@iveteran.me -p

# Discovering Messages
curl --insecure imaps://mail.iveteran.me/ -u yu@iveteran.me -p --request "EXAMINE INBOX"
curl --insecure imaps://mail.iveteran.me/ -u yu@iveteran.me -p --request "EXAMINE Sent"

curl -v --url "imaps://mail.goe.works:993" --user "${EMAIL_USER}:${EMAIL_PASS}" --list-only

# Listing Messages ID(UID) of the Folder
curl --insecure --url "imaps://mail.iveteran.me/INBOX?ALL" -u yu@iveteran.me -p

# Fetching A Single Message
curl --insecure --url "imaps://mail.iveteran.me/INBOX;UID=1" -u yu@iveteran.me -p

# Fetching A Single Message With Only Date, From, To, Subject
curl --insecure --url "imaps://mail.iveteran.me/INBOX;UID=43;SECTION=HEADER.FIELDS%20(DATE%20FROM%20TO%20SUBJECT)" -u yu@iveteran.me -p
# Or 
curl --insecure --url "imaps://mail.iveteran.me/INBOX" -u yu@iveteran.me -p --request "fetch 43 BODY.PEEK[HEADER.FIELDS (Date From To Subject)]" -v
