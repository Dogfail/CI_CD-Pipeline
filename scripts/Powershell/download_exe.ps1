$pcs = cat comps.txt;

foreach($pc in $pcs)
{
    if (Test-Connection -ComputerName $pc -Count 2 -Quiet -ErrorAction SilentlyContinue){
    
        #Установить на 64bit Windows
        if (Test-Path -Path "\\$pc\c$\Program Files (x86)\")
        {   
            gci "\\$pc\c$\Users\*\AppData\Roaming\"|% {#Проходится по всем папкам пользователей на ПК
            
                $path = $_.Fullname          
                $folder = "\nintegra"
                $fullpath = $path + $folder  #Сохраняет полный путь до папки, где хранится конфиг программы 
                
                if (!(Test-Path -Path $fullpath)){ #Если полный путь не существует...
                
                mkdir -p $fullpath   #...то он создается
                Copy-Item -Path \\dc1\soft\nintegra\hlms.ini -Destination $fullpath #И копируется с dc1 конфиг в папку, где он должен содержаться
                }
                elseif (Test-Path -Path $fullpath){
                Copy-Item -Path \\dc1\soft\nintegra\hlms.ini -Destination $fullpath #Если существует, то копирует файл в уже созданную папку
                }
                }
   
            xcopy "\\dc1\soft\EducationMO_win_64" "\\$pc\c$\Program Files\EducationMO_win" /i /Y /H; #Копирует exe программы на ПК
            xcopy "\\dc1\soft\Новое Образование МО.lnk" "\\$pc\c$\Users\Public\Desktop\" /i /Y /H; #Создает ярлык для всех пользователей ПК
        } 
        
        #Установить на 32bit Windows
        else
        {
        
         gci "\\$pc\c$\Users\*\AppData\Roaming\"|% {
                $path = $_.Fullname
                $folder = "\nintegra"
                $fullpath = $path + $folder
                
                if (!(Test-Path -Path $fullpath)){
                
                mkdir -p $fullpath
                Copy-Item -Path \\dc1\soft\nintegra\hlms.ini -Destination $fullpath
                }
                elseif (Test-Path -Path $fullpath){
                Copy-Item -Path \\dc1\soft\nintegra\hlms.ini -Destination $fullpath
                }
                }
                
            xcopy "\\dc1\soft\EducationMO_win_32" "\\$pc\c$\Program Files\EducationMO_win" /i /Y;
            xcopy "\\dc1\soft\Новое Образование МО_32.lnk" "\\$pc\c$\Users\Public\Desktop\" /i /Y /H;
        }     
    }
    
    else 
    {
        Add-Content D:\Scripts\psdownloadfile\not_reachable_pcs.txt $pc #Если ПК не доступен, добавляет в файл not_reachable_pcs
    
    }
    
    
        
}