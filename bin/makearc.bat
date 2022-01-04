@echo off

REM This is a example .BAT file that you can setup to run and build
REM your zip archives automatically. Change the "Data.zip" and
REM "password" to your liking.
REM
REM If you keep the "archive" directory in the same directory as
REM your executable, you can load files from the filesystem also
REM without having to change your paths throughout your code during
REM testing.

if exist "Data.zip" (del Data.zip)
ziparc a15bef2d07b24a589c3d78d5ba341a94 Data.zip arc
echo(
pause