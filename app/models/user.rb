class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :kingdoms
         
  def castles 
    Castle.joins(:kingdom).where(:kingdoms => {:user_id => id});
  end
  def current_kingdom 
    kingdoms.first
  end
end
