# React-native setup in Windows 10 for Ryzen CPU

This is a guide to setup and run react-native app on a ryzen system. 

### Requirements
* [Visual Studio Android Emulator](https://www.visualstudio.com/vs/msft-android-emulator/)
* [Android sdk tools](https://developer.android.com/studio/index.html)
* [Android platform tools](https://developer.android.com/studio/releases/platform-tools.html)
* [Node.js](https://nodejs.org/en/)
* [Expo XDE (react-native)](https://expo.io)

### Visual studio emulator setup

The below steps will ensure that the emulator won't have stability issues when it runs

* Install Visual Studio Android Emulator and any of the profile
* Go to hyper-v manager
* Looks for the vm with the profile name you downloaded
* Right-click and go to settings
* Go to Processor and click on compatibility
* Check **Migrate to a physical computer with a different processor version** option
* Click apply and then ok


### Platform-tools adb setup
* Set up adb in your PATH
* In powershell `adb start-server`
* Start emulator and get it's ip address from `about phone` settings
* In powershell `adb connect {ip}:5555`

### Expo setup
* Install expo
* Create new project and start
* Once it is ready, click on Share -> Connect to android
