//
//  SceneDelegate.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 1. Capturamos la escena
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2. Creamos la ventana manualmente
        let window = UIWindow(windowScene: windowScene)
        
        // 3. Definimos el controlador inicial (Listado)
        let rootVC = MedicalListViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        // 4. Personalización básica de la barra de navegación
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        // 5. Asignamos y mostramos
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
