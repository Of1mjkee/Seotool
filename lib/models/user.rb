DataMapper.setup(:default, 'postgres://ofim:bond007@localhost/seodb')

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash

  def authenticate(attempted_password)
    # The BCrypt class, which `self.password` is an instance of, has `==` defined to compare a
    # test plain text string to the encrypted string and converts `attempted_password` to a BCrypt
    # for the comparison.
    if self.password == attempted_password
      true
    else
      false
    end
  end

end

DataMapper.finalize
DataMapper.auto_upgrade!