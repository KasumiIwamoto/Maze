//
//  EditViewController.swift
//  Maze
//
//  Created by 岩本果純 on 2016/07/18.
//  Copyright © 2016年 KasumiIwamoto. All rights reserved.
//

import UIKit

class EditViewController: UIViewController,UITextFieldDelegate {
    var rows: Int!
    var cols: Int!
    var mode: Int!
    var map: [Int]!
    
    let colors:[[CGFloat]] = [[ 0.7, 0.7, 0.7, 1.0 ],
                              [ 1.0, 0.0, 0.0, 1.0 ],
                              [ 0.0, 1.0, 0.0, 1.0 ],
                              [ 0.0, 0.0, 1.0, 1.0 ]]
    
    @IBOutlet weak var colsField: UITextField!
    @IBOutlet weak var rowsField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    @IBAction func colsEditingEnd(sender: AnyObject) {
        if let t = Int(colsField.text!) {
            changeMapSize(rows,t)
        }
        colsField.text = String(cols)
    }
    @IBAction func rowsEditingEnd(sender: AnyObject) {
        if let t = Int(rowsField.text!) {
            changeMapSize(t,cols)
        }
        rowsField.text = String(rows)
    }
    @IBAction func tapBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func tapSave(sender: AnyObject) {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        format.timeZone = NSTimeZone(abbreviation: "JST")
        let now = format.stringFromDate(NSDate())
        
        let path = NSHomeDirectory() + "/Documents/" + now + ".txt"
        var contents: String = "\(rows) \(cols)"
        for m in map {
            contents = contents + " " + String(m)
        }
        do {
            try contents.writeToFile(path, atomically:true, encoding:NSUTF8StringEncoding)
        } catch let error as NSError {
            let alert = UIAlertController(title:"Save", message: "error occurred: "+String(error), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel,handler:nil))
            presentViewController(alert,animated:true,completion:nil)
        }
    }
    @IBAction func tapButton0(sender: AnyObject) {
        mode = 0
    }
    @IBAction func tapButton1(sender: AnyObject) {
        mode = 1
    }
    @IBAction func tapButton2(sender: AnyObject) {
        mode = 2
    }
    
    @IBAction func tapButton3(sender: AnyObject) {
        mode = 3
    }
    @IBAction func tapImageView(sender: UITapGestureRecognizer) {
        let pos = sender.locationInView(myImageView)
        let sz:CGSize = myImageView.bounds.size
        let bw = sz.width / CGFloat(cols)
        let bh = sz.height / CGFloat(rows)
        let c = Int(pos.x / bw)
        let r = Int(pos.y / bh)
        map[r * cols + c] = mode
        drawMap()
    }
    
    func drawMap() {
        let sz:CGSize = myImageView.bounds.size
        let bw = sz.width / CGFloat(cols);
        let bh = sz.height / CGFloat(rows);
        UIGraphicsBeginImageContext(sz)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetLineWidth(context, 2.0)
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0)
        for i in 0..<(rows*cols) {
            let r = CGFloat(i / cols)
            let c = CGFloat(i % cols)
            let m = map[i]
            CGContextSetRGBFillColor(context, colors[m][0], colors[m][1], colors[m][2], colors[m][3])
            let rect = CGRect(x: c * bw, y: r * bh, width: bw, height: bh)
            CGContextFillRect(context, rect)
            CGContextStrokeRect(context, rect)
        }
        myImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func changeMapSize(rs:Int, _ cs:Int) {
        print("map = \(rows) x \(cols) to \(rs) x \(cs)")
        var map2 = Array<Int>(count: (rs*cs), repeatedValue: 0)
        for r in 0..<rs {
            for c in 0..<cs {
                if (r < rows) && (c < cols) {
                    map2[r * cs + c] = map[r * cols + c]
                }
            }
        }
        map = map2; rows = rs; cols = cs
        drawMap()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        //returnキーを押したらキーボードを下げる
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rows = rows ?? 10  //横
        cols = cols ?? 6 //縦
        mode = mode ?? 0
        rowsField.text = String(rows)
        colsField.text = String(cols)
        map = Array<Int>(count: (rows*cols), repeatedValue: 0)
        drawMap()
        colsField.delegate = self
        rowsField.delegate = self
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
