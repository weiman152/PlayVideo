//
//  VideoPlayView.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/3.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit
import SnapKit

class VideoPlayView: UIView {

    lazy var backgroundView: UIView = {
        $0.backgroundColor = .clear
        return $0
    }( UIView() )
    lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "我是标题"
        return $0
    }( UILabel() )
    lazy var controlView: UIView = {
        return $0
    }( UIView() )
    lazy var currentTimeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "00:00"
        return $0
    }( UILabel() )
    lazy var totalTimeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "00:00"
        return $0
    }( UILabel() )
    lazy var progress: UIProgressView = {
        $0.progressTintColor = .gray
        $0.progress = 0
        return $0
    }( UIProgressView() )
    lazy var slider: UISlider = {
        $0.maximumTrackTintColor = .clear
        $0.minimumTrackTintColor = .red
        return $0
    }( UISlider() )
    lazy var playAndPauseButton: UIButton = {
        $0.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "pause"), for: .selected)
        return $0
    }( UIButton() )
    lazy var showAndHideButton: UIButton = {
        $0.addTarget(self, action: #selector(showOrHideButtonAction(button:)), for: .touchUpInside)
        return $0
    }( UIButton() )
    
    private var mediaPlayer = VideoPlay.shareSingle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
      
        backgroundColor = .clear
        
        addSubview(backgroundView)
        addSubview(showAndHideButton)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(playAndPauseButton)
        backgroundView.addSubview(controlView)
        controlView.addSubview(currentTimeLabel)
        controlView.addSubview(totalTimeLabel)
        controlView.addSubview(progress)
        controlView.addSubview(slider)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalToSuperview()
        }
        showAndHideButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-49)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundView.snp.left).offset(10)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        playAndPauseButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        controlView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(controlView.snp.left).offset(10)
            make.centerY.equalToSuperview()
        }
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(controlView.snp.right).offset(-10)
            make.centerY.equalTo(currentTimeLabel.snp.centerY)
        }
        progress.snp.makeConstraints { (make) in
            make.left.equalTo(currentTimeLabel.snp.right).offset(10)
            make.centerY.equalTo(currentTimeLabel.snp.centerY)
            make.right.equalTo(totalTimeLabel.snp.left).offset(-10)
            make.height.equalTo(1.5)
        }
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(progress.snp.left)
            make.top.equalToSuperview()
            make.right.equalTo(progress.snp.right)
            make.bottom.equalToSuperview()
        }
        
        
    }
    
    /// 显示\隐藏 控制按钮事件
    @objc func showOrHideButtonAction(button: UIButton) {
        print("显示或隐藏按钮点击")
    }

}

/// 播放相关
extension VideoPlayView {
    
    /// 带播放控件的视频播放器
    func playVideo(url: String, frame: CGRect) {
        self.frame = frame
        mediaPlayer.delegate = self
        let playerLayer = mediaPlayer.setup(url: url, frame: frame)
        self.layer.insertSublayer(playerLayer, at: 0)
        play()
    }
    
    func play() {
        mediaPlayer.play()
    }
    
    func pause() {
        mediaPlayer.pause()
    }
    
    func remove() {
        mediaPlayer.remove()
        removeFromSuperview()
    }
}

/// 代理相关
extension VideoPlayView: VideoPlayDelegate {
    
    func updateProgress(progress: Float) {
        self.progress.progress = progress
    }
    
    func updateTotalTime(totalTime: Float) {
        let time = timeToHMS(time: totalTime)
        totalTimeLabel.text = time
    }
    
    func updatePlayTime(progress: Float, value: Float) {
        slider.value = progress
        currentTimeLabel.text = timeToHMS(time: value)
    }
    
    func playFinish() {
        removeFromSuperview()
    }
}

/// 工具相关
extension VideoPlayView {
    
    /// 把浮点型的秒转成时分秒字符串
    func timeToHMS(time: Float) -> String {
        
        let format = DateFormatter()
        if time / 3600 >= 1 {
            format.dateFormat = "HH:mm:ss"
        } else {
            format.dateFormat = "mm:ss"
        }
        let string = format.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
        return string
    }
}







