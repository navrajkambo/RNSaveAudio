# ![NDART LOGO](/android/src/main/res/raw/72x72.png?raw=true)
# NDART
## http://ndart.ca
##
## RNSaveAudio Module
### React-Native
### Purpose
The purpose of this module is to take an array of int16 data from javascript, and create a .wav file from that data, on Android and iOS devices natively. This module is essentially suppose to provide a sink when working with the `react-native-recording` module (https://www.npmjs.com/package/react-native-recording). More information can be found on the projects respective github homepage page -> https://github.com/qiuxiang/react-native-recording#readme...
### Installation
- To install, run `npm install rnsaveaudio`
- Make sure to link the module __(look online for more information)__
### Notes
- Currently exports on Android only, however play static... (working on resolving the issue)
- Working on iOS soon...
### Useage
- Import the module using `import RNSaveAudio from 'rnsaveaudio';`
- Export audio using `RNsaveAudio.saveWav(PATH,'filename.wav');`
- Make sure to include the keywords `await` and `async` if used inside of a function, eg. `async func(prop){ const var = await RNsaveAudio.saveWav(PATH,'filename.wav'); }`
### Contact Information
- My email is `nkambo1@my.bcit.ca`, use the module name in the subject line.
- Submit an issue to the github page. http://github.com/navrajkambo/RNSaveAudio/issues
### Other Information
- If you feel like contributing, send me a message or open an issue! Any help is appriciated :)
- For more information on bridging native modules to react-native, have a look at https://gist.github.com/chourobin/f83f3b3a6fd2053fad29fff69524f91c, and http://matthewsessions.com/2017/10/27/developing-rn-module.html. They are very informative!
