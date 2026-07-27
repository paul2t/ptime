@echo off


rem https://stackoverflow.com/questions/3785976/cmake-generate-visual-studio-2008-solution-for-win32-and-x64


rem ===== Usage
rem builder [-32bit|-64bit] [-Debug|-Release]
rem --> Defaults: -64bit -Release


rem No generator is hardcoded: CMake picks its default, the newest Visual Studio it can find.
rem Override it through the CMAKE_GENERATOR environment variable, e.g. SET CMAKE_GENERATOR=Ninja
rem -A only exists on the Visual Studio generators, so it is dropped whenever one is overridden.
SET ARCH=-A x64
if "%1"=="-32bit" SET ARCH=-A Win32
if defined CMAKE_GENERATOR SET ARCH=

rem First parameter is project folder path
SET PROJECT_DIR="%~dp0"
SET ORIGINAL_DIR="%cd%"

rem Go to project directory
cd %PROJECT_DIR%

rem Second parameter defines 32 bit or 64 bit compilation
if "%1"=="-32bit" (
  echo === Generating 32bit project ===

  rmdir /s /q build_32
  md build_32
  cd build_32
  cmake .. %ARCH%
) ELSE (
  echo === Generating 64bit project ===

  rmdir /s /q build_64
  md build_64
  cd build_64
  cmake .. %ARCH%
)

rem Third parameter defines debug or release compilation
rem cpack is invoked directly rather than through the PACKAGE target, which only the
rem Visual Studio generators spell that way.
if "%2"=="-Debug" (
  echo === Building in Debug mode ===
  cmake --build . --config Debug
  cpack -C Debug
) ELSE (
  echo === Building in Release mode ===
  cmake --build . --config Release
  cpack -C Release
)


rem Go to source code directory and finalize script
cd %ORIGINAL_DIR%

@echo on
