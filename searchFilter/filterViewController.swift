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
import TagListView
import FontAwesome_swift

class filterPriceViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    let minimal: UILabel = {
        let label = UILabel()
        label.text = "Minimum Price"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let maximal: UILabel = {
        let label = UILabel()
        label.text = "Maximum Price"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let minimalText: UITextField = {
        let text = UITextField()
        //text.delegate = self()
        text.backgroundColor = .white
        text.keyboardType = UIKeyboardType.numberPad
        text.layer.cornerRadius = 5
        text.translatesAutoresizingMaskIntoConstraints = false
        text.addTarget(self, action: #selector(filterViewController.textMin(_:)), for: .editingChanged)
        return text
    }()
    let maximalText: UITextField = {
        let text = UITextField()
        //text.delegate = self()
        text.backgroundColor = .white
        text.textAlignment = .right
        text.keyboardType = UIKeyboardType.numberPad
        text.layer.cornerRadius = 5
        text.translatesAutoresizingMaskIntoConstraints = false
        text.addTarget(self, action: #selector(filterViewController.textMax(_:)), for: .editingChanged)
        return text
    }()

    let rangeHarga: RangeSlider = {
        let rh = RangeSlider()
        rh.trackHighlightTintColor = UIColor(hexString: "#42B549")
        rh.curvaceousness = 1.0
        rh.thumbBorderColor = UIColor(hexString: "#42B549")
        rh.thumbTintColor = UIColor.white
        rh.addTarget(self, action: #selector(filterViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
        return rh
    }()

    let stackviewMin: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .vertical
        sv.distribution  = .equalSpacing
        sv.alignment = .fill
        sv.spacing   = 8.0
        return sv
    }()

    let stackviewMax: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .vertical
        sv.distribution  = .equalSpacing
        sv.alignment = .fill
        sv.spacing   = 8.0
        return sv
    }()

    let stackviewHarga: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .horizontal
        sv.distribution  = .fillEqually
        sv.alignment = .fill
        sv.spacing   = 4
        return sv
    }()

    let lGrosir: UILabel = {
        let label = UILabel()
        label.text = "Whole Sale"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let swithGrosir: UISwitch = {
        let s = UISwitch()
        s.isOn = wholesale
        s.onTintColor = UIColor(hexString: "#42B549")
        s.addTarget(self, action: #selector(filterViewController.tGrosir(sender:)), for: .valueChanged)
        return s
    }()

    func setupViews() {
        backgroundColor = .white
        stackviewMin.addArrangedSubview(minimal)
        stackviewMin.addArrangedSubview(minimalText)
        stackviewMax.addArrangedSubview(maximal)
        stackviewMax.addArrangedSubview(maximalText)

        stackviewHarga.addArrangedSubview(stackviewMin)
        stackviewHarga.addArrangedSubview(stackviewMax)

        minimalText.text = String(pmin)
        if let amountString = minimalText.text?.currencyInputFormatting() {
            minimalText.text = amountString
        }

        maximalText.text = String(pmax)
        if let amountString = maximalText.text?.currencyInputFormatting() {
            maximalText.text = amountString
        }

        addSubview(stackviewHarga)
        _ = stackviewHarga.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)

        addSubview(rangeHarga)
        let deltaPrice = Double(pmaxPrice - pminPrice)
        rangeHarga.lowerValue = Double(pmin - 100) / deltaPrice
        rangeHarga.upperValue = Double(pmax - 100) / deltaPrice

        _ = rangeHarga.anchor(stackviewHarga.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 4, bottomConstant: 16, rightConstant: 4,widthConstant: 0,heightConstant: 35)

        addSubview(swithGrosir)
        _ = swithGrosir.anchor(rangeHarga.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: 8, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        addSubview(lGrosir)
        lGrosir.anchorWithConstantsToTop(rangeHarga.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: swithGrosir.leftAnchor, topConstant: 16, leftConstant: 4, bottomConstant: 8, rightConstant: 8)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class filterShopTypeViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    var filter: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Shop Type", for: .normal)
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        b.setTitleColor(.gray, for: .highlighted)
        b.addTarget(self, action: #selector(filterViewController.shopFilter(sender:)), for: .touchUpInside)
        b.contentHorizontalAlignment = .left
        return b
    }()

    let stackview: UIStackView = {
        let sv = UIStackView()
        sv.axis  = .vertical
        sv.distribution  = .fillEqually
        sv.alignment = .fill
        sv.spacing   = 10
        return sv
    }()

    let shopTag: TagListView = {
        let t = TagListView()
        t.enableRemoveButton = true
        t.tagBackgroundColor =  .white
        t.cornerRadius = 20
        t.paddingX = 10
        t.paddingY = 10
        t.borderWidth = 1
        t.textFont = UIFont.systemFont(ofSize: 15)
        t.textColor = UIColor(white: 0.0, alpha: 0.5)
        t.borderColor = UIColor(white: 0.0, alpha: 0.5)
        t.removeIconLineColor = .black
        return t
    }()
    func setupViews() {
        backgroundColor = .white


        stackview.addArrangedSubview(filter)
        stackview.addArrangedSubview(shopTag)
        addSubview(stackview)
        stackview.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 4, rightConstant: 4)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class filterViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, TagListViewDelegate{

    var filter: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Apply", for: .normal)
        b.backgroundColor = UIColor(hexString: "#42B549")
        b.addTarget(self, action: #selector(apply(sender:)), for: .touchUpInside)
        return b
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(filterPriceViewCell.self, forCellWithReuseIdentifier: "price")
        cv.register(filterShopTypeViewCell.self, forCellWithReuseIdentifier: "shop")
        //cv.isPagingEnabled = true
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = []
        view = UIView()
        view.backgroundColor = UIColor(hexString: "#E7E8E9")
        title = "Filter"
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "filterShop"), object: nil)
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


        view.addSubview(collectionView)
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: filter.topAnchor, right: view.rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let  screenSize = UIScreen.main.bounds
        var tabel:CGSize

        if indexPath.row == 0 {
            tabel = CGSize(width: (screenSize.width - 8), height: 150)
        } else {
            tabel = CGSize(width: (screenSize.width - 8), height: 100)
        }
        
        return tabel
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "price", for: indexPath) as! filterPriceViewCell
            cell.minimalText.delegate = self
            cell.maximalText.delegate = self
            cell.setupViews()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shop", for: indexPath) as! filterShopTypeViewCell
            cell.setupViews()
            cell.shopTag.delegate = self

            let icon = UIImage.fontAwesomeIcon(name: .angleRight, textColor: UIColor(hexString: "#42B549"), size: CGSize(width: 30, height: 30))
            let iconHighlighted = UIImage.fontAwesomeIcon(name: .angleRight, textColor: .green, size: CGSize(width: 30, height: 30))

            cell.filter.setImage(icon, for: .normal)
            cell.filter.setImage(iconHighlighted, for: .highlighted)
            cell.filter.imageEdgeInsets = UIEdgeInsets(top: 0, left: cell.frame.width-40, bottom: 0, right: 0)
            cell.filter.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            cell.shopTag.removeAllTags()
            for shop in shopTypeList {
                if shop.status {
                    cell.shopTag.addTag(shop.shop)
                }
            }
            return cell
        }

    }


    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        //print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        let deltaPrice = Double(pmaxPrice - pminPrice)
        pmin = Int(rangeSlider.lowerValue * deltaPrice + Double(pminPrice))
        pmax = Int(rangeSlider.upperValue * deltaPrice + Double(pminPrice))
        filterPriceViewCell().minimalText.text = String(pmin)
        collectionView.reloadData()
    }

    @objc func textMax(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
        let nilai = Int((textField.text?.currencyToString())!)!
        if nilai < pmaxPrice && nilai > pmin {
            pmax = nilai
            textField.textColor = .black
        } else {
            textField.textColor = .red
        }
    }

    @objc func textMin(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
        let nilai = Int((textField.text?.currencyToString())!)!
        if nilai > pminPrice && nilai < pmax {
            pmin = nilai
            textField.textColor = .black
        } else {
            textField.textColor = .red
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        collectionView.reloadData()
    }
    @objc func tGrosir(sender: UISwitch!) {
        wholesale = sender.isOn
    }

    @objc func reloadData() {
        collectionView.reloadData()
    }

    @objc func shopFilter(sender: UIButton!) {
        print ("penasdasdasdcet")
        let controller = shopTypeViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func apply(sender: UIButton!) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filter"), object: nil)
        start = 0
        dismiss(animated: true, completion: nil)
    }

    @objc func close(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }

    @objc func reset(sender: UIButton!) {
        resetParam()
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        let index = shopTypeList.index(where: { $0.shop == title })! as Int
        shopTypeList[index].status = false
        sender.removeTagView(tagView)
    }

}
