On error resume next

Set WshShell = WScript.CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")
Set oWshNetwork = WScript.CreateObject("WScript.Network")

sFolderUsers = "C:\Users\"

For Each UsersSubfolder in FSO.GetFolder(sFolderUsers).SubFolders
	sFolder1 = UsersSubfolder + "\AppData\Roaming\1C\1Cv8"
	
	IF FSO.FolderExists(UsersSubfolder) Then
			
		DelAllCache(sFolder1)
	End If

Next

For Each UsersSubfolder in FSO.GetFolder(sFolderUsers).SubFolders
	sFolder1 = UsersSubfolder + "\AppData\Local\1C\1Cv8"
	
	IF FSO.FolderExists(UsersSubfolder) Then
			
		DelAllCache(sFolder1)
	End If

Next

MsgBox ("Done!")


Sub DelAllCache(FolderPath)
	Set FSO = CreateObject("Scripting.FileSystemObject")
	'MsgBox (FolderPath)
	Set Folder = FSO.GetFolder(FolderPath)
	For Each Subfolder in Folder.SubFolders
		If InStr(Subfolder,"vrs-cache") = 0 Then
			DelAllCache(Subfolder)	
		Else 
			fso.DeleteFolder Subfolder
		End If
	Next
End Sub