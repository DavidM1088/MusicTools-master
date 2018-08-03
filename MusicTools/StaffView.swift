import Foundation
import UIKit

class StaffView : UIView {
    private var staff : Staff?
    private var key : KeySignature?
    private let lineSpace : CGFloat = 8.0
    var show_notes = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setStaff(staff : Staff, key : KeySignature) {
        self.staff = staff
        self.key = key
    }
    
    //return highest and lowest note on the staff
    private func hiLoNotes() -> (Int, Int) {
        var hi = 0
        var lo = 9999
        for voice in self.staff!.voices {
            for object in voice.contents {
                if object is Chord {
                    let chord = object as! Chord
                    if chord.notes[0].noteValue < lo {
                        lo = chord.notes[0].noteValue
                    }
                    if chord.notes[chord.notes.count-1].noteValue > hi {
                        hi = chord.notes[chord.notes.count-1].noteValue
                    }
                }
                if object is Note {
                    let note = object as! Note
                    if note.noteValue > hi {
                        hi = note.noteValue
                    }
                    if note.noteValue < lo {
                        lo = note.noteValue
                    }
                }
            }
        }
        return (lo, hi)
    }
    
    private func drawNote(ctx : CGContext, x : CGFloat, y : CGFloat, height : CGFloat, width : CGFloat ) {
        //ctx.setFillColor(UIColor.blue.cgColor)
        //let offset = height / 2.0
        let rect : CGRect = CGRect(origin: CGPoint(x: x, y: y - height/2), size: CGSize(width: width, height: height))
        //CGContextAddEllipseInRect(ctx, rect)
        ctx.addEllipse(in: rect)
        //CGContextStrokePath(ctx)
        ctx.fillPath()
    }
    
    private func drawAccidental(ctx : CGContext, accidental : Int, x : CGFloat, y : CGFloat, height : CGFloat, width : CGFloat ) {
        var accImage : UIImage? = nil
        switch (accidental) {
            case ACCIDENTAL_FLAT: accImage = UIImage(named: "flat.png")!
            case ACCIDENTAL_SHARP: accImage = UIImage(named: "sharp.png")!
            case ACCIDENTAL_NATURAL: accImage = UIImage(named: "natural.png")!
            default: accImage = nil
        }
        let accRect = CGRect(x: x - width/2, y: y - height/2, width: width, height: height)
        //CGContextDrawImage(ctx, accRect, accImage!.cgImage)
        ctx.draw(accImage!.cgImage!, in: accRect)
        //CGContextAddEllipseInRect(ctx, accRect)
        //CGContextFillPath(ctx)
    }

    //the space offset on the staff of this note from middle C
    private func offsetFromC(note : NotePresentation) -> Int {
        /*switch (note.name) {
            case "C": offset = 0
            case "D": offset = 1
            case "E": offset = 2
            case "F": offset = 3
            case "G": offset = 4
            case "A": offset = 5
            case "B": offset = 6
        default: offset = 0
        }*/
        var offset  = note.offset
        let octaveOffset = (note.octave - 4) * 7
        return offset + octaveOffset
    }
    
    private func renderObject(ctx : CGContext, object : StaffObject, key : KeySignature, xPos : CGFloat, middleCPos : CGFloat, lineRange : (Int, Int)) {
        var accidental = ACCIDENTAL_NONE
        var presentation : NotePresentation?
        
        if object is Note {
            let note : Note = object as! Note
            presentation = key.notePresentation(midiNote: note.noteValue, key: key)
            accidental = presentation!.accidental
        }
        //TODO restore this
        if object is Accidental {
            let acc = object as! Accidental
            accidental = acc.type
            presentation = key.notePresentation(midiNote: acc.midiOffset, key: key)
            //presentation = NotePresentation(offset: 0, octave: 0, accidental: ACCIDENTAL_NONE)
        }
        
        let offsetLines = self.offsetFromC(note: presentation!)

        for index in -20..<20 {
            let ypos : CGFloat = middleCPos + CGFloat(index) * lineSpace/2
            let noteWidth = 2 * lineSpace
            if index == offsetLines {
                if accidental != ACCIDENTAL_NONE {
                    self.drawAccidental(ctx: ctx, accidental: accidental, x: xPos - 14, y: ypos, height: lineSpace * 1.5, width : noteWidth)
                }
                if object is Note {
                    self.drawNote(ctx: ctx, x: xPos, y: ypos, height: lineSpace, width : noteWidth)
                }
            }
            // partially draw in any missing ledger lines for the note if its above or below the staff lines
            if object is Note {
                if index % 2 == 0 {
                    if (offsetLines > lineRange.1 && index <= offsetLines && index > lineRange.1) ||
                        (offsetLines < lineRange.0 && index >= offsetLines && index < lineRange.0) ||
                        (offsetLines == 0 && index==0 /* middle C in a double clef */) {
                        ctx.move(to: CGPoint(x: xPos-4, y: ypos))
                        ctx.addLine(to: CGPoint(x: xPos+noteWidth, y: ypos))
                        ctx.strokePath()
                    }
                }
            }
        }
    }
    
    func drawStaff(ctx: CGContext, centerAt: CGFloat, margin: CGFloat, width: CGFloat, staffType : Int, keySignature: KeySignature) -> CGFloat {
        //draw the staff lines
        let midLine = 3
        for line : Int in 1...5 {
            let rowAt : CGFloat = (CGFloat(midLine - line) * lineSpace) + centerAt
            //CGContextMoveToPoint(ctx, margin, rowAt)
            ctx.move(to: CGPoint(x: margin, y: rowAt))
            //CGContextAddLineToPoint(ctx, width - margin, rowAt)
            ctx.addLine(to: CGPoint(x: width-margin, y: rowAt))
        }
        let middleCPos = staffType == CLEF_TREBLE ? (CGFloat(midLine - 6) * lineSpace) + centerAt : (CGFloat(6 - midLine) * lineSpace) + centerAt

        //draw the clef image
        var clefHeight : CGFloat = 5 * lineSpace
        var clefWidth = clefHeight / 2.0
        if (staffType == CLEF_TREBLE) {
            clefHeight = clefHeight * 1.5
            clefWidth = clefWidth  * 1.5
        }
        let clefRect = CGRect(x: margin, y: centerAt - clefHeight/2, width: clefWidth, height: clefHeight)
        let clefImage : UIImage = staffType == CLEF_TREBLE ? UIImage(named: "treble_clef.png")! : UIImage(named: "bass_clef.png")!
        ctx.draw(clefImage.cgImage!, in: clefRect)
        
        //draw the key signature
        let accidentals = keySignature.getAccidentals(staffType: staffType)
        let accidentalType = keySignature.getAccidentalType()
        var xKeySigPos = margin + clefWidth
        xKeySigPos += 24
        for accidental in accidentals {
            let acc = Accidental(midiOffset: accidental, type: accidentalType)
            self.renderObject(ctx: ctx, object: acc, key: keySignature, xPos: xKeySigPos, middleCPos : middleCPos, lineRange: (0,0))
            xKeySigPos += 10
        }
        return xKeySigPos + 10
    }
    
    override func draw(_ rect: CGRect) {
        if !self.show_notes {
            return
        }
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        if self.staff == nil {
            return
        }
        
        //determine clef(s) to show based on the clef(s) of the voices
        var needTrebleClef : Bool = false
        var needBassClef : Bool = false
        for voice in self.staff!.voices {
            if voice.clef == CLEF_TREBLE {
                needTrebleClef = true
            }
            if voice.clef == CLEF_BASS {
                needBassClef = true
            }
        }

        //set the drawing context to (0,0) at bottom left
        let ctx = UIGraphicsGetCurrentContext()
        var transform : CGAffineTransform = CGAffineTransform(translationX: 0.0, y: rect.height)
        //switch origin to bottom left since images render upside down otherwise
        transform = transform.scaledBy(x: 1.0, y: -1.0)

        ctx!.concatenate(transform)

        //draw staff lines and determine middle C position for all clefs
        var xPos : CGFloat = 10.0
        ctx!.setStrokeColor(UIColor.gray.cgColor)
        var middleCTreble : CGFloat = 0
        var middleCBass : CGFloat = 0
        if needTrebleClef && needBassClef {
            var staffCenter = (3 * rect.height) / 4.0
            drawStaff(ctx: ctx!, centerAt: staffCenter, margin: xPos, width: rect.width, staffType: CLEF_TREBLE, keySignature: key!)
            middleCTreble = staffCenter - 3 * self.lineSpace
            staffCenter = rect.height / 4.0
            xPos = drawStaff(ctx: ctx!, centerAt: staffCenter, margin: xPos, width: rect.width, staffType: CLEF_BASS, keySignature: key!)
            middleCBass = staffCenter + 3 * self.lineSpace
        }
        else {
            let centerOfView : CGFloat = rect.height / 2.0
            xPos = drawStaff(ctx: ctx!, centerAt: centerOfView, margin: xPos, width: rect.width, staffType: needTrebleClef ? CLEF_TREBLE : CLEF_BASS, keySignature: key!)
            middleCTreble = centerOfView - 3 * self.lineSpace
            middleCBass = centerOfView + 3 * self.lineSpace
        }
        
        ctx!.strokePath()
        
        // draw the notes in the voices
        if self.show_notes {
            for voice in self.staff!.voices {
                var x : CGFloat = xPos
                let lineRange : (Int, Int) = voice.clef == CLEF_TREBLE ? (2, 10) : (-10, -2)
                let middleCPos : CGFloat = voice.clef == CLEF_TREBLE ? middleCTreble : middleCBass
                for object in voice.contents {
                    if object is Chord {
                        let chord : Chord = object as! Chord
                        for note in chord.notes {
                            self.renderObject(ctx: ctx!, object: note, key: key!, xPos: x, middleCPos : middleCPos, lineRange: lineRange)
                        }
                    }
                    if object is Note {
                        let note : Note = object as! Note
                        self.renderObject(ctx: ctx!, object: note, key: key!, xPos: x, middleCPos : middleCPos, lineRange: lineRange)
                    }
                    x += 48
                }
            }
        }
        else {
            //CGContextRef myContext = UIGraphicsGetCurrentContext();
            //UIImage image = UIImage(named:"emote_smile")
            //let i = UIImage(named:"emote_smile")
            //let r = CGRect(x: 0, y: 0, width: 20, height: 20)
            //let ci = CGImage(#imageLiteral(resourceName: "emote_smile.png"))
            //ctx?.draw(ci, in: r, byTiling: false)
            //ctx?.draw(i, CGRect(x: 0, y: 0, width: 30, height: 30))
        }
    }
}
