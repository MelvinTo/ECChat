//
//  ClassicLoginViewController.swift
//  Pods
//
//  Created by Melvin Tu on 7/24/15.
//
//

import Foundation

@objc(ClassicLoginViewController)

public protocol EnCloudsLoginDelegate {
    func success(payload: String)
}

public class ClassicLoginViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var serviceCollection: UICollectionView!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var separator: UIView!
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    let reuseIdentifier = "serviceCell"
    
    public var delegate: EnCloudsLoginDelegate? = nil
    
    init() {
        super.init(nibName: getLocalizedNibName("ClassicLoginViewController"), bundle: NSBundle(forClass: ClassicLoginViewController.self))
    }

    required public convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.boxView.backgroundColor = UIColor.grayColor()
        self.boxView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).CGColor
        self.separator.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        self.serviceCollection.registerNib(UINib(nibName: getLocalizedNibName("LoginServiceCell"), bundle: NSBundle(forClass: LoginServiceCell.self)), forCellWithReuseIdentifier: reuseIdentifier)
        self.serviceCollection.bounces = true
        self.serviceCollection.delegate = self
        self.serviceCollection.dataSource = self
    }
    
    func hideKeyboard() {
        self.email.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 0
        }
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        NSLog("calling numberOfSectionsInCollectionView")
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        if let x = cell as? LoginServiceCell {
            let index = indexPath.indexAtPosition(1)
            var imageName : String? = nil
            
            switch index {
            case 0:
                imageName = "EnClouds.bundle/weixin.png"
            case 1:
                imageName = "EnClouds.bundle/weibo.png"
            default:
                imageName = "EnClouds.bundle/weixin.png"
            }
            
            let image = UIImage(named: imageName!, inBundle: NSBundle(forClass: ClassicLoginViewController.self), compatibleWithTraitCollection: nil)
            x.serviceButton.setImage(image, forState: .Normal)

        }
        
        // Configure the cell
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.indexAtPosition(1)
    }
    
    @IBAction func login(sender: AnyObject) {
        let auth_url = "http://enclouds.co:8080/auth/login"
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.success("")
    }
    
}