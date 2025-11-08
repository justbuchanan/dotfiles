# Provides a `gmail-send` script for sending emails from the
# buchanan.smarthome@gmail.com account.
{
  lib,
  msmtp,
  writeShellScriptBin,
  writeText,
  config,
}:

writeShellScriptBin "gmail-send" ''
  # Simple wrapper around msmtp for sending emails via Gmail
  # Usage: gmail-send --to EMAIL --subject SUBJECT [--body BODY | < stdin]

  FROM="buchanan.smarthome@gmail.com"
  TO=""
  SUBJECT=""
  BODY=""
  READ_STDIN=1

  while [[ $# -gt 0 ]]; do
    case $1 in
      --to)
        TO="$2"
        shift 2
        ;;
      --subject)
        SUBJECT="$2"
        shift 2
        ;;
      --body)
        BODY="$2"
        READ_STDIN=0
        shift 2
        ;;
      --html)
        # HTML flag for compatibility, msmtp sends whatever content-type you specify
        shift
        ;;
      *)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    esac
  done

  if [ -z "$TO" ]; then
    echo "Error: --to is required" >&2
    exit 1
  fi

  if [ -z "$SUBJECT" ]; then
    echo "Error: --subject is required" >&2
    exit 1
  fi

  # Build email
  {
    echo "From: $FROM"
    echo "To: $TO"
    echo "Subject: $SUBJECT"
    echo ""
    if [ $READ_STDIN -eq 1 ]; then
      cat
    else
      echo "$BODY"
    fi
  } | ${msmtp}/bin/msmtp \
      -t

  if [ $? -eq 0 ]; then
    echo "Email sent successfully to $TO" >&2
  else
    echo "Error sending email" >&2
    exit 1
  fi
''
