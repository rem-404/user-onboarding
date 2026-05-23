# userOnboarding_v3
$newUsers = Import-Csv -Path C:\Logs\newusers.csv

if (-not $cred) {
  $cred = Get-Credential -Message "Enter credentials with permissions to create AD users"
}

foreach ($user in $newUsers) {

  $SecurePassword = ConvertTo-SecureString "P@ssword1" -AsPlainText -Force
  $ouPath = "OU=staging users,DC=lab,DC=local"
  $domain = "@lab.local"

  # CSV Values combined
  $fullName = "$($user.GivenName) $($user.SurName)"
  $upn = "$($user.SamAccountName)$domain"

  $userParams = @{
    Name                  = $fullName
    GivenName             = $user.GivenName
    SurName               = $user.SurName
    SamAccountName        = $user.SamAccountName
    UserPrincipalName     = $upn
    AccountPassword       = $SecurePassword
    ChangePasswordAtLogon = $true 
    Enabled               = $true
    #PasswordNeverExpires  = $false <-- just ignore it for now (it's a syntax quirks)
    Path                  = $ouPath
    PassThru              = $true # <-- this will cauht me off guard for sure
    Credential            = $cred
  }
  
  New-ADUser @userParams
}

<#
CSV Format:
GivenName,SurName,SamAccountName
#>
