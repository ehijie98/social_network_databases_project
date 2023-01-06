require 'user_account_repository'

RSpec.describe UserAccountRepository do
    def reset_user_accounts_table
        seed_sql = File.read('spec/seeds_user_accounts.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
        connection.exec(seed_sql)
    end

    before(:each) do 
        reset_user_accounts_table
    end


    it "returns two user accounts" do
        repo = UserAccountRepository.new

        user_accounts = repo.all

        expect(user_accounts.length).to eq 2
        expect(user_accounts[0].email_address).to eq 'johnsmith@gmail.com'
        expect(user_accounts[0].username).to eq 'johnsmith98'
        expect(user_accounts[1].email_address).to eq 'harrybacon@gmail.com'
        expect(user_accounts[1].username).to eq 'harrybacon97'
    end

    context "it gets a single user account record by its id" do
        it "returns John Smith's account" do
            repo = UserAccountRepository.new

            user_account = repo.find(1)

            expect(user_account.email_address).to eq 'johnsmith@gmail.com'
            expect(user_account.username).to eq 'johnsmith98'
        end

        it "returns Harry Bacon's account" do
            repo = UserAccountRepository.new

            user_account = repo.find(2)

            expect(user_account.email_address).to eq 'harrybacon@gmail.com'
            expect(user_account.username).to eq 'harrybacon97'
        end
    end

    it "inserts a new UserAccount object into the array" do
        repo = UserAccountRepository.new

        user_account = UserAccount.new
        user_account.email_address = 'jakebishop@gmail.com'
        user_account.username = 'jakebishop99'

        repo.create(user_account)

        expect(repo.all).to include(
            have_attributes(
                email_address: 'jakebishop@gmail.com',
                username: 'jakebishop99'
            )
        )
    end

    it "deletes an existing UserAccount object from the array" do
        repo = UserAccountRepository.new

        repo.delete(1)

        expect(repo.all.length).to eq 1
        expect(repo.all[0].email_address).to eq "harrybacon@gmail.com"
        expect(repo.all[0].username).to eq "harrybacon97"
    end

    it "updates an exisitin"
end
