#import <AVFoundation/AVFoundation.h>
//#import <RCTEventEmitter.h>
#import <React/RCTEventEmitter.h>
@interface RNSaveAudio : NSObject <RCTBridgeModule>
@property (nonatomic) NSError *error;

-(bool) SaveFile:(NSString*)path
        andArray:(NSMutableArray*)rawData;
-(NSMutableData*) get16BitPcm:(NSMutableArray*)data;
// debugging
-(NSURL *) applicationDocumentsDirectory;
-(void) writeTextFile:(NSString*)filename
          withContent:(NSMutableArray*)data;
@end
