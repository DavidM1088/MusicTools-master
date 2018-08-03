import Foundation

class MidiInstrument {
    var name : String
    var id : Int // midi Identifier
    init (name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

class AvailableInstruments {

    var instruments : [MidiInstrument]
    var selected : Int
    var lastRandom = 0
    
    init() {
        self.instruments = []
        instruments.append(MidiInstrument(name: "Piano", id: 1))  //0
        instruments.append(MidiInstrument(name: "Glockenspiel", id: 9))
        instruments.append(MidiInstrument(name: "Vibraphone", id: 11))
        instruments.append(MidiInstrument(name: "Marimba", id: 12))
        instruments.append(MidiInstrument(name: "Nylon Guitar", id: 24))
        instruments.append(MidiInstrument(name: "Overdrive Guitar", id: 29)) //5
        instruments.append(MidiInstrument(name: "Electric Guitar", id: 30))
        instruments.append(MidiInstrument(name: "Acoustic Bass", id: 32))
        instruments.append(MidiInstrument(name: "Cello", id:42))
        instruments.append(MidiInstrument(name: "Stereo Strings", id:44))
        instruments.append(MidiInstrument(name: "Synth Strings", id: 50)) //10
        instruments.append(MidiInstrument(name: "Choir", id: 52))
        instruments.append(MidiInstrument(name: "Synth", id: 54))
        instruments.append(MidiInstrument(name: "Trumpet", id: 56))
        instruments.append(MidiInstrument(name: "Tuba", id: 58))
        instruments.append(MidiInstrument(name: "French Horn", id: 60))
        instruments.append(MidiInstrument(name: "Oboe", id: 68))
        instruments.append(MidiInstrument(name: "Clarinet", id: 71)) //17
        instruments.append(MidiInstrument(name: "Flute", id:73))
        instruments.append(MidiInstrument(name: "Fantasia", id:88))
        instruments.append(MidiInstrument(name: "Warm Pad", id:89))
        instruments.append(MidiInstrument(name: "Soundtrack", id:97)) 
        selected = 8
    }
    
    class var sharedInstance: AvailableInstruments {
        struct Singleton {
            static let instance = AvailableInstruments()
        }
        return Singleton.instance
    }
    
    class func getSelectedInstrument() -> Int {
        return sharedInstance.instruments[sharedInstance.selected].id
    }
    class func getInstrumentId(index : Int) -> Int {
        return sharedInstance.instruments[index].id
    }
    class func getInstrument(index : Int) -> MidiInstrument {
        return sharedInstance.instruments[index]
    }
    class func getInstruments() -> [MidiInstrument] {
        return sharedInstance.instruments
    }
    class func getInstrumentId(name : String) -> Int {
        for i in sharedInstance.instruments {
            if i.name == name {
                return i.id
            }
        }
        return 0
    }
    
    class func getRandomInstrument() -> Int {
        var i = 0
        while true {
            i = Int(arc4random()) % sharedInstance.instruments.count
            if i == 0 || i == 20 || i == 7 || i==5 || i==6 {
                continue
            }
            break
        }
        return sharedInstance.instruments[i].id
    }

}
