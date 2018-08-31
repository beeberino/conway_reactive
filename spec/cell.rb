require_relative '../lib/cell'
require_relative '../lib/world'

describe Cell do
  subject { Cell.new(location, world, alive) }
  let(:location) { Struct.new(:x, :y).new(1,2) }
  let(:alive) { true }
  let!(:world) { instance_double(World, cell_at: cell_getter) }
  let(:cell_getter) do ->(x, y) {
    subject
  }
  end

  describe '#dead?' do
    it 'returns the negation of alive' do
      expect(subject.dead?).to eq(false)
    end
  end

  describe '#alive?' do
    it 'returns the boolean value of alive getter' do
      expect(subject.alive?).to eq(true)
    end
  end

  describe '#x_coord' do
    it 'returns the x coordinate of the cell' do
      expect(subject.x_coord).to eq(1)
    end
  end

  describe '#y_coord' do
    it 'returns the y coordinate of the cell' do
      expect(subject.y_coord).to eq(2)
    end
  end

  describe '#toggle!' do
    it 'toggles cell state' do
      subject.toggle!
      expect(subject.alive?).to eq(false)
      expect(subject.dead?).to eq(true)
      subject.toggle!
      expect(subject.alive?).to eq(true)
      expect(subject.dead?).to eq(false)
    end
  end

  describe '#should_be_toggled?' do
    context 'when alive' do
      before do
        allow(subject).to receive(:alive?).and_return(true)
      end

      context 'when should be swept' do
        before do
          allow(subject).to receive(:should_be_swept?).and_return(true)
        end

        it 'returns self' do
          expect(subject.should_be_toggled?).to eq(subject)
        end
      end

      context 'when should not be swept' do
        before do
          allow(subject).to receive(:should_be_swept?).and_return(false)
        end

        it 'returns nil' do
          expect(subject.should_be_toggled?).to eq(nil)
        end
      end
    end

    context 'when dead' do
      before do
        allow(subject).to receive(:alive?).and_return(false)
        allow(subject).to receive(:dead?).and_return(true)
      end

      context 'when should be resurrected' do
        before do
          allow(subject).to receive(:should_be_resurrected?).and_return(true)
        end

        it 'returns self' do
          expect(subject.should_be_toggled?).to eq(subject)
        end
      end

      context 'when should not be resurrected' do
        before do
          allow(subject).to receive(:should_be_resurrected?).and_return(false)
        end

        it 'returns nil' do
          expect(subject.should_be_toggled?).to eq(nil)
        end
      end
    end
  end
end
