//
//  GGLayoutManager.swift
//  GGQ
//
//  Created by DianQK13 on 16/5/27.
//  Copyright © 2016年 org.dianqk. All rights reserved.
//

import UIKit

class GGLayoutManager: NSLayoutManager {
    
    
//    override func drawBackgroundForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
////        print(origin)
//        print(glyphsToShow)
//    }

    override func fillBackgroundRectArray(rectArray: UnsafePointer<CGRect>, count rectCount: Int, forCharacterRange charRange: NSRange, color: UIColor) {

        let cornerRadius:CGFloat = 5.0
        let path = CGPathCreateMutable()
        
        if rectCount == 1 || (rectCount == 2 && (CGRectGetMaxX(rectArray[1]) < CGRectGetMaxX(rectArray[0]))) {
            
            CGPathAddRect(path, nil, CGRectInset(rectArray[0], cornerRadius, cornerRadius))
            if rectCount == 2 {
                CGPathAddRect(path, nil, CGRectInset(rectArray[1], cornerRadius, cornerRadius))
            }
            
        } else {
            
            let lastRect = rectCount - 1
            
            CGPathMoveToPoint(path, nil, CGRectGetMinX(rectArray[0]) + cornerRadius, CGRectGetMaxY(rectArray[0]) + cornerRadius);
            
            CGPathAddLineToPoint(path, nil, CGRectGetMinX(rectArray[0]) + cornerRadius, CGRectGetMinY(rectArray[0]) + cornerRadius);
            CGPathAddLineToPoint(path, nil, CGRectGetMaxX(rectArray[0]) - cornerRadius, CGRectGetMinY(rectArray[0]) + cornerRadius);
            
            CGPathAddLineToPoint(path, nil, CGRectGetMaxX(rectArray[0]) - cornerRadius, CGRectGetMinY(rectArray[lastRect]) - cornerRadius);
            CGPathAddLineToPoint(path, nil, CGRectGetMaxX(rectArray[lastRect]) - cornerRadius, CGRectGetMinY(rectArray[lastRect]) - cornerRadius);
            
            CGPathAddLineToPoint(path, nil, CGRectGetMaxX(rectArray[lastRect]) - cornerRadius, CGRectGetMaxY(rectArray[lastRect]) - cornerRadius);
            CGPathAddLineToPoint(path, nil, CGRectGetMinX(rectArray[lastRect]) + cornerRadius, CGRectGetMaxY(rectArray[lastRect]) - cornerRadius);
            
            CGPathAddLineToPoint(path, nil, CGRectGetMinX(rectArray[lastRect]) + cornerRadius, CGRectGetMaxY(rectArray[0]) + cornerRadius);
            
            CGPathCloseSubpath(path);
        }
        
        color.set()
        
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(ctx, cornerRadius * 2.0)
        CGContextSetLineJoin(ctx, .Round)
        
        CGContextAddPath(ctx, path)
        
        CGContextDrawPath(ctx, .FillStroke)

    }
    
    override func drawUnderlineForGlyphRange(glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
        let firstPosition = locationForGlyphAtIndex(glyphRange.location).x
        guard firstPosition == 25 else { return }
//        if lineRect.origin.x != 0 {
            Info("\(firstPosition)")
//        }
        let rect = CGRect(x: lineRect.origin.x + containerOrigin.x + firstPosition - 10, y: lineRect.origin.y + containerOrigin.y, width: 3, height: lineRect.size.height)
        UIColor(red: 96.0/255.0, green: 201.0/255.0, blue: 248.0/255.0, alpha: 1).setFill()
        UIBezierPath(rect: rect).fill()
    }
    
    private func fixHighlightRect(rect: CGRect) -> CGRect {
        var fixedRect = rect
        let fixOffset: CGFloat = 6.0
        fixedRect.size.height -= fixOffset;
        fixedRect.origin.y += fixOffset;
        return rect;
    }
    
}
