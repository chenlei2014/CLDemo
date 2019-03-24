//
//  CLRotateAnimationView.swift
//  CLDemo
//
//  Created by AUG on 2019/3/24.
//  Copyright © 2019年 JmoVxia. All rights reserved.
//

import UIKit

class CLRotateAnimationViewConfigure: NSObject {
   
    ///开始起点
    var startAngle: CGFloat = -(.pi * 0.5)
    ///开始结束点
    var endAngle: CGFloat = .pi * 1.5
    ///动画总时间
    var duration: TimeInterval = 2
    ///动画间隔时间
    var intervalDuration:TimeInterval = 0.12
    ///小球个数
    var number: NSInteger = 5
    ///小球直径
    var diameter: CGFloat = 8
    ///小球背景颜色
    var backgroundColor: UIColor = UIColor.red

    fileprivate class func defaultConfigure() -> CLRotateAnimationViewConfigure {
        let configure = CLRotateAnimationViewConfigure()
        return configure
    }
}

class CLRotateAnimationView: UIView {
    ///默认配置
    private let defaultConfigure: CLRotateAnimationViewConfigure = CLRotateAnimationViewConfigure.defaultConfigure()
    ///layer数组
    private var layerArray: Array<CALayer> = Array()
    ///是否暂停
    private var isPause: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initLayer() -> Void {
        let origin_x: CGFloat = frame.size.width * 0.5
        let origin_y: CGFloat = frame.size.height * 0.5
        for item in 0 ..< defaultConfigure.number {
            //创建layer
            let scale: CGFloat = CGFloat(defaultConfigure.number + 1 - item) / CGFloat(defaultConfigure.number + 1)
            let layer: CALayer = CALayer()
            layer.backgroundColor = defaultConfigure.backgroundColor.cgColor
            layer.frame = CGRect.init(x: -5000, y: -5000, width: scale * defaultConfigure.diameter, height: scale * defaultConfigure.diameter)
            layer.cornerRadius = scale * defaultConfigure.diameter * 0.5;
            //运动路径
            let pathAnimation: CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "position")
            pathAnimation.calculationMode = .paced;
            pathAnimation.fillMode = .forwards;
            pathAnimation.isRemovedOnCompletion = false;
            pathAnimation.duration = (defaultConfigure.duration) - Double((defaultConfigure.intervalDuration) * Double(defaultConfigure.number));
            pathAnimation.beginTime = Double(item) * defaultConfigure.intervalDuration;
            pathAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            pathAnimation.path = UIBezierPath(arcCenter: CGPoint.init(x: origin_x, y: origin_y), radius: (self.frame.size.width - self.defaultConfigure.diameter) * 0.5, startAngle: defaultConfigure.startAngle, endAngle: defaultConfigure.endAngle, clockwise: true).cgPath
            //动画组，动画组时间长于单个动画时间，会有停留效果
            let group: CAAnimationGroup = CAAnimationGroup()
            group.animations = [pathAnimation]
            group.duration = defaultConfigure.duration
            group.isRemovedOnCompletion = false
            group.fillMode = .forwards
            group.repeatCount = MAXFLOAT
            
            layer.add(group, forKey: "RotateAnimation")
            layerArray.append(layer)
        }
    }
    ///更新配置
    func updateWithConfigure(configure: ((CLRotateAnimationViewConfigure) -> (Void))?) -> Void {
        configure?(self.defaultConfigure)
        let intervalDuration: CGFloat = CGFloat(CGFloat(self.defaultConfigure.duration) / 2.0 / CGFloat(self.defaultConfigure.number));
        self.defaultConfigure.intervalDuration = min(self.defaultConfigure.intervalDuration, TimeInterval(intervalDuration));
    }
}
extension CLRotateAnimationView {
    ///开始动画
    func startAnimation() -> Void {
        initLayer()
        for item in layerArray {
            layer.addSublayer(item)
        }
    }
    ///停止动画
    func stopAnimation() -> Void {
        for item in layerArray {
            item.removeFromSuperlayer()
        }
        layerArray.removeAll()
    }
    ///暂停动画
    func pauseAnimation() {
        if isPause {
            return
        }
        isPause = true
        //取出当前时间,转成动画暂停的时间
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        layer.speed = 0.0;
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        layer.timeOffset = pausedTime
    }
    ///恢复动画
    func resumeAnimation() {
        if !isPause {
            return
        }
        isPause = false
        //获取暂停的时间差
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
