//
//  ListViewController.swift
//  Maze
//
//  Created by 岩本果純 on 2016/07/18.
//  Copyright © 2016年 KasumiIwamoto. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var manager: NSFileManager!
    var fullPath: String!
    var paths: Array<String>!
    @IBOutlet weak var myTableView: UITableView!
    @IBAction func tapBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if paths == nil {
            return 1
        }
        return paths.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = paths[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let controller: SelectViewController = storyboard.instantiateViewControllerWithIdentifier("SelectViewController") as! SelectViewController
        controller.path = paths[indexPath.row]
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func refreshPaths() {
        paths = manager.subpathsAtPath(fullPath)
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshPaths()
        self.myTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        manager = NSFileManager.defaultManager()
        fullPath = NSHomeDirectory() + "/Documents"

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
