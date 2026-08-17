@JS class Library {
    @JS struct Shelf {
        @JS struct Divider {
            var slot: Int

            @JS init(slot: Int) {
                self.slot = slot
            }
        }
    }

    @JS init() {}
}

extension Library {
    @JS func divider(_ value: Shelf.Divider) -> Shelf.Divider {
        value
    }
}

@JS class Outer {
    @JS struct Inner {
        @JS struct Outer {
            @JS struct Inner {
                @JS init() {}
            }
        }

        @JS init() {}
    }

    @JS init() {}
}

extension Outer.Inner {
    @JS func marker() -> Int { 1 }
}
