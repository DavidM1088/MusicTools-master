import UIKit
import Foundation

class AdaptiveEngine : NSObject, XMLParserDelegate {


    func parserDidStartDocument(_ parser: XMLParser) {
        //Start Parsing
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        let strElement = elementName
        //print("element:", strElement)
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    func readRules() -> Int {
        if let path = Bundle.main.url(forResource: "adaptive_rules", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self as XMLParserDelegate
                parser.parse()
            }
        }
        func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            let e = elementName
            print(e)
            /*if elementName == "book" {
                bookTitle = String()
                bookAuthor = String()
            }*/
        }

        return 0
    }
}

