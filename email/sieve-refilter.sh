#!/bin/bash
#------------------------------------------------------------------------------
# Reapply user-defined Sieve filters to a Dovecot mail­box folder.
# Refer: https://shoreless.limited/en/knowledge-base/kb20224071315-reapply-dovecot-sieve-filters
#------------------------------------------------------------------------------
# REQUIRE­MENTS:
# awk, cat, doveadm, echo, exit, find, grep, ionice, printf, read, shift,
# sieve-filter, tr, wc, non-POSIX support for `< <()` syntax
#------------------------------------------------------------------------------
# USAGE:
# ./sieve-refilter.sh <user> [<folder>]
#
# Options:
#   <user>             The Dovecot user to reapply Sieve filters for. E.g.,
#                      "user.name@example.com".
#   <folder>           Optional: The mail­box folder to process.
#                      Defaults to 'INBOX.Refilter'.
#------------------------------------------------------------------------------
# Author: SHORELESS Limited <contact@shoreless.limited>
# See https://shoreless.ltd/kb20224071315
#------------------------------------------------------------------------------

# User option.
EMAIL_USER="$1"
if [[ -z "${EMAIL_USER}" ]]; then
  printf "\n\e[1;31mAn argument error occurred.\e[0m\n\n"
  (>&2 printf 'Argument error: The user parameter "<user>" is missing.')
  printf "\n\nUsage: ./sieve-refilter.sh <user> [<folder>]\n\n"
  printf "Options:\n\n"
  printf "  <user>             The Dovecot user to reapply Sieve filters for. E.g.,\n"
  printf "                     \"user.name@example.com\"."
  printf "  <folder>           Optional: The mail­box folder to process.\n"
  printf "                     Defaults to 'INBOX.Refilter'.\n\n"
  exit 22
fi

FOLDER="$2"
if [[ -z "${FOLDER}" ]]; then
  FOLDER="INBOX.Refilter"
fi

# Executes a command while writing STDOUT and STDERR to variables.
#
# @param STDOUT
#   The variable to write STDOUT to.
# @param STDERR
#   The variable to write STDERR to.
# @param COMMAND
#   The command to run.
# @param [ARG1[ ARG2[ ...[ ARGN]]]]
#   Any additional arguments for the command to run.
#
# @return
#   The command exit code.
#
# @see https://stackoverflow.com/questions/11027679/#answer-59592881
catch() {
  {
    IFS=$'\n' read -r -d '' "${1}";
    IFS=$'\n' read -r -d '' "${2}";
    (IFS=$'\n' read -r -d '' _ERRNO_; return ${_ERRNO_});
  } < <((printf '\0%s\0%d\0' "$(((({ shift 2; ${@}; echo "${?}" 1>&3-; } | tr -d '\0' 1>&4-) 4>&2- 2>&1- | tr -d '\0' 1>&4-) 3>&1- | exit "$(cat)") 4>&1-)" "${?}" 1>&2) 2>&1)
}

echo "Dovecot Sieve refilter"
echo "----------------------"
echo "Checking provided options and mail­box:"

# Check, whether the user exists in the local Dovecot instance.
printf '\e[0m- Checking, whether the user exists... '
catch STDOUT STDERR doveadm user "${EMAIL_USER}"
if [ ${?} -eq 0 ]; then
  printf "\e[1;32m[ok]\e[0m\n"
else
  printf "\e[1;31m[error]\e[0m\n"
  (>&2 printf '%s\n%s\n\n' "  User lookup failed." "  ${STDERR}")
  exit 22;
fi

# Determine mail folder.
printf '\e[0m- Determine mail folder... '
MAIL_FOLDER=$(echo "${STDOUT}" | grep '^mail' | awk '{print $2}')
MAIL_FOLDER="${MAIL_FOLDER#maildir:}"
if [[ -z "${MAIL_FOLDER}" ]] || [ ! \( -d "${MAIL_FOLDER}" \) ]; then
  printf "\e[1;31m[error]\e[0m\n"
  (>&2 printf '%s\n%s\n\n' "  Dovecot Maildir could not be found." "  ${MAIL_FOLDER}")
  exit 2;
else
  printf "\e[1;32m[ok]\e[0m\n"
  printf "  ${MAIL_FOLDER}\n"
fi

# Determine sieve script.
printf '\e[0m- Check for Sieve script... '
#SIEVE=$(echo "${STDOUT}" | grep '^sieve' | awk '{print $2}')
HOME=$(echo "${STDOUT}" | grep '^home' | awk '{print $2}')
SIEVE=$HOME/.dovecot.sieve
if [[ -z "${SIEVE}" ]] || [ ! \( -e "${SIEVE}" \) ] || [ ! \( -f "${SIEVE}" \) ] || [ ! \( -r "${SIEVE}" \) ] || [ ! \( -s "${SIEVE}" \) ]; then
  printf "\e[1;31m[error]\e[0m\n"
  (>&2 printf '%s\n%s\n\n' "  Sieve script does not exist or is empty." "  ${SIEVE}")
  exit 2;
else
  printf "\e[1;32m[ok]\e[0m\n"
  printf "  ${SIEVE}\n"
fi

# Count the number of unprocessed messages.
printf '\e[0m- Check for messages to refilter... '
#MAIL_FOLDER="${MAIL_FOLDER}/.${FOLDER}"
MAIL_FOLDER="${MAIL_FOLDER}"
echo ">MAIL_FOLDER: $MAIL_FOLDER"
if [ ! \( -d "${MAIL_FOLDER}/cur" \) ] || [ ! \( -d "${MAIL_FOLDER}/new" \) ]; then
  printf "\e[1;31m[error]\e[0m\n"
  (>&2 printf "  User inbox doesn't have a '${FOLDER}' folder.\n\n")
  exit 2;
fi
# Count the number of files in the target inbox folder.
FILES=`find "${MAIL_FOLDER}/cur/" "${MAIL_FOLDER}/new/" -type f -name '*' | wc -l`
if [ ${FILES} -eq 0 ]; then
  printf "\e[1;33m[warning]\e[0m\n"
  (>&2 printf "  No messages to process. Aborting.\n\n")
  exit 61;
fi

printf "\e[1;32m[ok]\e[0m\n"
printf "  Found ${FILES} messages to process.\n\n"

echo "Running ${FILES} messages in ${FOLDER} through the Sieve filter."
ionice -c2 -n7 sieve-filter -e -W -C -u "${EMAIL_USER}" "${SIEVE}" "${FOLDER}"
