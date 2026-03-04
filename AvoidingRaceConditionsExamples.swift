import Foundation

// Issue example

class TicketOffice {
    var availableTickets: Int
    
    init(availableTickets: Int) {
        self.availableTickets = availableTickets
    }
    
    func buyTicket(user: String) {
        // 1. Check availability
        if availableTickets <= 0 {
            print("No tickets left")
            return
        }
        
        // 2. Simulate a validation process that takes time
        Thread.sleep(forTimeInterval: 2)
        print("Validation completed for \(user)")
        
        // 3. Decrement the ticket count
        availableTickets -= 1
        print("Ticket purchased by \(user). Remaining: \(availableTickets)")
    }
}

// EXAMPLE
//let ticketOffice = TicketOffice(availableTickets: 1)
//
//// Simulate two purchases happening at the same time
//DispatchQueue.global().async { ticketOffice.buyTicket(user: "Ana") }
//DispatchQueue.global().async { ticketOffice.buyTicket(user: "Luis") }


//
//
// MARK: - SOLUTION 1: Double checking tickets amount

class TicketOffice1 {
    var availableTickets: Int
    
    init(availableTickets: Int) {
        self.availableTickets = availableTickets
    }
    
    func buyTicketSafely(user: String) {
        // 1. Check availability
        if availableTickets <= 0 {
            print("No tickets left")
            return
        }
        
        // 2. Simulate a validation process that takes time
        Thread.sleep(forTimeInterval: 2)
        print("Validation completed for \(user)")
        
        // 3. Check again before updating the value and decrement the ticket count
        if availableTickets > 0 {
            availableTickets -= 1
            print("Ticket purchased by \(user). Remaining: \(availableTickets)")
        } else {
            print("Tickets were sold out while validating \(user)")
        }
    }
}

//let ticketOffice1 = TicketOffice1(availableTickets: 1)
//
//// Simulate two purchases happening at the same time
//DispatchQueue.global().async { ticketOffice1.buyTicketSafely(user: "Ana") }
//DispatchQueue.global().async { ticketOffice1.buyTicketSafely(user: "Luis") }


//
//
// MARK: - SOLUTION 2: Using NSLock

class TicketOffice2 {
    let lock = NSLock()
    var availableTickets: Int
    
    init(availableTickets: Int) {
        self.availableTickets = availableTickets
    }
    
    func buyTicketWithLock(user: String) {
        // 0. Lock the thread
        lock.lock()
        defer { lock.unlock() } // Unlock the thread at the end
        
        // 1. Check availability
        if availableTickets <= 0 {
            print("No tickets left")
            return
        }
        
        // 2. Simulate a validation process that takes time
        Thread.sleep(forTimeInterval: 2)
        print("Validation completed for \(user)")
        
        // 3. Decrement the ticket count
        availableTickets -= 1
        print("Ticket purchased by \(user). Remaining: \(availableTickets)")
    }
}

//let ticketOffice2 = TicketOffice2(availableTickets: 1)
//
//// Simulate two purchases happening at the same time
//DispatchQueue.global().async { ticketOffice2.buyTicketWithLock(user: "Ana") }
//DispatchQueue.global().async { ticketOffice2.buyTicketWithLock(user: "Luis") }


//
//
// MARK: - SOLUTION 3: Using GCD

class TicketOffice3: @unchecked Sendable {
    // Adding attributes concurrent
    let concurrentQueue = DispatchQueue(
        label: "theater.concurrent.queue",
        attributes: .concurrent
    )
    
    var availableTickets: Int
    
    init(availableTickets: Int) {
        self.availableTickets = availableTickets
    }
    
    func buyTicketWithBarrier(user: String) {
        // barrier tag
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            // 1. Check availability
            if self.availableTickets <= 0 {
                print("No tickets left")
                return
            }
            
            // 2. Simulate a validation process that takes time
            Thread.sleep(forTimeInterval: 2)
            print("Validation completed for \(user)")
            
            // 3. Decrement the ticket count
            self.availableTickets -= 1
            print("Ticket purchased by \(user). Remaining: \(self.availableTickets)")
        }
    }
}

//let ticketOffice3 = TicketOffice3(availableTickets: 1)
//
//// Simulate two purchases happening at the same time
//DispatchQueue.global().async { ticketOffice3.buyTicketWithBarrier(user: "Ana") }
//DispatchQueue.global().async { ticketOffice3.buyTicketWithBarrier(user: "Luis") }

//
//
// MARK: - SOLUTION 4: Using Actors y Swift Concurrency

// Actor responsible for managing the ticket office
actor TicketOffice4 {
    
    private var availableTickets: Int
    
    init(tickets: Int) {
        self.availableTickets = tickets
    }
    
    // Actor-isolated method: only one task can access this state at a time
    func buyTicket(user: String) -> Bool {
        // 1. Check availability
        if availableTickets <= 0 {
            print("No tickets left")
            return false
        }
        
        // 2. Simulate a validation process that takes time
        Thread.sleep(forTimeInterval: 2)
        print("Validation completed for \(user)")
        
        // 3. Decrement the ticket count
        availableTickets -= 1
        print("Ticket purchased by \(user). Remaining: \(availableTickets)")
        
        return true
    }
}

let ticketOffice4 = TicketOffice4(tickets: 1)

Task {
    async let result1 = ticketOffice4.buyTicket(user: "Ana")
    async let result2 = ticketOffice4.buyTicket(user: "Luis")
    
    // Wait for both results
    let (success1, success2) = await (result1, result2)
    
    print("Successful purchases:", success1, success2)
}
