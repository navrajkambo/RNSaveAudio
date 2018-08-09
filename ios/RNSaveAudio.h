#import <AVFoundation/AVFoundation.h>
//#import <RCTEventEmitter.h>
#import <RCTEventEmitter.h>

@interface RNSaveAudio : NSObject <RCTBridgeModule>

//- (void)processInputBuffer:(AudioQueueBufferRef)inBuffer queue:(AudioQueueRef)queue;

-(bool) SaveFile:(NSString*)path
        andArray:(short int [])rawData;
-(NSMutableData*) get16BitPcm:(short int*)data;

@end
