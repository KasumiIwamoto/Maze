//
//  ViewController.swift
//  Maze
//
//  Created by 岩本果純 on 2016/06/06.
//  Copyright © 2016年 KasumiIwamoto. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var playerView:UIView!
    var playerMotionManeger:CMMotionManager!
    var speedX:Double = 0.0
    var speedY:Double = 0.0
    
    
    let screenSize = UIScreen.mainScreen().bounds.size
    let maze = [
        [1,0,0,0,1,0],
        [1,0,1,0,1,0],
        [3,0,1,0,1,0],
        [1,1,1,0,0,0],
        [1,0,0,1,1,0],
        [0,0,1,0,0,0],
        [0,1,1,0,1,0],
        [0,0,0,0,1,1],
        [0,1,1,0,0,0],
        [0,0,1,1,1,2],
        ]
    var goalView:UIView!
    var startView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        playerView = UIView(frame: CGRectMake(0 ,0 ,screenSize.width ,screenSize.height/60))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(playerView)
        
        //MotionManagerを生成
        playerMotionManeger = CMMotionManager()
        playerMotionManeger.accelerometerUpdateInterval = 0.02
        
        self.startAccelerometer()
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
    func startAccelerometer(){
        let handler: CMAccelerometerHandler = {(accelerometerData:CMAccelerometerData?,error:NSError?) -> Void in
            
            self.speedX += accelerometerData!.acceleration.x
            self.speedY += accelerometerData!.acceleration.y
            
            var posX = self.playerView.center.x + (CGFloat(self.speedX)/3)
            var posY = self.playerView.center.y + (CGFloat(self.speedY)/3)
            
            if posX <= (self.playerView.frame.width/2){
                self.speedX = 0
                posX = self.playerView.frame.width/2
            }
            if posY <= (self.playerView.frame.height/2){
                self.speedY = 0
                posY = self.playerView.frame.height/2
            }
            if posX >= (self.screenSize.width - (self.playerView.frame.width/2)){
                self.speedX = 0
                posX = (self.screenSize.width - (self.playerView.frame.width/2))
            }
            if posY >= (self.screenSize.height - (self.playerView.frame.height/2)){
                self.speedY = 0
                posX = (self.screenSize.height - (self.playerView.frame.height/2))
            }
            
            self.playerView.center = CGPointMake(posX, posY)
        }
        playerMotionManeger.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: handler)
    }
}

