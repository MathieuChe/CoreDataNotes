//
//  ColorViewController.swift
//  Notes
//
//  Created by Mathieu CHELIM on 04/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

protocol ColorViewControllerDelegate {

    func controller(_ controller: ColorViewController, didPick color: UIColor)

}

class ColorViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var greenSlider: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    
    // MARK: -
    var delegate: ColorViewControllerDelegate?

    // MARK: -
    var color: UIColor = .bitterSweet()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Choose Color"

        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Notify Delegate
        delegate?.controller(self, didPick: (colorView.backgroundColor ?? .white))
    }

    // MARK: - View Methods
    fileprivate func setupView() {
        setupSliders()
        setupColorView()
    }
    
    // MARK: -
    private func setupSliders() {
        // Helpers
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0

        // Extract Components
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        // Configure Sliders
        redSlider.value = Float(r)
        blueSlider.value = Float(g)
        greenSlider.value = Float(b)
    }

    private func setupColorView() {
        // Configure Layer Color View
        colorView.layer.cornerRadius = CGFloat(colorView.frame.height / 2.0)

        updateColorView()
    }
    
    private func updateColorView() {
        // Create Color
        let color = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)

        // Configure Color View
        colorView.backgroundColor = color
    }
    
    // MARK: - Actions
    @IBAction func colorDidChange(sender: UISlider) {
        // Update View
        updateColorView()
    }

}
