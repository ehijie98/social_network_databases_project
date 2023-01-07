# User Accounts Model and Repository Classes Design Recipe

## 1. Design and create the Table
If the table is already created in the database, you can skip this step.

Otherwise, follow this recipe to design and create the SQL schema for your table.

In this template, we'll use an example table students

```
# EXAMPLE

Table: user_accounts

Columns:
id | email_address | username
```

## 2. Create Test SQL seeds
Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_user_accounts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE user_accounts RESTART IDENTITY CASCADE; -- replace with your own table name.


-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (email_address, username) VALUES ('johnsmith@gmail.com', 'johnsmith98');
INSERT INTO user_accounts (email_address, username) VALUES ('harrybacon@gmail.com', 'harrybacon97');
-- Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```

```bash
psql -h 127.0.0.1 social_network_test < seeds_user_accounts.sql
```

## 3. Define the class names
Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

```ruby
# EXAMPLE
# Table name: user_accounts

# Model class
# (in lib/user_account.rb)
class UserAccount
end

# Repository class
# (in lib/user_account_repository.rb)
class UserRepository
end
```

## 4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: user_accounts

# Model class
# (in lib/user_account.rb)

class UserAccount
  # Replace the attributes by your own columns.
  attr_accessor :id, :email_address, :username
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# user_account = UserAccount.new
# user_account.email_address = 'johnsmith@gmail.com'
# user_account.email_address 
```

You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.

## 5. Define the Repository Class interface
Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: user_accounts

# Repository class
# (in lib/user_account_repository.rb)

class UserAccountRepository
    # Selecting all records
    # No arguments
    def all
        # Executes the SQL query:
        # SELECT id, email_address, username FROM user_accounts;
       
        # Returns an array of UserAccount objects.
    end

    # Gets a single record by its ID
    # One argument: the id (number)
    def find(id)
        # Executes the SQL query:
        # SELECT id, email_address, username FROM user_accounts WHERE id = $1;
        
        # Returns a single UserAccount object.
    end

    # Inserts a new user account record 
    # One argument: a new UserAccount object
    def create(user_account)
        # Executes the SQL query:
        # INSERT INTO user_accounts (email_address, username) VALUES ($1, $2);
       
        # Returns nothing
    end

    # Deletes a user account record by its id
    # One argument: the id (number)
    def delete(id)
        # Executes the SQL query:
        # DELETE FROM user_accounts WHERE id = $1
       
        # Returns nothing
    end

    # Haven't yet looked at Update SQL Query
end
```

## 6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all user accounts

repo = UserAccountRepository.new

user_accounts = repo.all

user_accounts.length # =>  2

user_accounts[0].id # =>  1
user_accounts[0].email_address # =>  'johnsmith@gmail.com'
user_accounts[0].username # =>  'johnsmith98'

user_accounts[1].id # =>  2
user_accounts[1].email_address # =>  'harrybacon@gmail.com'
user_accounts[1].username # =>  'harrybacon97'

# 2
# Get a single user account

repo = UserAccountRepository.new

user_account = repo.find(1)

user_account.id # =>  1
user_account.email_address # =>  ''johnsmith@gmail.com'
user_account.username # =>  'johnsmith98'

# Add more examples for each method

```
Encode this example as a test.

## 7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_Account_repository_spec.rb

def reset_user_accounts_table
  seed_sql = File.read('spec/seeds_user_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_accounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour