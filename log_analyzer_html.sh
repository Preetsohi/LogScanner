
#!/bin/bash

# Usage: ./log_analyzer_html.sh /path/to/yourlog.txt

LOGFILE="$1"
if [ -z "$LOGFILE" ]; then
  echo "Usage: $0 /path/to/logfile"
  exit 1
fi

BASENAME=$(basename "$LOGFILE")
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT_DIR="log_analysis_$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"
REPORT="$OUTPUT_DIR/report_${BASENAME%.txt}_$TIMESTAMP.html"

echo "Analyzing log file: $LOGFILE"
echo "Results will be saved in: $REPORT"

# Start HTML Report
cat <<EOF > "$REPORT"
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Log Analysis Report</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f4f4f4; color: #333; padding: 20px; }
    h2 { background: #333; color: #fff; padding: 10px; }
    table { width: 100%%; border-collapse: collapse; margin-bottom: 20px; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background: #eee; }
  </style>
</head>
<body>
  <h1>Log Analysis Report</h1>
  <p>Generated on: $(date)</p>
  <p>Log File: $LOGFILE</p>
EOF

# Function to insert a table into HTML
insert_table() {
  TITLE="$1"
  HEADERS="$2"
  COMMAND="$3"

  echo "<h2>$TITLE</h2><table><tr>" >> "$REPORT"
  for h in $HEADERS; do echo "<th>$h</th>" >> "$REPORT"; done
  echo "</tr>" >> "$REPORT"

  eval "$COMMAND" | while IFS= read -r line; do
    echo "<tr>" >> "$REPORT"
    for cell in $line; do echo "<td>$cell</td>" >> "$REPORT"; done
    echo "</tr>" >> "$REPORT"
  done

  echo "</table>" >> "$REPORT"
}

# Insert tables
insert_table "Top IPs by Request Count" "Requests IP" "awk '{print \$1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -20"

insert_table "Frequent 404 Errors" "IP Count" "grep ' 404 ' "$LOGFILE" | awk '{print \$1}' | sort | uniq -c | sort -nr | head -20"

insert_table "Suspicious Tools Detected" "Count Line" "grep -Ei 'nikto|sqlmap|nmap|acunetix|dirbuster|burp|curl|wpscan|masscan' "$LOGFILE" | awk '{print NR, \$0}'"

insert_table "Bots and Crawlers Detected" "Count Line" "grep -Ei 'bot|crawl|wget|spider|httpclient|python-requests' "$LOGFILE" | awk '{print NR, \$0}'"

insert_table "Suspicious Paths Accessed" "Count Line" "grep -Ei '/etc/passwd|/bin/sh|\.env|\.git|\.\./|wp-admin|config' "$LOGFILE" | awk '{print NR, \$0}'"

insert_table "Unusual HTTP Methods" "Count Line" "grep -E '"(DELETE|PUT|OPTIONS|TRACE|CONNECT)' "$LOGFILE" | awk '{print NR, \$0}'"

# Close HTML
echo "</body></html>" >> "$REPORT"

echo "HTML report created: $REPORT"
