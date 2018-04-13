//
//  CGHomeVC.swift
//  CgExercise
//
//  Created by Test User 1 on 11/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

class CGHomeVC: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    var dataSource = NSMutableArray()
    let manager = CGNetworkManager()
    var cellSize:[Int: CGSize] = [:]
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CGHomeVC.handleRefresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTableView()
        
    }
    
    func configureTableView() -> Void {
       homeCollectionView.addSubview(refreshControl)
        handleRefresh()
    }
    func handleRefresh() {
        ImageLoader.sharedInstance.removeAll()
        self.dataSource.removeAllObjects()
        self.cellSize.removeAll()
        
        manager.getFeeds { (data, error) in
            print(data)
            self.dataSource = data as! NSMutableArray
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.homeCollectionView.reloadData()
            }
        }
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToDetail" {
            let vc = segue.destination as? CGDetailVC
            vc?.model = sender as? FactModel
        }
    }

}

extension CGHomeVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aCell", for: indexPath) as! CGHomeCVCell
        cell.isHidden = true
        if let model = dataSource.object(at: indexPath.item) as? FactModel {
            if let name = model.title {
                cell.titleLabel.text = name
            }
            if let imageUrlString = model.imageHref {
                ImageLoader.sharedInstance.obtainImageWithPath(imagePath: imageUrlString) { (image,fromCache) in
                    if fromCache{
                        cell.imageView.image = image
                    } else{
                        cell.imageView.image = image
                        self.cellSize[indexPath.row] = image.size
                        self.homeCollectionView.reloadItems(at: [indexPath])
                    }
                    cell.isHidden = false
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let size = self.cellSize[indexPath.row]{
            let screenWidth = self.view.frame.width - 20
            var imageWidth = size.width
            var imageHeight = size.height
            var ratio: CGFloat = 1.0
            if imageWidth > screenWidth {
                ratio = imageWidth / screenWidth
                imageWidth = self.view.frame.width
                imageHeight = ((imageHeight / ratio) - 20)
            }
            return CGSize(width: imageWidth, height: imageHeight)
        }else{
            return CGSize(width: 100, height: 100)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedObj = dataSource.object(at: indexPath.row) as? FactModel {
            performSegue(withIdentifier: "HomeToDetail", sender: selectedObj)
        }
        
    }
    
    
    
}
