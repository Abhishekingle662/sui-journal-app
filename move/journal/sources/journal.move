module journal::journal {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::clock::{Self, Clock};
    use std::string::{Self, String};
    use sui::transfer;
    use sui::address;
    use std::vector;

    const ENotOwner: u64 = 0;

    public struct Journal has key, store {
        id: UID,
        owner: address,
        title: String,
        entries: vector<Entry>
    }

    public struct Entry has store {
        content: String,
        create_at_ms: u64
    }

    public fun new_journal(title: String, ctx: &mut TxContext): Journal {
        Journal {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            title,
            entries: vector::empty()
        }
    }

    public entry fun add_entry(journal: &mut Journal, content: String, clock: &Clock, ctx: &TxContext) {
        assert!(tx_context::sender(ctx) == journal.owner, ENotOwner);
        let entry = Entry {
            content,
            create_at_ms: clock.timestamp_ms()
        };
        vector::push_back(&mut journal.entries, entry);
    }
}