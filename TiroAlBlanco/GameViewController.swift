//
//  ViewController.swift
//  TiroAlBlanco
//
//  Created by Forsaken on 12/04/2019.
//  Copyright © 2019 Forsaken. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController {

    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var tiempoLabel: UILabel!
    
    @IBOutlet weak var recordLabel: UILabel!
    
    
    
    
    
    var valorActual = 0
    var targetValue : Int = 0
    var score = 0
    var round = 0
    var tiempo : Int = 30
    var timer : Timer?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setupSlider()
        resetGame()
        updateLabels()
    }

    
    
    
    @IBAction func hitButton(_ sender: Any) {
        
        
        let difference : Int = abs(self.valorActual-self.targetValue)
      
        //let puntuacion = (difference > 0) ? 100 - difference : 1000
        var puntuacion = 100 - difference
        
        
        
        
        let tittle: String
        switch difference {
        case 0:
            tittle = "Has dado en el Blanco!!!"
            puntuacion = Int(10.0 * Float(puntuacion))
            self.tiempo += 5
        case 1...5:
            tittle = "Casi perfecto!"
            puntuacion = Int(1.5 * Float(puntuacion))
        case 6...10:
            tittle = "Has estado cerca"
            puntuacion = Int(1.2 * Float(puntuacion))
        default:
            tittle = "Sigue intentandolo"
        }
        self.score += puntuacion
        
        let message = "Tu Puntuación es de : \(puntuacion)"
        
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        
        //completion es para ejecutar el codigo posterior
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: { action in
           //se ejecutan con el boton
            self.newRonda()
            self.updateLabels()
        })
        
        alert.addAction(action)
        present(alert, animated: true)
       
       
    }
    
    
    @IBAction func moveSlider(_ sender: UISlider) {
        self.valorActual = lroundf(sender.value)
        
    }
    
    
    @IBAction func resetButton(_ sender: Any) {
        resetGame()
        updateLabels()
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        self.view.layer.add(transition, forKey: nil)
    }
    
    
    
    
    
    
    //Funciones extras
    
    func newRonda (){
        self.valorActual = 50
        targetValue = 1 + Int(arc4random_uniform(100))
        self.slider.value = Float(self.valorActual)
          self.targetLabel.text = String(targetValue)
        self.round += 1
    }
    
    func updateLabels() {
        self.pointsLabel.text = "\(self.score)"
        self.roundLabel.text = "\(self.round)"
        self.tiempoLabel.text = "\(self.tiempo)"
        
    }
    
    func setupSlider() {
        let imageNormal = UIImage(named: "SliderThumb-Normal")
        let imageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        let trackLeftImage = UIImage(named: "SliderTrackLeft")
        let trackRightImage = UIImage(named: "SliderTrackRight")
        
        self.slider.setThumbImage(imageNormal, for: .normal)
        self.slider.setThumbImage(imageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets (top: 0, left: 14, bottom: 0, right: 14)
        let trackResizableLeft = trackLeftImage?.resizableImage(withCapInsets: insets)
        let trackResizableRight = trackRightImage?.resizableImage(withCapInsets: insets)
        
        self.slider.setMinimumTrackImage(trackResizableLeft, for: .normal)
        self.slider.setMaximumTrackImage(trackResizableRight, for: .normal)
    }
    
    func resetGame(){
        //Comprobamos puntuación máxima aquí
        var maxscore = UserDefaults.standard.integer(forKey: "maxscore")
        
        if maxscore < self.score {
            maxscore = self.score
            UserDefaults.standard.set(maxscore, forKey: "maxscore")
        }
        
        self.recordLabel.text = "\(maxscore)"
        
        
        self.pointsLabel.text = "0"
        self.roundLabel.text = "0"
        self.score = 0
        self.round = 0
        self.tiempo = 30
        
       
        
        if timer != nil {
            timer?.invalidate()
        }
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickTack), userInfo: nil, repeats: true)
        self.updateLabels()
         self.newRonda()
    }
    
    
    @objc func tickTack(){
        self.tiempo -= 1
        self.tiempoLabel.text = "\(self.tiempo)"
        if self.tiempo <= 0 {
            self.tiempoLabel.text = "00"
            let message = """
                   ¡Tiempo Agotado!
            Tu Puntuación es de : \(self.score)
            """
            
            let alert = UIAlertController(title: "GAME OVER", message: message, preferredStyle: .alert)
            
            //completion es para ejecutar el codigo posterior
            let action = UIAlertAction(title: "Aceptar", style: .default, handler: { action in
               
                 self.resetGame()
            })
            alert.addAction(action)
            present(alert, animated: true)
           
        }
    }
}

