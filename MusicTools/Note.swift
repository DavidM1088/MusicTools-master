import Foundation

let ACCIDENTAL_NONE = 0
let ACCIDENTAL_SHARP = 1
let ACCIDENTAL_FLAT = 2
let ACCIDENTAL_NATURAL = 3

let OCTAVE_OFFSET = 12

let MIDDLE_C = 60

// describes how the note is presented on a music staff in a given key
class NotePresentation {
    var name1 : String
    var offset : Int //offset line from C
    var octave : Int
    var accidental : Int
    
    init (offset : Int, octave: Int, accidental : Int) {
        self.name1 = "name1"
        self.octave = octave
        self.accidental = accidental
        self.offset = offset
    }
    
    func toString() -> String {
        return "note presentation name:\(self.name1) octave:\(octave) accidental:\(accidental)"
    }
}

//any object that can be placed on a staff
class StaffObject {
    
}

//an object that has some duration on a staff
class Duration : StaffObject {
    var duration : Float
    init (duration : Float) {
        self.duration = duration
    }
}

class Rest : Duration {
    init() {
        super.init(duration: 0.0)
    }
}

class Accidental : StaffObject {
    var midiOffset = 0
    var type = ACCIDENTAL_NONE
    
    init(midiOffset : Int, type  : Int) {
        self.midiOffset = midiOffset
        self.type = type
    }
}

class Note : Duration {
    var noteValue : Int
    
    init(noteValue : Int) {
        self.noteValue = noteValue
        super.init(duration: DURATION_QTR)
    }
    
    init(noteValue : Int, duration : Float) {
        self.noteValue = noteValue
        super.init(duration: duration) 
    }
    
    init(note : Note) {
        self.noteValue = note.noteValue
        super.init(duration: note.duration)
    }
    
    class func noteDescription(note : Note, withOctave : Bool) -> String {
        let noteValue = note.noteValue % 12
        let octave = (note.noteValue / 12) - 1 //by convention middle C is octave 4
        var noteName=""
        switch (noteValue) {
        case 0: noteName = "C"
        case 1: noteName = "C#"
        case 2: noteName = "D"
        case 3: noteName = "Eb"
        case 4: noteName = "E"
        case 5: noteName = "F"
        case 6: noteName = "F#"
        case 7: noteName = "G"
        case 8: noteName = "Ab"
        case 9: noteName = "A"
        case 10: noteName = "Bb"
        case 11: noteName = "B"
        default : noteName = ""
        }
        if withOctave {
            return ("\(noteName)(\(octave))")
        }
        else {
            return ("\(noteName)")
        }
    }    

}

