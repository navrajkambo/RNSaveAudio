#import "RNSaveAudio.h"

@implementation RNSaveAudio

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(saveWav:(NSString*)path
       andArray:(NSArray*)audio
    andacceptor:(RCTPromiseResolveBlock)resolve
    andrejecter:(RCTPromiseRejectBlock)reject){
  
    SInt16 *newaudio = NULL;
    for(NSInteger i=0; i<[audio count]; i++){
        id element = [audio objectAtIndex:i];
        SInt16 tmp = [element intValue] & 0xffff;
        newaudio[i] = tmp;
    }
    BOOL message = [self SaveFile:path andArray:newaudio];
    NSString *thingToReturn = @"true";
    if(message){
        resolve(thingToReturn);
    }
}

-(bool) SaveFile:(NSString*)path
        andArray:(SInt16*)rawData {
  
    //bool ret = true;
    NSMutableData *data = [[self get16BitPcm:rawData] mutableCopy];
  
    // WAVE header
    // see http://ccrma.stanford.edu/courses/422/projects/WaveFormat/
    // https://stackoverflow.com/questions/32312508/audio-file-format-issue-in-objective-c iOS
  
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
	
    NSMutableData *wavFileData = [NSMutableData dataWithBytes:header length:44];
    [wavFileData appendBytes:[data bytes] length:[data length]];
    //NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    [wavFileData writeToFile:path atomically:YES];
    return true;
}

-(NSMutableData*) get16BitPcm:(SInt16*)data {
    int len = sizeof(data)/sizeof(SInt16);
    int len2 = len*2;
    unsigned char *aBuffer;
    aBuffer = malloc(len2);
    NSMutableData *resultData = [NSMutableData dataWithBytes:aBuffer length:len2];
    //*little_endian_short_array = NSSwapShort();
    char tmp1,tmp2;
  
    int iter = 0;
    for (int i=0; i<len; i++){
        SInt16 sample = data[i];
        SInt16 maxSample = (sample * 32767); // 32767 is Short.MAX_VAL equivalent
        tmp1 = maxSample & 0x00ff;
        tmp2 = (maxSample & 0xff00) >> 8;
        iter +=1;
        [resultData replaceBytesInRange:NSMakeRange(iter, iter+1) withBytes:&tmp1 length:strlen(&tmp1)];
        iter +=1;
        [resultData replaceBytesInRange:NSMakeRange(iter, iter+1) withBytes:&tmp2 length:strlen(&tmp2)];
    }
	
    NSMutableData *endianData = [resultData mutableCopy];
    uint32_t *bytes = endianData.mutableBytes;
    *bytes = CFSwapInt32(*bytes);
	
    return endianData;
}

@end
