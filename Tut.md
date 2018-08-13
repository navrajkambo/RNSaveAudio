# ![NDART LOGO](/72x72.png?raw=true)
# NDART
## http://ndart.ca
##
## RNSaveAudio Module
### React-Native | [Home](README.md) | [Useful Links](UsefulLinks.md) | [Custom Module Tutorial](Tut.md)
###
### Tutorial For creating your own custom modules, and adding them to npmjs.com
1) Navigate to new project root directory
2) Run the command `npm install` to install the `node_modules` folder with it's react-native dependencies
3) From your root directory, create two folders: `android` & `ios`
#### Android
1) Figure out a package domain name and package name, because the associated directory structure is dependant on it (eg. domain module.navraj.com -> `com.navraj.module` in java with the package `mod` follow directory structure: 
```
.
java
|
+-- com
|     |
|     +-- navraj
|         |
|	  +-- module
|              |
|	       +-- modModule.java
|              |
|	       +-- modPackage.java
```
)

2) Inside the android folder, create the following file structure:
```
.
Project Root
|
+-- android
|    |
|    +-- src
|        |
|        +-- main
|             |
|	      +-- AndroidManifest.xml
|             |
|	      +-- java
|		    |
|		    +-- domain... (look above)
|			  |
|			  +-- modModule.java
|			  |
|			  +-- modPackage.java 
```
3) Open `AndroidManifest.xml` and add the following,
``` xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.navraj.module">
</manifest>
```
, changing the domain name for your module

4) Open `modPackage.java` (where mod is your module name), and add the following (replacing mod with your module name...),
``` java
package com.navraj.module;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class modPackage implements ReactPackage {
@Override
public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
return Collections.<NativeModule>singletonList(new modModule(reactContext));
}

@Override
public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
return Collections.emptyList();
}
}
```

5) Open `modModule.java` and add the following (replace mod with your module name, and add native java methods as needed to this file):
``` java
package com.navraj.module;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableType;

// your imports here...
import java.io.File;
import java.io.IOException;
import java.lang.String;
import java.util.Arrays;

public class modModule extends ReactContextBaseJavaModule {
	public modModule(ReactApplicationContext reactContext) {
		super(reactContext);
	}
	
	@Override
	public String getName() {
		return "mod";
	}

	// this will be exported
	@ReactMethod
	public void yourmethodhere(String path, ReadableArray arrayfromjs, final Promise promise){
		try {
			short[] newarray = new short[arrayfromjs.size()];
			for(int i=0; i<arrayfromjs.size();i++){
				newarray[i] = (short) (arrayfromjs.getInt(i) & 0xFFFF);
			}
			boolean result = privatemethodhere(path, newarray);
			promise.resolve(result);
		} catch (Exception ex) {
			promise.reject("ERR_UNEXPECTED_EXCEPTION", ex);
		}
	}

	private boolean privatemethodhere(String path, short[] rawData) throws Exception{
		return true;
	}
}
```
#### iOS
1) Navigate to your `ios` folder
1) Open xCode and create a new `cocoa touch static library` with your project name (in my case, mod) inside of the `ios` folder
2) When choosing the options for your new project, set the `Organization Identifier:` field to your domain name (eg com.navraj.module)
3) Add a new `cocoa touch class` and name if after your module (mod in my case)
4) Double click on your project name on the left project browser pane, and open up the project build settings
5) Click on your project name under `PROJECT` on the left pane of the new window, and open up `Build Settings`
6) Expand `Search Paths` and add the two entries below to `Header Search Paths` with the `recursive` setting:
- `$(SRCROOT)/../React`
- `$(SRCROOT)/../node_modules/react-native/React`
7) Do the same for the `Target` mod (your module name), under `Build Settings`
8) Add the following code to your header file (`mod.h` in my case)
``` objective-c
#import <AVFoundation/AVFoundation.h> //import whatever you need here

//#import <React/RCTEventEmitter.h> <-- When you're ready to publish, change the header below to this
#import <RCTEventEmitter.h>

@interface mod : NSObject <RCTBridgeModule>

// private method prototypes here
-(BOOL) privatemethodhere:(NSString*)path withdata:(NSMutableData*)rawData;
return true;
}

@end
```
9) Add the following code to your .m file (`mod.m` in my case)
``` objective-c
#import "mod.h"

@implementation mod

RCT_EXPORT_MODULE();

// this will be exported
RCT_EXPORT_METHOD(yourmethodhere:(NSString*)path
						  andArray:(NSArray*)arrayfromjs
                     andacceptor:(RCTPromiseResolveBlock)resolve
                     andrejecter:(RCTPromiseRejectBlock)reject){

	unsigned long len = [arrayfromjs count];
	NSMutableArray *newarray = [[NSMutableArray alloc] initWithCapacity:[arrayfromjs count]];

	for(NSInteger i=0; i<len; i++){
		short int tmp = [[arrayfromjs objectAtIndex:i] intValue] & 0xffff;
		[newarray insertObject:[NSNumber numberWithShort:tmp] atIndex:i];
	}

	BOOL message = [self privatemethodhere:path andArray:newarray];
	NSString *thingToReturn = @"true";
	if(message){
		resolve(thingToReturn);
	}else{
		reject(@"Failed", [[@"Failed to do " stringByAppendingString:path] stringByAppendingString:@" sorry..."], nil);
	}
}

-(bool) privatemethodhere:(NSString*)path withdata:(SInt16*)rawData {
	return true;
}

@end
```
10) Navigate to your root project folder and create a `index.js` file
11) Add the following to your `index.js` file (replacing mod with your module name, and your exported module methods)
``` javascript
import {NativeModules} from 'react-native';
const {mod} = NativeModules;

export default {
yourmethodhere: (path, arrayfromjs) => mod.yourmethodhere(path, arrayfromjs),
}
```
12) Build and test your module locally
13) When you're ready to publish your module, delete the `node_modules` folder
14) Open your module header file (`mod.h` in my case) and change `#import <RCTEventEmitter.h>`  to `#import <React/RCTEventEmitter.h>` (or equivalent, if you didn't use `RCTEventEmitter.h`)
15) Redo steps 4) to 7), except replace the paths as follows:
- `$(SRCROOT)/../../../React`
- `$(SRCROOT/../../react-native/React)`
16) Run `npm init` to create a `package.json` file with all the relevant details for your package, and make sure to set your entry point as `index.js`
17) Run `npm publish` to add your package to `https://npmjs.com`, assuming you're signed into your npmjs account (look only for instructions on how to do this)
18) Create a new project, and install it using `npm install mod` (change mod with your package name)
- You should add optional `LICENSE` and `README.md` files to your project
### Directory Structure
```
.
Project Root
|
+-- android
|    |
|   +-- src
|        |
|        +-- main
|             |
|	      +-- AndroidManifest.xml
|             |
|	      +-- java
|		    |
|		    +-- com
|			 |
|			 +-- navraj
|			      |
|			      +-- module
|			  	    |
|			  	    +-- modModule.java
|			  	    |
|			  	    +-- modPackage.java 
|
+-- ios
|    |
|    +-- mod.h
|    |
|    +-- mod.m
|    |
|    +-- mod.xcodeproj
|
+-- package.json
|
+-- index.js
```
