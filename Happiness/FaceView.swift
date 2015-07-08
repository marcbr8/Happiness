//
//  FaceView.swift
//  Happiness
//
//  Created by Marc Balaguer on 08/07/15.
//  Copyright (c) 2015 Marc Balaguer. All rights reserved.
//

import UIKit

class FaceView: UIView {

    override func drawRect(rect: CGRect) {

        var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay()}}
        var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay()}}
        
        var scale: CGFloat = 0.90
        
        var faceCenter: CGPoint {
            return convertPoint(center, fromView: superview)
        }
        
        var faceRadius: CGFloat {
            return min(bounds.size.width, bounds.size.height) / 2 * scale
        }
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
    }


}
