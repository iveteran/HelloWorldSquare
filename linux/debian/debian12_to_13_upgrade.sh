#!/bin/bash

# Debian 12 (bookworm) 升级到 Debian 13 (trixie) 自动化脚本
# 创建日期: 2025年9月
# 警告: 请在测试环境中先验证，生产环境请谨慎使用

set -euo pipefail

# 配置变量
SCRIPT_NAME="Debian 12 -> 13 升级脚本"
LOG_FILE="/var/log/debian-upgrade-$(date +%Y%m%d_%H%M%S).log"
BACKUP_DIR="/var/backups/debian-upgrade-$(date +%Y%m%d_%H%M%S)"
SOURCES_BACKUP="/etc/apt/sources.list.backup-$(date +%Y%m%d_%H%M%S)"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_info() {
    log "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    log "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    log "${RED}[ERROR]${NC} $1"
}

log_success() {
    log "${GREEN}[SUCCESS]${NC} $1"
}

# 错误处理
error_exit() {
    log_error "升级过程中发生错误: $1"
    log_error "请查看日志文件: $LOG_FILE"
    log_error "如需回滚，请参考备份目录: $BACKUP_DIR"
    exit 1
}

# 检查是否以 root 权限运行
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error_exit "此脚本需要 root 权限运行。请使用 sudo $0"
    fi
}

# 检查当前系统版本
check_current_version() {
    log_info "检查当前系统版本..."
    
    if [[ ! -f /etc/debian_version ]]; then
        error_exit "这不是一个 Debian 系统"
    fi
    
    current_version=$(cat /etc/debian_version)
    log_info "当前 Debian 版本: $current_version"
    
    # 检查是否为 Debian 12
    if ! grep -q "bookworm\|12\." /etc/debian_version; then
        log_warn "当前系统可能不是 Debian 12，继续升级可能有风险"
        read -p "是否继续? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# 检查系统资源
check_system_resources() {
    log_info "检查系统资源..."
    
    # 检查磁盘空间 (至少需要 5GB)
    available_space=$(df / | awk 'NR==2 {print $4}')
    required_space=$((5 * 1024 * 1024)) # 5GB in KB
    
    if [[ $available_space -lt $required_space ]]; then
        error_exit "磁盘空间不足。至少需要 5GB 可用空间，当前可用: $(($available_space / 1024 / 1024))GB"
    fi
    
    # 检查内存
    available_memory=$(free -m | awk 'NR==2{print $7}')
    if [[ $available_memory -lt 512 ]]; then
        log_warn "可用内存较少 (${available_memory}MB)，升级过程可能较慢"
    fi
    
    log_success "系统资源检查通过"
}

# 检查网络连接
check_network() {
    log_info "检查网络连接..."
    
    if ! ping -c 1 deb.debian.org >/dev/null 2>&1; then
        error_exit "无法连接到 Debian 软件源服务器"
    fi
    
    log_success "网络连接正常"
}

# 创建备份
create_backup() {
    log_info "创建系统备份..."
    
    mkdir -p "$BACKUP_DIR"
    
    # 备份重要配置文件
    cp -r /etc/apt "$BACKUP_DIR/apt" 2>/dev/null || true
    cp /etc/debian_version "$BACKUP_DIR/" 2>/dev/null || true
    cp /etc/hostname "$BACKUP_DIR/" 2>/dev/null || true
    cp /etc/hosts "$BACKUP_DIR/" 2>/dev/null || true
    cp -r /etc/systemd "$BACKUP_DIR/systemd" 2>/dev/null || true
    
    # 备份已安装软件包列表
    dpkg --get-selections > "$BACKUP_DIR/package-selections.txt"
    apt list --installed > "$BACKUP_DIR/installed-packages.txt" 2>/dev/null
    
    log_success "备份创建完成: $BACKUP_DIR"
}

# 更新当前系统
update_current_system() {
    log_info "更新当前 Debian 12 系统..."
    
    export DEBIAN_FRONTEND=noninteractive
    
    apt-get update || error_exit "无法更新软件包列表"
    
    # 升级所有包到最新版本
    apt-get -y upgrade || error_exit "升级现有软件包失败"
    apt-get -y full-upgrade || error_exit "完整升级失败"
    
    # 清理不需要的包
    apt-get -y autoremove || error_exit "清理不需要的软件包失败"
    apt-get -y autoclean || error_exit "清理缓存失败"
    
    log_success "当前系统更新完成"
}

# 更新软件源到 Debian 13
update_sources_list() {
    log_info "更新软件源到 Debian 13 (trixie)..."
    
    # 备份原始 sources.list
    cp /etc/apt/sources.list "$SOURCES_BACKUP"
    
    # 创建新的 sources.list
    cat > /etc/apt/sources.list << 'EOF'
# Debian 13 (trixie) 官方软件源
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

# 安全更新
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware

# 更新源
deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
EOF
    
    # 处理 sources.list.d 目录中的文件
    if [[ -d /etc/apt/sources.list.d ]]; then
        log_info "更新 sources.list.d 中的源文件..."
        find /etc/apt/sources.list.d -name "*.list" -exec sed -i 's/bookworm/trixie/g' {} \; || true
    fi
    
    log_success "软件源已更新到 Debian 13"
}

# 执行升级
perform_upgrade() {
    log_info "开始升级到 Debian 13..."
    
    export DEBIAN_FRONTEND=noninteractive
    
    # 更新软件包列表
    apt-get update || error_exit "更新软件包列表失败"
    
    # 执行最小升级
    log_info "执行最小升级..."
    apt-get -y upgrade || error_exit "最小升级失败"
    
    # 执行完整升级
    log_info "执行完整升级... (这可能需要很长时间)"
    apt-get -y full-upgrade || error_exit "完整升级失败"
    
    # 清理
    apt-get -y autoremove || log_warn "清理不需要的软件包时出现警告"
    apt-get -y autoclean || log_warn "清理缓存时出现警告"
    
    log_success "升级过程完成"
}

# 验证升级结果
verify_upgrade() {
    log_info "验证升级结果..."
    
    new_version=$(cat /etc/debian_version)
    log_info "新的 Debian 版本: $new_version"
    
    # 检查是否成功升级到 Debian 13
    if grep -q "trixie\|13\." /etc/debian_version; then
        log_success "成功升级到 Debian 13!"
    else
        log_warn "升级可能不完整，当前版本: $new_version"
    fi
    
    # 检查系统服务状态
    log_info "检查关键系统服务..."
    
    systemctl status systemd-resolved >/dev/null 2>&1 && log_info "✓ DNS 解析服务正常" || log_warn "✗ DNS 解析服务异常"
    systemctl status networking >/dev/null 2>&1 && log_info "✓ 网络服务正常" || log_warn "✗ 网络服务异常"
    systemctl status ssh >/dev/null 2>&1 && log_info "✓ SSH 服务正常" || log_warn "✗ SSH 服务异常"
    
    # 检查关键软件包
    log_info "验证关键软件包..."
    dpkg -l | grep -E "^ii.*linux-image" | tail -1 | awk '{print "内核版本: " $3}'
    dpkg -l | grep -E "^ii.*libc6" | awk '{print "glibc 版本: " $3}'
}

# 清理和优化
cleanup_and_optimize() {
    log_info "执行清理和优化..."
    
    # 清理旧的内核
    apt-get -y autoremove --purge || log_warn "清理旧内核时出现警告"
    
    # 重建字体缓存
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f -v >/dev/null 2>&1 || log_warn "重建字体缓存失败"
    fi
    
    # 更新 initramfs
    update-initramfs -u || log_warn "更新 initramfs 时出现警告"
    
    # 更新 GRUB
    if command -v update-grub >/dev/null 2>&1; then
        update-grub || log_warn "更新 GRUB 时出现警告"
    fi
    
    log_success "清理和优化完成"
}

# 生成升级报告
generate_report() {
    log_info "生成升级报告..."
    
    report_file="/tmp/debian-upgrade-report-$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$report_file" << EOF
==========================================
Debian 升级报告
==========================================
升级时间: $(date)
升级前版本: $current_version
升级后版本: $(cat /etc/debian_version)

系统信息:
- 内核版本: $(uname -r)
- 架构: $(uname -m)
- 主机名: $(hostname)

磁盘使用情况:
$(df -h / | tail -1)

内存使用情况:
$(free -h | head -2)

备份位置: $BACKUP_DIR
日志文件: $LOG_FILE

已安装软件包数量:
$(dpkg -l | grep -c '^ii')

关键服务状态:
$(systemctl is-active systemd-resolved networking ssh 2>/dev/null | sed 's/^/- /')

建议:
1. 重启系统以确保所有更改生效
2. 检查自定义配置文件是否需要更新
3. 验证所有应用程序正常工作
4. 如确认无问题，可删除备份: rm -rf $BACKUP_DIR

==========================================
EOF
    
    log_success "升级报告已生成: $report_file"
    echo "升级报告内容:"
    cat "$report_file"
}

# 主函数
main() {
    log_info "=== $SCRIPT_NAME 开始 ==="
    log_info "日志文件: $LOG_FILE"
    
    # 预检查
    check_root
    check_current_version
    check_system_resources
    check_network
    
    # 确认升级
    echo
    log_warn "警告: 即将升级到 Debian 13 (trixie)"
    log_warn "请确保已备份重要数据！"
    echo
    read -p "确认开始升级? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "用户取消升级"
        exit 0
    fi
    
    # 执行升级步骤
    create_backup
    update_current_system
    update_sources_list
    perform_upgrade
    verify_upgrade
    cleanup_and_optimize
    generate_report
    
    log_success "=== Debian 升级完成! ==="
    log_info "强烈建议现在重启系统: sudo reboot"
}

# 信号处理
trap 'error_exit "脚本被用户中断"' INT TERM

# 运行主函数
main "$@"