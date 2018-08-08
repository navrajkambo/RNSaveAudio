#import <AVFoundation/AVFoundation.h>
#import <React/RCTEventEmitter.h>

@interface RNSaveAudio : NSObject <RCTBridgeModule>

//- (void)processInputBuffer:(AudioQueueBufferRef)inBuffer queue:(AudioQueueRef)queue;

-(bool) SaveFile:(NSString*)path (short int)rawData;
-(NSData*) get16BitPcm:(short int)data;

@end
