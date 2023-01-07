# Posts Model and Repository Classes Design Recipe

## 1. Design and Create the Table
If the table is already created in the database, you can skip this step.

Otherwise, follow this recipe to design and create the SQL schema for your table.

In this template, we'll use an example table students

```
# EXAMPLE

Table: posts

Columns:
title | content | views | user_account_id
```

## 2. Create Test SQL seeds
Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_posts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, views, user_account_id) VALUES ('ABC', 'abc', 40, 1);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('DEF', 'def' 20, 2);
-- Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```

```bash
psql -h 127.0.0.1 social_network_test < seeds_posts.sql
```

## 3. Define the class names
Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)

class Post
    attr_accessor :id, :title, :content, :views, :user_account_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:

# post = Post.new
# post.title = 'ABC'
# post.title
```
You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.


## 5. Define the Repository Class interface
Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository

    # Selecting all records
    # No arguments
    def all
        # Executes the SQL query:
        # SELECT id, title, content, views, user_account_id FROM posts;

        # Returns an array of Post objects.
    end

    # Gets a single record by its ID
    # One argument: the id (number)
    def find(id)
        # Executes the SQL query:
        # SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;

        # Returns a single Post object.
    end

    # Add more methods below for each operation you'd like to implement.

    # Inserts a new post record
    # One argument: a Post object
    def create(post)
        # Executes the SQL query:
        # INSERT INTO posts (title, content, views, user_account_id) VALUES ($1, $2, $3)

        # Returns nothing
    end

    # Deletes an existing post record 
    # One argument: the id (number)
    def delete(id)
        # Executes the SQL query:
        # DELETE FROM posts WHERE ID = $1

        # Returns nothing
    end
end
```

## 6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all posts

repo = UserAccountRepository.new

posts = repo.all

posts.length # =>  3

posts[0].id # =>  1
posts.[0].title # =>  'ABC'
posts[0].content # =>  'abc'
posts[0].views # => 40
posts[0].user_account_id # => 1

posts[1].id # =>  2
posts.[1].title # =>  'DEF'
posts[1].content # =>  'def'
posts[1].views # => 20
posts[1].user_account_id # => 2

# 2
# Get a single post

repo = PostRepository.new

post = repo.find(1)

post.id # =>  1
posts.title # =>  'ABC'
post.content # =>  'abc'
post.views # => 40
post.user_account_id # => 1

# Add more examples for each method

repo = PostRepository.new

repo.update(1)

repo.find(1).views # => 41
```
Encode this example as a test.

## 7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour