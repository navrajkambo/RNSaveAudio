#import <AVFoundation/AVFoundation.h>
//#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface RNSaveAudio : NSObject <RCTBridgeModule>

//- (void)processInputBuffer:(AudioQueueBufferRef)inBuffer queue:(AudioQueueRef)queue;

-(bool) SaveFile:(NSString*)path
        andArray:(short int [])rawData;
-(NSData*) get16BitPcm:(short int [])data;

@end
