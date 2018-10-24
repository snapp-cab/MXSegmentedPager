//
//  ViewSegmentControll.swift
//  MXSegmentedPager
//
//  Created by farhad jebelli on 6/17/18.
//  Copyright © 2018 maxep. All rights reserved.
//

import UIKit

@objc open class ViewSegmentControl: UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var indicatorColor:[UIColor]?
    var indicatorHeigth: CGFloat = 0
    @objc open var selectedSegmentIndex:Int = 0 {
        didSet{
            for (index,view) in tabViews?.enumerated() ?? [].enumerated(){
                if(index != selectedSegmentIndex){
                    view.segmentViewIsSelected = false
                }else {
                    view.segmentViewIsSelected = true
                }
            }
        }
    }
    var tabViews:[SegmentedView]? {
        didSet{
            for (index,view) in tabViews?.enumerated() ?? [].enumerated(){
                if(index != selectedSegmentIndex){
                    view.segmentViewIsSelected = false
                }else {
                    view.segmentViewIsSelected = true
                }
            }
        }
    }
    var indicator:UIView?
    var indicatorLeading: NSLayoutConstraint?
    
    
    
    @objc open func setViews(_ views: [SegmentedView],heigth: CGFloat,selectedSegmentIndex: Int){
        for view in tabViews ?? [] {
            view.removeFromSuperview()
        }
        
        self.tabViews = views
        self.selectedSegmentIndex = selectedSegmentIndex
        indicatorHeigth = heigth
        views.forEach(addSubview(_:))
        for (offset,view) in views.enumerated() {
            view.index = offset
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leftAnchor.constraint(equalTo: { () -> NSLayoutXAxisAnchor in if offset == 0 {return self.leftAnchor} else {return views[offset-1].rightAnchor}}()).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -indicatorHeigth).isActive = true
            if offset == views.count-1 {
                view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            }else {
                view.widthAnchor.constraint(equalTo: views[views.count-1].widthAnchor).isActive = true
            }
            view.addTarget(self, action: #selector(pageSelected), for: UIControl.Event.touchUpInside)
            
        }
        
        if views.count > 0 {
            if indicator == nil {
                indicator = UIView();
                addSubview(indicator!)
            }
            indicator?.backgroundColor = indicatorColor?[selectedSegmentIndex] ?? UIColor.black
            indicator?.translatesAutoresizingMaskIntoConstraints = false
            
            indicator?.heightAnchor.constraint(equalToConstant: indicatorHeigth).isActive = true
            indicator?.widthAnchor.constraint(equalTo: views[0].widthAnchor).isActive = true
            indicator?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            indicatorLeading = indicator?.leftAnchor.constraint(equalTo: tabViews![selectedSegmentIndex].leftAnchor)
            indicatorLeading?.isActive = true


        }

        
    }
    
    @objc open func setIndocatorColor(colors: [UIColor]){
        self.indicatorColor = colors
        indicator?.backgroundColor = colors[selectedSegmentIndex % colors.count];
    }
    
    
    @objc func pageSelected(control: SegmentedView){
        selectedSegmentIndex = control.index!
        sendActions(for: .valueChanged);
    }
    
    @objc func setSelectedPage(index: Int){
        selectedSegmentIndex = index
        sendActions(for: .valueChanged)
    }
    
    @objc open func setSelectedSegmentIndex(_ index: Int, animated: Bool){

        
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {[unowned self] in
        self.indicatorLeading?.isActive = false
        self.indicator?.removeConstraint(self.indicatorLeading!)
        self.indicatorLeading = self.indicator?.leftAnchor.constraint(equalTo: self.tabViews![index].leftAnchor)
        self.indicatorLeading!.isActive = true
        self.selectedSegmentIndex = index
        self.indicator?.backgroundColor = self.indicatorColor?[index]
        self.layoutIfNeeded()
        })
        
    }
    
    
    
    
    

}
