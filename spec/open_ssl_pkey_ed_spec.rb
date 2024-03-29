require 'open3'

RSpec.describe OpenSSLPKeyED do

  let(:rsa_private_key) { OpenSSL::PKey::RSA.generate(4096)       }
  let(:ec_private_key)  { OpenSSL::PKey::EC.generate("secp384r1") }
  let(:dh_private_key)  { OpenSSL::PKey::DH.generate(512, 2)      }
  let(:dsa_private_key) { OpenSSL::PKey::DSA.generate(512)        }

  describe "to_der" do
    subject { OpenSSLPKeyED.to_der(key) }

    context 'RSA' do
      context 'private key' do
        let(:key) { rsa_private_key }
        let(:key_by_openssl_cli) { Open3.capture3('openssl rsa -outform der', stdin_data: key.to_pem, binmode: true)[0] }

        it "matches key which generated by openssl cli" do
          expect(subject).to eq(key_by_openssl_cli)
        end
      end

      context 'public key' do
        let(:key) { rsa_private_key.public_key }
        let(:key_by_openssl_cli) { Open3.capture3('openssl rsa -pubin -outform der', stdin_data: key.to_pem, binmode: true)[0] }

        it "matches key which generated by openssl cli" do
          expect(subject).to eq(key_by_openssl_cli)
        end
      end
    end

    context 'EC' do
      context 'private key' do
        let(:key) { ec_private_key }
        let(:key_by_openssl_cli) { Open3.capture3('openssl ec -outform der', stdin_data: key.to_pem, binmode: true)[0] }

        it "matches key which generated by openssl cli" do
          expect(subject).to eq(key_by_openssl_cli)
        end
      end

      context 'public key' do
        let(:key) { ec_private_key.public_key }
        let(:key_by_openssl_cli) { Open3.capture3('openssl ec -pubout -outform der', stdin_data: ec_private_key.to_pem, binmode: true)[0] }

        it "matches key which generated by openssl cli" do
          expect(subject).to eq(key_by_openssl_cli)
        end
      end
    end
  end

  # for confirm der-encoded key
  def pretty(bin)
    bin.unpack('H*').first.gsub(/(..)/,'\1 ').rstrip
  end
end
