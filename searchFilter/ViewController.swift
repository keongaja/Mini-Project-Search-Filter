//
//  ViewController.swift
//  searchFilter
//
//  Created by PPTSI-MBP on 12/03/18.
//  Copyright © 2018 Bobby Chandra Martonio. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class productsViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = #imageLiteral(resourceName: "noImage")
        iv.clipsToBounds = true
        return iv
    }()

    var produk: UILabel = {
        let label = UILabel()
        label.text = "barang barang barang barang barang barang barang barang"
        label.font = label.font.withSize(15)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var harga: UILabel = {
        let label = UILabel()
        label.text = "Rp 100000"
        label.font = label.font.withSize(16)
        label.textColor = .orange
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupViews() {

        addSubview(imageView)
        imageView.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true

        addSubview(harga)
        harga.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 8, rightConstant: 4)

        addSubview(produk)
        produk.anchorWithConstantsToTop(imageView.bottomAnchor, left: leftAnchor, bottom: harga.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4)

        self.layer.cornerRadius = 5
        self.clipsToBounds = true;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(productsViewCell.self, forCellWithReuseIdentifier: "products")
        //cv.isPagingEnabled = true
        return cv
    }()

    var filter: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Filter", for: .normal)
        b.backgroundColor = UIColor(hexString: "#42B549")
        b.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []

        title = "Search"
        view.backgroundColor = UIColor(hexString: "#E7E8E9")

        setup()
    }


    func loadData() {
        let parameternya : Parameters = [
            "q" : "samsung" ,
            "pmin" : "10000" ,
            "pmax" : "100000" ,
            "wholesale" : true ,
            "official" : false ,
            "fshop" : "2" ,
            "start" : "0" ]

        let linkAPI = "https://ace.tokopedia.com/search/v2.5/product"
        Alamofire.request(linkAPI, parameters: parameternya).responseJSON { response in
            var json = JSON(response.result.value)
            print(json)
        }
    }

    func setup(){
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

    @objc func pressed(sender: UIButton!) {
        loadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let  screenSize = UIScreen.main.bounds
        var tabel:CGSize

        if screenSize.width > 500 {
            tabel = CGSize(width: (screenSize.width-24)/4, height: 1.5 * (screenSize.width-24)/4)
        } else {
            tabel = CGSize(width: (screenSize.width-10)/2, height: 1.5 * (screenSize.width-10)/2)
        }
        return tabel
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "products", for: indexPath) as! productsViewCell

        cell.backgroundColor = .white
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }


}

