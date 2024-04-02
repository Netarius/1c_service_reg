#Регистрируем и запускаем службу 1С:
$serviceName = Read-Host "Введите имя службы" 
$description = "Агент сервера $serviceName "
$regport = Read-Host "Ввeдите regport"
$port = Read-Host "Ввeдите port"
$range = Read-Host "Ввeдите rage xxxx:xxxx"
$path = Read-Host "Введите путь"
$version= Read-Host "Введите версию платформы"
    if (Get-Service $serviceName -ErrorAction SilentlyContinue) { 
        Stop-Service -Name $serviceName -Force; 
        $serviceToRemove = Get-WmiObject -Class Win32_Service -Filter "name = '$serviceName'"; 
        $serviceToRemove.delete(); Write-Host "$_ - Служба 1С успешно удалена" -ForegroundColor Cyan; 
        } 
    else { "service does not exists" }
#installing service 1C
$binaryPath ="""C:\Program Files\1cv8\"+$Version+"\bin\ragent.exe`" -srvc -agent -regport "+$regport+" -port "+$port+" -range "+$range+" -d "+$path+""
New-Service -Name $serviceName -BinaryPathName $binaryPath -displayName $description -startupType Automatic; 
Start-Service -Name $serviceName;
#Проверяем, установлена ли служба 1С:
    if (Get-Service $serviceName -ErrorAction SilentlyContinue) { 
        Write-host "$_ - Служба 1С установлена" -ForegroundColor Green; 
        } 
    else { Write-Host "$_ - Служба 1С не установлена" -ForegroundColor Red; }
#Проверяем. запущена ли служба 1С:
    if (Get-Service -Name $serviceName | Where-Object {$_.Status -EQ "Running"}) { 
        Write-Host "$_ - Служба 1С успешно запущена" -ForegroundColor Green; 
        } 
    else { Write-Host "$_ - Служба 1С не запущена" -ForegroundColor Red; } 

#Регистрируем консоль администрирования:
$regbin = "C:\Program Files\1cv8\"+$Version+"\bin\radmin.dll"
try { Invoke-Command -computername $env:computername {cmd /c (regsvr32 /s $regbin)}; Write-host "$_ - Консоль администрирования 1С зарегистрирована" -ForegroundColor Green; } 
catch{ Write-host "$_ - Консоль администрирования 1С не зарегистрирована" -ForegroundColor Red; }
