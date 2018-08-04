package com.ndart.RNSaveAudio;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import android.widget.Toast;

public class RNSaveAudioModule extends ReactContextBaseJavaModule {
    
    public RNSaveAudioModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }
    
    @Override
    public String getName() {
        return "RNSaveAudioModule";
    }
    
    @ReactMethod
    public void show(string message) {
        //Toast.makeText(getReactApplicationContext(), message, Toast.LENGTH_LONG).show();
    }
}
