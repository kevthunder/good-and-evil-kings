class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :kingdoms
  has_many :castles, through: :kingdoms
         
  def current_kingdom 
    return @current_kingdom unless @current_kingdom.nil?
    @current_kingdom = kingdoms.first
  end
  def current_castle
    current_kingdom.current_castle
  end
end
