//
//  filterViewController.swift
//  searchFilter
//
//  Created by PPTSI-MBP on 13/03/18.
//  Copyright © 2018 Bobby Chandra Martonio. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class filterViewController: UIViewController{

    var filter: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Apply", for: .normal)
        b.backgroundColor = UIColor(hexString: "#42B549")
        b.addTarget(self, action: #selector(apply(sender:)), for: .touchUpInside)
        return b
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []
        view = UIView()
        view.backgroundColor = .white
        title = "Filter"
        setup()
    }


    func setup(){

        view.addSubview(filter)
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(close(sender:)));
        doneItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = doneItem

        let reset = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.plain, target: self, action: #selector(reset(sender:)))
        reset.tintColor = UIColor(hexString: "#42B549")
        self.navigationItem.rightBarButtonItem = reset


        if #available(iOS 11.0, *) {
            filter.anchorToTop(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)

        } else {
            // Fallback on earlier versions
            filter.anchorToTop(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        }
        filter.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc func apply(sender: UIButton!) {
        print ("pencet")
        //dismiss(animated: true, completion: nil)
        let controller = shopTypeViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func close(sender: UIButton!) {
        print ("close")
        dismiss(animated: true, completion: nil)
    }

    @objc func reset(sender: UIButton!) {
        print ("reset")
        resetParam()
    }



}
