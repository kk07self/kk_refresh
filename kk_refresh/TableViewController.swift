//
//  TableViewController.swift
//  Refresh
//
//  Created by 陈康 on 2017/3/24.
//  Copyright © 2017年 陈康. All rights reserved.
//

import UIKit

class TableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 不建议直接使用
        tableView.kk_header = RefreshView.kk_refresh(.gif(images), {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.tableView.kk_header.stopRefreshing()
            })
        })*/
        
        
        /* 建议将其封装一层再使用：见BaseTableViewController、LoadDataTableView */
        // 下拉刷新
        loadNewData = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.endHeaderRefreshing()
                self.isHideFooter = false
            })
        }
        // 上拉加载更多
        loadMoreData = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.endFooterRefreshing()
            })
        }
        isHideHeader = false
        beginRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(tableView.contentOffset)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifile")
        cell?.contentView.backgroundColor = UIColor.red
        return cell!
    }

}
