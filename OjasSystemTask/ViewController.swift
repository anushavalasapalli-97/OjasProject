//
//  ViewController.swift
//  OjasSystemTask
//
//  Created by Mouritech on 15/06/20.
//  Copyright © 2020 Mouritech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var tableVwDetails: UITableView!
    var dictDetails = NSDictionary()
    var dictMeta = NSDictionary()
    var dictView = NSDictionary()
    var aryColumns = NSArray()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableVwDetails.reloadData()
        self.apiCall()
        self.tableVwDetails.delegate = self
        self.tableVwDetails.reloadData()
        self.tableVwDetails.separatorStyle = .singleLine
        if #available(iOS 10.0, *) {
            tableVwDetails.refreshControl = refreshControl
        } else {
            tableVwDetails.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)

        }
    @objc private func refreshTableData(_ sender: Any) {
        // Fetch Weather Data
        apiCall()
    }
    
    func apiCall() {
        let url = URL(string: "https://data.hawaii.gov/api/views/usep-nua7/rows.json?accessType=DOWNLOAD")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                  print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }
          if let data = data {
              do{
              let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
              //print ("dataANUSHA = \(jsonResponse)")
                  
              self.dictDetails = jsonResponse as! NSDictionary
              //print ("DataResponse", self.dictDetails)
                  
              self.dictMeta = self.dictDetails.value(forKey: "meta") as! NSDictionary
             // print ("MetaDataResponse", self.dictMeta)
                  
              self.dictView  =  self.dictMeta.value(forKey: "view") as! NSDictionary
             // print("dictView:%@", self.dictView)
              self.aryColumns = self.dictView.value(forKey: "columns") as! NSArray
              print("aryColumns:%@", self.aryColumns)
              print("aryColumnsCount:%@", self.aryColumns.count)
                DispatchQueue.main.async {
                    self.tableVwDetails.reloadData()
                    self.refreshControl.endRefreshing()
                   // self.activityIndicatorView.stopAnimating()
                }
              }catch _ {
              print ("OOps not good JSON formatted response")
              }
              }

        
          
          
        })
        self.tableVwDetails.reloadData()

        task.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryColumns.count
         
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:DetailsTableViewCell = tableVwDetails.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailsTableViewCell
        let dict:NSDictionary = aryColumns[indexPath.row] as! NSDictionary
        print("tableVwDict:%@", dict)
        cell.lblName.text =  dict.value(forKey: "name") as? String
        cell.lblFieldName.text = dict.value(forKey: "fieldName") as? String
        //cell.lblPosition.text = NSNumber(dict.value(forKey: "position"))
        
        if let pos = dict.value(forKey: "position") as? Int {
            cell.lblPosition.text =  String(pos)
        }
        
        
        cell.switchOperator.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        cell.switchOperator.tag = indexPath.row

      
        return cell
        
         
     }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    
   }
    @objc func switchValueDidChange(_ sender: UISwitch) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableVwDetails.cellForRow(at: indexPath)
                if (sender.isOn == true){
                    
                   // sender.tag = 1
                    print("on")
                    cell?.layer.backgroundColor = UIColor.red.cgColor

                }
                else{
                   // sender.tag = 0
                    print("off")
                    cell?.layer.backgroundColor = UIColor.white.cgColor
                }
    
    }
    

    
    }




