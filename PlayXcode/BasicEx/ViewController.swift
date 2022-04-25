//
//  ViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTap(_ sender: Any) {
        guard let c = self.storyboard?.instantiateViewController(withIdentifier: "YellowViewController") else {
            return
        }
        self.present(c, animated: true)
    }
}

class YellowViewController: UIViewController {
    
//    var qanda: String
//
//    required init?(coder: NSCoder, qanda: String) {
//        self.qanda = qanda
//        super.init(coder: coder)
//    }
//
//    required init?(coder: NSCoder) {
//        self.qanda = ""
//        super.init(coder: coder)
//    }
    
    override func loadView() {
        super.loadView()
        print(#function)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
    }
}

