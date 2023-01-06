require_relative './post'

class PostRepository

    # Selecting all records
    # No arguments
    def all
        # Executes the SQL query:
        # SELECT id, title, content, views, user_account_id FROM posts;
        sql = 'SELECT id, title, content, views, user_account_id FROM posts;'
        params = []

        result_set = DatabaseConnection.exec_params(sql, params)

        posts = []

        result_set.each do |record|
            post = Post.new
            post.id = record['id'].to_i
            post.title = record['title']
            post.content = record['content']
            post.views = record['views'].to_i
            post.user_account_id = record['user_account_id'].to_i

            posts << post
        end
    
        return posts
        # Returns an array of Post objects.
    end
    
        # Gets a single record by its ID
        # One argument: the id (number)
    def find(id)
        # Executes the SQL query:
        # SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;
        sql = 'SELECT id, title, content, views, user_account_id FROM posts WHERE id = $1;'
        params = [id]

        result_set = DatabaseConnection.exec_params(sql, params)

        record = result_set[0]

        post = Post.new
        post.id = record['id'].to_i
        post.title = record['title']
        post.content = record['content']
        post.views = record['views'].to_i
        post.user_account_id = record['user_account_id'].to_i

        return post

        # Returns a single Post object.
        end
    
        # Add more methods below for each operation you'd like to implement.
    
        def create(post)
            sql = 'INSERT INTO posts (title, content, views, user_account_id)
                        VALUES
                        ($1, $2, $3, $4)'
            params = [post.title, post.content, post.views, post.user_account_id]

            result_set = DatabaseConnection.exec_params(sql, params)
        end
    
        def delete(id)
            sql = 'DELETE FROM posts WHERE id = $1'
            params = [id]

            result_set = DatabaseConnection.exec_params(sql, params)

            return nil
        end
    end