@echo off
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"
set "ANDROID_HOME=C:\Android"

echo --- Accepting Licenses ---
(for /l %%i in (1,1,30) do @echo y) | C:\Android\cmdline-tools\latest\bin\sdkmanager.bat --sdk_root=C:\Android --licenses

echo --- Installing SDK Components ---
(for /l %%i in (1,1,30) do @echo y) | C:\Android\cmdline-tools\latest\bin\sdkmanager.bat --sdk_root=C:\Android "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo --- Done ---
