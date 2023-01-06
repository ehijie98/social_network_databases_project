require_relative './user_account'

class UserAccountRepository
    # Selecting all records
    # No arguments
    def all
        # Executes the SQL query:
        # SELECT id, email_address, username FROM user_accounts;
        sql = 'SELECT id, email_address, username FROM user_accounts;'
        params = []

        result_set = DatabaseConnection.exec_params(sql, params)

        user_accounts = []

        result_set.each do |record|
            user_account = UserAccount.new
            user_account.email_address = record['email_address']
            user_account.username = record['username']

            user_accounts << user_account
        end

        return user_accounts
        # Returns an array of UserAccount objects.
    end

    # Gets a single record by its ID
    # One argument: the id (number)
    def find(id)
        # Executes the SQL query:
        # SELECT id, email_address, username FROM user_accounts WHERE id = $1;
        sql = 'SELECT id, email_address, username FROM user_accounts WHERE id = $1;'
        params = [id]

        result_set = DatabaseConnection.exec_params(sql, params)
        record = result_set[0]

        user_account = UserAccount.new
        user_account.email_address = record['email_address']
        user_account.username = record['username']

        return user_account
        # Returns a single UserAccount object.
    end


    # Inserts a new user account record 
    # One argument: a new UserAccount object
    def create(user_account)
        # Executes the SQL query:
        # INSERT INTO user_accounts (email_address, username) VALUES ($1, $2);
        sql = 'INSERT INTO user_accounts (email_address, username) VALUES ($1, $2);'
        params = [user_account.email_address, user_account.username]

        result_set = DatabaseConnection.exec_params(sql, params)

        return nil
        # Returns nothing
    end

    # Deletes a user account record by its id
    # One argument: the id (number)
    def delete(id)
        # Executes the SQL query:
        # DELETE FROM user_accounts WHERE id = $1
        sql = 'DELETE FROM user_accounts WHERE id = $1'
        params = [id]

        result_set = DatabaseConnection.exec_params(sql, params)

        return nil
        # Returns nothing
    end

    # Haven't yet looked at Update SQL Query
end