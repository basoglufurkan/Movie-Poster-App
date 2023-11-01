//
//  HomeViewController.swift
//  Movie Poster App
//
//  Created by Furkan BAŞOĞLU on 31.10.2023.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    var list: [OmdbModel] = []
    var grid: [OmdbModel] = []
    lazy var timer: Timer? = nil
    lazy var searchBar:UISearchBar = UISearchBar()
    lazy var tableView = UITableView()
    var safeArea: UILayoutGuide!
    lazy var collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        setupCollectionView()
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.frame = CGRect(x: 30, y: topNotch(), width: UIScreen.main.bounds.width-60, height: 60)
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        self.getHints()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(HomeViewController.getHints),
            userInfo: ["searchText": searchText],
            repeats: false)
    }
    
    @objc func getHints() {
        let userInfo = timer?.userInfo as? [String: String] ?? [String:String]()
        var searchText = userInfo["searchText"] ?? "Star"
        if searchText.isEmpty {
            searchText = "Star"
        }
        Services.shared.getData(searchStr: searchText) { arr in
            self.list = arr
            self.list = self.list.filter({ obj in
                return !(obj.title ?? "").isEmpty
            })
            self.grid = self.list.filter({ obj in
                return obj.genre?.contains("Comedy") ?? false
            })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
            
        }
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2+80, height: UIScreen.main.bounds.width/2-20)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-topNotch()-50-250+80, width: UIScreen.main.bounds.width, height: 200), collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: topNotch()+100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-topNotch()-50-300)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
    }

}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        let obj = list[indexPath.row]
        cell.textLabel?.text = obj.title ?? ""
        cell.imageView?.image = UIImage(named: "img")
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height ?? 0.0)/2
        cell.imageView?.clipsToBounds = true
        cell.detailTextLabel?.text = obj.plot ?? ""
        let representedIdentifier = obj.id
        cell.imageView?.tag = Int(representedIdentifier) ?? 4174320
        cell.selectionStyle = .none
        
        Services.shared.image(poster: obj.poster ?? "") { data  in
            let img = image(data: data)
            DispatchQueue.main.async {
                if ((cell.imageView?.tag ?? 0) == (Int(representedIdentifier) ?? 0)) {
                    cell.imageView?.image = img
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        let obj = list[indexPath.row]
        vc.imageUrl = obj.poster ?? ""
        vc.titleStr = obj.title ?? ""
        vc.subTitle = obj.plot ?? ""
        self.present(vc, animated: true)
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grid.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let obj = grid[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width/2+80, height: UIScreen.main.bounds.width/2))
        imageView.image = UIImage(named: "img")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        let representedIdentifier = obj.id
        imageView.tag = Int(representedIdentifier) ?? 4174320
        Services.shared.image(poster: obj.poster ?? "") { data  in
            let img = image(data: data)
            DispatchQueue.main.async {
                if (imageView.tag == (Int(representedIdentifier) ?? 0)) {
                    imageView.image = img
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        let obj = grid[indexPath.row]
        vc.imageUrl = obj.poster ?? ""
        vc.titleStr = obj.title ?? ""
        vc.subTitle = obj.plot ?? ""
        self.present(vc, animated: true)
    }
}
