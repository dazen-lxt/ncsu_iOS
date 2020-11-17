//
//  WeedSearchTextField.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/24/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class WeedSearchTextField: UITextField {
    
    let weedList = [
        "Nutsedge (yellow)",
        "Nutsedge (purple)",
        "Pigweed (redroot)",
        "Pigweed (tumble)",
        "Pigweed (spiny)",
        "Palmer amaranth",
        "Morningglory (ivyleaf)",
        "Morningglory (pitted)",
        "Morningglory (tall)",
        "Waterhemp (common)",
        "Waterhemp (tall)",
        "Common lambsquarters",
        "Ragweed (common)",
        "Ragweed (giant)",
        "Sicklepod",
        "Barnyardgrass",
        "Bermudagrass",
        "Crabgrass"
    ]
    
    var weedFilteredList: [String] = []

    
    var tableView: UITableView?
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.addTarget(self, action: #selector(WeedSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(WeedSearchTextField.textFieldDidEnd), for: .editingDidEnd)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
        
    }
    
   
    @objc open func textFieldDidChange(){
        print("Text changed ...")
        filter()
        updateSearchTableView()
        tableView?.isHidden = false
    }
    
    @objc open func textFieldDidEnd() {
        tableView?.isHidden = true
    }
       
    private func filter() {
        weedFilteredList = weedList.filter{ $0.lowercased().contains(self.text?.lowercased() ?? "") }
        weedFilteredList.append("Other: " + (self.text ?? ""))
    }
    
}

extension WeedSearchTextField: UITableViewDelegate, UITableViewDataSource {
    
    func buildSearchTableView() {
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WeedSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)

        } else {
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        updateSearchTableView()
    }
    
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weedFilteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeedSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = weedFilteredList[indexPath.row]
        cell.textLabel?.highlight(searchedText: self.text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row < weedFilteredList.count - 1) {
            self.text = weedFilteredList[indexPath.row]
        }
        self.endEditing(true)
    }
    
}
