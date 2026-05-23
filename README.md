# AD User Onboarding Script

## What does it do
Reads a CSV of new users and creates their Active Directory accounts. 
For each user it:
- Creates the AD account with full name, UPN, and SAM account name
- Sets a default password and forces a password change on first login
- Places the account in a staging OU for review before moving to the right department

## What does it solve
Manually creating AD accounts one by one is repetitive and easy to get wrong — typos in names, wrong OU, forgetting to tick "change password at logon". This runs through the whole thing consistently from a CSV.


## Who's it for
Sysadmins handling user onboarding in a Windows/Active Directory environment. Works well for batch onboarding or just a single new user.

## Requirements
- PowerShell with the ActiveDirectory module (RSAT)
- Credentials with permissions to create AD users — the script will prompt via `Get-Credential` if `$cred` isn't already set in your session
- A CSV file at `C:\Logs\newusers.csv` with these columns:

```plaintext
GivenName,SurName,SamAccountName
Juan,DelaCruz,jdCruz
```

**The staging OU must already exist:** `OU=staging users,DC=lab,DC=local` — update to match your domain

## Warning
Default password is hardcoded as `P@ssword1` — fine for a lab, change this before using anywhere real
The `$ouPath` and `$domain` are hardcoded variables — update them before running in your environment
Tested for single user so far — bulk behavior should be fine but worth validating with a few test accounts first
PassThru is in the params — means New-ADUser will return the created user object to the pipeline. Will throw a wall of text if run with multiple users

## Limitations
- No error handling yet — one bad row in the CSV and the loop stops there
- No duplicate checking — if the account already exists it'll just error out
- Password is the same for every user in the batch
- No logging — you won't have a record of who got created unless you check AD manually

## Notes
Work in progress — error handling and input validation coming in the next iteration.
