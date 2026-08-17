@JS enum Catalog {
    @JS struct Entry {
        var title: String

        @JS init(title: String) {
            self.title = title
        }
    }
}

@JS struct Entry {
    var identifier: Int

    @JS init(identifier: Int) {
        self.identifier = identifier
    }
}

@JS func takeEntry(_ entry: Entry) -> Entry {
    entry
}

@JS func takeCatalogEntry(_ entry: Catalog.Entry) -> Catalog.Entry {
    entry
}
