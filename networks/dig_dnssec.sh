# Ref: https://www.onitroad.com/jc/linux/service/dns/validate-dnssec-using-dig.html

# 使用dig来验证DNSSEC记录
dig YOUR-DOMAIN-NAME +DNSSEC +short

# 获取用于验证DNS记录的公钥
dig DNSKEY YOUR-DOMAIN-NAME +short

# 使用dig命令查看DNSSEC信任链
dig DS YOUR-DOMAIN-NAME +trace

# 使用dig查看某个域名的DS记录：
dig DS {domain-name}
dig DS seaevergreen.com
