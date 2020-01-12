class Lono::Blueprint
  module Helper
    extend Memoist

    def user_info
      git_author_name = git_installed? ? `git config user.name`.chomp : ""
      git_user_email = git_installed? ? `git config user.email`.chomp : ""
      github_username = git_installed? ? `git config github.user`.chomp : ""

      author = git_author_name.empty? ? "TODO: Write your name" : git_author_name
      email = git_user_email.empty? ? "TODO: Write your email address" : git_user_email

      author = "author" if ENV['LONO_TEST']
      email = "email" if ENV['LONO_TEST']

      {
        :author           => author,
        :email            => email,
        :github_username  => github_username.empty? ? "[USERNAME]" : github_username,
      }
    end
    memoize :user_info
  end
end
