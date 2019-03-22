//
//  WorkoutDetailTableViewCell.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/21/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class WorkoutDetailTableViewCell: UITableViewCell {
    
    var workout: Workout? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: WorkoutDetailTableViewCellDelegate?

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateViews() {
        guard let workout = workout else { return }
        self.activityLabel.text = workout.activity
        self.durationLabel.text = "\(workout.duration)"
        self.dateLabel.text = "\(workout.end.day)/\(workout.end.day)"
    }
}

protocol WorkoutDetailTableViewCellDelegate: class {
}
