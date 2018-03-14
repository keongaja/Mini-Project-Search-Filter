//
//  shopTypeViewController.swift
//  searchFilter
//
//  Created by PPTSI-MBP on 13/03/18.
//  Copyright © 2018 Bobby Chandra Martonio. All rights reserved.
//

import UIKit
import DLRadioButton

class shopTypeViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let selectButton : DLRadioButton = {
        let rb = DLRadioButton()
        rb.isIconSquare = true
        rb.isSelected = false
        rb.isMultipleSelectionEnabled = false
        rb.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        rb.setTitle("Button", for: UIControlState())
        rb.iconColor = UIColor(hexString: "#2AB99C")
        rb.indicatorColor = UIColor(hexString: "#2AB99C")
        rb.setTitleColor(.black, for: UIControlState())
        rb.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        rb.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        rb.addTarget(self, action: #selector(shopTypeViewController.selectShop(_:)), for: UIControlEvents.touchUpInside);
        return rb
    }()

    func setupViews() {
        addSubview(selectButton)
        _ = selectButton.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class shopTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(shopTypeViewCell.self, forCellWithReuseIdentifier: "Shop")
        //cv.isPagingEnabled = true
        return cv
    }()


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
        view.backgroundColor = UIColor(hexString: "#E7E8E9")
        title = "Shop Type"
        setup()
    }

    func setup(){
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(close(sender:)));
        doneItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = doneItem

        let reset = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.plain, target: self, action: #selector(reset(sender:)))
        reset.tintColor = UIColor(hexString: "#42B549")
        self.navigationItem.rightBarButtonItem = reset

        view.addSubview(filter)
        if #available(iOS 11.0, *) {
            filter.anchorToTop(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)

        } else {
            // Fallback on earlier versions
            filter.anchorToTop(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        }
        filter.heightAnchor.constraint(equalToConstant: 50).isActive = true


        view.addSubview(collectionView)
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: filter.topAnchor, right: view.rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let  screenSize = UIScreen.main.bounds
        var tabel:CGSize
            tabel = CGSize(width: (screenSize.width - 8), height: 50)

        return tabel
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopTypeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shop", for: indexPath) as! shopTypeViewCell
        cell.selectButton.setTitle(shopTypeList[indexPath.row].shop, for: .normal)
        cell.selectButton.tag = indexPath.row
        print (cell.selectButton.isSelected)
        cell.selectButton.isSelected = shopTypeList[indexPath.row].status


        cell.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    @objc @IBAction fileprivate func selectShop(_ radioButton : DLRadioButton) {
        shopTypeList[radioButton.tag].status = !shopTypeList[radioButton.tag].status
        radioButton.isSelected = shopTypeList[radioButton.tag].status

    }

    @objc func apply(sender: UIButton!) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filterShop"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

    @objc func close(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func reset(sender: UIButton!) {
        for i in 0..<shopTypeList.count {
            shopTypeList[i].status = true
        }
        collectionView.reloadData()
    }
}
