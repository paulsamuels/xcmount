#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASRubyErrorFormatter.h"

// Constants
#import "PASXcmountfileParser.h"

SpecBegin(PASRubyErrorFormatter)

describe(@"PASRubyErrorFormatter", ^{
  
  it(@"pretty prints the error", ^{
    
    NSString *xcmountfile = ({
      @"xcodeproj \"Test\"\n"
      @"\n"
      @"target \"A\", \"B\" do\n"
      @"  mount \"Test/Source\", \"Test/Source\"\n"
      @"end\n"
      @"\n"
      @"target \"Specs\" do\n"
      @"  mount \"Specs/Source\", \"Specs/Source\"as\n"
      @"end";
    });
    
    NSString *result = ({
      [PASRubyErrorFormatter.new formatString:@"-e:29: syntax error, unexpected tIDENTIFIER, expecting keyword_end"
                              withXcmountfile:xcmountfile
                                 parserString:PASXcmountfileParser()];
    });
    
    NSString *formatted = ({
      @"syntax error, unexpected tIDENTIFIER, expecting keyword_end\n"
      @"\n"
      @"   xcodeproj \"Test\"\n"
      @"   \n"
      @"   target \"A\", \"B\" do\n"
      @"     mount \"Test/Source\", \"Test/Source\"\n"
      @"   end\n"
      @"   \n"
      @"   target \"Specs\" do\n"
      @"->   mount \"Specs/Source\", \"Specs/Source\"as\n"
      @"   end";
    });
    
    expect(result).to.equal(formatted);
  });
  
});

SpecEnd
