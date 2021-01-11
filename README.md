# ![NDART LOGO](/72x72.png?raw=true)
# NDART
## http://ndart.ca
##
## RNSaveAudio Module [![npm version](https://badge.fury.io/js/rnsaveaudio.svg)](https://badge.fury.io/js/rnsaveaudio)
### React-Native | [Home](README.md) | [Useful Links](UsefulLinks.md) | [Custom Module Tutorial](Tut.md)
###
### Purpose
The purpose of this module is to take an array of int16 data from javascript, and create a .wav file from that data, on Android and iOS devices natively. This module is essentially suppose to provide a sink when working with the `react-native-recording` module (https://www.npmjs.com/package/react-native-recording). More information can be found on the projects respective github homepage page -> https://github.com/qiuxiang/react-native-recording#readme...
### Installation
#### Android
1) To install, run `npm install rnsaveaudio`
2) Edit `/android/settings.gradle` and add the following lines...
``` java
include ':rnsaveaudio'
project(':rnsaveaudio').projectDir = new File(rootProject.projectDir, '../node_modules/rnsaveaudio/android')
```
3) Edit `/android/app/build.gradle` and add the following line inside of `dependencies`...
``` java
compile project(':rnsaveaudio')
```
4) Edit `/android/app/src/main/java/.../MainApplication.java` with the follow lines...
- Import the module at the top of the file
```java
import com.navraj.rnsaveaudio.RNSaveAudioPackage;
```
- Instantiate the package inside of the `getPackages()` method
```java
new RNSaveAudioPackage()
```
5) run the command `cd android && gradlew clean && cd ../` for windows, or `cd android && ./gradlew clean && cd ../` for OSX, inside the root directory of your react-native project
#### iOS
1) Open your xCode project and add the `RNSaveAudio.xcodeproj` file to your project
2) Go to your project's build phases, and add the `libRNSaveAudio.a` file to the list labeled `Link Binary With Libraries`, using the `+` under the list
- If you get an error saying xCode cannot find `<RCTEventEmitter.h>`, open `RNSaveAudio.h` inside of the `ios` project folder, and change the the header to `<React/RCTEventEmitter.h>`
- For more information, look at https://github.com/maxs15/react-native-spinkit/wiki/Manual-linking---IOS
### Notes
- Version 1.0.6 is current
- Works on Android and iOS (Tested)
- Sends a promise when complete
- Creates a .wav file based on an array of signed short (SInt16) values at a frequency of 44.1kHz (mono)
- Meant to work with react-native-recording node package and react-native-fs package
### Useage
- Import the module using `import RNSaveAudio from 'rnsaveaudio';`
- Export audio using `RNsaveAudio.saveWav(PATH+'/filename.wav',dataArray);`
- Make sure to include the keywords `await` and `async` if used inside of a function, eg. `async func(prop){ const variable = await RNsaveAudio.saveWav(PATH+'/filename.wav',dataArray); }`
### Contact Information
- My email is `nkambo1@my.bcit.ca`, use the module name in the subject line.
- Submit an issue to the github page. http://github.com/navrajkambo/RNSaveAudio/issues
### Contribution
- If someone would like to add methods for exporting stereo wav files, or files of other formats and sampling frequencies from signed short arrays, feel free to create a PR, it would be useful to have
### Other Information
- If you feel like contributing, send me a message or open an issue! Any help is appreciated :)
- For more information on bridging native modules to react-native, have a look at https://gist.github.com/chourobin/f83f3b3a6fd2053fad29fff69524f91c, https://eastcodes.com/packaging-and-sharing-react-native-modules, and http://matthewsessions.com/2017/10/27/developing-rn-module.html. They are very informative!
