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
import iAd

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
    var managedObjectContext: NSManagedObjectContext? = nil
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var streak: Int = 0
    var attempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("attempts")
    var correctAttempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("correctAttempts")
    var streakText: String {
        return NSLocalizedString("Streak: \(self.streak)", comment: "Navigation bar title showing the user's streak.")
    }
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
        saveUserDefaultLongestStreak()
        userDefaults.setInteger(self.attempts, forKey: "attempts")
        userDefaults.setInteger(self.correctAttempts, forKey: "correctAttempts")
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
//        var adView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
//        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait
//        self.view.addSubview(adView)
        //adView

        //let layoutConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[button]-30-[button2]", options: NSLayoutFormatOptions, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>)
        //button.addConstraint(<#constraint: NSLayoutConstraint#>)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.attempts += 1
        if (sender.correct) {
            sayWord(wordLabel.text!, answer: sender.currentTitle!)
            self.streak += 1
            self.correctAttempts += 1
            refreshGame()
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            endStreak()
        }
    }

    func refreshGame () {
        var wordNumbers: [Int] = [0,0,0,0]
        
        var index = 0
        do {
            wordNumbers[index] = Int(arc4random_uniform(UInt32(self.words.count)))
            if (index == 0) {
                index += 1
            } else if (!contains(wordNumbers[0...(index-1)], wordNumbers[index])) {
                index += 1
            }
        } while (index < 4)
//        var pass: Bool
//        do {
//            pass = true //it is considered passed until fail detected
//            for index in 0...3 {
//                wordNumbers[index] = (Int(arc4random_uniform(UInt32(self.words.count))))
//                switch (index) {
//                    case 0:
//                        break
//                    case 1:
//                        if (wordNumbers[0] == wordNumbers[1]) {
//                            pass = false
//                        }
//                    case 2:
//                        if (wordNumbers[0] == wordNumbers[1] || wordNumbers[1] == wordNumbers[2] || wordNumbers[0] == wordNumbers[2]) {
//                            pass = false
//                        }
//                    case 3:
//                        if (wordNumbers[0] == wordNumbers[1] || wordNumbers[0] == wordNumbers[2] || wordNumbers[0] == wordNumbers[3]) {
//                            pass = false
//                        } else if (wordNumbers[1] == wordNumbers[2] || wordNumbers[1] == wordNumbers[3]) {
//                            pass = false
//                        } else if (wordNumbers[2] == wordNumbers[3]) {
//                            pass = false
//                        }
//                    default:
//                        break
//                }
//            }
//        } while (pass == false)
        
        let correctButtonIndex = Int(arc4random_uniform(4))
        for gameButton in gameButtonCollection {
            if gameButton.gameButtonIndex == correctButtonIndex {
                gameButton.correct = true
                //let correctWordIndex = Int(arc4random_uniform(UInt32(wordNumbers.count)))
                gameButton.setTitle(words[wordNumbers[gameButton.gameButtonIndex]], forState: UIControlState.Normal)
                wordLabel.text = answers[wordNumbers[gameButton.gameButtonIndex]]
            } else {
                gameButton.correct = false
                gameButton.setTitle(words[wordNumbers[gameButton.gameButtonIndex]], forState: UIControlState.Normal)
            }
            UIView.animateWithDuration(0.25, animations: {gameButton.alpha = 1})
        }
        self.navigationItem.title = streakText
        //        let button: UIButton = self.view.viewWithTag(50) as UIButton
        //        gameButton1.setTitle(randomWord(), forState: UIControlState.Normal)
    }
    
    private func saveUserDefaultLongestStreak () {
        if userDefaults.integerForKey("longestStreak") < streak {
            userDefaults.setInteger(streak, forKey: "longestStreak")
        }
    }
    
    internal func endStreak () {
        saveUserDefaultLongestStreak()
        self.streak = 0
        self.navigationItem.title = streakText
    }
    
    func sayWord (word: String, answer: String) {
        if self.userDefaults.boolForKey("hasSound") {
            var utteranceAnswer: AVSpeechUtterance = AVSpeechUtterance(string: answer)
            var utteranceWord: AVSpeechUtterance = AVSpeechUtterance(string: word)
            //utteranceAnswer.voice = AVSpeechSynthesisVoice(language: "en-AU")
            utteranceAnswer.rate = 0.3
            utteranceWord.voice = AVSpeechSynthesisVoice(language: "it-IT")
            utteranceWord.rate = 0.3
            var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utteranceAnswer)
            synthesizer.speakUtterance(utteranceWord)
        }
    }
    
    func flashScore () {
    }
}

