//
//  LoadDataTableView.swift
//  kk_refresh
//
//  Created by 陈康 on 2017/6/26.
//  Copyright © 2017年 陈康. All rights reserved.
//

import UIKit

// tableView
class LoadDataTableView: UITableView {
    
    var loadNewData  : (()->())?
    var loadMoreData : (()->())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.estimatedRowHeight = 100
        self.rowHeight = UITableViewAutomaticDimension
        backgroundColor = UIColor.white
        
        // header
        var images = [UIImage]()
        for i in 1...19 {
            images.append(UIImage(named:String(format:"loading_%02d",i))!)
        }
        kk_header = RefreshView.kk_refresh(.gif_only(images), { [weak self] in
            self?.loadNewData?()
        })
        kk_header.isHidden = true
        
        // footer
        kk_footer = RefreshView.kk_refresh(.normal(), { [weak self] in
            self?.loadMoreData?()
        })
        kk_footer.isHidden = true
    }
    
    func nomoreData() {
        kk_footer.isHidden = false
        kk_footer.status = .footer_noData
    }
    
    var isHideHeader: Bool! {
        didSet {
            kk_header.isHidden = isHideHeader
        }
    }
    
    var isHideFooter: Bool! {
        didSet {
            kk_footer.isHidden = isHideFooter
        }
    }
    
    func beginRefresh() {
        kk_header.beginRefresh()
    }
    
    func endFooterRefreshing() {
        kk_footer.stopRefreshing()
    }
    
    func endHeaderRefreshing() {
        kk_header.stopRefreshing()
    }
}
