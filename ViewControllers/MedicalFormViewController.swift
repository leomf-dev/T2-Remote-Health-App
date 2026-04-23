//
//  MedicalFormViewController.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import UIKit

final class MedicalFormViewController: UIViewController {
    
    var medicalControlToEdit: MedicalControl?
    
    private let repository = MedicalRepository()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Campos de texto (TextFields)
    private let nameField = createTextField(placeholder: "Nombres y apellidos")
    private let ageField = createTextField(placeholder: "Edad", keyboardType: .numberPad)
    private let weightField = createTextField(placeholder: "Peso (kg)", keyboardType: .decimalPad)
    private let heightField = createTextField(placeholder: "Altura (m)", keyboardType: .decimalPad)
    private let pressureField = createTextField(placeholder: "Presión arterial")
    private let commentField = createTextField(placeholder: "Comentario")
    
    private let registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Registrar"
        config.baseBackgroundColor = .systemBlue
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let data = medicalControlToEdit {
                title = "Editar Control"
                nameField.text = data.name
                ageField.text = "\(data.age)"
                weightField.text = "\(data.weight)"
                heightField.text = "\(data.height)"
                pressureField.text = data.bloodPressure
                commentField.text = data.commentary
                registerButton.setTitle("Actualizar", for: .normal)
            }
    }
    
    private func setupUI() {
        title = "Control Médico"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [nameField, ageField, weightField, heightField, pressureField, commentField, registerButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapRegister() {
        guard let name = nameField.text, !name.isEmpty,
              let ageStr = ageField.text, let age = Int(ageStr),
              let weightStr = weightField.text, let weight = Double(weightStr.replacingOccurrences(of: ",", with: ".")),
              let heightStr = heightField.text, let height = Double(heightStr.replacingOccurrences(of: ",", with: ".")) else {
            showAlert(message: "Por favor, completa todos los campos correctamente.")
            return
        }
        
        if let existingControl = medicalControlToEdit, let id = existingControl.id {
            repository.updateControl(
                id: id,
                name: name,
                age: age,
                weight: weight,
                height: height,
                pressure: pressureField.text ?? "",
                commentary: commentField.text ?? ""
            )
            showSuccessAlert(isEdit: true)
        } else {
            repository.saveControl(
                name: name,
                age: age,
                weight: weight,
                height: height,
                pressure: pressureField.text ?? "",
                commentary: commentField.text ?? ""
            )
            showSuccessAlert(isEdit: false)
        }
    }

    private func showSuccessAlert(isEdit: Bool) {
        let title = isEdit ? "Actualización correcta" : "Registro correcto"
        let message = isEdit ? "Los datos se han actualizado exitosamente" : "Su registro se realizó exitosamente"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private static func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.keyboardType = keyboardType
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return tf
    }
}
