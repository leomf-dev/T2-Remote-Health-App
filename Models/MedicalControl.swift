//
//  MedicalControl.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import Foundation
import CoreData

struct MedicalControl {
    let id: NSManagedObjectID?
    let name: String
    let age: Int
    let weight: Double
    let height: Double
    let bloodPressure: String
    let commentary: String
    let imc: Double
    let date: Date
    
    var imcCategory: String {
        switch imc {
        case ..<18.5: return "Bajo peso"
        case 18.5..<25: return "Peso normal"
        case 25..<30: return "Sobrepeso"
        default: return "Obesidad"
        }
    }
}
