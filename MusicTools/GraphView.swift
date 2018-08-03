import Foundation
import UIKit

class GraphView : UIView {
    private var notes : [Int] = []
    
    func setNotes(notes : [Int]) {
        self.notes = notes
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor

        let ctx = UIGraphicsGetCurrentContext()
        let centerLine : CGFloat = rect.height / 2.0
        let cx1 = UIColor.black.cgColor //CGColor()
        ctx?.setStrokeColor(cx1)
        ctx?.setLineWidth(2)
        //ctx?.move(to: CGPoint(x: 0, y: centerLine))
        //ctx?.addLine(to: CGPoint(x: 250, y: centerLine))
        
        //ctx?.strokePath()

        //return

        if self.notes.count == 0 {
            return
        }
        //let path = CGMutablePath()

        let margin : CGFloat = 10.0
        let width = rect.size.width - 2*margin
        let height = rect.size.height
        let cHeight = height / 3.5
        
        //axes
        
        //CGContextSetStrokeColor(ctx!, 0, 0, 0, 0.25)
        //let c : CGFloat = 0
        //CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
        //CGContextSetStrokeColor(ctx!, UIColor.black);
        //CGContextSetStrokeColorWithColor(ctx!,UIColor.whiteColor().CGColor)
        let cx = UIColor.black.cgColor //CGColor()
        ctx?.setStrokeColor(cx)
        ctx?.move(to: CGPoint(x: margin, y: centerLine))
        ctx?.addLine(to: CGPoint(x: margin + width, y: centerLine))
        ctx?.strokePath()
        
        let baseFrequency : CGFloat = 2.0
        let baseNote = self.notes[0]
        var allZero : [CGFloat:Int] = [0:0]
        let noteColor = UIColor.blue.cgColor 
        
        //plot the notes as sine curves with the note frequency
        //note > 1 frequency is shown relative to note[0] frequency (which is constant for all notes)
        for n in 0..<self.notes.count {
            ctx?.move(to: CGPoint(x: margin, y: height/2))
            let octaveOffset : CGFloat = CGFloat(self.notes[n] - baseNote) / 12.0
            let mult : CGFloat = octaveOffset + 1
            let frequency = pow(baseFrequency, mult)
            if n == 0 {
                ctx?.setStrokeColor(UIColor.black.cgColor)
            }
            else {
                ctx?.setStrokeColor(noteColor)
            }
            
            for i in 0..<Int(width+1) {
                let x : CGFloat = (CGFloat(i) * 2.0 * CGFloat.pi * frequency) / CGFloat(width)
                let yVal = height/2 - (sin(x)  * cHeight)
                let xVal = CGFloat(i)
                if abs(yVal - centerLine) < 2 {
                    if allZero[xVal] == nil {
                        allZero[xVal] = 1
                    }
                    else {
                        allZero[xVal] = allZero[xVal]! + 1
                    }
                }
                //CGContextAddLineToPoint(ctx, xVal + margin, yVal)
                ctx?.addLine(to: CGPoint(x: xVal + margin, y: yVal))
            }
            ctx!.strokePath()
        }
        
        //hilight the places where all notes join at the zero y value (showing the 'perfect' note ratios)
        for (xVal, count) in allZero {
            if count > 1 {
                ctx!.setFillColor(UIColor.purple.cgColor)
                let sizes = [CGFloat(7.0) /*, CGFloat(3.0) */]
                for circSize in sizes {
                    let rect : CGRect = CGRect(origin: CGPoint(x: xVal - circSize/2 + margin, y: centerLine - circSize/2), size: CGSize(width: circSize, height: circSize))
                    //CGContextAddEllipseInRect(ctx!, rect)
                    ctx?.addEllipse(in: rect)
                    //CGContextStrokePath(ctx)
                    ctx?.fillPath()
                }
            }
        }
    }
    
}
