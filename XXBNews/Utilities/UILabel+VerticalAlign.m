//
//  UILabel+VerticalAlign.m
//  XXBNews
//
//  Created by xuxubin on 15/8/18.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticleAlign)

/**
 *  将label中的文字置顶，思路是字符串后面加换行符
 */
- (void) alignToTop
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;
    
//    CGSize stringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(finalWidth, finalHeight)];
    
    int newLinesToPad = (finalHeight - stringSize.height)/fontSize.height;
    for(int i=0;i<newLinesToPad;i++)
    {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize;
}

@end
