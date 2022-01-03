import SwiftUI
import Kushki

struct CardTokenView: View {
    
    @State var name: String = ""
    @State var cardNumber: String = ""
    @State var cvv: String = ""
    @State var expiryMonth: String = ""
    @State var expiryYear: String = ""
    @State var totalAmount: String = ""
    @State var currency: String = "USD"
    @State var showResponse: Bool = false
    @State var responseMsg: String = ""
    @State var isSubscription: Bool = false
    @State var merchantId: String = ""
    @State var loading: Bool = false
    
    let currencies = ["CRC", "USD", "GTQ", "HNL", "NIO"]
    
    
    func getCard() -> Card {
        return Card(name: self.name,number: self.cardNumber, cvv: self.cvv,expiryMonth: self.expiryMonth,expiryYear: self.expiryYear)
    }
    
    
    func requestToken() {
        self.loading.toggle()
        let card = getCard();
        let totalAmount = Double(self.totalAmount) ?? 0.0
        let kushki = Kushki(publicMerchantId: self.merchantId, currency: self.currency, environment: KushkiEnvironment.testing_qa)
        
        if(self.isSubscription){
            kushki.requestSubscriptionToken(card: card, isTest: true){
                transaction in
                self.responseMsg = transaction.isSuccessful() ?
                    transaction.token : transaction.code + ": " + transaction.message
                self.showResponse = true
                self.loading.toggle()
            }
        }
        else{
            kushki.requestToken(card: card, totalAmount: totalAmount, isTest: true){
                transaction in
                self.responseMsg = transaction.isSuccessful() ?
                       transaction.token : transaction.code + ": " + transaction.message
                self.showResponse = true
                self.loading.toggle()
            }
        }
    
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("MerchantId")){
                    TextField("merchantId", text: $merchantId)
                }
                
                Section(header: Text("data")){
                    TextField("Name", text: $name)
                    TextField("Card Number", text: $cardNumber)
                    TextField("CVV", text: $cvv)
                    HStack{
                        TextField("Expiry Month", text: $expiryMonth)
                        TextField("Expiry Year", text: $expiryYear)
                    }
                    TextField("Total amount", text: $totalAmount)
                    Picker("Currency", selection: $currency){
                        ForEach(currencies, id: \.self){
                            Text($0)
                        }
                    }
                }
                
                Section(header:Text("Subscrition")){
                    Toggle(isOn: $isSubscription ){
                        Text("Subscription")
                    }
                    
                }
                
                Section {
                    Button(action: {self.requestToken()}, label: {
                        Text("Request token")
                    }).alert(isPresented: $showResponse) {
                        Alert(title: Text("Token Response"), message: Text(self.responseMsg), dismissButton: .default(Text("Got it!")))
                    }
                }
            }.navigationBarTitle("Card Token").disabled(self.loading)
        }
    }
}

struct CardTokenView_Previews: PreviewProvider {
    static var previews: some View {
        CardTokenView()
    }
}
