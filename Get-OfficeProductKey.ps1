# Define a function to decode the product key
function Get-OfficeProductKey {
    $officeVersions = @(
        "2010",
        "2013",
        "2016",
        "2019",
        "2021",
        "365"
    )

    $officeProducts = @(
        "ProPlus",
        "ProPlusR",
        "ProPlusVL",
        "HomeBusiness",
        "HomeBusinessR",
        "HomeBusinessVL",
        "Standard",
        "StandardR",
        "StandardVL",
        "HomeStudent",
        "HomeStudentR",
        "HomeStudentVL",
        "Personal",
        "PersonalR",
        "PersonalVL"
    )

    foreach ($version in $officeVersions) {
        foreach ($product in $officeProducts) {
            $keyPath = "HKLM:\SOFTWARE\Microsoft\Office\$version.$product\Registration"

            if (Test-Path $keyPath) {
                $productId = (Get-ItemProperty -Path $keyPath).ProductID

                if ($productId) {
                    Write-Host "Office Version: $version"
                    Write-Host "Product ID: $productId"
                    return
                }
            }
        }
    }

    Write-Host "Office Product Key not found"
}

Get-OfficeProductKey
