//
//  DCArticleCell.swift
//  Delicacy
//
//  Created by Youwei Teng on 9/5/15.
//  Copyright © 2015 Dcard. All rights reserved.
//

import UIKit
import SDWebImage


class DCArticleCell: UITableViewCell {
	
	let kArticleCellTitleHeight: Float = 70
	let kCoverPhotoParallaxHeight: Float = 30
	
	//UI
	let coverImageView: UIImageView = UIImageView()
	let genderImageView: UIImageView = UIImageView()
	let titleLabel: UILabel = UILabel()
	let descriptionLabel: UILabel = UILabel()
	let schoolLabel: UILabel = UILabel()
	let visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
	var vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Light)))
	let blurTitleBackground: UIView = UIView()
	let loadingImageArray: Array = [UIImage(named: "milk"),UIImage(named: "meal"),UIImage(named: "coffee"),UIImage(named: "hot_dog")]
	
	var didSetUpContraints: Bool = false
	
	var article: DCArticle? {
		didSet {
			self.article?.loadContent { () -> Void in
				
				let placeholder: UIImage = self.loadingImageArray[Int.random(0...self.loadingImageArray.count - 1)]!
				
				if((self.article?.coverPhotoUrl) != nil) {
					self.coverImageView.contentMode = .Center
					self.coverImageView.sd_setImageWithURL(self.article?.coverPhotoUrl!, placeholderImage: placeholder, options: .LowPriority, progress: { (receivedSize: Int, expectedSize: Int) -> Void in
						self.coverImageView.alpha = CGFloat(receivedSize) / CGFloat(expectedSize)
					}, completed: { _, _, _, _  in
						self.coverImageView.alpha = 1
						self.coverImageView.contentMode = .ScaleAspectFill
					})
					
				} else {
					//no containts imgur url
					self.coverImageView.contentMode = .Center
					self.coverImageView.alpha = 1
					self.coverImageView.image = placeholder
					self.titleLabel.text = self.article?.content
				}
			}
			self.titleLabel.text = self.article?.title
			self.descriptionLabel.text = self.article?.content
			self.genderImageView.image = self.genderImage
		}
	}
	
	override func prepareForReuse() {
		//TODO: cancel download queue
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.coverImageView.translatesAutoresizingMaskIntoConstraints = false
		self.coverImageView.image = UIImage(named: "test")
		self.coverImageView.contentMode = .ScaleAspectFill
		self.coverImageView.layer.masksToBounds = true
		self.coverImageView.tintColor = UIColor.whiteColor()
		self.coverImageView.clipsToBounds = true
		self.contentView.addSubview(self.coverImageView)
		
		self.blurTitleBackground.translatesAutoresizingMaskIntoConstraints = false
		self.blurTitleBackground.backgroundColor = UIColor.clearColor()
		self.contentView.addSubview(self.blurTitleBackground)
		
		self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		self.blurTitleBackground.addSubview(self.visualEffectView)
		
		self.vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		self.titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		self.descriptionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
		
		self.vibrancyEffectView.contentView.addSubview(self.titleLabel)
		self.vibrancyEffectView.contentView.addSubview(self.descriptionLabel)
		
		self.visualEffectView.contentView.addSubview(self.vibrancyEffectView)
		
		self.genderImageView.translatesAutoresizingMaskIntoConstraints = false
		self.genderImageView.image = UIImage(named: "ic_head_anon")
		self.contentView.addSubview(self.genderImageView)
		
		self.selectionStyle = .None
		self.contentView.backgroundColor = UIColor.blackColor()
		self.layer.masksToBounds = true
		self.contentView.clipsToBounds = true
		
		//set the tableview separator to full width
		self.preservesSuperviewLayoutMargins = false
		self.layoutMargins = UIEdgeInsetsZero
		self.separatorInset = UIEdgeInsetsZero
		
		//update contraints
		self.contentView.setNeedsUpdateConstraints()
	}
	
	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
	}
	
	override func updateConstraints() {
		if !didSetUpContraints {
			self.coverImageView.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.contentView)
				make.right.equalTo(self.contentView)
				make.bottom.equalTo(self.contentView).offset(kCoverPhotoParallaxHeight/2)
				make.top.equalTo(self.contentView).offset(-kCoverPhotoParallaxHeight/2)
			}
			self.blurTitleBackground.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.contentView)
				make.right.equalTo(self.contentView)
				make.bottom.equalTo(self.contentView)
				make.height.equalTo(kArticleCellTitleHeight)
			}
			self.descriptionLabel.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.genderImageView.snp_right).offset(10)
				make.right.equalTo(self.contentView).offset(-25)
				make.height.equalTo(20)
				make.bottom.equalTo(self.blurTitleBackground.snp_bottom).offset(-10)
			}
			self.titleLabel.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.genderImageView.snp_right).offset(10)
				make.right.equalTo(self.contentView).offset(-25)
				make.top.equalTo(self.blurTitleBackground).offset(8)
				make.height.equalTo(30)
			}
			self.visualEffectView.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.blurTitleBackground)
			}
			self.vibrancyEffectView.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.blurTitleBackground)
			}
			self.genderImageView.snp_makeConstraints { (make) -> Void in
				let imageSize: CGFloat = 35
				make.size.equalTo(CGSize(width: imageSize,height: imageSize))
				make.left.equalTo(self.contentView).offset(15)
				make.centerY.equalTo(blurTitleBackground)
			}
			self.didSetUpContraints = true
		}
		super.updateConstraints()
	}
	
// MARK - Private Methods
	
	var genderImage: UIImage {
		return (self.article?.gender == .Male ? UIImage(named: "ic_head_boy"):UIImage(named: "ic_head_girl"))!
	}
	
// MARK - Public Methods
	
	func applyParallax(ratio: Float) {
		self.coverImageView.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(ratio * kCoverPhotoParallaxHeight - kCoverPhotoParallaxHeight)
			make.bottom.equalTo(ratio * kCoverPhotoParallaxHeight + kCoverPhotoParallaxHeight)
		}
	}
	
}