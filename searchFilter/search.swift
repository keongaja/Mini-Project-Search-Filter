//
//  search.swift
//  searchFilter
//
//  Created by PPTSI-MBP on 14/03/18.
//  Copyright © 2018 Bobby Chandra Martonio. All rights reserved.
//

import UIKit

class search: UIViewController, UITextFieldDelegate {

    let searchItem: UITextField = {
        let text = UITextField()
        //text.delegate = self()
        text.backgroundColor = .white
        text.layer.cornerRadius = 15
        text.clearButtonMode = .whileEditing
        text.textAlignment = .center
        text.placeholder = "Cari Produk atau Toko"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    var cari: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Cari", for: .normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = UIColor(hexString: "#42B549")
        b.addTarget(self, action: #selector(cari(sender:)), for: .touchUpInside)
        return b
    }()

    var tutup: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("batal", for: .normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = UIColor(hexString: "#42B549")
        b.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
        return b
    }()

    let  screenSize = UIScreen.main.bounds

    override func viewDidLoad() {

        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []
        view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        setup()
    }

    func setup() {
        view.addSubview(searchItem)
        searchItem.text = q
        _ = searchItem.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 50, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 30)

        view.addSubview(cari)
        _ = cari.anchor(searchItem.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: screenSize.width/2 + 4, widthConstant: screenSize.width/4, heightConstant: 25)

        view.addSubview(tutup)
        _ = tutup.anchor(searchItem.bottomAnchor, left: cari.rightAnchor , bottom: nil, right: nil, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: screenSize.width/4, heightConstant: 25)
    }

    @objc func cari(sender: UIButton!) {
        q = searchItem.text!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filter"), object: nil)
        start = 0
        dismiss(animated: true, completion: nil)
    }

    @objc func cancel(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }

}
