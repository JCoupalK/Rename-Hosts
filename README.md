# Rename-Hosts
## Rename hostnames of workstations (and only workstations) of an entire domain.
### Hostnames will now have a convention for every workstation which can help problem solving for technicians and just generally ease everything related to them.
#

Right now the convention in the script is letters dash number:
```bash
eg: TEST-001, TEST-002, TEST-003, ..., TEST-101, TEST-102, etc
```
Simply put it those parameters when asked:

![image](https://user-images.githubusercontent.com/108779415/195246020-ac2d4ca8-882c-4382-99f1-4c73dbac6157.png)

(the password is converted to a secure string so it's not stored anywhere in the logs or wherever)

And then let the script run :)

It can take time depending of the number of computers connected to the domain and only renames computers NOT using any Windows Server operating system.

### WARNING: the script reboots workstations after renaming the computers so the new hostname takes effect.
