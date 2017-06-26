//
//  PXGBaseTableViewController.swift
//  PingoSwift
//
//  Created by 陈康 on 16/6/12.
//  Copyright © 2016年 封光. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    var loadNewData  : (()->())?
    var loadMoreData : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // header
        var images = [UIImage]()
        for i in 1...19 {
            images.append(UIImage(named:String(format:"loading_%02d",i))!)
        }
        tableView.kk_header = RefreshView.kk_refresh(.gif_only(images), { [weak self] in
            self?.loadNewData?()
        })
        tableView.kk_header.isHidden = true
        
        // footer
        tableView.kk_footer = RefreshView.kk_refresh(.normal(), { [weak self] in
            self?.loadMoreData?()
        })
        tableView.kk_footer.isHidden = true
    }
    
    func nomoreData() {
        tableView.kk_footer.isHidden = false
        tableView.kk_footer.status = .footer_noData
    }
    
    var isHideHeader: Bool! {
        didSet {
           tableView.kk_header.isHidden = isHideHeader
        }
    }
    
    var isHideFooter: Bool! {
        didSet {
            tableView.kk_footer.isHidden = isHideFooter
        }
    }
    
    func beginRefresh() {
        tableView.kk_header.beginRefresh()
    }
    
    func endFooterRefreshing() {
        tableView.kk_footer.stopRefreshing()
    }
    
    func endHeaderRefreshing() {
        tableView.kk_header.stopRefreshing()
    }
    
}
