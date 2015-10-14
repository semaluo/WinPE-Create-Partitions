@echo off
REM	https://msdn.microsoft.com/en-us/library/windows/hardware/dn293283.aspx

wpeutil UpdateBootInfo
for /f "tokens=2* delims=	 " %%A in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') DO SET Firmware=%%B
:: Note: delims is a TAB followed by a space.

echo PEFirmwareType %Firmware%

::	Create Partitions based on 
if %Firmware%==0x1 goto BIOS
if %Firmware%==0x2 goto UEFI
exit /b

:BIOS
echo select disk 0 >"%Temp%\CreatePartitions-BIOS.txt"
echo clean>>"%Temp%\CreatePartitions-BIOS.txt"
echo rem == 1. System partition =========================>>"%Temp%\CreatePartitions-BIOS.txt"
echo create partition primary size=984>>"%Temp%\CreatePartitions-BIOS.txt"
echo format quick fs=ntfs label="System">>"%Temp%\CreatePartitions-BIOS.txt"
echo assign letter="S">>"%Temp%\CreatePartitions-BIOS.txt"
echo active>>"%Temp%\CreatePartitions-BIOS.txt"
echo rem == 2. Windows partition ========================>>"%Temp%\CreatePartitions-BIOS.txt"
echo create partition primary>>"%Temp%\CreatePartitions-BIOS.txt"
echo format quick fs=ntfs label="Windows">>"%Temp%\CreatePartitions-BIOS.txt"
echo assign letter="W">>"%Temp%\CreatePartitions-BIOS.txt"
echo rem ================================================>>"%Temp%\CreatePartitions-BIOS.txt"
echo rescan>>"%Temp%\CreatePartitions-BIOS.txt"
echo list volume>>"%Temp%\CreatePartitions-BIOS.txt"
echo exit>>"%Temp%\CreatePartitions-BIOS.txt"

diskpart /s %Temp%\CreatePartitions-BIOS.txt
exit /b

:UEFI
echo select disk 0 >"%Temp%\CreatePartitions-UEFI.txt"
echo clean>>"%Temp%\CreatePartitions-UEFI.txt"
echo convert gpt>>"%Temp%\CreatePartitions-UEFI.txt"
echo rem == 1. Windows RE tools partition ===============>>"%Temp%\CreatePartitions-UEFI.txt"
echo create partition primary size=984>>"%Temp%\CreatePartitions-UEFI.txt"
echo set id=DE94BBA4-06D1-4D40-A16A-BFD50179D6AC>>"%Temp%\CreatePartitions-UEFI.txt"
echo gpt attributes=0x8000000000000001>>"%Temp%\CreatePartitions-UEFI.txt"
echo format quick fs=ntfs label="Windows RE tools">>"%Temp%\CreatePartitions-UEFI.txt"
echo assign letter=T>>"%Temp%\CreatePartitions-UEFI.txt"
echo rem == 2. System partition =========================>>"%Temp%\CreatePartitions-UEFI.txt"
echo create partition efi size=200>>"%Temp%\CreatePartitions-UEFI.txt"
echo format quick fs=fat32 label="System">>"%Temp%\CreatePartitions-UEFI.txt"
echo assign letter=S>>"%Temp%\CreatePartitions-UEFI.txt"
echo rem == 3. Microsoft Reserved (MSR) partition =======>>"%Temp%\CreatePartitions-UEFI.txt"
echo create partition msr size=128>>"%Temp%\CreatePartitions-UEFI.txt"
echo rem == 4. Windows partition ========================>>"%Temp%\CreatePartitions-UEFI.txt"
echo create partition primary>>"%Temp%\CreatePartitions-UEFI.txt"
echo gpt attributes=0x0000000000000000>>"%Temp%\CreatePartitions-UEFI.txt"
echo format quick fs=ntfs label="Windows">>"%Temp%\CreatePartitions-UEFI.txt"
echo assign letter=W>>"%Temp%\CreatePartitions-UEFI.txt"
echo rem ================================================>>"%Temp%\CreatePartitions-UEFI.txt"
echo rescan>>"%Temp%\CreatePartitions-UEFI.txt"
echo list volume>>"%Temp%\CreatePartitions-UEFI.txt"
echo exit>>"%Temp%\CreatePartitions-UEFI.txt"

diskpart /s %Temp%\CreatePartitions-UEFI.txt
exit /b