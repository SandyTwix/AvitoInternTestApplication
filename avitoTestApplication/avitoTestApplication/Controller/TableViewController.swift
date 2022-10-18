import UIKit

class TableViewController: UITableViewController {

    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "employee")
        AvitoParser()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let employee = employees[indexPath.row]
        
        cell.nameLabel.text = "\(employee.name)"
        cell.phoneLabel.text = "\(employee.phone_number)"
        cell.skillsLabel.text = "\(employee.skills.joined(separator: ", "))"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension TableViewController{
    private func AvitoParser(){
        let networkManager = NetworkManager()
        networkManager.AvitoJSON { result in
            switch result {
            case .success(let data):
                self.employees = data.company.employees
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.title = data.company.name
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
