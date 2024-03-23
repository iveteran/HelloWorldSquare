# Ref: https://www.onitroad.com/jc/linux/service/dns/validate-dnssec-using-dig.html
#      https://www.cyberciti.biz/faq/unix-linux-test-and-validate-dnssec-using-dig-command-line/

# 使用dig来验证DNSSEC记录
dig YOUR-DOMAIN-NAME +DNSSEC
# 查看查询结果中的flags，如果是否有"ad"
# ad: (Authentic Data): indicates the resolver believes the responses to be authentic - that is, validated by DNSSEC
# ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
#
# do: only defined is DNSSEC OK (DO) currently
# ; EDNS: version: 0, flags: do; udp: 1232

# 获取用于验证DNS记录的公钥
dig DNSKEY YOUR-DOMAIN-NAME +short

# 使用dig命令查看DNSSEC信任链
dig DS YOUR-DOMAIN-NAME +trace

# 使用dig查看某个域名的DS记录：
dig DS {domain-name}
dig DS seaevergreen.com
