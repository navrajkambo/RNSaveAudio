#import "RNSaveAudio.h"

@implementation RNSaveAudio
@synthesize error;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(saveWav:(NSString*)path
       andArray:(NSArray*)audio
    andacceptor:(RCTPromiseResolveBlock)resolve
    andrejecter:(RCTPromiseRejectBlock)reject){

    //[self writeTextFile:@"audiodatajs.txt" withContent:audio]; //debugging
    unsigned long len = [audio count];
    NSMutableArray *newaudio = [[NSMutableArray alloc] initWithCapacity:[audio count]];

    for(NSInteger i=0; i<len; i++){
        short int tmp = [[audio objectAtIndex:i] intValue] & 0xffff;
        [newaudio insertObject:[NSNumber numberWithShort:tmp] atIndex:i];
    }

    BOOL message = [self SaveFile:path andArray:newaudio];
    NSString *thingToReturn = @"true";
    if(message){
        resolve(thingToReturn);
    }else{
      reject(@"WAV_WRITE_FAILED", [[@"Writing the wav file to " stringByAppendingString:path] stringByAppendingString:@" failed..."], error);
    }
}

-(NSMutableData*) get16BitPcm:(NSMutableArray*)data {

  unsigned long len = [data count];
  unsigned long len2 = len*2;
  Byte tmp1,tmp2;
  short int sample, maxSample;
  NSMutableData *resultData = [[NSMutableData alloc] initWithCapacity:len2];

  for (int i=0; i<len; i++){
    sample = [[data objectAtIndex:i] shortValue];
    //maxSample = (sample * 32767); // 32767 is Short.MAX_VAL equivalent
    maxSample = sample;
    tmp1 = maxSample & 0x00ff;
    tmp2 = (maxSample >>8) & 0x00ff;
    [resultData appendBytes:&tmp1 length:1];
    [resultData appendBytes:&tmp2 length:1];
  }
  NSMutableData *endianData = [resultData mutableCopy];
  uint16_t *bytes = endianData.mutableBytes;
  *bytes = CFSwapInt16(*bytes);
  return endianData;
}

-(bool) SaveFile:(NSString*)path
        andArray:(NSMutableArray*)rawData {
    // WAVE header
    // see http://ccrma.stanford.edu/courses/422/projects/WaveFormat/
    // https://stackoverflow.com/questions/32312508/audio-file-format-issue-in-objective-c iOS
    bool ret = true;
    @try{
        //[self writeTextFile:@"test.txt" withContent:rawData]; //debugging
        // get pcm data byte-array
        NSMutableData *data = [self get16BitPcm:rawData];

        // create header byte-array
        long int totalAudioLen = [data length];
        long int totalDataLen = [data length]+36; //headerSize-8
        int sampleRate = 44100;
        SInt16 channels = 1;
        int byteRate = 2 * sampleRate;

        Byte *header = (Byte*)malloc(44);
        header[0] = 'R';  // RIFF/WAVE header
        header[1] = 'I';
        header[2] = 'F';
        header[3] = 'F';

        header[4] = (Byte) (totalDataLen & 0xff);
        header[5] = (Byte) ((totalDataLen >> 8) & 0xff);
        header[6] = (Byte) ((totalDataLen >> 16) & 0xff);
        header[7] = (Byte) ((totalDataLen >> 24) & 0xff);

        header[8] = 'W';
        header[9] = 'A';
        header[10] = 'V';
        header[11] = 'E';

        header[12] = 'f';  // 'fmt ' chunk
        header[13] = 'm';
        header[14] = 't';
        header[15] = ' ';

        header[16] = 16;  // 4 bytes: size of 'fmt ' chunk
        header[17] = 0;
        header[18] = 0;
        header[19] = 0;

        header[20] = 1;  // format = 1
        header[21] = 0;

        header[22] = (Byte) channels;
        header[23] = 0;

        header[24] = (Byte) (sampleRate & 0xff);
        header[25] = (Byte) ((sampleRate >> 8) & 0xff);
        header[26] = (Byte) ((sampleRate >> 16) & 0xff);
        header[27] = (Byte) ((sampleRate >> 24) & 0xff);

        header[28] = (Byte) (byteRate & 0xff);
        header[29] = (Byte) ((byteRate >> 8) & 0xff);
        header[30] = (Byte) ((byteRate >> 16) & 0xff);
        header[31] = (Byte) ((byteRate >> 24) & 0xff);

        header[32] = 2;  // block align
        header[33] = 0;

        header[34] = 16;  // bits per sample
        header[35] = 0;

        header[36] = 'd';
        header[37] = 'a';
        header[38] = 't';
        header[39] = 'a';

        header[40] = (Byte) (totalAudioLen & 0xff);
        header[41] = (Byte) ((totalAudioLen >> 8) & 0xff);
        header[42] = (Byte) ((totalAudioLen >> 16) & 0xff);
        header[43] = (Byte) ((totalAudioLen >> 24) & 0xff);

        // combine data, and write to file
        NSMutableData *wavFileData = [NSMutableData dataWithBytes:header length:44];
        [wavFileData appendBytes:[data bytes] length:[data length]];
        [wavFileData writeToFile:path atomically:YES];
    }
    @catch (NSException *exception) {
        // create error code if it fails anywhere
        NSMutableDictionary * info = [NSMutableDictionary dictionary];
        [info setValue:exception.name forKey:@"ExceptionName"];
        [info setValue:exception.reason forKey:@"ExceptionReason"];
        [info setValue:exception.callStackReturnAddresses forKey:@"ExceptionCallStackReturnAddresses"];
        [info setValue:exception.callStackSymbols forKey:@"ExceptionCallStackSymbols"];
        [info setValue:exception.userInfo forKey:@"ExceptionUserInfo"];
        error = [NSError errorWithDomain:@"com.ndart.rnsaveaudio" code:1 userInfo:info];
        ret = false;
    }
    @finally{
        return ret;
    }
}

// for debugging
- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                 inDomains:NSUserDomainMask] lastObject];
}
-(void) writeTextFile:(NSString*)filename
       withContent:(NSMutableArray*)data{
    NSString *path = [[self applicationDocumentsDirectory].path
    stringByAppendingPathComponent:filename];

    NSString *stringFromArray = NULL;
    NSMutableArray *array= [[NSMutableArray alloc] initWithCapacity: [data count]];
    if(array){
      NSInteger i = 0;
      while(i++ < [data count]){
        [array addObject: [NSString stringWithFormat: @"%d", [[data objectAtIndex:i] shortValue]]];
      }
      stringFromArray = [array componentsJoinedByString:@","];
      //[array release];
    }
    [stringFromArray writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
