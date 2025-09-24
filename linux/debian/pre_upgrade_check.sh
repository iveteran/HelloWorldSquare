#!/bin/bash

# Debian 升级前系统检查脚本
# 在执行升级前运行此脚本确保系统状态良好

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检查结果计数器
PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

# 输出函数
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS_COUNT++))
}

print_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN_COUNT++))
}

print_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL_COUNT++))
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 检查系统版本
check_system_version() {
    print_header "系统版本检查"
    
    if [[ -f /etc/debian_version ]]; then
        version=$(cat /etc/debian_version)
        print_info "当前版本: $version"
        
        if grep -q "bookworm\|12\." /etc/debian_version; then
            print_pass "确认为 Debian 12 系统"
        else
            print_warn "系统版本可能不是 Debian 12: $version"
        fi
    else
        print_fail "无法确定系统版本 - 不是 Debian 系统"
    fi
    
    print_info "内核版本: $(uname -r)"
    print_info "系统架构: $(uname -m)"
}

# 检查磁盘空间
check_disk_space() {
    print_header "磁盘空间检查"
    
    # 检查根分区空间
    root_space=$(df / | awk 'NR==2 {print $4}')
    root_space_gb=$((root_space / 1024 / 1024))
    
    if [[ $root_space_gb -ge 5 ]]; then
        print_pass "根分区可用空间充足: ${root_space_gb}GB"
    elif [[ $root_space_gb -ge 3 ]]; then
        print_warn "根分区空间紧张: ${root_space_gb}GB (建议至少5GB)"
    else
        print_fail "根分区空间不足: ${root_space_gb}GB (至少需要5GB)"
    fi
    
    # 检查 /var 分区空间
    var_space=$(df /var | awk 'NR==2 {print $4}')
    var_space_gb=$((var_space / 1024 / 1024))
    
    if [[ $var_space_gb -ge 2 ]]; then
        print_pass "/var 分区空间充足: ${var_space_gb}GB"
    else
        print_warn "/var 分区空间紧张: ${var_space_gb}GB"
    fi
    
    # 检查 /tmp 分区空间
    tmp_space=$(df /tmp | awk 'NR==2 {print $4}')
    tmp_space_gb=$((tmp_space / 1024 / 1024))
    
    if [[ $tmp_space_gb -ge 1 ]]; then
        print_pass "/tmp 分区空间充足: ${tmp_space_gb}GB"
    else
        print_warn "/tmp 分区空间不足: ${tmp_space_gb}GB"
    fi
}

# 检查内存
check_memory() {
    print_header "内存检查"
    
    total_mem=$(free -m | awk 'NR==2{print $2}')
    available_mem=$(free -m | awk 'NR==2{print $7}')
    
    print_info "总内存: ${total_mem}MB"
    print_info "可用内存: ${available_mem}MB"
    
    if [[ $available_mem -ge 1024 ]]; then
        print_pass "可用内存充足"
    elif [[ $available_mem -ge 512 ]]; then
        print_warn "可用内存较少，升级可能较慢"
    else
        print_fail "可用内存过少，可能导致升级失败"
    fi
}

# 检查网络连接
check_network() {
    print_header "网络连接检查"
    
    # 检查 DNS 解析
    if nslookup deb.debian.org >/dev/null 2>&1; then
        print_pass "DNS 解析正常"
    else
        print_fail "DNS 解析失败"
    fi
    
    # 检查与 Debian 服务器的连接
    if ping -c 3 -W 5 deb.debian.org >/dev/null 2>&1; then
        print_pass "可以连接到 Debian 服务器"
    else
        print_fail "无法连接到 Debian 服务器"
    fi
    
    # 检查 HTTPS 连接
    if curl -s --connect-timeout 10 https://deb.debian.org >/dev/null 2>&1; then
        print_pass "HTTPS 连接正常"
    else
        print_warn "HTTPS 连接可能有问题"
    fi
}

# 检查软件包状态
check_packages() {
    print_header "软件包状态检查"
    
    # 检查损坏的软件包
    broken_packages=$(dpkg --audit | wc -l)
    if [[ $broken_packages -eq 0 ]]; then
        print_pass "没有发现损坏的软件包"
    else
        print_fail "发现 $broken_packages 个损坏的软件包"
        print_info "运行 'sudo dpkg --configure -a' 修复"
    fi
    
    # 检查暂停的软件包
    held_packages=$(apt-mark showhold | wc -l)
    if [[ $held_packages -eq 0 ]]; then
        print_pass "没有暂停升级的软件包"
    else
        print_warn "有 $held_packages 个软件包被暂停升级"
        print_info "暂停的软件包: $(apt-mark showhold | tr '\n' ' ')"
    fi
    
    # 检查第三方软件源
    third_party_sources=$(find /etc/apt/sources.list.d -name "*.list" 2>/dev/null | wc -l)
    if [[ $third_party_sources -eq 0 ]]; then
        print_pass "没有第三方软件源"
    else
        print_warn "发现 $third_party_sources 个第三方软件源文件"
        print_info "升级前建议禁用第三方源"
    fi
}

# 检查系统服务
check_services() {
    print_header "关键服务检查"
    
    services=("systemd-resolved" "networking" "ssh" "cron" "rsyslog")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            print_pass "$service 服务运行正常"
        else
            print_warn "$service 服务未运行"
        fi
    done
}

# 检查文件系统
check_filesystem() {
    print_header "文件系统检查"
    
    # 检查文件系统错误
    if command -v fsck >/dev/null 2>&1; then
        print_info "建议升级前运行文件系统检查: sudo fsck -f /"
    fi
    
    # 检查重要目录权限
    critical_dirs=("/etc" "/var" "/usr" "/boot")
    
    for dir in "${critical_dirs[@]}"; do
        if [[ -d "$dir" && -r "$dir" ]]; then
            print_pass "$dir 目录可访问"
        else
            print_fail "$dir 目录权限异常"
        fi
    done
}

# 检查备份建议
check_backup_recommendations() {
    print_header "备份建议"
    
    important_dirs=("/etc" "/home" "/var/lib" "/opt")
    
    print_info "强烈建议升级前备份以下目录:"
    for dir in "${important_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            print_info "  $dir (大小: $size)"
        fi
    done
    
    print_info "备份命令示例:"
    print_info "  sudo tar -czf /backup/system-backup-\$(date +%Y%m%d).tar.gz /etc /home"
    print_info "  sudo rsync -av /home/ /backup/home/"
}

# 检查潜在问题
check_potential_issues() {
    print_header "潜在问题检查"
    
    # 检查自定义内核
    custom_kernels=$(dpkg -l | grep -c "linux-image.*[+~]" || true)
    if [[ $custom_kernels -gt 0 ]]; then
        print_warn "发现自定义内核，可能影响升级"
    else
        print_pass "没有发现自定义内核"
    fi
    
    # 检查 dkms 模块
    if command -v dkms >/dev/null 2>&1; then
        dkms_modules=$(dkms status | wc -l)
        if [[ $dkms_modules -gt 0 ]]; then
            print_warn "发现 $dkms_modules 个 DKMS 模块，升级后可能需要重新编译"
        else
            print_pass "没有 DKMS 模块"
        fi
    fi
    
    # 检查非官方软件包
    non_debian_packages=$(aptitude search '~i!~ODebian' 2>/dev/null | wc -l || echo "0")
    if [[ $non_debian_packages -gt 0 ]]; then
        print_warn "发现 $non_debian_packages 个非 Debian 官方软件包"
    else
        print_pass "所有软件包均为 Debian 官方包"
    fi
}

# 生成检查报告
generate_summary() {
    print_header "检查摘要"
    
    total_checks=$((PASS_COUNT + WARN_COUNT + FAIL_COUNT))
    
    echo -e "检查项目总数: $total_checks"
    echo -e "${GREEN}通过: $PASS_COUNT${NC}"
    echo -e "${YELLOW}警告: $WARN_COUNT${NC}"
    echo -e "${RED}失败: $FAIL_COUNT${NC}"
    
    if [[ $FAIL_COUNT -eq 0 ]]; then
        if [[ $WARN_COUNT -eq 0 ]]; then
            print_pass "系统状态良好，可以进行升级"
        else
            echo -e "\n${YELLOW}建议处理警告项目后再升级${NC}"
        fi
    else
        echo -e "\n${RED}发现严重问题，请解决后再尝试升级${NC}"
    fi
    
    echo -e "\n升级命令:"
    echo -e "sudo bash debian12-to-13-upgrade.sh"
}

# 主函数
main() {
    echo -e "${BLUE}Debian 12 -> 13 升级前系统检查${NC}"
    echo -e "检查时间: $(date)\n"
    
    check_system_version
    check_disk_space
    check_memory
    check_network
    check_packages
    check_services
    check_filesystem
    check_backup_recommendations
    check_potential_issues
    generate_summary
}

# 运行检查
main "$@"