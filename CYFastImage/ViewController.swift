//
//  ViewController.swift
//  CYFastImage
//
//  Created by jason on 14-6-17.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var mdataArray: Array<String> = {
        var dataArray = Array<String>()
        dataArray.append("http://g.hiphotos.baidu.com/image/pic/item/dc54564e9258d1097dec49e3d358ccbf6c814d50.jpg")
        dataArray.append("http://c.hiphotos.baidu.com/image/pic/item/8cb1cb13495409231766832f9058d109b3de4950.jpg")
        dataArray.append("http://a.hiphotos.baidu.com/image/pic/item/4034970a304e251f75a304a9a586c9177f3e530f.jpg")
        dataArray.append("http://h.hiphotos.baidu.com/image/pic/item/c8177f3e6709c93d97a6eea69d3df8dcd100540f.jpg")
        dataArray.append("http://f.hiphotos.baidu.com/image/pic/item/5bafa40f4bfbfbed4656077a7af0f736afc31fa3.jpg")
        dataArray.append("http://g.hiphotos.baidu.com/image/pic/item/a5c27d1ed21b0ef4d57ea95bdfc451da81cb3e24.jpg")
        dataArray.append("http://e.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c2b123d12e0cf41bd5ad6e39b6.jpg")
        dataArray.append("http://c.hiphotos.baidu.com/image/pic/item/1ad5ad6eddc451da53603deeb4fd5266d0163224.jpg")
        dataArray.append("http://g.hiphotos.baidu.com/image/pic/item/9213b07eca8065388a4d711795dda144ad34820b.jpg")
        dataArray.append("http://a.hiphotos.baidu.com/image/pic/item/b8389b504fc2d562f5a3f1bce51190ef76c66c33.jpg")

        return dataArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds)
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MAKR: tableview
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return mdataArray.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        if !cell  {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
            var imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.backgroundColor = UIColor.redColor()
            imageView.tag = 222
            cell.contentView.addSubview(imageView)
        }
        
        var url = mdataArray[indexPath.row]
        var imageView:UIImageView! = cell.contentView.viewWithTag(222) as? UIImageView
        imageView.setImageURL(url, placeHolderImage: UIImage(named: "125.jpg"))
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 60
    }
}

