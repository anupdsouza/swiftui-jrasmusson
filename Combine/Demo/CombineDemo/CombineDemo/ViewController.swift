//
//  ViewController.swift
//  CombineDemo
//
//  Created by jrasmusson on 2021-05-10.
//

import UIKit
import SwiftUI

final class ViewController: UIViewController {
    
    let stackView = UIStackView()
    let nameTextField = TextFieldView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension ViewController {
    
    func style() {
        title = "Wizard School Signup"
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
    }
    
    func layout() {
        stackView.addArrangedSubview(nameTextField)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension ViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

@available(iOS 13.0, *)
struct ViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ViewController()
                .navigationBarTitle(Text("Wizard School Signup"), displayMode: .inline)
                .preferredColorScheme(.dark)
        }
    }
}
#endif