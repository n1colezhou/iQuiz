//
//  QuizTableViewCell.swift
//  iQuiz
//
//  Created by Nicole Zhou on 5/5/25.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    static let identifier = "QuizTableViewCell"
    
    private let quizIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(quizIconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // Icon constraints
            quizIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quizIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quizIconImageView.widthAnchor.constraint(equalToConstant: 40),
            quizIconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Title constraints
            titleLabel.leadingAnchor.constraint(equalTo: quizIconImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Description constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: quizIconImageView.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with quiz: Quiz) {
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
        quizIconImageView.image = UIImage(systemName: quiz.iconName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quizIconImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}
