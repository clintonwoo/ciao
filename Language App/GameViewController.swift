//
//  ViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 6/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


class GameViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var gameButton1: UIButton!
    @IBOutlet weak var gameButton2: UIButton!
    @IBOutlet weak var gameButton3: UIButton!
    @IBOutlet weak var gameButton4: UIButton!
    @IBOutlet var gameButtonCollection: [GameButton]!
    @IBOutlet weak var soundButton: UIBarButtonItem!
    
    //MARK: Properties
//  var managedObjectContext: NSManagedObjectContext? = nil
    var streak: Int = 0
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var words: [String] = ["Hi","Bye","Sorry","Thanks","Good morning","Good afternoon","Good evening","Good night","Apple","Orange","Banana","Dog","Cat","Cow","Sheep","Computer","Phone","I love you","How are you?","Good","Bad","Happy","Sad","You","Me","Mum","Head","Arm","Hand","Foot","Shoulder","Elbow","Knee","Ankle","Leg","Dad","Brother","Sister","Grandfather","Grandmother","Wallet","Money","Bag","Shirt","Pants","Socks","Shoes","Hat","Flower","Tree","Plant","Animal","Where","How","Why","When","What","Park","Water","Juice","Left","Right","North","South","East","West","Bandage","Like","Find","Copy","Paste","Key","Lock","Table","Chair","Couch","Television","Tissue","Mop","Bucket","Glass","Cup","Drink","Eat","Go","Garbage","Bin","Fridge","Freezer","Cold","Hot","Toilet","Shower","Bath","Door","And","Is","Are","They","He","She","Him","Her","His","Her's","Cousin","Aunty","Uncle","Card","Cash","Coin","Grass","Floor","Carpet","Power","Strong","Weak","Car","Bicycle","Truck","Plane","Seat","Sky","Sea","Ocean","Fish","Bottle","Pan","Knife","Fork","Spoon","Pot","Kettle","Tea","Coffee","Meat","Fruit","Vegetable","Case","Suit","Dress","Skirt","Stockings","Boots","Onion","Tomato","Bread","Toast","Jam","Light","Dark","White","Black","Blue","Green","Red","Orange","Purple","Grey","Fire","Yellow","Beach","Travel","Drive","Ride","Bus","Train","Mobile Phone","Call","City","Country","State","Man","Woman","Boy","Girl","The","Towel","Blanket","Warm","Cosy","Comfortable","Class","Teacher","Student","Coach","Learn","Smile","Face","Hair","Smell","Taste","Sweet","Sour","Spicy","Salt","Pepper","Oil","Spray","Jacket","Plastic","Wireless","Help","Battery","Medicine","Milk","Cereal","Breakfast","Lunch","Dinner","Exercise","Sport","Cook","Chocolate","Can","Gym","Walk","Run","Switch","Math","Science","Club","Nightclub","Friend","Food","Speaker","Talk","Had","Alcohol","Soap","Shampoo","Conditioner","Soft","Hard","Sponge","Roof","House","Home","Rent","Buy","Sauce","Ketchup","Pasta","Small","Big","Sugar","Bed","Sleep","Night","Day","Morning","Evening","Question","Answer","Top","Bottom"]
    var answers: [String] = ["Ciao","Arrivederci","Scusate","Grazie","Buongiorno","Buon pomeriggio","Buonasera","Buonanotte","Mela","Arancione","Banana","Cane","Gatto","Mucca","Pecora","Computer","Telefono","Ti amo","Come stai?","Buono","Male","Felice","Triste","Voi","Me","Mamma","Testa","Braccio","Mano","Piede","Spalla","Gomito","Ginocchio","Caviglia","Gamba","Papà","Fratello","Sorella","Nonno","Nonna","Portafoglio","Soldi","Borsa","Camicia","Pantaloni","Calze","Scarpe","Cappello","Fiore","Albero","Impianto","Animale","Dove","Come","Perché","Quando","Che Cosa","Parco","Acqua","Succo","Sinistra","Destra","A nord","Sud","Oriente","Occidente","Benda","Come","Trovare","Copia","Pasta","Chiave","Serratura","Tavolo","Sedia","Divano","Televisione","Tessuto","Scopa","Secchio","Vetro","Coppa","Bere","Mangiare","Andare","Spazzatura","Bidone","Frigorifero","Congelatore","Freddo","Caldo","Toilette","Doccia","Bagno","Porta","E","È","Sono","Essi","Lui","Lei","Lui","Suo","Suo","Le sue di","Cugino","Aunty","Zio","Carta","Contanti","Moneta","Erba","Piano","Tappeto","Potere","Forte","Debole","Auto","Bicicletta","Camion","Piano","Posto","Cielo","Mare","Oceano","Pesce","Bottiglia","Pan","Coltello","Forchetta","Cucchiaio","Pentola","Bollitore","Tè","Caffè","Carne","Frutta","Ortaggio","Caso","Tuta","Vestito","Gonna","Calze","Stivali","Cipolla","Pomodoro","Pane","Brindisi","Marmellata","Luce","Scuro","Bianco","Nero","Blu","Verde","Rosso","Arancione","Porpora","Grigio","Fuoco","Giallo","Spiaggia","Viaggi","Drive","Corsa","Autobus","Treno","Telefono Cellulare","Chiamata","Città","Paese","Stato","Uomo","Donna","Ragazzo","Ragazza","Il","Asciugamano","Coperta","Caldo","Cosy","Confortevole","Classe","Insegnante","Studente","Allenatore","Imparare","Sorriso","Faccia","Capelli","Odore","Gusto","Dolce","Aspro","Piccante","Sale","Pepe","Olio","Spray","Giacca","Plastica","Senza fili","Aiuto","Batteria","Medicina","Latte","Cereale","Colazione","Pranzo","Cena","Esercizio","Sport","Cuoco","Cioccolato","Lattina","Palestra","Passeggiata","Correre","Interruttore","Matematica","Scienza","Club","Locale notturno","Amico","Cibo","Altoparlante","Discorso","Aveva","Alcol","Sapone","Shampoo","Condizionatore","Morbido","Duro","Spugna","Tetto","Casa","Casa","Affitto","Acquistare","Salsa","Ketchup","Pasta","Piccolo","Grande","Zucchero","Letto","Sonno","Notte","Giorno","Mattina","Sera","Domanda","Risposta","Top","Fondo"]
    
    //MARK: Initialisers
    override init() {
        super.init()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        if userDefaults.integerForKey("bestStreak") < streak {
            userDefaults.setInteger(streak, forKey: "streak")
        }
    }
    
    //MARK: View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for gameButton in gameButtonCollection {
            gameButton.layer.cornerRadius = CGFloat(2)
        }
        if (self.userDefaults.boolForKey("hasSound") == true) {
            soundButton.title = "Sound On"
        } else {
            soundButton.title = "Sound Off"
        }
        //let layoutConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[button]-30-[button2]", options: NSLayoutFormatOptions, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>)
        //button.addConstraint(<#constraint: NSLayoutConstraint#>)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //
    }
    
    //MARK: Game methods
    @IBAction func clickSoundButton(sender: UIBarButtonItem) {
        if (self.userDefaults.boolForKey("hasSound") == true) {
            self.userDefaults.setBool(false, forKey: "hasSound")
            sender.title = "Sound Off"
        } else {
            self.userDefaults.setBool(true, forKey: "hasSound")
            sender.title = "Sound On"
        }
    }
    
    @IBAction func clickGameButton(sender: GameButton) {
        if (sender.correct) {
            sayWord(wordLabel.text!, answer: sender.currentTitle!)
            self.streak += 1
            refreshGame(buttonPressed: sender)
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            endStreak()
        }
    }

    func refreshGame (#buttonPressed: GameButton?) {
        let correctButtonIndex = Int(arc4random_uniform(4) + 1)
        for gameButton in gameButtonCollection {
            if gameButton.gameButtonIndex == correctButtonIndex {
                gameButton.correct = true
                let correctWordIndex = Int(arc4random_uniform(UInt32(words.count)))
                gameButton.setTitle(words[correctWordIndex], forState: UIControlState.Normal)
                wordLabel.text = answers[correctWordIndex]
            } else {
                gameButton.correct = false
                gameButton.setTitle(randomWord(), forState: UIControlState.Normal)
            }
            UIView.animateWithDuration(0.25, animations: {gameButton.alpha = 1})
        }
        self.navigationItem.title = NSLocalizedString("Streak: \(self.streak)", comment: "Navigation bar title showing the user's streak.")
        //        let button: UIButton = self.view.viewWithTag(50) as UIButton
        //        gameButton1.setTitle(randomWord(), forState: UIControlState.Normal)
    }
    
    func endStreak () {
        self.streak = 0
        self.navigationItem.title = NSLocalizedString("Streak: \(self.streak)", comment: "Navigation bar title showing the user's streak.")
    }
    
    func randomWord() -> String {
        let randomNumber = Int(arc4random_uniform(UInt32(words.count)))
        return words[randomNumber]
    }
    
    func sayWord (word: String, answer: String) {
        if self.userDefaults.boolForKey("hasSound") {
            var utteranceAnswer: AVSpeechUtterance = AVSpeechUtterance(string: answer)
            var utteranceWord: AVSpeechUtterance = AVSpeechUtterance(string: word)
            utteranceAnswer.rate = 0.3
            utteranceWord.rate = 0.3
            var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utteranceAnswer)
            synthesizer.speakUtterance(utteranceWord)
        }
    }
    
    func flashScore () {
    }
}

