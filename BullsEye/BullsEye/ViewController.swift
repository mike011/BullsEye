//
//  ViewController.swift
//  BullsEye
//
//  Created by Michael Charland on 2017-10-28.
//  Copyright © 2017 charland. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var target: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        updateLabels()
        setSliderImages()
    }

    func setSliderImages() {
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)

        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)

        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)

        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }

    func setTransition() {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference

        if(difference == 0) {
            points += 100
        }

        score += points
        
        let message = "You scored \(points) points"
        let alert  = UIAlertController(title: getTitle(difference), message: message,
                                       preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: { action in self.startNewRound()
            self.updateLabels()})
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }

    func getTitle(_ difference: Int) -> String {
        var title = ""
        switch difference {
        case 0:
            title = "Perfect"
        case 1..<9:
            title = "Really close"
        case 10..<25:
            title = "Close"
        default:
            title = "Not even close"
        }
        return title
    }

    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }

    func startNewRound() {
        round += 1
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)
    }

    func updateLabels() {
        target.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }

    func startNewGame() {
        round = 0
        score = 0
        startNewRound()
    }

    @IBAction func startOver(_ sender: Any) {
        startNewGame()
        updateLabels()
        setTransition()
    }
}

