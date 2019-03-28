//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework //(24)

class ChatViewController: UIViewController, /*(1)*/UITableViewDelegate, UITableViewDataSource, /*(9)*/UITextFieldDelegate
    
    //(1)
    // for UITableViewDelegate protocol I am saying this class is going to be delegat of TableView so eveything happining such is (the cell is clicked or page is swipped) in tableView so this class will be notified, so The ChatViewController will handele everything happining in tableViewController
    // and for UITableViewDataSource I am saying the ChatViewController will be responsible for serving the data that's going to be displayed in tableViewController
    //(9) everything occure in the TextField will notify this class to it , and this class will respnsile for it.
{
   
    
    
    // Declare instance variables here
    //(16)
    var messgaeArray = [Message]()
   

    
    // We've pre-linked the IBOutlets
    ////////////////////////////////////////////(1)
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        //(2)
        messageTableView.delegate = self // not only adopt the protocol but you have to set the class in viewDidLoad as delegate
        messageTableView.dataSource = self // the same above
        
        
        //TODO: Set yourself as the delegate of the text field here:
        //(10)
        messageTextfield.delegate = self

        
        
        //TODO: Set the tapGesture here:
        //(13)
        //In this method we are saying when the user tapped any where on messageTableView this method will triggered, then I will do an action which is keyboard diabled
        // and now go to the next step which is (14)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture) //we have to register it
        

        //TODO: Register your MessageCell.xib file here:
        // in this method we have to register the custom design cell that we are created
        //(4)
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        //nib is the same like xib(Zip) file
        //bundle: nil because I haven't put the path for custom design file the xcode smart and will know where it is
        //forCellReuseIdentifier you will find it in MessageCell.xib idetifire

        
        //(18)
        //then run your app and see what happining 
        retriveMessages()
        
        //(22) now the table view controller is seperated by lines, so now we want it without lines like every messenger app.
        messageTableView.separatorStyle = .none
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here: just write cellForRowAtIndexPath and the completion will appear
    //(3)
    // here we are going to provide the cells that are going to be displayed in the tableView
    //this method called for every single cell that exist inside the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        //because we are using our own custom cell so we have to spicify it its own class which is CustomMessageCell, so each cell wiil be an object from CustomMessageCell
       //indexPath is location or index of cell
       //(5) for testing purpose
        
//        let arrayMessage = ["message 1", "message 2", "message 3"]
//        cell.messageBody.text = arrayMessage[indexPath.row]
        
        //(20) to print out the certain message text in messageArray
        cell.messageBody.text = messgaeArray[indexPath.row].messageBody
        cell.senderUsername.text = messgaeArray[indexPath.row].sender
        //and now we want to put profile image
        cell.avatarImageView.image = UIImage(named: "egg")
        configureTableView()
        
        //(23)Now we want to know who is sender because we want to make it diffrent between user to another (make the color diffrent ...)
        //because we xcode don't know currentUser data type we have to cast it into String 'as' String!
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            //Using Chameleann Framework that contains greate colors to your app
            // here we open chameleon framewok in github to see what it is and what are the colors that includes
            // you have first to import ChameleonFramework
            cell.avatarImageView.backgroundColor = UIColor.flatMint() //this is for an egg background image
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()// this is for message text background
        }
        else { //Here if we didn't send the message
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell //we have to output that cell
        
       
        
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    //(6)
    //how many cell you want in the tableView and that is second required which is UITableViewDataSource, you have to spicify how many cell you want in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //(21)
        //Then run your app!
        return messgaeArray.count //we write it automatically instead of write it hard coded
    }
    
    
    
    //TODO: Declare tableViewTapped here:
    //(14)
    @objc func tableViewTapped() {
        
        messageTextfield.endEditing(true) //so this method will call textFieldDidEndEditing, so we finish endEditing
    }
    
    
    
    //TODO: Declare configureTableView here:
    //(7)
    // making the cell as large as needs to be in order to fit all the content(text message) that's contained 
    // if the user write a lot in the cell then the cell will fit to apprpriate size
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0 // that enough for message
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    //These are not required methods it optional because when we cilck on text field and the keyboard appeared textfield should be with appropriate size
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    //(11)
    //this will triggered when some activity is deticted inside the textfield i.e. user beggining type in textfield
    //IMPORTANT: textfield hight constraint is 50 pt , and the iphone keyboard is 258 pt hight
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
      
        
        
        //optional way if we want something preaty is making animation when the keyboard appear
        //you can change animate duration
        UIView.animate(withDuration: 0.2, animations: {
            
            self.heightConstraint.constant = 308
            //50 + 258
            // and now if you run your app nothing will change even you tap on textfield because you need to update constriant which is view.layoutIfNeeded()
            // note : because we are in the closure we have to write self key word
            
            self.view.layoutIfNeeded()
            //ifneeded that means if something change i.e constriant redraw the hall thing
            
            })
       
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    //(12)
    //this method will not triggered automatically like beginEditing but you need to call it manually so we will use (13) tappedGesture
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
            
            
            })
        
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    //(15)
    // in this method we are going to send what the message inside the textfield to Firebase database
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true) //in here there is another way to endediting which is when you press send button
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false //VERY IMPORTANT! this method will helps you to diabled the textfield from sending any new message while the message sending to the Firebase database
        sendButton.isEnabled = false //and here also
        
        // now we are creating a messages database inside Firebase database
        let messageDB = Database.database().reference().child("messages")
        // we used th child method (.child("messages")) to create new child database inside a main database, and we gave it a name which is messages
        // so when the button clicked we will create a new child database from of main database
        // and it similar like an object to this array which is here "Messgaes"
        
        
        
        // and now we will save user message in the dectionary
        // and that the information that want to save it in the firebase database
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email , "MessageBody" : messageTextfield.text!]
        
        
        //to create a custom random key for a message, so the messages can be saved under there own unique identifire then add message dictionary to it.
        // this method has a clusore.
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully")
                
                //and now the textfield and send button unclickable so we need to make them clickable
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                // also we need to reset the textfield to write a new messgae
                self.messageTextfield.text = ""
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    //(17)
    // In this method we will retrive the data that stored in Firebase database into our app
    func retriveMessages(){
        
        let messagesDB = Database.database().reference().child("messages")
        //It is reference to the "messages" database
        //sender and reterive method should be referenced from the same name of the database which is "messages"
        
        
        //here we will ask the firebase to keep tracking for any new data being added to the "messages" database
        //we are saying that when there is a new event i.e message was added to the database then we want to grab the result of the database
        messagesDB.observe(.childAdded) { (snapshot) in
            // in here we will grab the data inside this snapshot and format it into a custom message object, so it is gonna has a sender and messageBody. So this closure will called whenever a new item has been added to the messages database and it returns a snapshot i.e snapshot of the database
            
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            //because the value of type any so we have to converte it to something known and something we will using which is [String : String] , and we put as! that keyword is to convert the value to different data tye
            
            let text = snapshotValue["MessageBody"]! //it must the same key name with sender method
            let sender = snapshotValue["Sender"]!
            
            //and now we will call retriveMessages() in viewDidLoad()
            
            print(text , sender) // inteade of printing the text and sender we have to save it to message DB
            
            //(19)
            //So now we want to store message and sender into messageArray.
            //This array is going to contain all messages in flatchat
            let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messgaeArray.append(message)
            
            //so now we need to call
            self.configureTableView()
            // and we need to reload data after we added it
            self.messageTableView.reloadData()
            
            
        }
        
        
        //.childAdded we are saying if any thing added to the "messages" DB
        // we change the name of parameter to snapshot
        
        
    }
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        ////////////////////////////////////////////(2)
        do {
        try Auth.auth().signOut() // to sign out
        navigationController?.popToRootViewController(animated: true) //take the user from chat view to root view (main view)
            
        }
        catch {
        print("error signing out")
        }
        
    }
    
    


}
