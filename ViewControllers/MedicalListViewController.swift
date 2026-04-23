//
//  MedicalListViewController.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import UIKit

final class MedicalListViewController: UIViewController {
    private var controls: [MedicalControl] = []
    private let repository = MedicalRepository()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGroupedBackground
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

    private func setupUI() {
        title = "Control Médico"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Agregar", 
            style: .plain, 
            target: self, 
            action: #selector(goToAdd)
        )

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MedicalControlCell.self, forCellReuseIdentifier: MedicalControlCell.identifier)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func goToAdd() {
        let formVC = MedicalFormViewController()
        navigationController?.pushViewController(formVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func loadData() {
        controls = repository.fetchControls()
        tableView.reloadData()
    }
}

extension MedicalListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MedicalControlCell.identifier, for: indexPath) as! MedicalControlCell
        cell.configure(with: controls[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedControl = controls[indexPath.row]
        let detailVC = MedicalDetailViewController(medicalControl: selectedControl)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
