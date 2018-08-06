import {NativeModules} from 'react-native';
const {RNSaveAudio} = NativeModules;

export default {
    saveWav: (path, audio) => RNSaveAudio.saveWav(path, audio),
}

//module.exports = NativeModules.RNSaveAudio;
