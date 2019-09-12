public struct Amount {
    let subtotalIva: Double
    let subtotalIva0: Double
    let iva: Double    
    
    public init(subtotalIva: Double, subtotalIva0: Double, iva: Double) {
        self.subtotalIva = subtotalIva
        self.subtotalIva0 = subtotalIva0
        self.iva = iva
    }
}

