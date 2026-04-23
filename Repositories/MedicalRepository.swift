//
//  MedicalRepositorie.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import CoreData

final class MedicalRepository {
    private let context = CoreDataManager.shared.context

    func saveControl(name: String, age: Int, weight: Double, height: Double, pressure: String, commentary: String) {
        let entity = MedicalControlEntity(context: context)
        
        let imcValue = weight / (height * height)
        
        entity.name = name
        entity.age = Int16(age)
        entity.weight = weight
        entity.height = height
        entity.bloodPressure = pressure
        entity.commentary = commentary
        entity.imc = imcValue
        entity.date = Date()

        CoreDataManager.shared.saveContext()
    }

    func fetchControls() -> [MedicalControl] {
        let request: NSFetchRequest<MedicalControlEntity> = MedicalControlEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            return results.map { MedicalControl(
                id: $0.objectID,
                name: $0.name ?? "",
                age: Int($0.age),
                weight: $0.weight,
                height: $0.height,
                bloodPressure: $0.bloodPressure ?? "",
                commentary: $0.commentary ?? "",
                imc: $0.imc,
                date: $0.date ?? Date()
            )}
        } catch {
            return []
        }
    }
    
    func deleteControl(id: NSManagedObjectID) {
        let object = context.object(with: id)
        context.delete(object)
        CoreDataManager.shared.saveContext()
    }
    
    func updateControl(id: NSManagedObjectID, name: String, age: Int, weight: Double, height: Double, pressure: String, commentary: String) {
        let object = context.object(with: id) as? MedicalControlEntity
        
        let imcValue = weight / (height * height)
        
        object?.name = name
        object?.age = Int16(age)
        object?.weight = weight
        object?.height = height
        object?.bloodPressure = pressure
        object?.commentary = commentary
        object?.imc = imcValue
        
        CoreDataManager.shared.saveContext()
    }
}
