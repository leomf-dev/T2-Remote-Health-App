//
//  MedicalControlCell.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import UIKit

final class MedicalControlCell: UITableViewCell {
    static let identifier = "MedicalControlCell"

    private let statusIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with model: MedicalControl) {
        nameLabel.text = "Paciente: \(model.name)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        infoLabel.text = """
        Edad: \(model.age)  Altura: \(model.height)m
        Presión: \(model.bloodPressure)
        IMC: \(String(format: "%.2f", model.imc)) (\(model.imcCategory))
        Fecha: \(dateFormatter.string(from: model.date))
        """
        
        switch model.imc {
            case ..<18.5:
                 statusIndicatorView.backgroundColor = .systemYellow
            case 18.5..<25:
                 statusIndicatorView.backgroundColor = .systemGreen
            case 25..<30:
                 statusIndicatorView.backgroundColor = .systemOrange
            default:
                 statusIndicatorView.backgroundColor = .systemRed
            }
    }

    private func setupUI() {
        contentView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(containerView)
        containerView.addSubview(statusIndicatorView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(infoLabel)

        NSLayoutConstraint.activate([
                    containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                    containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

                    statusIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor),
                    statusIndicatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    statusIndicatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    statusIndicatorView.widthAnchor.constraint(equalToConstant: 8),

                    nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
                    nameLabel.leadingAnchor.constraint(equalTo: statusIndicatorView.trailingAnchor, constant: 12),

                    infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                    infoLabel.leadingAnchor.constraint(equalTo: statusIndicatorView.trailingAnchor, constant: 12),
                    infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
                    infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
                ])
    }
}
