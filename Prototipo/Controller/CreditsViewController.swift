//
//  DetailsViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 26/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit
import HealthKit
import SVProgressHUD

class CreditsViewController: UIViewController {
    
    let healthKitStore : HKHealthStore = HKHealthStore()
    var acesso : Bool = false
    var idade : String = ""
    var tipoSangue : String = ""
    var genero : String = ""
    var dataNasc : String = ""
    var altura : String = ""
    var peso : String = ""
    var clientHKData = [String : String]()

    @IBOutlet weak var videoDisplay: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideo(videoCode : "bEDd3dxdJ-k")
    }
    
    func getVideo (videoCode : String){
        let url =  URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoDisplay.loadRequest(URLRequest(url : url!))
        
    }
    
    //MARK: Métodos de autorização Health Kit
    
    @IBAction func permitirAcessoHealth(_ sender: UIButton) {
        autorizarHealthKit()
        SVProgressHUD.show()
        readHKData()
        readHeightData()
        readWeightData()
    }
    
    func autorizarHealthKit() {
        
        if (!HKHealthStore.isHealthDataAvailable() ){
            print("User não utiliza o App Health")
            acesso = false
        }
        
        let dataNasc = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        let tipoSangue = HKObjectType.characteristicType(forIdentifier: .bloodType)!
        let genero = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        let altura = HKObjectType.quantityType(forIdentifier: .height)!
        let peso = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        //              let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
        //              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
        //              let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        
        let healthKitDataRead : Set<HKObjectType> = [dataNasc, tipoSangue, genero, altura, peso]
        let healthKitDataWrite : Set<HKSampleType> = []
        
        healthKitStore.requestAuthorization(toShare: healthKitDataWrite, read: healthKitDataRead, completion: { (success, error) in
            print("Autorização de leitura concluída")
            self.acesso = true
        })
        
        
    }
    
    // Ler características do user (Dados Fixos)
    
    func readHKData(){
        
        let healthKitStore = HKHealthStore()
        
        do{
            let data1 = try healthKitStore.dateOfBirthComponents()
            let data2 = try healthKitStore.biologicalSex().biologicalSex
            let data3 = try healthKitStore.bloodType().bloodType
            
            genero = converteGenero(info: data2)
            tipoSangue = converteTipoSangue (info : data3)
            
            let calendar = Calendar.current
            let anoAtual = calendar.component(.year, from: Date())
            let idade = anoAtual - data1.year!
        
            clientHKData["Idade"] = idade.description
            clientHKData["Gênero"] = genero
            clientHKData["Tipo Sanguineo"] = tipoSangue
            
            print(clientHKData["Idade"]!)
            print(clientHKData["Gênero"]!)
            print(clientHKData["Tipo Sanguineo"]!)
        }
        catch{
            print(error)
        }
        
    }
    
    // Ler samples do user (Dados variáveis)
    
    func getMostRecentSample (sampleType : HKSampleType, completion : @escaping (HKQuantitySample?, Error?) -> Void){
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            DispatchQueue.main.async {
                
                guard let samples = samples,
                    let mostRecentSample = samples.first as? HKQuantitySample else{
                        print("Erro na busca")
                        completion(nil, error)
                        return
                }
                
                completion(mostRecentSample, nil)
                
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    func readHeightData (){
        
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else{
            print("Altura não está disponível no Health")
            return
        }
        
        getMostRecentSample(sampleType: heightSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.clientHKData["Altura"] = heightInMeters.description + " m"
            SVProgressHUD.dismiss()
        }
        
    }
    
    func readWeightData (){
        
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else{
            print("Peso não está disponível no Health")
            return
        }
        
        getMostRecentSample(sampleType: weightSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.clientHKData["Peso"] = weightInKilograms.description + " KG"
        }
        
    }
    
    
    //MARK: Métodos auxiliares
    
    func converteGenero (info: HKBiologicalSex ) -> String{
        if (info == .female){
            return "Feminino"
        }
        else if (info == .male){
            return "Masculino"
        }
        else if (info == .other){
            return "Outro"
        }
        return "Indisponível"
        
    }
    
    func converteTipoSangue(info : HKBloodType ) -> String{
        
        if(info == .abNegative){
            return "AB-"
        }
        else if(info == .abPositive){
            return "AB+"
        }
        else if(info == .aNegative){
            return "A-"
        }
        else if(info == .aPositive){
            return "A+"
        }
        else if(info == .bNegative){
            return "B-"
        }
        else if(info == .bPositive){
            return "B+"
        }
        else if(info == .oNegative){
            return "O-"
        }
        else if(info == .oPositive){
            return "O+"
        }
        return "Indisponível"
        
    }
    
    @IBAction func startQuestions(_ sender: UIButton) {
        //print(clientHKData)
        performSegue(withIdentifier: "goToQuestionsView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToQuestionsView"){
            let navigationVC = segue.destination as! QuestionsViewController
            navigationVC.clientHKData = self.clientHKData
            
        }
    }
    
}
