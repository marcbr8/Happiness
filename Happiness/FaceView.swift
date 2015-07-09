//
//  FaceView.swift
//  Happiness
//
//  Created by Marc Balaguer on 08/07/15.
//  Copyright (c) 2015 Marc Balaguer. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class{
    
    func smilinessForFaceView(sender: FaceView) -> Double?
    
}

@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay()}}
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay()}}
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay()}}
    
    var faceCenter: CGPoint {
       return convertPoint(center, fromView: superview)
    }
        
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    weak var dataSource: FaceViewDataSource?
    
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if(gesture.state == .Changed){
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 3
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye {
        case Left, Right
    }
    
    
    private func bezierPathForEye(whichEye : Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
            case .Left: eyeCenter.x -= eyeHorizontalSeparation
            case .Right: eyeCenter.x += eyeHorizontalSeparation
        }
        
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        eyePath.lineWidth = lineWidth
        
        return eyePath
    }
    
    private func bezierPathForMouth(fractionOfMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidthRadius = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeightRadius = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeightRadius
        
        let start = CGPoint(x : faceCenter.x - mouthWidthRadius/2, y : faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x : faceCenter.x + mouthWidthRadius/2, y : start.y)
        let cp1 = CGPoint(x : start.x + mouthWidthRadius/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x : end.x - mouthWidthRadius/3, y: cp1.y)
        
        let mouthPath = UIBezierPath()
        mouthPath.moveToPoint(start)
        mouthPath.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        mouthPath.lineWidth = lineWidth
        
        return mouthPath
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        let leftEye = bezierPathForEye(.Left)
        let rightEye = bezierPathForEye(.Right)
        leftEye.stroke()
        rightEye.stroke()

        let smiliness:Double = dataSource?.smilinessForFaceView(self) ?? 0
        let mouth = bezierPathForMouth(smiliness)
        mouth.stroke()
        
    }


}
