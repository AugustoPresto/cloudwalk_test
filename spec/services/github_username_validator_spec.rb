require 'rails_helper'

RSpec.describe GithubUsernameValidator, type: :service do
  describe '.check' do
    context 'when GitHub username exists' do
      it 'does not raise an error' do
        allow(HTTParty).to receive(:get).and_return(double('response', code: 200, body: ''))
        expect { GithubUsernameValidator.check('valid-username') }.not_to raise_error
      end
    end

    context 'when GitHub username does not exist' do
      it 'raises a "GitHub username not found" error' do
        allow(HTTParty).to receive(:get).and_return(double('response', code: 404, body: ''))
        expect { GithubUsernameValidator.check('invalid-username') }.to raise_error("GitHub username 'invalid-username' not found")
      end
    end

    context 'when an unexpected status code is returned' do
      it 'raises a "Failed to validate GitHub username" error' do
        allow(HTTParty).to receive(:get).and_return(double('response', code: 500, body: ''))
        expect { GithubUsernameValidator.check('any-username') }.to raise_error("Failed to validate GitHub username (status code: 500)")
      end
    end
  end
end
