# Ref: 1) http://server1.sharewiz.net/doku.php?id=curl:perform_imap_queries_using_curl
#      2) https://curl.se/mail/archive-2014-04/0071.html

# Listing Folders
curl imaps://mail.iveteran.me -u yu@iveteran.me -p
# Listing Sub Folders
curl --url "imaps://mail.matrix.works/" -u test001@matrix.works -p --request 'LIST "IncontrolChat" "*"'
curl --url "imaps://mail.matrix.works/" -u test001@matrix.works -p --request 'LIST "IncontrolChat.Notes" "*"'

# Create Folder
curl --url "imaps://mail.matrix.works/" -u test001@matrix.works -p --request "CREATE Sent"
curl --url "imaps://mail.matrix.works/" -u test001@matrix.works -p --request "CREATE IncontrolChat"
# Create sub folder
#  the path seperator maybe is '/', ':' or '.', depend on IMAP server, Dovecot is '.'
curl --url "imaps://mail.matrix.works/" -u test001@matrix.works -p --request "CREATE IncontrolChat.Notes"
# Remove folder
curl --url "imaps://mail.matrix.works/" -u test001@matrix.works -p --request "DELETE IncontrolChat.Notes"

# Discovering Messages
curl imaps://mail.iveteran.me/ -u yu@iveteran.me -p --request "EXAMINE INBOX"
curl imaps://mail.iveteran.me/ -u yu@iveteran.me -p --request "EXAMINE Sent"

curl -v --url "imaps://mail.goe.works:993" --user "${EMAIL_USER}:${EMAIL_PASS}" --list-only

# Listing Messages ID(UID) of the Folder
curl --url "imaps://mail.iveteran.me/INBOX?ALL" -u yu@iveteran.me -p
curl --url "imaps://mail.matrix.works/IncontrolChat.Notes?ALL" -u test001@matrix.works -p

# Fetching A Single Message
curl --url "imaps://mail.iveteran.me/INBOX;UID=1" -u yu@iveteran.me -p
curl --url "imaps://mail.matrix.works/IncontrolChat.Notes;UID=1" -u test001@matrix.works -p

# Fetching A Single Message With Only Date, From, To, Subject
curl --url "imaps://mail.iveteran.me/INBOX;UID=43;SECTION=HEADER.FIELDS%20(DATE%20FROM%20TO%20SUBJECT)" -u yu@iveteran.me -p
# Or 
curl --url "imaps://mail.iveteran.me/INBOX" -u yu@iveteran.me -p --request "FETCH 43 BODY.PEEK[HEADER.FIELDS (Date From To Subject)]" -v

# Set flags
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "STORE 3 +flags (\Flagged)" -v
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "STORE 3 +flags (Test Demo)" -v
# Remove flags
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "STORE 3 -flags (Test Demo)" -v
# Fetch message uid from 1 to 3
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "FETCH 1:3 FLAGS"
# Fetch message uid 3
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "FETCH 3 FLAGS"
# Search the subject has string `test`
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "SEARCH subject test"
# Search the flag `flagged`
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "SEARCH flagged"
# Search the flag `seen`
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "SEARCH seen"
# Search the custom flag `Demo` - for IMAP server Dovecot
curl --url "imaps://mail.matrix.works/INBOX" -u test001@matrix.works -p --request "SEARCH KEYWORD Demo"
