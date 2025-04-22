# Log Analyzer CLI

A lightweight CLI tool to analyze web server log files and generate an HTML dashboard report for security auditing and suspicious activity detection.

## 🚀 Features
- Detect top IPs by request volume
- Identify vulnerability scanners (e.g., sqlmap, Nikto)
- Track common bots/crawlers
- Highlight 404 abuse attempts
- Detect unusual HTTP methods and suspicious paths
- Outputs a structured, styled HTML dashboard

## 📦 Requirements
- Bash
- awk, grep, sort, uniq

Works natively on Kali Linux and most Unix-like systems.

## 📄 Usage

```bash
chmod +x log_analyzer_html.sh
./log_analyzer_html.sh /full/path/to/access.log
```

The report will be saved in a directory named `log_analysis_<timestamp>`.

## 📜 License
MIT