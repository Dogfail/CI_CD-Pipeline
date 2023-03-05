$pcs = cat comps.txt;

foreach($pc in $pcs)
{
    if (Test-Connection -ComputerName $pc -Count 2 -Quiet -ErrorAction SilentlyContinue){
    
        #���������� �� 64bit Windows
        if (Test-Path -Path "\\$pc\c$\Program Files (x86)\")
        {   
            gci "\\$pc\c$\Users\*\AppData\Roaming\"|% {#���������� �� ���� ������ ������������� �� ��
            
                $path = $_.Fullname          
                $folder = "\nintegra"
                $fullpath = $path + $folder  #��������� ������ ���� �� �����, ��� �������� ������ ��������� 
                
                if (!(Test-Path -Path $fullpath)){ #���� ������ ���� �� ����������...
                
                mkdir -p $fullpath   #...�� �� ���������
                Copy-Item -Path \\dc1\soft\nintegra\hlms.ini -Destination $fullpath #� ���������� � dc1 ������ � �����, ��� �� ������ �����������
                }
                elseif (Test-Path -Path $fullpath){
                Copy-Item -Path \\dc1\soft\nintegra\hlms.ini -Destination $fullpath #���� ����������, �� �������� ���� � ��� ��������� �����
                }
                }
   
            xcopy "\\dc1\soft\EducationMO_win_64" "\\$pc\c$\Program Files\EducationMO_win" /i /Y /H; #�������� exe ��������� �� ��
            xcopy "\\dc1\soft\����� ����������� ��.lnk" "\\$pc\c$\Users\Public\Desktop\" /i /Y /H; #������� ����� ��� ���� ������������� ��
        } 
        
        #���������� �� 32bit Windows
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
            xcopy "\\dc1\soft\����� ����������� ��_32.lnk" "\\$pc\c$\Users\Public\Desktop\" /i /Y /H;
        }     
    }
    
    else 
    {
        Add-Content D:\Scripts\psdownloadfile\not_reachable_pcs.txt $pc #���� �� �� ��������, ��������� � ���� not_reachable_pcs
    
    }
    
    
        
}