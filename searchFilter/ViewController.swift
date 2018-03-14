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

        //setupViews()
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.image = #imageLiteral(resourceName: "noImage")
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()

    var produk: UILabel = {
        let label = UILabel()
        label.text = "barang barang barang barang barang barang barang barang"
        label.font = label.font.withSize(15)
        label.numberOfLines = 2
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

    func setupViews(data : dataProduk) {
        addSubview(imageView)
        imageView.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true

        addSubview(harga)
        harga.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 8, rightConstant: 4)

        addSubview(produk)
        produk.anchorWithConstantsToTop(imageView.bottomAnchor, left: leftAnchor, bottom: harga.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4)

        self.layer.cornerRadius = 5
        self.clipsToBounds = true;

        Alamofire.request(data.image_uri).responseImage { response in
            if (response.result.error == nil)
            {
                self.imageView.image = response.result.value
            }
        }

        produk.text = data.name
        harga.text = data.price
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var jsoncache = JSON.null
    var total_data = 0
    var loadStatus = false

    var data_produk = [dataProduk]()

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
        let  screenSize = UIScreen.main.bounds
        if screenSize.width > 500 {
            row = 16
        } else {
            row = 10
        }
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []
        title = "Search"
        view.backgroundColor = UIColor(hexString: "#E7E8E9")
        setup()

        start = 0
        data_produk.removeAll()
        collectionView.reloadData()
        loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        print(needReloadData)
        if needReloadData {
            needReloadData = false
            data_produk.removeAll()
            collectionView.reloadData()
            loadData()
        }
    }

    func loadData() {
        loadStatus = false
        var jumlahGold = 0
        if shopTypeList[0].status {
            jumlahGold = 2
        }
        let parameternya : Parameters = [
            "q" : q ,
            "pmin" : pmin ,
            "pmax" : pmax ,
            "wholesale" : wholesale ,
            "official" : shopTypeList[1].status ,
            "fshop" : jumlahGold ,
            "start" : "\(start)" ,
            "rows" : row]
        print(parameternya)
        let linkAPI = "https://ace.tokopedia.com/search/v2.5/product"
        Alamofire.request(linkAPI, parameters: parameternya).responseJSON { response in
             if (response.response?.statusCode == 200) {
                let json = JSON(response.result.value!)
                //print (json)
                self.jsoncache = self.getJSON(data: json["header"].description)
                self.total_data = Int(self.jsoncache["total_data"].doubleValue)

                self.jsoncache = self.getJSON(data: json["data"].description)

                for (_,subJson):(String, JSON) in self.jsoncache {

                    let jsonShop = self.getJSON(data: subJson["shop"].description)
                    let dataShop = shop(id: jsonShop["id"].description,
                                        name: jsonShop["name"].description,
                                        uri: jsonShop["uri"].description,
                                        is_gold: jsonShop["is_gold"].description,
                                        rating: jsonShop["rating"].description,
                                        location: jsonShop["location"].description,
                                        reputation_image_uri: jsonShop["reputation_image_uri"].description,
                                        shop_lucky: jsonShop["shop_lucky"].description,
                                        city: jsonShop["city"].description)

                    let jsonBadges = self.getJSON(data: subJson["badges"].description)
                    let dataBadges = badges(title: jsonBadges["title"].description,
                                            uri: jsonBadges["uri"].description)

                    self.data_produk.append(dataProduk(name: subJson["name"].description,
                                                       uri: subJson["uri"].description,
                                                       image_uri: subJson["image_uri"].description,
                                                       image_uri_700: subJson["image_uri_700"].description,
                                                       price: subJson["price"].description,
                                                       shop: dataShop,
                                                       condition: subJson["condition"].description,
                                                       preorder: subJson["preorder"].description,
                                                       department_id: subJson["department_id"].description,
                                                       count_review: subJson["count_review"].description,
                                                       count_talk: subJson["count_talk"].description,
                                                       count_sold: subJson["count_sold"].description,
                                                       badges: dataBadges,
                                                       original_price: subJson["original_price"].description,
                                                       discount_expired: subJson["discount_expired"].description,
                                                       discount_percentage: subJson["discount_percentage"].description,
                                                       stock: subJson["stock"].description))
                }
            }
            self.loadStatus = true
            if self.total_data > 0 {
                start += row
                print (self.total_data)
                print (self.data_produk.count)
                self.collectionView.reloadData()
            }
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

//
//        start = 0
//        data_produk.removeAll()
//        collectionView.reloadData()
//        loadData()
//        hapusData()
        let popOverVC = UINavigationController(rootViewController: filterViewController())
        show(popOverVC, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let  screenSize = UIScreen.main.bounds
        var tabel:CGSize

        if screenSize.width > 500 {
            tabel = CGSize(width: (screenSize.width-16)/4, height: 1.75 * (screenSize.width-16)/4)
        } else {
            tabel = CGSize(width: (screenSize.width-10)/2, height: 1.75 * (screenSize.width-10)/2)
        }
        return tabel
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data_produk.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "products", for: indexPath) as! productsViewCell
        cell.setupViews(data: data_produk[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height && loadStatus{
            loadData()
        }
    }
}

