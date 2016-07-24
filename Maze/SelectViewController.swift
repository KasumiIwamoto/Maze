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
    var maze: [[Int]] = []
    let screenSize = UIScreen.mainScreen().bounds.size
    var wallRectArray = [CGRect]()
    
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextView: UITextView!
    //@IBOutlet weak var myImage : UIImageView!
    override func viewDidAppear(animated: Bool) {
    }
    
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
                    let text = try NSString(contentsOfFile: fullPath, encoding: NSUTF8StringEncoding) as String
                    text.enumerateLines({ (line, stop) in
                        print("line...\(line)")
                        print("stop...\(stop)")
                        let item = line.componentsSeparatedByString(" ").map({str in Int(str)!})
                        self.maze.append(item)
                    })
                    print(self.maze)
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
    var goalView:UIView!
    var startView:UIView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        fileContents()        // Do any additional setup after loading the view.
        let cellWidth = screenSize.width / CGFloat(maze[0].count)
        let cellHeight = screenSize.height / CGFloat(maze.count)
        
        let celloffsetX = screenSize.width / CGFloat(maze[0].count*2)
        let celloffsetY = screenSize.height / CGFloat(maze.count*2)
        
        for y in 0 ..< maze.count{
            for x in 0 ..< maze[y].count{
                switch maze[y][x]{
                case 1:
                    let wallView = createView(x:x,y:y,width:cellWidth,height:cellHeight,offsetX:celloffsetX,offsetY:celloffsetY)
                    wallView.backgroundColor = UIColor.blackColor()
                    view.addSubview(wallView)
                    wallRectArray.append(wallView.frame)
                case 2:
                    startView = createView(x:x,y:y,width:cellWidth,height:cellHeight,offsetX:celloffsetX,offsetY:celloffsetY)
                    startView.backgroundColor = UIColor.greenColor()
                    self.view.addSubview(startView)
                case 3:
                    goalView = createView(x:x,y:y,width:cellWidth,height:cellHeight,offsetX:celloffsetX,offsetY:celloffsetY)
                    goalView.backgroundColor = UIColor.redColor()
                    self.view.addSubview(goalView)
                default:
                    break
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createView(x x:Int,y:Int,width:CGFloat,height:CGFloat,offsetX:CGFloat = 0,offsetY:CGFloat = 0)->UIView{
        let rect = CGRect(x: 0,y: 0,width: width,height: height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(
            x: offsetX + width * CGFloat(x),
            y: offsetY + height * CGFloat(y)
        )
        view.center = center
        return view
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
