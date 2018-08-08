/**
 * @providesModule RNSaveAudio
 * @flow
 */
'use strict';

var NativeRNSaveAudio = require('NativeModules').RNSaveAudio;

/**
 * High-level docs for the RNSaveAudio iOS API can be written here.
 */

var RNSaveAudio = {
  test: function() {
    NativeRNSaveAudio.test();
  }
};

module.exports = RNSaveAudio;
