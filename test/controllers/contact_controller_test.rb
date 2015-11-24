require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  def setup
    FakeWeb.allow_net_connect = false
  end

  def teardown
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end
  test 'Should redirect to home' do
    create_fake_web
    post :send_simple_message, from: 'teste@email.com', subject: 'Teste',
                               text: 'Teste'
    assert_response :redirect
    assert_redirected_to root_path
  end

  def create_fake_web
    url = create_url('teste@email.com', 'contato@aondebrasil.com', 'Teste',
                     'Teste')
    FakeWeb.register_uri(:post, url, body: '{"subject"=>"Teste",'\
      ' "from"=>"teste@email.com", "text"=>"teste",'\
      ' "action"=>"send_simple_message", "controller"=>"contact"}')
  end

  def create_url(_from, _to, _subject, _text)
    url = 'https://api:key-a62565e9b90e81656f70602e3b4d1cae'\
    '@api.mailgun.net/v3/aondebrasil.com/messages'
    url
  end
end
