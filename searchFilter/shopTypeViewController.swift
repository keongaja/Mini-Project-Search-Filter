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
        view.addSubview(collectionView)
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)

        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(close(sender:)));
        doneItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = doneItem

        let reset = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.plain, target: self, action: #selector(reset(sender:)))
        reset.tintColor = UIColor(hexString: "#42B549")
        self.navigationItem.rightBarButtonItem = reset
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

        if indexPath.row == 0 && shopTypeList[0].status {
            cell.selectButton.isSelected = true
        } else if indexPath.row == 1 && shopTypeList[1].status {
            cell.selectButton.isSelected = true
        } else {
            cell.selectButton.isSelected = false
        }

        cell.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    @objc @IBAction fileprivate func selectShop(_ radioButton : DLRadioButton) {
        radioButton.isSelected = !radioButton.isSelected
        switch radioButton.tag {
        case 0:
            shopTypeList[0].status = radioButton.isSelected
        case 1:
            shopTypeList[1].status = radioButton.isSelected
        default:
            break
        }
    }

    @objc func close(sender: UIButton!) {
        print ("close")
        self.navigationController?.popViewController(animated: true)
    }

    @objc func reset(sender: UIButton!) {
        print ("reset")
        resetParam()
        collectionView.reloadData()
    }
}
