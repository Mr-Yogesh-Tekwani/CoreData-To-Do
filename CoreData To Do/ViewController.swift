//
//  ViewController.swift
//  CoreData To Do
//
//  Created by Dhiraj on 6/6/23.
//

import UIKit

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var allData = [ToDoTable]()
    
    let tableView : UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
    }()
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let titleLabel = UILabel(frame: .zero)
    let addItemButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data App"
        
        self.view.backgroundColor = .white
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(tableView)
        stack.addArrangedSubview(addItemButton)
        addItemButton.backgroundColor = .blue
        addItemButton.setTitle("Add", for: .normal)
        addItemButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        readAll()
        tableView.reloadData()
        
        self.view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        
    }
    
    @objc func addPressed(){
        print("Add Button pressed!!!!")
        let alert = UIAlertController(title: "Add New Item", message: "Enter New Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        let action = UIAlertAction(title: "Submit", style: .default) { action in
            guard let textfields = alert.textFields?.first, let todoListItemString = textfields.text else {
                return
            }
            DispatchQueue.main.async {
                self.createNewItem(name: todoListItemString)
                self.readAll()
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    // Core Data Code
    
    func readAll(){
        do{
            allData = try  context.fetch(ToDoTable.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch{
            print(error)
        }
    }
    
    
    func createNewItem(name: String){
        let newItem = ToDoTable(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.done = false
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteItem(item: ToDoTable){
        context.delete(item)
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateItem(item: ToDoTable, doneUpdate: Bool){
        item.done = doneUpdate
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
}



extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if allData[indexPath.row].done {
            readAll()
            cell.backgroundColor = .green
        }
        cell.textLabel?.text = allData[indexPath.row].name
        return cell
    }
}

// Delegate to show green done
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if allData[indexPath.row].done {
                cell.contentView.backgroundColor = UIColor.white
                updateItem(item: allData[indexPath.row], doneUpdate: false)
                
            }
            else {
                cell.contentView.backgroundColor = UIColor.green
                updateItem(item: allData[indexPath.row], doneUpdate: true)
                
            }
        }
    }
    
    // Swipe to Delete
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(item: allData[indexPath.row])
            readAll()
            tableView.reloadData()
        }
    }
    
}
