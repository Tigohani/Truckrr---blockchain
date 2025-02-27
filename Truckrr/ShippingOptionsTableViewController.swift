//
//  ShippingOptionsTableViewController.swift
//  Truckrr
//
//  Created by Drew Patel on 4/14/18.
//  Copyright © 2018 Drew Patel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class MasterViewControllerCell: UITableViewCell{
    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionBox: UILabel!
    @IBOutlet weak var price: UILabel!
    
}

class Shipper {
    
    var email: String!
    var name: String!
    var price: Double!
    var length: Double!
    var width: Double!
    var height: Double!
    var totalArea: Double!
    var pricePerUnit: Double!
    var rating: String!
    init (value: JSON) {
        let json = JSON(value)
        print(json)
        email = json["email"].string
        name = json["name"].string
        price = json["Price"].double
        length = json["length"].double
        width = json["width"].double
        height = json["height"].double
        rating = json["Rating"].string
        let totalArea = ((length * width) * height!)
        let pricePerUnit = price/totalArea
        
    }
    
}


class ShippingOptionsTableViewController: UITableViewController {

    var shipmentId: Int!
    var length: Double!
    var width: Double!
    var height: Double!
    
    var shippers = [Shipper]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://138.68.233.59:3000/api/Truck").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                for (key,subJson):(String, JSON) in json {
                    self.shippers.append(Shipper(value: subJson))
                    print(self.shippers[0].name)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the segue that triggered the function is the one to the detailed view controller
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {

                let item = self.shippers[indexPath.row]
                //create a reference to the detail view controller
                let controller = (segue.destination as! UINavigationController).topViewController as! detailViewController
                //set all the variables of detailview controller
                controller.shipperName = item.name
                controller.shipperEmail = item.email
                controller.shipmentId = shipmentId
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shippers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MasterViewControllerCell
        cell.title.text = shippers[indexPath.row].name
        cell.price.text = String(shippers[indexPath.row].price)
        cell.descriptionBox.text = "Rating: \(shippers[indexPath.row].rating!)"
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
