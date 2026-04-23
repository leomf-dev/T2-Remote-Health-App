//
//  MedicalDetailViewController.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import UIKit

final class MedicalDetailViewController: UIViewController {
    
    private let medicalControl: MedicalControl
    private let repository = MedicalRepository()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Eliminar Registro"
        config.baseBackgroundColor = .systemRed
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(medicalControl: MedicalControl) {
        self.medicalControl = medicalControl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    private let editButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Editar Registro"
        config.baseBackgroundColor = .systemBlue
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setupUI() {
        title = "Control Médico"
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        view.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(editButton)
        buttonsStackView.addArrangedSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
    }
    
    private func configureData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        addInfoRow(title: "Fecha:", value: dateFormatter.string(from: medicalControl.date), alignment: .right)
        addInfoRow(title: "Hora:", value: timeFormatter.string(from: medicalControl.date), alignment: .right)
        
        addSectionHeader(title: "Paciente:")
        addBodyLabel(text: medicalControl.name)
        

        let hStack = UIStackView()
        hStack.distribution = .fillEqually
        hStack.addArrangedSubview(createPair(title: "Edad:", value: "\(medicalControl.age)"))
        hStack.addArrangedSubview(createPair(title: "Altura:", value: "\(medicalControl.height) m"))
        stackView.addArrangedSubview(hStack)
        
        addSectionHeader(title: "Presión Arterial:")
        addBodyLabel(text: medicalControl.bloodPressure)
        
        addSectionHeader(title: "Comentarios:")
        addBodyLabel(text: medicalControl.commentary)
        
        addSectionHeader(title: "Índice de Masa Corporal (IMC):")
        addBodyLabel(text: medicalControl.imcCategory, isBold: true)
    }
    
    private func addSectionHeader(title: String) {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 16)
        stackView.addArrangedSubview(label)
    }
    
    private func addBodyLabel(text: String, isBold: Bool = false) {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = isBold ? .boldSystemFont(ofSize: 15) : .systemFont(ofSize: 15)
        stackView.addArrangedSubview(label)
    }
    
    private func createPair(title: String, value: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        let tLabel = UILabel(); tLabel.text = title; tLabel.font = .boldSystemFont(ofSize: 16)
        let vLabel = UILabel(); vLabel.text = value; vLabel.font = .systemFont(ofSize: 15)
        container.addArrangedSubview(tLabel)
        container.addArrangedSubview(vLabel)
        return container
    }
    
    private func addInfoRow(title: String, value: String, alignment: NSTextAlignment) {
        let label = UILabel()
        label.text = "\(title) \(value)"
        label.textAlignment = alignment
        label.font = .systemFont(ofSize: 14)
        stackView.addArrangedSubview(label)
    }

    @objc private func didTapDelete() {
        let alert = UIAlertController(title: "Eliminar Registro", 
                                      message: "Los datos se eliminarán permanentemente", 
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            guard let self = self, let id = self.medicalControl.id else { return }
            self.repository.deleteControl(id: id)
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    @objc private func didTapEdit() {
        let editVC = MedicalFormViewController()
        
        editVC.medicalControlToEdit = self.medicalControl
        
        navigationController?.pushViewController(editVC, animated: true)
    }
}
