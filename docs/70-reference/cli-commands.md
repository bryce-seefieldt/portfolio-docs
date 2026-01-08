---
title: 'CLI Commands'
description: 'Reference for general CLI commands.'
sidebar_position: 1
tags: [cli, wsl2, powershell, linux]
---

## WSL2 Commands

### Network

#### List Sockets

This command lists all listening TCP network sockets along with their associated process information, then filters the results to show only those using port 3000. Useful for identifying which process is using port 3000 in a WSL environment.

```bash
ss -ltnp | grep ':3000'
```

Example Output:

```bash
LISTEN 0      511                 *:3000             *:*    users:(("MainThread",pid=10015,fd=27))
```

#### Retrieve IP Addresses

Retrieve the first IP address assigned to the WSL2 instance.
It uses `hostname -I` to list all IP addresses associated with the system,
and `awk '{print $1}'` to extract and display only the first one,
which is typically the primary network interface's IP address.

```bash
hostname -I | awk '{print $1}'
```

Example Output:

```bash
172.24.176.1
```

:::Note

The actual IP address will vary depending on your WSL2 instance and network configuration.
