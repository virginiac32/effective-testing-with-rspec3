Sandwich = Struct.new(:taste, :toppings)

RSpec.describe 'An ideal sandwich' do
  # before{ @sandwich = Sandwich.new('delicious', []) }
  #
  # def sandwich
  #   @sandwich ||= Sandwich.new('delicious', [])
  # end
  #

  let(:sandwich) { Sandwich.new('delicious', []) }
  
  it 'is delicious' do
    taste = sandwich.taste
    sandwich.toppings << 'cheese'

    expect(taste).to eq 'delicious'
  end
  
  it 'lets me add toppings' do
    # sandwich.toppings << 'cheese'
    expect(sandwich.toppings).to be_empty
  end
end
