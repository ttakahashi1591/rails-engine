require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  it { should belong_to(:item) }
  it { should belong_to(:invoice) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:unit_price) }    
end