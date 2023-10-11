//
//  ViewController.swift
//  customPulltoRefresh
//
//  Created by Imcrinox Mac on 19/12/1444 AH.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var demoTable: UITableView!
   
    var refreshControler : UIRefreshControl!
    var customerView: UIView!
    var LblArray: Array<UILabel> = []
    var isAnimating = false
    var currentColorIndex = 0
    var currentLblIndex = 0
    var timer: Timer!
    var dataaArray: Array<String> = ["𝖒","𝖔","𝖍","𝖆","𝖓"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        demoTable.delegate = self
        demoTable.dataSource = self
        refreshControler = UIRefreshControl()
        refreshControler.backgroundColor = UIColor.clear
        refreshControler.tintColor = UIColor.clear
        demoTable.addSubview(refreshControler)
        
        loadcustomRefreshContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadcustomRefreshContents() {
        let refreshContnets = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customerView = refreshContnets![0] as? UIView
        customerView.frame = refreshControler.bounds
        
        for i in 0..<customerView.subviews.count {
            LblArray.append(customerView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControler.addSubview(customerView)
    }

    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.LblArray[self.currentLblIndex].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            self.LblArray[self.currentLblIndex].textColor = self.getNextColor()
        }, completion: { _ in
            UIView.animate(withDuration: 0.05,delay: 0.0,options: .curveLinear, animations: {
                self.LblArray[self.currentLblIndex].transform = .identity
                self.LblArray[self.currentLblIndex].textColor = UIColor.black
            },completion: { _ in
            self.currentLblIndex += 1
            if self.currentLblIndex < self.LblArray.count {
                self.animateRefreshStep1()
            }
            else {
                self.animateRefreshStep2()
            }
        })
    })
        
    }
    
    
    func animateRefreshStep2() {
        UIView.animate(withDuration: 0.40, delay: 0.0,options: .curveLinear, animations: {
            let scale = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.LblArray[1].transform = scale
            self.LblArray[2].transform = scale
            self.LblArray[3].transform = scale
            self.LblArray[4].transform = scale
            self.LblArray[5].transform = scale
            self.LblArray[6].transform = scale
            self.LblArray[7].transform = scale
            self.LblArray[8].transform = scale
            self.LblArray[9].transform = scale
            self.LblArray[10].transform = scale
            self.LblArray[11].transform = scale
//            self.LblArray[12].transform = scale
//            self.LblArray[13].transform = scale

        }, completion: { _ in
            UIView.animate(withDuration: 0.25,delay: 0.0,options: .curveLinear, animations: {
                self.LblArray[1].transform = .identity
                self.LblArray[2].transform = .identity
                self.LblArray[3].transform = .identity
                self.LblArray[4].transform = .identity
                self.LblArray[5].transform = .identity
                self.LblArray[6].transform = .identity
                self.LblArray[7].transform = .identity
                self.LblArray[8].transform = .identity
                self.LblArray[9].transform = .identity
                self.LblArray[10].transform = .identity
                self.LblArray[11].transform = .identity
//                self.LblArray[12].transform = .identity
//                self.LblArray[13].transform = .identity
            }, completion: { _ in
                if self.refreshControler.isRefreshing {
                    self.currentLblIndex = 0
                    self.animateRefreshStep1()
                }
                else {
                    self.isAnimating = false
                    self.currentLblIndex = 0
                    for i in 0..<self.LblArray.count {
                        self.LblArray[i].textColor = UIColor.black
                        self.LblArray[i].transform = .identity
                    }
                }
            })
        } )
    }
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [.magenta, .brown, .yellow,
                                           .red, .green, .blue, .orange]
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        return returnColor
    }
    
    func doSomething() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.endOfWork), userInfo: nil, repeats: true)
    }
    
    @objc func endOfWork() {
        refreshControler.endRefreshing()
        timer.invalidate()
        timer = nil
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControler.isRefreshing {
            if isAnimating {
                doSomething()
                animateRefreshStep1()
            }
        }
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = dataaArray[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Apple Color Emoji", size: 40)
        cell.textLabel!.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
