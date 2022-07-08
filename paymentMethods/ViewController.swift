import UIKit
import Firebase
import FirebaseAuth



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var CreditCard = [String]()
    var dID = ""
    let db = Firestore.firestore()
    //create a uitableview
    
    
    //MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadTable()
    }
    
    //MARK: Tableview

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreditCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = CreditCard[indexPath.row]
    }
    
    //MARK: Actions
    
    @IBAction func removeItemButtom(_ sender: Any) {
       
    }
    
    //write
    @IBAction func buttonView(_ sender: Any) {
        addDocument()
        //CreditCard.append("Paul Smith: 01234556789")
       
    }
    
    @IBAction func removeButton(_ sender: Any) {
        
    }
    
    //MARK: DB Access
    
    func DBRef() -> CollectionReference {
        return db.collection("CreditCard")
    }
    
    func addDocument() {
        self.DBRef().addDocument(data:
                                    ["CardNumber": "Paul Smith: 01234556789"]
        ) {
            err in
                if let err = err {
                    print("error adding documents: \(err)")
                } else {
                    print("Document successfully added!")
                    
                    self.CreditCard.append("Paul Smith: 01234556789")
                    self.tableView.reloadData()
                    
                }
            // update local datamodel
            // update UI
        }
    }
    
    //delete
    @IBAction func removeItemButtonOld(_ sender: Any) {
        db.collection("CreditCard").document(dID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.reloadTable()
            }
        }
        
    }
    
    //write
    @IBAction func buttonViewOld(_ sender: Any) {
        //var ref: DocumentReference? = nil
        //adding the item to the database
        //ref = db.collection("CreditCard").addDocument(data: [
        //                                               "CardNumber": "Paul Smith: 01234556789",
        //]) { err in
        //    if let err = err {
        //        print("error adding documents: \(err)")
        //    } else {
        //        print("Document added with ID: \(ref!.documentID)")
        //        self.reloadTable()
        //    }
        //}
        addDocument()
        
    }
    
    @IBAction func removeButtonOld(_ sender: Any) {
        deleteTable()
    }
    
    func reloadTable() {
        //CreditCard = [String]()
        
        //read
        db.collection("CreditCard").order(by: "CardNumber").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("error getting documents: \(err)")
            } else {
                self.CreditCard.removeAll()
                for document in QuerySnapshot!.documents {
                    if let CardNumber = document.data()["CardNumber"] as? String {
                        self.CreditCard.append(CardNumber)
                        self.dID = document.documentID
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Hoppa
    
    func deleteTable() {
        //CreditCard = [String]()
        
         
        db.collection("CreditCard").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("error getting documents: \(err)")
            } else {
                self.CreditCard.removeAll()
                for document in QuerySnapshot!.documents {
                    if let uniqueID = document.documentID as? String {
                        self.db.collection("CreditCard").document(uniqueID).delete()
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

