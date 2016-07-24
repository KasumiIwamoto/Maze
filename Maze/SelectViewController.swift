//
//  SelectViewController.swift
//  Maze
//
//  Created by 岩本果純 on 2016/07/18.
//  Copyright © 2016年 KasumiIwamoto. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
    var path: String!     // this value should be set from the outer
    var fullPath: String!
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextView: UITextView!
    //@IBOutlet weak var myImage : UIImageView!
    
    @IBAction func tapBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func tapLoad(sender: AnyObject) {
        if let txt = myTextView.text {
            let a:[String] = txt.componentsSeparatedByString(" ")
            if a.count > 2 {
                let rows = Int(a[0])
                let cols = Int(a[1])
                if (rows != nil) && (cols != nil) {
                    var map = Array<Int>()
                    for s in a {
                        if let n = Int(s) {
                            map.append(n)
                        } else {
                            return
                        }
                    }
                    // success
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.rows = rows
                    appDelegate.cols = cols
                    appDelegate.map = map
                    print("\(rows) \(cols) \(map.count)")
                    dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
    }
    @IBAction func tapRemove(sender: AnyObject) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(fullPath)
            dismissViewControllerAnimated(true, completion: nil)
        } catch let error as NSError {
            let alert: UIAlertController = UIAlertController(title:"Selected File",
                                                             message: "error occurred: "+String(error),
                                                             preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Cancel",style:UIAlertActionStyle.Cancel,handler:nil))
            presentViewController(alert,animated:true, completion:nil)
        }
    }
    func fileContents() {
        let manager:NSFileManager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        let flag = manager.fileExistsAtPath(fullPath, isDirectory:&isDir)
        if flag && Bool(isDir) {
            myTextView.text = "[[Directory]]"
        } else if flag {
            if fullPath.hasSuffix(".txt") {
                do {
                    myTextView.text = try NSString(contentsOfFile: fullPath, encoding: NSUTF8StringEncoding) as String
                        print(myTextView.text)
                } catch let error as NSError {
                    let alert: UIAlertController = UIAlertController(title:"Selected File",
                                                                     message: "cannot read .txt file: "+String(error),
                                                                     preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title:"Cancel",style:UIAlertActionStyle.Cancel,handler:nil))
                    presentViewController(alert,animated:true, completion:nil)
                    
                }
            } else {
                myTextView.text = "[[not directory, but has no \".txt\" suffix]]"
            }
        } else {
            let alert: UIAlertController = UIAlertController(title:"Selected File",
                                                             message: "No such file exists",
                                                             preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Cancel",style:UIAlertActionStyle.Cancel,handler:nil))
            presentViewController(alert,animated:true, completion:nil)
        }
    }
    
    func setup() {
        if path == nil {
            let alert: UIAlertController = UIAlertController(title:"Selected File",
                                                             message: "path is nil: ",
                                                             preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Cancel",style:UIAlertActionStyle.Cancel,handler:nil))
            presentViewController(alert,animated:true, completion:nil)
            path = ""
        }
        fullPath = NSHomeDirectory() + "/Documents/" + path
        myLabel.text = path
    }
    override func viewDidAppear(animated: Bool) {
        setup()
        fileContents()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
