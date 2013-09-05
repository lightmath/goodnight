@echo off
D:
cd D:\Program Files (x86)\Adobe Flash Builder 4.6\sdks\4.6.0\bin
mxmlc -load-config=E:\workspace\DllTool\src\config\project-config.xml -swf-version=18 E:\workspace\DF\src\FDream.as  -output E:\DFSVN\releaseVersion\201309051340\FDream201309051430.swf
copy E:\workspace\DF\doc\Entry.swf E:\DFSVN\releaseVersion\201309051340\Entry.swf
copy E:\workspace\DF\doc\EntryTw.swf E:\DFSVN\releaseVersion\201309051340\EntryTw.swf
copy E:\workspace\DF\src\config\sound_ini.xml E:\DFSVN\releaseVersion\201309051340\config\sound_ini201309051430.xml