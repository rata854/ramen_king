class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stores
  has_many :store_comments, dependent: :destroy
  attachment :profile_image

  validates :name, presence: true, length: {maximum: 15, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 100}


  def plus_one(int)
    int + 1
  end
end

context 'n is 1' do
  it 'return 2' do
    expect(User.new.plus_one(1)). to eq 2
  end
end

context 'n is 2' do
  it 'return 3' do
    expect(User.new.plus_one(2)). to eq 3
  end
end