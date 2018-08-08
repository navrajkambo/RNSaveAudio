# ![NDART LOGO](/72x72.png?raw=true)
# NDART
## http://ndart.ca
##
## RNSaveAudio Module
### React-Native
### Purpose
The purpose of this module is to take an array of int16 data from javascript, and create a .wav file from that data, on Android and iOS devices natively. This module is essentially suppose to provide a sink when working with the `react-native-recording` module (https://www.npmjs.com/package/react-native-recording). More information can be found on the projects respective github homepage page -> https://github.com/qiuxiang/react-native-recording#readme...
### Installation
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
__Make sure to link the module (look online for more information)__
### Notes
- Currently exports on Android only (Tested)
- Working on iOS soon... (Testing)
### Useage
- Import the module using `import RNSaveAudio from 'rnsaveaudio';`
- Export audio using `RNsaveAudio.saveWav(PATH+'/filename.wav',dataArray);`
- Make sure to include the keywords `await` and `async` if used inside of a function, eg. `async func(prop){ const var = await RNsaveAudio.saveWav(PATH+'/filename.wav',dataArray); }`
### Contact Information
- My email is `nkambo1@my.bcit.ca`, use the module name in the subject line.
- Submit an issue to the github page. http://github.com/navrajkambo/RNSaveAudio/issues
### Other Information
- If you feel like contributing, send me a message or open an issue! Any help is appriciated :)
- For more information on bridging native modules to react-native, have a look at https://gist.github.com/chourobin/f83f3b3a6fd2053fad29fff69524f91c, and http://matthewsessions.com/2017/10/27/developing-rn-module.html. They are very informative!
