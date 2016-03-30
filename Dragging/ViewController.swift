//
//  ViewController.swift
//  Dragging
//
//  Created by Marco Linhares on 8/23/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var xFromCenter : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // o valor do centro é subtraído da metade da largura ou altura para ficar
        // centralizado
        let label: UILabel = UILabel (frame: CGRectMake(self.view.bounds.width / 2 - 100, self.view.bounds.height / 2 - 50, 200, 100))
        
        label.text = "Drag me!"
        label.textAlignment = NSTextAlignment.Center

        label.font = label.font.fontWithSize (30)
        
        self.view.addSubview(label)
        
        // cria uma pan gesture (pra poder mexer a label na tela) e ao ser clicada,
        // será chamada a função wasDragged
        // note os : depois do nome da função. ele serve para passar parâmetros.
        // sem ele, é apenas chamada a função sem passar nada.
        let gesture = UIPanGestureRecognizer (target: self, action: Selector ("wasDragged:"))
        
        // adiciona o gesture à label
        label.addGestureRecognizer (gesture)
        
        // para o user poder interagir com o usuário
        // para botões, não precisa, mas para labels, sim!
        label.userInteractionEnabled = true
    }

    func wasDragged (gesture: UIPanGestureRecognizer) {
        
        // retorna o movimento que foi feito
        let translation = gesture.translationInView (self.view)
        
        // é o gesture que foi passado por parâmetro. no caso, a view será a própria
        // label
        let label = gesture.view!

        xFromCenter += translation.x
        
        let scale = min (100 / abs (xFromCenter), 1)
        
        label.center = CGPoint (x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        // zera novamente a translação para que não seja usado o valor acumulado feito
        // anteriormente
        gesture.setTranslation (CGPointZero, inView: self.view)

        // rotaciona em radianos (1 rad = 60 graus aproximadamente)
        var rotation : CGAffineTransform = CGAffineTransformMakeRotation (xFromCenter / 200)

        var stretch : CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        if label.center.x < 100 {
            print ("not chosen")
        } else if label.center.x > self.view.bounds.width - 100 {
            print ("chosen")
        }
        
        // quando o usuário solta o objeto, os valores são resetados
        if gesture.state == UIGestureRecognizerState.Ended {

            label.center = CGPointMake (self.view.bounds.width / 2, self.view.bounds.height / 2)
            
            xFromCenter = 0
            
            rotation = CGAffineTransformMakeRotation (0)
            
            stretch = CGAffineTransformScale (rotation, 1, 1)
            
            label.transform = stretch
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

