# 🛠️ CLI Log Analyzer Tool – Full Development Summary

This document summarizes the full conversation regarding the development of a CLI-based log analysis tool, covering tool suggestions, commands, automation, and publishing.

---

## ✅ Objective

Build a CLI tool to analyze server log files for:
- Bot attacks
- Vulnerability scans
- High request frequency from IPs
- Suspicious access patterns
- Export HTML dashboard reports

---

## 🔍 Infra & OS Audit

### Nmap Deep Scan for Infra Audit
```bash
nmap -A -T4 -p- -Pn <target-ip>
```

### Extract OS from IP
```bash
nmap -O <target-ip>
```

---

## 🧰 OS Vulnerability Scanning Tools

| S.No | Tool        | Free/Paid | License Type | Install Command                                   | Scan Command                                       | Output Format                      |
|------|-------------|-----------|---------------|---------------------------------------------------|---------------------------------------------------|------------------------------------|
| 1    | Lynis       | Free      | GPL           | `sudo apt install lynis`                          | `sudo lynis audit system`                         | Text (/var/log/lynis-report.dat)   |
| 2    | Greenbone   | Free      | GPL           | `sudo apt install gvm && sudo gvm-setup`          | `sudo gvm-check-setup && sudo gvm-start`          | HTML via Web UI (https://127.0.0.1:9392) |
| 3    | GoAccess    | Free      | GPL           | `sudo apt install goaccess`                       | `goaccess access.log -o report.html --log-format=COMBINED` | HTML or Terminal            |
| 4    | Custom Bash | Free      | MIT           | Place `log_analyzer_html.sh` and run              | `./log_analyzer_html.sh /path/to/logfile.log`     | HTML dashboard                    |

---

## 🔍 Log Analysis with grep & awk

### High CPU or Request Usage (Top IPs)
```bash
awk '{print $1}' /path/to/access.log | sort | uniq -c | sort -nr | head -20
```

### Tools or Scanner Detection
```bash
grep -Ei 'sqlmap|nikto|acunetix|nmap|nessus|fimap' /path/to/access.log
```

### Bots, Crawlers, Spiders
```bash
grep -Ei 'bot|crawl|spider|wget|curl|python-requests' /path/to/access.log | sort | uniq -c | sort -nr | head
```

### Suspicious HTTP Methods
```bash
grep -Ei '"(DELETE|PUT|TRACE|CONNECT|OPTIONS)' /path/to/access.log
```

### Repeated 4xx/5xx Errors
```bash
awk '$9 ~ /^4|5/' /path/to/access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head
```

---

## 🧾 Bash Script Enhancements

Features:
- Accepts log file as input argument
- Auto-creates output folder with timestamp
- HTML dashboard creation using Bash + CSS

Sample run:
```bash
./log_analyzer_html.sh /var/log/apache2/access.log
```

---

## 📦 CLI Tool Files for GitHub

- `log_analyzer_html.sh` – Bash script to parse logs
- `README.md` – Project documentation
- `LICENSE` – MIT
- `.gitignore` – Ignore log files, generated output

---

## ✅ Next Steps to Publish on GitHub

```bash
git init
git add .
git commit -m "Initial commit - CLI log analyzer"
git branch -M main
git remote add origin https://github.com/yourusername/log-analyzer-cli.git
git push -u origin main
```

---