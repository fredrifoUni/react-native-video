extension Bundle {
    func resourceBundle(name: String) -> Bundle? {
        guard let url = self.url(forResource: name, withExtension: "bundle") else { return nil }
        return Bundle.init(url: url)
    }
}
