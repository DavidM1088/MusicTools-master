import Foundation
let KEY_MAJOR = 0
let KEY_MINOR = 1

class KeySignature {
    private var sharps : Int = 0
    private var flats : Int = 0
    var root : String = ""
    private var type : Int = 0
    private var rootNote : Int = 0
    
    init(root : String, type : Int, sharps : Int, flats : Int, rootNote : Int) {
        self.root = root
        self.type = type
        self.sharps = sharps
        self.flats = flats
        self.rootNote = rootNote
    }
    
    func getName() -> String {
        let typeName = type == KEY_MAJOR ? "Major" : "Minor"
        return "\(self.root) \(typeName)"
    }
    
    func getSharpCount() -> Int {
        return self.sharps
    }
    func getFlatCount() -> Int {
        return self.flats
    }
    func getRootNote() -> Int {
        return self.rootNote
    }
    
    func isBlackNote(note : Int) -> Bool {
        return note == 1 || note == 3 || note == 6 || note == 8 || note == 10
    }
    
    //returns how this note is presented on the staff in this key
    func notePresentation_old(midiNote : Int, key : KeySignature) -> NotePresentation {
        let sharpKeySig : Int = key.getSharpCount() > 0 ? ACCIDENTAL_SHARP : ACCIDENTAL_FLAT
        let octave : Int  = midiNote / Int(12) - 1  //middle c (=60) is most often notated as C octave 4 (C4)
        let noteNormalized = midiNote % 12 //normalize to C=0 to B=11
        var noteName = "C"
        var accidental = ACCIDENTAL_NONE
        switch (noteNormalized) {
            case 0: noteName = "C"
            case 1: noteName = sharpKeySig == ACCIDENTAL_SHARP ? "C" : "D"
            case 2: noteName = "D"
            case 3: noteName = sharpKeySig == ACCIDENTAL_SHARP ? "D" : "E"
            case 4: noteName = "E"
            case 5: noteName = "F"
            case 6: noteName = sharpKeySig == ACCIDENTAL_SHARP ? "F" : "G"
            case 7: noteName = "G"
            case 8: noteName = sharpKeySig == ACCIDENTAL_SHARP ? "G" : "A"
            case 9: noteName = "A"
            case 10: noteName = sharpKeySig == ACCIDENTAL_SHARP ? "A" : "B"
            case 11: noteName = "B"
            default: noteName = ""
        }
        //if self.isBlackNote(note: noteNormalized) {
            let sigAccs = self.flatsInKeySig()
            accidental = ACCIDENTAL_NATURAL
            for acc in sigAccs {
                if acc == noteNormalized {
                    accidental = ACCIDENTAL_NONE
                    break
                }
            }
        //}
        return NotePresentation(offset: 0, octave: octave, accidental: accidental)
    }
    
    func getNaturalsInKey(keySig : KeySignature) -> [Int] {
        var nats : [Int] = []
        if keySig.getFlatCount() > 0 {
            switch (keySig.getFlatCount()) {
            case 1: nats = [10]
            case 2: nats = [10, 3]
            case 3: nats = [10, 3, 8]
            case 4: nats = [10, 3, 8, 2]
            case 5: nats = [10, 3, 8, 2, 6]
            default: nats = []
            }
        }
        if keySig.getSharpCount() > 0 {
            switch (keySig.getSharpCount()) {
            case 1: nats = [6]
            case 2: nats = [6, 1]
            case 3: nats = [6, 1, 8]
            case 4: nats = [6, 1, 8, 3]
            default: nats = []
            }
        }
        return nats
    }
    
    func getNoteOffsets(note : Int) -> [Int] {
        let noteNormalized = note % 12 //normalize to C=0 to B=11
        var offsets = [0,0]
        switch (noteNormalized) {
        case 1: offsets = [1,0]
        case 2: offsets = [1,1]
        case 3: offsets = [2,1]
        case 4: offsets = [2,2]
        case 5: offsets = [3,3]
        case 6: offsets = [4,3]
        case 7: offsets = [4,4]
        case 8: offsets = [5,4]
        case 9: offsets = [5,5]
        case 10: offsets = [6,5]
        case 11: offsets = [6,6]
        default: offsets = [0,0]
        }
        return offsets
    }
    
    func notePresentation(midiNote : Int, key : KeySignature) -> NotePresentation {
        var accidental = ACCIDENTAL_NONE
        let note = midiNote % 12 //normalize to C=0 to B=11
        let noteOffsets = self.getNoteOffsets(note: note)
        let sharps = key.getSharpCount() > 0
        let offsetIndex = sharps ? 1 : 0
        //if key.getFlatCount() > 0 {
        var anotherAtSameOffset = -1
        for noteIndex in 0..<12 {
            let offsets = self.getNoteOffsets(note: noteIndex)
            if noteIndex != note && offsets[offsetIndex] == noteOffsets[offsetIndex] {
                anotherAtSameOffset = noteIndex
                break
            }
        }
        let nats = self.getNaturalsInKey(keySig: key)
        var anotherInSig = false
        if anotherAtSameOffset > -1 {
            for i in 0..<nats.count {
                if anotherAtSameOffset == nats[i] {
                    anotherInSig = true
                    break
                }
            }
        }
        var noteInSig = false 
        for i in 0..<nats.count {
            if note == nats[i] {
                noteInSig = true
                break
            }
        }
        if midiNote <= 64 {
            var x = midiNote
        }
        var noteOffset1 = noteOffsets[0]
        let c_maj = key.getFlatCount()==0 && key.getSharpCount()==0
        if self.isBlackNote(note: note) {
            if key.getFlatCount() > 0 || (c_maj && (note==3 || note==10)) {
                noteOffset1 = noteOffsets[0]
                accidental = noteInSig ? ACCIDENTAL_NONE : ACCIDENTAL_FLAT
            }
            if key.getSharpCount() > 0 || (c_maj && (note != 3 && note != 10) ){
                noteOffset1 = noteOffsets[1]
                accidental = noteInSig ? ACCIDENTAL_NONE : ACCIDENTAL_SHARP
            }
        } else {
            if key.getFlatCount() > 0 {
                noteOffset1 = noteOffsets[0]
                accidental = anotherInSig ? ACCIDENTAL_NATURAL : ACCIDENTAL_NONE
            }
            if key.getSharpCount() > 0 {
                noteOffset1 = noteOffsets[1]
                accidental = anotherInSig ? ACCIDENTAL_NATURAL : ACCIDENTAL_NONE
            }
        }

        let octave : Int  = midiNote / Int(12) - 1  //middle c (=60) is most often notated as C octave 4 (C4)
        return NotePresentation(offset: noteOffset1, octave: octave, accidental: accidental)
    }

    //return the accidental type (sharp, flat) of this key
    func getAccidentalType() -> Int {
        if self.sharps > 0 {return ACCIDENTAL_SHARP} else {return ACCIDENTAL_FLAT}
    }

    //return list of flats in key sig
    func flatsInKeySig() -> [Int] {
        var flats : [Int] = []
        if self.flats > 0 {
            switch (self.flats) {
            case 1: flats = [10]
            case 2: flats = [10, 3]
            case 3: flats = [10, 3, 8]
            default: flats = []
            }
        }
        return flats
    }

    //return the list of accidentals as midi values
    func getAccidentals(staffType : Int) -> [Int] {
        var list : [Int] = []
        let baseMidi = staffType == CLEF_TREBLE ? MIDDLE_C : MIDDLE_C - 2*12
        
        if self.sharps > 0 {
            for i in 0..<self.sharps {
                switch (i) {
                    case 0: list.append(baseMidi + 12 + 5)
                    case 1: list.append(baseMidi + 12 + 0)
                    case 2: list.append(baseMidi + 12 + 7)
                    case 3: list.append(baseMidi + 12 + 2)
                    case 4: list.append(baseMidi + 0  + 9)
                    case 5: list.append(baseMidi + 12 + 4)
                    case 6: list.append(baseMidi + 0  + 11)
                    default: list.append(0)
                }
            }
        }
        else {
            for i in 0..<self.flats {
                switch (i) {
                    case 0: list.append(baseMidi +  0 + 11)
                    case 1: list.append(baseMidi + 12 + 4)
                    case 2: list.append(baseMidi + 0  + 9)
                    case 3: list.append(baseMidi + 12 + 2)
                    case 4: list.append(baseMidi + 0  + 7)
                    case 5: list.append(baseMidi + 12 + 0)
                    case 6: list.append(baseMidi + 0  + 5)
                    default: list.append(0)
                }
            }
        }
        return list
    }
    
    class func getCommonKeys() -> [KeySignature] {
        var commonKeys : [KeySignature] = []
        commonKeys.append(SelectedKeys.getKeyList()[0])
        commonKeys.append(SelectedKeys.getKeyList()[1])
        commonKeys.append(SelectedKeys.getKeyList()[2])
        commonKeys.append(SelectedKeys.getKeyList()[3])
        commonKeys.append(SelectedKeys.getKeyList()[4])
        commonKeys.append(SelectedKeys.getKeyList()[5])
        commonKeys.append(SelectedKeys.getKeyList()[6])
        commonKeys.append(SelectedKeys.getKeyList()[7])
        commonKeys.append(SelectedKeys.getKeyList()[8])
        commonKeys.append(SelectedKeys.getKeyList()[10])
        return commonKeys
        
    }
}
