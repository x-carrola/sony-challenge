# sony-challenge

In this challenge, we will focus on the 4th phase of hacking a system: the **post-exploitation** stage. Therefore, we 
will assume that we already have access to the target and that we want mainly two things:

* maintain access to the target, in case of a reboot or any issue that may kick us from the system

* escalate our privileges to have more control over the target (get *root* permissions, if possible)

The **attack vectors** that are going to be used for **privilege escalation** are:

* Misconfigured services

* Insufficient files and services permissions

* Kernel vulnerabilities

* Vulnerable software running with elevated privileges

* Sensitive information stored in local files (e.g. hard-coded credentials)







## References

* https://book.hacktricks.xyz/linux-hardening/linux-privilege-escalation-checklist