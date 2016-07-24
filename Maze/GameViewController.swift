//
//  GameViewController.swift
//  Maze
//
//  Created by 岩本果純 on 2016/07/18.
//  Copyright © 2016年 KasumiIwamoto. All rights reserved.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController {
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
    //0が道、1が壁、2がスタート、3がゴール
    var goalView:UIView!
    var startView:UIView!
    var wallRectArray = [CGRect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        playerView = UIView(frame: CGRectMake(0 ,0 ,screenSize.width/30 ,screenSize.height/30))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(playerView)
        
        //MotionManagerを生成
        playerMotionManeger = CMMotionManager()
        //加速度を取得する間隔
        playerMotionManeger.accelerometerUpdateInterval = 0.025
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
    //実際に加速度を感知した時の動作
    func startAccelerometer(){
        let handler: CMAccelerometerHandler = {(accelerometerData:CMAccelerometerData?,error:NSError?) -> Void in
            
            self.speedX += accelerometerData!.acceleration.x
            self.speedY += accelerometerData!.acceleration.y
            
            var posX = self.playerView.center.x + (CGFloat(self.speedX)/3)
            var posY = self.playerView.center.y - (CGFloat(self.speedY)/3)
            
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
                posY = (self.screenSize.height - (self.playerView.frame.height/2))
            }
            for wallRect in self.wallRectArray{
                if (CGRectIntersectsRect(wallRect, self.playerView.frame)){
                    self.gameCheck("Game Over", message: "壁に当たりました")
                    return
                }
            }
            if(CGRectIntersectsRect(self.goalView.frame, self.playerView.frame)){
                self.gameCheck("Clear!", message: "クリアしました")
                return
            }
            self.playerView.center = CGPointMake(posX, posY)
        }
        //加速度の開始
        playerMotionManeger.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: handler)
    }
    func gameCheck(result:String,message:String){
        //加速度を止める
        if playerMotionManeger.accelerometerActive {
            playerMotionManeger.stopAccelerometerUpdates()
        }
        let gameCheckAlert : UIAlertController = UIAlertController(title: result,message: message,preferredStyle: .Alert)
        let retryAction = UIAlertAction(title: "もう一度",style: .Default){ action in
            self.retry()
        }
        let backAction = UIAlertAction(title: "戻る",style: .Default){ action in
            self.back()
            }
            gameCheckAlert.addAction(retryAction)
            gameCheckAlert.addAction(backAction)
            self.presentViewController(gameCheckAlert,animated: true,completion: nil)
        
    }
    func retry(){
        //位置を初期化
        playerView.center = startView.center
        //加速度を始める
        if !playerMotionManeger.accelerometerActive{
            self.startAccelerometer()
        }
        //スピードを初期化
        speedX = 0.0
        speedY = 0.0
    }
    func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "backtoTop"){
            let game:ViewController = (segue.destinationViewController as? ViewController)!
        }
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
