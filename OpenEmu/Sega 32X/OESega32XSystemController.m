/*
 Copyright (c) 2013, OpenEmu Team
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the OpenEmu Team nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OESega32XSystemController.h"
#import "OESega32XSystemResponder.h"
#import "OESega32XSystemResponderClient.h"

#import <OpenEmuSystem/OpenEmuSystem.h>

@implementation OESega32XSystemController

- (NSString *)systemName
{
    if([[OELocalizationHelper sharedHelper] isRegionJAP])
    {
        return @"Super 32X";
    }
    else if([[OELocalizationHelper sharedHelper] isRegionEU])
    {
        return @"Sega Mega Drive 32X";
    }
    else
    {
        return @"Sega 32X";
    }
}

- (NSImage *)systemIcon
{
    NSString *imageName;

    if([[OELocalizationHelper sharedHelper] isRegionJAP])
    {
        imageName = @"32x_jp_library";
    }
    else if([[OELocalizationHelper sharedHelper] isRegionEU])
    {
        imageName = @"32x_eu_library";
    }
    else
    {
        imageName = @"32x_na_library";
    }

    NSImage *image = [NSImage imageNamed:imageName];
    if(image == nil)
    {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForImageResource:imageName];
        image = [[NSImage alloc] initWithContentsOfFile:path];
        [image setName:imageName];
        [image autorelease];
    }
    return image;
}

- (OECanHandleState)canHandleFile:(NSString *)path
{
    if(![[path pathExtension] isEqualToString:@"bin"])
    {
        return OECanHandleUncertain;
    }

    BOOL valid = NO;

    const char *cPath = [path UTF8String];
    FILE *rom = fopen(cPath, "r");
    char systemName[8];
    fseek(rom, 0x100, SEEK_SET);
    size_t readBytes = fread(systemName, sizeof(char), 8, rom);
    fclose(rom);
    if(readBytes == 8 && (memcmp(systemName, "SEGA 32X", 8) == 0))
        valid = YES;

    return valid ? OECanHandleYes : OECanHandleNo;
}

@end
