import FluentProvider
import PostgreSQLProvider
import PostgreSQL

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
        try setupListenNotify()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(User.self)
        preparations.append(Reminder.self)
        preparations.append(Category.self)
        preparations.append(Pivot<Reminder, Category>.self)
    }
    
    // Listen and Notify
    private func setupListenNotify() throws {
        let postgreSQL = try PostgreSQL.Database(
            hostname: "localhost",
            database: "reminders",
            user: "reminder_user",
            password: "reminder_password"
        ).makeConnection()

        try postgreSQL.listen(toChannel: "test_channel") { notification, error, flag in
            guard let notification = notification else { return }
            print(notification.channel)
            print(notification.payload ?? "No Payload")
        }
        sleep(1)
        try postgreSQL.notify(channel: "test_channel", payload: "This is a test payload")
    }
}
