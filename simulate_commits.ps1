# Configure Git user
git config user.name "Gonga Akshay"
git config user.email "gongaakshay@gmail.com"

# Create activity file if it doesn't exist
if (-Not (Test-Path "activity.txt")) {
    New-Item -Path "." -Name "activity.txt" -ItemType "File" | Out-Null
}

# Function to generate N random dates for a specific weekday (1 = Monday, 7 = Sunday)
function Get-RandomDatesForWeekday {
    param (
        [int]$TargetWeekday,
        [int]$Count
    )

    $startDate = Get-Date "2024-07-20"
    $endDate = Get-Date "2025-07-20"
    $validDates = @()

    while ($startDate -le $endDate) {
        if ($startDate.DayOfWeek.value__ -eq (($TargetWeekday - 1) % 7)) {
            $validDates += $startDate.ToString("yyyy-MM-dd")
        }
        $startDate = $startDate.AddDays(1)
    }

    return $validDates | Get-Random -Count $Count
}

# Get 12 random Mondays (1) and 15 random Sundays (7)
$mondays = Get-RandomDatesForWeekday -TargetWeekday 1 -Count 12
$sundays = Get-RandomDatesForWeekday -TargetWeekday 7 -Count 15

# Merge and sort all commit days
$commitDays = ($mondays + $sundays) | Sort-Object

# Loop through each day and make 4–8 commits per day
foreach ($date in $commitDays) {
    $commitCount = Get-Random -Minimum 4 -Maximum 9
    for ($i = 1; $i -le $commitCount; $i++) {
        $timestamp = "$date 12:$((Get-Random -Minimum 0 -Maximum 60)):00"
        $env:GIT_AUTHOR_DATE = $timestamp
        $env:GIT_COMMITTER_DATE = $timestamp
        Add-Content -Path "activity.txt" -Value "$date - Commit $i"
        git add activity.txt
        git commit -m "Commit $i on $date"
    }
}
