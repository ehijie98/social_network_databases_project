require 'post_repository'

RSpec.describe PostRepository do

    def reset_posts_table
        seed_sql = File.read('spec/seeds_posts.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
        connection.exec(seed_sql)
    end

    before(:each) do 
        reset_posts_table
    end

    it "returns three Post objects" do
        repo = PostRepository.new 

        posts = repo.all

        expect(posts.length).to eq 3
        expect(posts[0].title).to eq "ABC"
        expect(posts[0].content).to eq "abc"
        expect(posts[0].views).to eq 40
        expect(posts[0].user_account_id).to eq 1
    end

    context "gets a single post record by its ID" do
        it "returns ABC post" do
            repo = PostRepository.new

            post = repo.find(1)

            expect(post.title).to eq "ABC"
            expect(post.content).to eq "abc"
            expect(post.views).to eq 40
            expect(post.user_account_id).to eq 1
        end

        it "returns DEF post" do
            repo = PostRepository.new

            post = repo.find(2)

            expect(post.title).to eq "DEF"
            expect(post.content).to eq "def"
            expect(post.views).to eq 20
            expect(post.user_account_id).to eq 2
        end

        it "returns GHI post" do
            repo = PostRepository.new

            post = repo.find(3)

            expect(post.title).to eq "GHI"
            expect(post.content).to eq "ghi"
            expect(post.views).to eq 45
            expect(post.user_account_id).to eq 1
        end
    end
    
    it "inserts a new Post object into the array" do
        repo = PostRepository.new

        post = Post.new
        post.title = "JKL"
        post.content = "jkl"
        post.views = 30
        post.user_account_id = 2

        repo.create(post)

        expect(repo.all).to include(
            have_attributes(
                title: "JKL",
                content: "jkl",
                views: 30,
                user_account_id: 2
            )
        )
    end

    it "deletes an exisiting Post object from the array" do
        repo = PostRepository.new

        repo.delete(2)

        expect(repo.all[1].title).to eq "GHI"
        expect(repo.all[1].content).to eq "ghi"
        expect(repo.all[1].views).to eq 45
        expect(repo.all[1].user_account_id).to eq 1
    end
end